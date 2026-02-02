package com.movieticket.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.movieticket.common.PageResult;
import com.movieticket.common.Result;
import com.movieticket.entity.Movie;
import com.movieticket.mapper.MovieMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 管理后台 - 影片管理
 */
@RestController
@RequestMapping("/api/admin/movies")
@RequiredArgsConstructor
@SaCheckRole("ADMIN")
@Tag(name = "管理后台-影片管理", description = "影片的增删改查")
public class AdminMovieController {

    private final MovieMapper movieMapper;

    /**
     * 获取影片列表 (分页)
     */
    @GetMapping
    @Operation(summary = "获取影片列表")
    public Result<PageResult<Movie>> list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size
    ) {
        Page<Movie> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Movie> wrapper = new LambdaQueryWrapper<>();
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Movie::getTitle, keyword);
        }
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Movie::getStatus, Movie.StatusEnum.valueOf(status));
        }
        
        wrapper.orderByDesc(Movie::getId);
        Page<Movie> result = movieMapper.selectPage(pageParam, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取影片详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取影片详情")
    public Result<Movie> getById(@PathVariable Long id) {
        Movie movie = movieMapper.selectById(id);
        return Result.success(movie);
    }

    /**
     * 创建影片
     */
    @PostMapping
    @Operation(summary = "创建影片")
    public Result<Movie> create(@Valid @RequestBody Movie movie) {
        movieMapper.insert(movie);
        return Result.success("创建成功", movie);
    }

    /**
     * 更新影片
     */
    @PutMapping("/{id}")
    @Operation(summary = "更新影片")
    public Result<Movie> update(@PathVariable Long id, @Valid @RequestBody Movie movie) {
        movie.setId(id);
        movieMapper.updateById(movie);
        return Result.success("更新成功", movie);
    }

    /**
     * 删除影片
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "删除影片")
    public Result<Void> delete(@PathVariable Long id) {
        movieMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    /**
     * 更新影片状态
     */
    @PutMapping("/{id}/status")
    @Operation(summary = "更新影片状态")
    public Result<Void> updateStatus(
            @PathVariable Long id,
            @RequestParam String status
    ) {
        Movie movie = new Movie();
        movie.setId(id);
        movie.setStatus(Movie.StatusEnum.valueOf(status));
        movieMapper.updateById(movie);
        return Result.success("状态更新成功", null);
    }
}
