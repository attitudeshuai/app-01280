package com.movieticket.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.movieticket.common.PageResult;
import com.movieticket.common.Result;
import com.movieticket.entity.*;
import com.movieticket.mapper.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

/**
 * 管理后台 - 订单管理
 */
@RestController
@RequestMapping("/api/admin/orders")
@RequiredArgsConstructor
@SaCheckRole("ADMIN")
@Tag(name = "管理后台-订单管理", description = "订单查询和统计")
public class AdminOrderController {

    private final OrderMapper orderMapper;
    private final ShowtimeMapper showtimeMapper;
    private final MovieMapper movieMapper;
    private final HallMapper hallMapper;
    private final CinemaMapper cinemaMapper;
    private final UserMapper userMapper;

    /**
     * 获取订单列表 (分页)
     */
    @GetMapping
    @Operation(summary = "获取订单列表")
    public Result<PageResult<Order>> list(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String orderNo,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "20") Integer size
    ) {
        Page<Order> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(status)) {
            wrapper.eq(Order::getStatus, Order.OrderStatusEnum.valueOf(status));
        }
        if (StringUtils.hasText(orderNo)) {
            wrapper.like(Order::getOrderNo, orderNo);
        }
        
        wrapper.orderByDesc(Order::getCreatedAt);
        Page<Order> result = orderMapper.selectPage(pageParam, wrapper);
        
        // 填充关联信息
        result.getRecords().forEach(this::fillOrderInfo);
        
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取订单详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取订单详情")
    public Result<Order> getById(@PathVariable Long id) {
        Order order = orderMapper.selectById(id);
        if (order != null) {
            fillOrderInfo(order);
            // 填充用户信息
            if (order.getUserId() != null) {
                order.setUser(userMapper.selectById(order.getUserId()));
            }
        }
        return Result.success(order);
    }

    /**
     * 统计数据
     */
    @GetMapping("/stats")
    @Operation(summary = "获取统计数据")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 今日订单数
        LambdaQueryWrapper<Order> todayWrapper = new LambdaQueryWrapper<>();
        todayWrapper.apply("DATE(created_at) = {0}", LocalDate.now());
        stats.put("todayOrders", orderMapper.selectCount(todayWrapper));
        
        // 今日营业额
        LambdaQueryWrapper<Order> paidTodayWrapper = new LambdaQueryWrapper<>();
        paidTodayWrapper.eq(Order::getStatus, Order.OrderStatusEnum.PAID)
                .apply("DATE(pay_time) = {0}", LocalDate.now());
        BigDecimal todayRevenue = orderMapper.selectList(paidTodayWrapper)
                .stream()
                .map(Order::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        stats.put("todayRevenue", todayRevenue);
        
        // 总订单数
        stats.put("totalOrders", orderMapper.selectCount(null));
        
        // 待支付订单
        LambdaQueryWrapper<Order> pendingWrapper = new LambdaQueryWrapper<>();
        pendingWrapper.eq(Order::getStatus, Order.OrderStatusEnum.PENDING);
        stats.put("pendingOrders", orderMapper.selectCount(pendingWrapper));
        
        // 总用户数
        stats.put("totalUsers", userMapper.selectCount(null));
        
        // 热映影片数
        LambdaQueryWrapper<Movie> showingWrapper = new LambdaQueryWrapper<>();
        showingWrapper.eq(Movie::getStatus, Movie.StatusEnum.SHOWING);
        stats.put("showingMovies", movieMapper.selectCount(showingWrapper));
        
        return Result.success(stats);
    }

    /**
     * 填充订单关联信息
     */
    private void fillOrderInfo(Order order) {
        if (order.getShowtimeId() != null) {
            Showtime showtime = showtimeMapper.selectById(order.getShowtimeId());
            if (showtime != null) {
                if (showtime.getMovieId() != null) {
                    showtime.setMovie(movieMapper.selectById(showtime.getMovieId()));
                }
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
}
