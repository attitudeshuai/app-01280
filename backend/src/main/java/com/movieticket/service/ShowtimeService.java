package com.movieticket.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.movieticket.common.PageResult;
import com.movieticket.common.ResultCode;
import com.movieticket.entity.*;
import com.movieticket.exception.BusinessException;
import com.movieticket.mapper.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

/**
 * 场次服务
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ShowtimeService {

    private final ShowtimeMapper showtimeMapper;
    private final MovieMapper movieMapper;
    private final HallMapper hallMapper;
    private final CinemaMapper cinemaMapper;
    private final SeatMapper seatMapper;

    /**
     * 查询场次列表
     */
    public PageResult<Showtime> getList(Long cinemaId, Long movieId, LocalDate date, Integer page, Integer size) {
        Page<Showtime> pageParam = new Page<>(page, size);
        
        LambdaQueryWrapper<Showtime> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Showtime::getStatus, 1); // 只查询正常的场次
        
        // 按影院筛选
        if (cinemaId != null) {
            // 先查询该影院的所有影厅
            List<Long> hallIds = hallMapper.selectByCinemaId(cinemaId)
                    .stream().map(Hall::getId).toList();
            if (hallIds.isEmpty()) {
                return new PageResult<>(List.of(), 0L, (long) size, (long) page);
            }
            wrapper.in(Showtime::getHallId, hallIds);
        }
        
        // 按影片筛选
        if (movieId != null) {
            wrapper.eq(Showtime::getMovieId, movieId);
        }
        
        // 按日期筛选
        if (date != null) {
            wrapper.eq(Showtime::getShowDate, date);
        } else {
            // 默认只查询今天及以后的场次
            wrapper.ge(Showtime::getShowDate, LocalDate.now());
        }
        
        // 排序: 日期 + 开始时间
        wrapper.orderByAsc(Showtime::getShowDate, Showtime::getStartTime);
        
        Page<Showtime> result = showtimeMapper.selectPage(pageParam, wrapper);
        
        // 填充关联信息
        result.getRecords().forEach(this::fillShowtimeInfo);
        
        return PageResult.of(result);
    }

    /**
     * 获取场次详情
     */
    public Showtime getDetail(Long id) {
        Showtime showtime = showtimeMapper.selectById(id);
        if (showtime == null) {
            throw new BusinessException(ResultCode.SHOWTIME_NOT_EXIST);
        }
        
        fillShowtimeInfo(showtime);
        return showtime;
    }

    /**
     * 获取场次座位图
     */
    public List<Seat> getSeatMap(Long showtimeId) {
        Showtime showtime = showtimeMapper.selectById(showtimeId);
        if (showtime == null) {
            throw new BusinessException(ResultCode.SHOWTIME_NOT_EXIST);
        }
        
        // 先释放过期锁定的座位
        seatMapper.releaseExpiredLocks();
        
        return seatMapper.selectByShowtimeId(showtimeId);
    }

    /**
     * 填充场次关联信息 (影片、影厅、影院)
     */
    private void fillShowtimeInfo(Showtime showtime) {
        if (showtime == null) return;
        
        // 填充影片信息
        if (showtime.getMovieId() != null) {
            Movie movie = movieMapper.selectById(showtime.getMovieId());
            showtime.setMovie(movie);
        }
        
        // 填充影厅和影院信息
        if (showtime.getHallId() != null) {
            Hall hall = hallMapper.selectById(showtime.getHallId());
            showtime.setHall(hall);
            
            if (hall != null && hall.getCinemaId() != null) {
                Cinema cinema = cinemaMapper.selectById(hall.getCinemaId());
                showtime.setCinema(cinema);
            }
        }
    }
}
