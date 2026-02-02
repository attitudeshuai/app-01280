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
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

/**
 * 管理后台 - 场次管理
 */
@RestController
@RequestMapping("/api/admin/showtimes")
@RequiredArgsConstructor
@SaCheckRole("ADMIN")
@Tag(name = "管理后台-场次管理", description = "场次的增删改查")
public class AdminShowtimeController {

    private final ShowtimeMapper showtimeMapper;
    private final MovieMapper movieMapper;
    private final HallMapper hallMapper;
    private final CinemaMapper cinemaMapper;
    private final SeatMapper seatMapper;

    /**
     * 获取场次列表 (分页)
     */
    @GetMapping
    @Operation(summary = "获取场次列表")
    public Result<PageResult<Showtime>> list(
            @RequestParam(required = false) Long cinemaId,
            @RequestParam(required = false) Long movieId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "20") Integer size
    ) {
        Page<Showtime> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Showtime> wrapper = new LambdaQueryWrapper<>();
        
        if (movieId != null) {
            wrapper.eq(Showtime::getMovieId, movieId);
        }
        
        wrapper.orderByDesc(Showtime::getShowDate, Showtime::getStartTime);
        Page<Showtime> result = showtimeMapper.selectPage(pageParam, wrapper);
        
        // 填充关联信息
        result.getRecords().forEach(this::fillShowtimeInfo);
        
        return Result.success(PageResult.of(result));
    }

    /**
     * 创建场次
     */
    @PostMapping
    @Transactional
    @Operation(summary = "创建场次")
    public Result<Showtime> create(@Valid @RequestBody Showtime showtime) {
        // 获取影厅信息
        Hall hall = hallMapper.selectById(showtime.getHallId());
        if (hall == null) {
            return Result.fail("影厅不存在");
        }
        
        showtime.setAvailableSeats(hall.getTotalSeats());
        showtime.setStatus(1);
        showtimeMapper.insert(showtime);
        
        // 创建座位
        createSeatsForShowtime(showtime.getId(), hall);
        
        return Result.success("创建成功", showtime);
    }

    /**
     * 更新场次
     */
    @PutMapping("/{id}")
    @Operation(summary = "更新场次")
    public Result<Showtime> update(@PathVariable Long id, @Valid @RequestBody Showtime showtime) {
        showtime.setId(id);
        showtimeMapper.updateById(showtime);
        return Result.success("更新成功", showtime);
    }

    /**
     * 删除场次
     */
    @DeleteMapping("/{id}")
    @Transactional
    @Operation(summary = "删除场次")
    public Result<Void> delete(@PathVariable Long id) {
        // 删除关联座位
        LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Seat::getShowtimeId, id);
        seatMapper.delete(wrapper);
        
        // 删除场次
        showtimeMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    /**
     * 为场次创建座位
     */
    private void createSeatsForShowtime(Long showtimeId, Hall hall) {
        int rows = hall.getSeatRows();
        int cols = hall.getSeatCols();
        
        for (int r = 1; r <= rows; r++) {
            String rowNum = String.valueOf((char) ('A' + r - 1));
            for (int c = 1; c <= cols; c++) {
                Seat seat = new Seat();
                seat.setShowtimeId(showtimeId);
                seat.setRowNum(rowNum);
                seat.setColNum(c);
                seat.setSeatLabel(rowNum + c);
                seat.setSeatType(r <= 2 ? Seat.SeatTypeEnum.VIP : Seat.SeatTypeEnum.NORMAL);
                seat.setStatus(Seat.SeatStatusEnum.AVAILABLE);
                seatMapper.insert(seat);
            }
        }
    }

    /**
     * 填充场次关联信息
     */
    private void fillShowtimeInfo(Showtime showtime) {
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
    }
}
