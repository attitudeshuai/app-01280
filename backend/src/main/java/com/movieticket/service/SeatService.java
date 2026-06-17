package com.movieticket.service;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.movieticket.common.ResultCode;
import com.movieticket.entity.Seat;
import com.movieticket.exception.BusinessException;
import com.movieticket.mapper.SeatMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 座位服务
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SeatService {

    private final SeatMapper seatMapper;

    /**
     * 锁定座位 (15分钟)
     */
    @Transactional
    public void lockSeats(Long showtimeId, List<Long> seatIds, Long userId) {
        // 先释放过期锁定
        seatMapper.releaseExpiredLocks();

        for (Long seatId : seatIds) {
            Seat seat = seatMapper.selectById(seatId);
            
            if (seat == null) {
                throw new BusinessException("座位不存在: " + seatId);
            }
            
            if (!seat.getShowtimeId().equals(showtimeId)) {
                throw new BusinessException("座位不属于该场次");
            }
            
            // 检查座位状态
            if (seat.getStatus() == Seat.SeatStatusEnum.SOLD) {
                throw new BusinessException(ResultCode.SEAT_ALREADY_SOLD, 
                        "座位 " + seat.getSeatLabel() + " 已售出");
            }
            
            if (seat.getStatus() == Seat.SeatStatusEnum.LOCKED) {
                // 检查是否是当前用户锁定的
                if (!userId.equals(seat.getLockedBy())) {
                    throw new BusinessException(ResultCode.SEAT_ALREADY_LOCKED, 
                            "座位 " + seat.getSeatLabel() + " 已被其他用户锁定");
                }
            }
            
            // 锁定座位
            LambdaUpdateWrapper<Seat> updateWrapper = new LambdaUpdateWrapper<>();
            updateWrapper.eq(Seat::getId, seatId)
                    .set(Seat::getStatus, Seat.SeatStatusEnum.LOCKED)
                    .set(Seat::getLockedBy, userId)
                    .set(Seat::getLockedUntil, LocalDateTime.now().plusMinutes(15));
            
            seatMapper.update(null, updateWrapper);
        }
        
        log.info("座位锁定成功: showtimeId={}, seatIds={}, userId={}", showtimeId, seatIds, userId);
    }

    /**
     * 释放座位锁定
     */
    @Transactional
    public void releaseSeats(List<Long> seatIds) {
        LambdaUpdateWrapper<Seat> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.in(Seat::getId, seatIds)
                .eq(Seat::getStatus, Seat.SeatStatusEnum.LOCKED)
                .set(Seat::getStatus, Seat.SeatStatusEnum.AVAILABLE)
                .set(Seat::getLockedBy, null)
                .set(Seat::getLockedUntil, null);
        
        seatMapper.update(null, updateWrapper);
        log.info("座位释放成功: seatIds={}", seatIds);
    }

    /**
     * 确认座位售出
     */
    @Transactional
    public void confirmSeatsSold(List<Long> seatIds) {
        LambdaUpdateWrapper<Seat> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.in(Seat::getId, seatIds)
                .eq(Seat::getStatus, Seat.SeatStatusEnum.LOCKED)
                .set(Seat::getStatus, Seat.SeatStatusEnum.SOLD)
                .set(Seat::getLockedBy, null)
                .set(Seat::getLockedUntil, null);
        
        seatMapper.update(null, updateWrapper);
        log.info("座位确认售出: seatIds={}", seatIds);
    }
}
