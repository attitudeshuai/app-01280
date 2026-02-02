package com.movieticket.controller;

import com.movieticket.common.PageResult;
import com.movieticket.common.Result;
import com.movieticket.entity.Seat;
import com.movieticket.entity.Showtime;
import com.movieticket.service.ShowtimeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

/**
 * 场次控制器
 */
@RestController
@RequestMapping("/api/showtimes")
@RequiredArgsConstructor
@Tag(name = "场次接口", description = "场次查询及座位相关接口")
public class ShowtimeController {

    private final ShowtimeService showtimeService;

    /**
     * 获取场次列表
     */
    @GetMapping
    @Operation(summary = "获取场次列表", description = "支持按影院、影片、日期筛选")
    public Result<PageResult<Showtime>> getList(
            @Parameter(description = "影院ID") @RequestParam(required = false) Long cinemaId,
            @Parameter(description = "影片ID") @RequestParam(required = false) Long movieId,
            @Parameter(description = "放映日期 (yyyy-MM-dd)") 
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer page,
            @Parameter(description = "每页数量") @RequestParam(defaultValue = "20") Integer size
    ) {
        PageResult<Showtime> result = showtimeService.getList(cinemaId, movieId, date, page, size);
        return Result.success(result);
    }

    /**
     * 获取场次详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取场次详情", description = "包含影片、影厅、影院信息")
    public Result<Showtime> getDetail(
            @Parameter(description = "场次ID") @PathVariable Long id
    ) {
        Showtime showtime = showtimeService.getDetail(id);
        return Result.success(showtime);
    }

    /**
     * 获取场次座位图
     */
    @GetMapping("/{id}/seats")
    @Operation(summary = "获取场次座位图", description = "返回所有座位及状态")
    public Result<List<Seat>> getSeatMap(
            @Parameter(description = "场次ID") @PathVariable Long id
    ) {
        List<Seat> seats = showtimeService.getSeatMap(id);
        return Result.success(seats);
    }
}
