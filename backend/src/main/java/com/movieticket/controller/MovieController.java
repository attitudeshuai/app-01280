package com.movieticket.controller;

import com.movieticket.common.PageResult;
import com.movieticket.common.Result;
import com.movieticket.entity.Movie;
import com.movieticket.service.MovieService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 影片控制器
 */
@RestController
@RequestMapping("/api/movies")
@RequiredArgsConstructor
@Tag(name = "影片接口", description = "影片查询相关接口")
public class MovieController {

    private final MovieService movieService;

    /**
     * 获取影片列表
     */
    @GetMapping
    @Operation(summary = "获取影片列表", description = "分页查询影片，支持按状态和关键词筛选")
    public Result<PageResult<Movie>> getList(
            @Parameter(description = "状态: SHOWING=热映, COMING=即将上映") 
            @RequestParam(required = false) String status,
            @Parameter(description = "搜索关键词") @RequestParam(required = false) String keyword,
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer page,
            @Parameter(description = "每页数量") @RequestParam(defaultValue = "10") Integer size
    ) {
        PageResult<Movie> result = movieService.getList(status, keyword, page, size);
        return Result.success(result);
    }

    /**
     * 获取热映影片
     */
    @GetMapping("/showing")
    @Operation(summary = "获取热映影片")
    public Result<PageResult<Movie>> getShowing(
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer page,
            @Parameter(description = "每页数量") @RequestParam(defaultValue = "10") Integer size
    ) {
        PageResult<Movie> result = movieService.getShowing(page, size);
        return Result.success(result);
    }

    /**
     * 获取即将上映影片
     */
    @GetMapping("/coming")
    @Operation(summary = "获取即将上映影片")
    public Result<PageResult<Movie>> getComing(
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer page,
            @Parameter(description = "每页数量") @RequestParam(defaultValue = "10") Integer size
    ) {
        PageResult<Movie> result = movieService.getComing(page, size);
        return Result.success(result);
    }

    /**
     * 获取影片详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取影片详情")
    public Result<Movie> getDetail(
            @Parameter(description = "影片ID") @PathVariable Long id
    ) {
        Movie movie = movieService.getDetail(id);
        return Result.success(movie);
    }
}
