package com.movieticket.controller;

import com.movieticket.common.PageResult;
import com.movieticket.common.Result;
import com.movieticket.entity.Cinema;
import com.movieticket.service.CinemaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 影院控制器
 */
@RestController
@RequestMapping("/api/cinemas")
@RequiredArgsConstructor
@Tag(name = "影院接口", description = "影院查询相关接口")
public class CinemaController {

    private final CinemaService cinemaService;

    /**
     * 获取影院列表
     */
    @GetMapping
    @Operation(summary = "获取影院列表", description = "分页查询影院，支持按城市和关键词筛选")
    public Result<PageResult<Cinema>> getList(
            @Parameter(description = "城市") @RequestParam(required = false) String city,
            @Parameter(description = "搜索关键词") @RequestParam(required = false) String keyword,
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer page,
            @Parameter(description = "每页数量") @RequestParam(defaultValue = "10") Integer size
    ) {
        PageResult<Cinema> result = cinemaService.getList(city, keyword, page, size);
        return Result.success(result);
    }

    /**
     * 获取影院详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取影院详情", description = "包含影厅列表")
    public Result<Cinema> getDetail(
            @Parameter(description = "影院ID") @PathVariable Long id
    ) {
        Cinema cinema = cinemaService.getDetail(id);
        return Result.success(cinema);
    }

    /**
     * 获取所有城市
     */
    @GetMapping("/cities")
    @Operation(summary = "获取所有城市", description = "用于城市选择器")
    public Result<List<String>> getCities() {
        List<String> cities = cinemaService.getCities();
        return Result.success(cities);
    }
}
