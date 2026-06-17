package com.movieticket.service;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.movieticket.common.PageResult;
import com.movieticket.common.ResultCode;
import com.movieticket.dto.order.CreateOrderRequest;
import com.movieticket.entity.*;
import com.movieticket.exception.BusinessException;
import com.movieticket.mapper.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 订单服务
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderMapper orderMapper;
    private final ShowtimeMapper showtimeMapper;
    private final SeatMapper seatMapper;
    private final SeatService seatService;
    private final MovieMapper movieMapper;
    private final HallMapper hallMapper;
    private final CinemaMapper cinemaMapper;
    private final CompanionService companionService;

    /**
     * 创建订单
     */
    @Transactional
    public Order createOrder(CreateOrderRequest request) {
        Long userId = StpUtil.getLoginIdAsLong();

        // 查询场次
        Showtime showtime = showtimeMapper.selectById(request.getShowtimeId());
        if (showtime == null) {
            throw new BusinessException(ResultCode.SHOWTIME_NOT_EXIST);
        }

        // 锁定座位
        seatService.lockSeats(request.getShowtimeId(), request.getSeatIds(), userId);

        // 构建座位信息 JSON
        List<Map<String, Object>> seatInfoList = new ArrayList<>();
        for (Long seatId : request.getSeatIds()) {
            Seat seat = seatMapper.selectById(seatId);
            Map<String, Object> info = new HashMap<>();
            info.put("id", seat.getId());
            info.put("row", seat.getRowNum());
            info.put("col", seat.getColNum());
            info.put("label", seat.getSeatLabel());
            seatInfoList.add(info);
        }

        // 计算总价
        BigDecimal totalAmount = showtime.getPrice().multiply(BigDecimal.valueOf(request.getSeatIds().size()));

        // 创建订单
        Order order = new Order();
        order.setOrderNo(IdUtil.getSnowflakeNextIdStr());
        order.setUserId(userId);
        order.setShowtimeId(request.getShowtimeId());
        order.setSeatInfo(JSONUtil.toJsonStr(seatInfoList));
        order.setSeatCount(request.getSeatIds().size());
        order.setUnitPrice(showtime.getPrice());
        order.setTotalAmount(totalAmount);  // 先设置基础总价
        order.setCompanionType(request.getCompanionType());
        order.setStatus(Order.OrderStatusEnum.PENDING);
        order.setExpireTime(LocalDateTime.now().plusMinutes(1));

        orderMapper.insert(order);

        // 处理陪伴选项
        if ("DOLL".equals(request.getCompanionType()) && request.getDollTypeId() != null) {
            // 玩偶陪伴
            Companion companion = companionService.createDollCompanion(
                order.getId(), userId, request.getShowtimeId(),
                request.getDollTypeId(), request.getSeatIds().get(0)
            );
            order.setCompanionId(companion.getId());
            // 加上玩偶租赁费
            totalAmount = totalAmount.add(companion.getExtraPrice());
            orderMapper.updateById(order);
        } else if ("STRANGER".equals(request.getCompanionType())) {
            // 路人匹配 - 尝试匹配
            Companion companion = companionService.tryMatch(
                userId, request.getShowtimeId(), order.getId(), request.getSeatIds().get(0)
            );
            if (companion != null) {
                order.setCompanionId(companion.getId());
                orderMapper.updateById(order);
            }
        }

        order.setTotalAmount(totalAmount);
        orderMapper.updateById(order);

        log.info("订单创建成功: orderNo={}, userId={}, amount={}, companion={}", 
                order.getOrderNo(), userId, order.getTotalAmount(), request.getCompanionType());

        return order;
    }

    /**
     * 支付订单 (模拟)
     */
    @Transactional
    public Order payOrder(Long orderId, String payType) {
        Long userId = StpUtil.getLoginIdAsLong();

        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_EXIST);
        }

        // 验证订单所属用户
        if (!order.getUserId().equals(userId)) {
            throw new BusinessException("无权操作此订单");
        }

        // 验证订单状态
        if (order.getStatus() != Order.OrderStatusEnum.PENDING) {
            throw new BusinessException("订单状态不正确，无法支付");
        }

        // 验证订单是否过期
        if (LocalDateTime.now().isAfter(order.getExpireTime())) {
            throw new BusinessException(ResultCode.ORDER_EXPIRED);
        }

        // 获取座位ID列表
        List<Long> seatIds = JSONUtil.parseArray(order.getSeatInfo())
                .stream()
                .map(obj -> ((Map<?, ?>) obj).get("id"))
                .map(id -> Long.valueOf(id.toString()))
                .toList();

        // 确认座位售出
        seatService.confirmSeatsSold(seatIds);

        // 生成取票码 (6位数字)
        String ticketCode = RandomUtil.randomNumbers(6);

        // 更新订单状态
        order.setStatus(Order.OrderStatusEnum.PAID);
        order.setPayType(payType);
        order.setPayTime(LocalDateTime.now());
        order.setTicketCode(ticketCode);
        orderMapper.updateById(order);

        log.info("订单支付成功: orderNo={}, ticketCode={}", order.getOrderNo(), ticketCode);

        return order;
    }

    /**
     * 取消订单
     */
    @Transactional
    public void cancelOrder(Long orderId) {
        Long userId = StpUtil.getLoginIdAsLong();

        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_EXIST);
        }

        if (!order.getUserId().equals(userId)) {
            throw new BusinessException("无权操作此订单");
        }

        if (order.getStatus() != Order.OrderStatusEnum.PENDING) {
            throw new BusinessException("订单状态不正确，无法取消");
        }

        // 获取座位ID列表并释放
        List<Long> seatIds = JSONUtil.parseArray(order.getSeatInfo())
                .stream()
                .map(obj -> ((Map<?, ?>) obj).get("id"))
                .map(id -> Long.valueOf(id.toString()))
                .toList();

        seatService.releaseSeats(seatIds);

        // 更新订单状态
        order.setStatus(Order.OrderStatusEnum.CANCELLED);
        orderMapper.updateById(order);

        log.info("订单取消成功: orderNo={}", order.getOrderNo());
    }

    /**
     * 获取订单详情
     */
    public Order getDetail(Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(ResultCode.ORDER_NOT_EXIST);
        }

        // 填充场次信息
        fillOrderInfo(order);

        return order;
    }

    /**
     * 获取我的订单列表
     */
    public PageResult<Order> getMyOrders(String status, Integer page, Integer size) {
        Long userId = StpUtil.getLoginIdAsLong();

        Page<Order> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getUserId, userId);

        if (StringUtils.hasText(status)) {
            wrapper.eq(Order::getStatus, Order.OrderStatusEnum.valueOf(status));
        }

        wrapper.orderByDesc(Order::getCreatedAt);

        Page<Order> result = orderMapper.selectPage(pageParam, wrapper);

        // 填充场次信息
        result.getRecords().forEach(this::fillOrderInfo);

        return PageResult.of(result);
    }

    /**
     * 填充订单关联信息
     */
    private void fillOrderInfo(Order order) {
        if (order == null || order.getShowtimeId() == null) return;

        Showtime showtime = showtimeMapper.selectById(order.getShowtimeId());
        if (showtime != null) {
            // 填充影片
            if (showtime.getMovieId() != null) {
                showtime.setMovie(movieMapper.selectById(showtime.getMovieId()));
            }
            // 填充影厅和影院
            if (showtime.getHallId() != null) {
                Hall hall = hallMapper.selectById(showtime.getHallId());
                showtime.setHall(hall);
                if (hall != null && hall.getCinemaId() != null) {
                    showtime.setCinema(cinemaMapper.selectById(hall.getCinemaId()));
                }
            }
            order.setShowtime(showtime);
        }
    }
}
