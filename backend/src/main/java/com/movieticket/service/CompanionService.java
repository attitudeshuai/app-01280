package com.movieticket.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.movieticket.entity.*;
import com.movieticket.exception.BusinessException;
import com.movieticket.mapper.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 陪伴服务
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CompanionService {

    private final DollTypeMapper dollTypeMapper;
    private final CompanionMapper companionMapper;
    private final MatchPoolMapper matchPoolMapper;
    private final SeatMapper seatMapper;
    private final OrderMapper orderMapper;

    /**
     * 获取可用玩偶列表
     */
    public List<DollType> getAvailableDolls() {
        LambdaQueryWrapper<DollType> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(DollType::getStatus, 1)
               .gt(DollType::getStock, 0)
               .orderByAsc(DollType::getSortOrder);
        return dollTypeMapper.selectList(wrapper);
    }

    /**
     * 获取玩偶详情
     */
    public DollType getDollById(Long id) {
        return dollTypeMapper.selectById(id);
    }

    /**
     * 创建玩偶陪伴订单
     * 
     * @param orderId 订单ID
     * @param userId 用户ID
     * @param showtimeId 场次ID
     * @param dollTypeId 玩偶类型ID
     * @param userSeatId 用户已选座位ID
     * @return 陪伴记录
     */
    @Transactional
    public Companion createDollCompanion(Long orderId, Long userId, Long showtimeId, 
                                          Long dollTypeId, Long userSeatId) {
        // 检查玩偶
        DollType doll = dollTypeMapper.selectById(dollTypeId);
        if (doll == null || doll.getStock() <= 0) {
            throw new BusinessException("玩偶已售罄");
        }

        // 查找邻座
        Seat companionSeat = findAdjacentSeat(showtimeId, userSeatId);
        if (companionSeat == null) {
            throw new BusinessException("没有可用的邻座");
        }

        // 锁定邻座为陪伴座
        companionSeat.setStatus(Seat.SeatStatusEnum.COMPANION);
        seatMapper.updateById(companionSeat);

        // 扣减玩偶库存
        doll.setStock(doll.getStock() - 1);
        dollTypeMapper.updateById(doll);

        // 创建陪伴记录
        Companion companion = new Companion();
        companion.setOrderId(orderId);
        companion.setUserId(userId);
        companion.setShowtimeId(showtimeId);
        companion.setCompanionType(Companion.CompanionTypeEnum.DOLL);
        companion.setDollTypeId(dollTypeId);
        companion.setCompanionSeatId(companionSeat.getId());
        companion.setMatchStatus(Companion.MatchStatusEnum.MATCHED);
        companion.setExtraPrice(doll.getPrice());
        companionMapper.insert(companion);

        // 填充关联对象
        companion.setDollType(doll);
        companion.setCompanionSeat(companionSeat);

        log.info("Created doll companion: orderId={}, dollType={}, companionSeat={}", 
                orderId, doll.getName(), companionSeat.getSeatLabel());
        return companion;
    }

    /**
     * 加入路人匹配池
     */
    @Transactional
    public MatchPool joinMatchPool(Long userId, Long showtimeId, Long seatId) {
        // 检查是否已在匹配池中
        LambdaQueryWrapper<MatchPool> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MatchPool::getUserId, userId)
               .eq(MatchPool::getShowtimeId, showtimeId)
               .eq(MatchPool::getStatus, MatchPool.MatchStatusEnum.WAITING);
        MatchPool existing = matchPoolMapper.selectOne(wrapper);
        if (existing != null) {
            return existing;
        }

        // 清理过期记录
        matchPoolMapper.expireOldRecords();

        // 加入匹配池
        MatchPool pool = new MatchPool();
        pool.setUserId(userId);
        pool.setShowtimeId(showtimeId);
        pool.setSeatId(seatId);
        pool.setStatus(MatchPool.MatchStatusEnum.WAITING);
        pool.setExpireTime(LocalDateTime.now().plusMinutes(5)); // 5分钟过期
        matchPoolMapper.insert(pool);

        log.info("User {} joined match pool for showtime {}", userId, showtimeId);
        return pool;
    }

    /**
     * 尝试匹配路人
     */
    @Transactional
    public Companion tryMatch(Long userId, Long showtimeId, Long orderId, Long userSeatId) {
        // 查找等待匹配的其他用户
        MatchPool match = matchPoolMapper.findWaitingMatch(showtimeId, userId);
        
        if (match == null) {
            // 没有找到匹配，加入等待池
            joinMatchPool(userId, showtimeId, userSeatId);
            return null;
        }

        // 找到匹配! 更新双方状态
        // 查找邻座
        Seat companionSeat = findAdjacentSeat(showtimeId, userSeatId);
        if (companionSeat == null) {
            // 尝试用对方的座位旁边
            companionSeat = findAdjacentSeat(showtimeId, match.getSeatId());
        }

        if (companionSeat == null) {
            // 没有邻座，匹配失败
            return null;
        }

        // 更新匹配池状态
        match.setStatus(MatchPool.MatchStatusEnum.MATCHED);
        matchPoolMapper.updateById(match);

        // 创建陪伴记录
        Companion companion = new Companion();
        companion.setOrderId(orderId);
        companion.setUserId(userId);
        companion.setShowtimeId(showtimeId);
        companion.setCompanionType(Companion.CompanionTypeEnum.STRANGER);
        companion.setCompanionSeatId(companionSeat.getId());
        companion.setMatchUserId(match.getUserId());
        companion.setMatchStatus(Companion.MatchStatusEnum.MATCHED);
        companion.setExtraPrice(BigDecimal.ZERO); // 路人匹配免费
        companionMapper.insert(companion);

        log.info("Matched users: {} with {} for showtime {}", userId, match.getUserId(), showtimeId);
        return companion;
    }

    /**
     * 获取匹配状态
     */
    public MatchPool getMatchStatus(Long userId, Long showtimeId) {
        LambdaQueryWrapper<MatchPool> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MatchPool::getUserId, userId)
               .eq(MatchPool::getShowtimeId, showtimeId)
               .orderByDesc(MatchPool::getCreatedAt)
               .last("LIMIT 1");
        return matchPoolMapper.selectOne(wrapper);
    }

    /**
     * 取消匹配
     */
    @Transactional
    public void cancelMatch(Long userId, Long showtimeId) {
        LambdaQueryWrapper<MatchPool> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MatchPool::getUserId, userId)
               .eq(MatchPool::getShowtimeId, showtimeId)
               .eq(MatchPool::getStatus, MatchPool.MatchStatusEnum.WAITING);
        MatchPool pool = matchPoolMapper.selectOne(wrapper);
        if (pool != null) {
            pool.setStatus(MatchPool.MatchStatusEnum.CANCELLED);
            matchPoolMapper.updateById(pool);
        }
    }

    /**
     * 获取陪伴记录
     */
    public Companion getCompanionByOrderId(Long orderId) {
        LambdaQueryWrapper<Companion> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Companion::getOrderId, orderId);
        Companion companion = companionMapper.selectOne(wrapper);
        if (companion != null) {
            fillCompanionInfo(companion);
        }
        return companion;
    }

    /**
     * 查找邻座 (左右优先，前后次之)
     */
    private Seat findAdjacentSeat(Long showtimeId, Long seatId) {
        Seat userSeat = seatMapper.selectById(seatId);
        if (userSeat == null) return null;

        String row = userSeat.getRowNum();
        int col = userSeat.getColNum();

        // 优先查找左右邻座
        int[] colOffsets = {1, -1}; // 右边、左边
        for (int offset : colOffsets) {
            int targetCol = col + offset;
            if (targetCol > 0) {
                Seat adjacent = findSeatByPosition(showtimeId, row, targetCol);
                if (adjacent != null && adjacent.getStatus() == Seat.SeatStatusEnum.AVAILABLE) {
                    return adjacent;
                }
            }
        }

        // 没有左右邻座，查找前后排同列
        String[] rowOffsets = getAdjacentRows(row);
        for (String targetRow : rowOffsets) {
            Seat adjacent = findSeatByPosition(showtimeId, targetRow, col);
            if (adjacent != null && adjacent.getStatus() == Seat.SeatStatusEnum.AVAILABLE) {
                return adjacent;
            }
        }

        return null;
    }

    private Seat findSeatByPosition(Long showtimeId, String row, int col) {
        LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Seat::getShowtimeId, showtimeId)
               .eq(Seat::getRowNum, row)
               .eq(Seat::getColNum, col);
        return seatMapper.selectOne(wrapper);
    }

    private String[] getAdjacentRows(String row) {
        char c = row.charAt(0);
        return new String[]{
            String.valueOf((char)(c + 1)), // 后一排
            String.valueOf((char)(c - 1))  // 前一排
        };
    }

    private void fillCompanionInfo(Companion companion) {
        if (companion.getDollTypeId() != null) {
            companion.setDollType(dollTypeMapper.selectById(companion.getDollTypeId()));
        }
        if (companion.getCompanionSeatId() != null) {
            companion.setCompanionSeat(seatMapper.selectById(companion.getCompanionSeatId()));
        }
    }
}
