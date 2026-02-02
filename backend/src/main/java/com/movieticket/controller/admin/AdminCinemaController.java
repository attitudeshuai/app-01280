package com.movieticket.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.movieticket.common.PageResult;
import com.movieticket.common.Result;
import com.movieticket.entity.Cinema;
import com.movieticket.entity.Hall;
import com.movieticket.mapper.CinemaMapper;
import com.movieticket.mapper.HallMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 管理后台 - 影院管理
 */
@RestController
@RequestMapping("/api/admin/cinemas")
@RequiredArgsConstructor
@SaCheckRole("ADMIN")
@Tag(name = "管理后台-影院管理", description = "影院和影厅的增删改查")
public class AdminCinemaController {

    private final CinemaMapper cinemaMapper;
    private final HallMapper hallMapper;

    /**
     * 获取影院列表 (分页)
     */
    @GetMapping
    @Operation(summary = "获取影院列表")
    public Result<PageResult<Cinema>> list(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size
    ) {
        Page<Cinema> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Cinema> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Cinema::getName, keyword);
        }
        wrapper.orderByDesc(Cinema::getId);
        Page<Cinema> result = cinemaMapper.selectPage(pageParam, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取影院详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取影院详情")
    public Result<Cinema> getById(@PathVariable Long id) {
        Cinema cinema = cinemaMapper.selectById(id);
        if (cinema != null) {
            cinema.setHalls(hallMapper.selectByCinemaId(id));
        }
        return Result.success(cinema);
    }

    /**
     * 创建影院
     */
    @PostMapping
    @Operation(summary = "创建影院")
    public Result<Cinema> create(@Valid @RequestBody Cinema cinema) {
        cinema.setStatus(1);
        cinemaMapper.insert(cinema);
        return Result.success("创建成功", cinema);
    }

    /**
     * 更新影院
     */
    @PutMapping("/{id}")
    @Operation(summary = "更新影院")
    public Result<Cinema> update(@PathVariable Long id, @Valid @RequestBody Cinema cinema) {
        cinema.setId(id);
        cinemaMapper.updateById(cinema);
        return Result.success("更新成功", cinema);
    }

    /**
     * 删除影院
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "删除影院")
    public Result<Void> delete(@PathVariable Long id) {
        cinemaMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    // ========== 影厅管理 ==========

    /**
     * 获取影厅列表
     */
    @GetMapping("/{cinemaId}/halls")
    @Operation(summary = "获取影厅列表")
    public Result<List<Hall>> getHalls(@PathVariable Long cinemaId) {
        List<Hall> halls = hallMapper.selectByCinemaId(cinemaId);
        return Result.success(halls);
    }

    /**
     * 创建影厅
     */
    @PostMapping("/{cinemaId}/halls")
    @Operation(summary = "创建影厅")
    public Result<Hall> createHall(@PathVariable Long cinemaId, @Valid @RequestBody Hall hall) {
        hall.setCinemaId(cinemaId);
        hall.setStatus(1);
        hall.setTotalSeats(hall.getSeatRows() * hall.getSeatCols());
        hallMapper.insert(hall);
        return Result.success("创建成功", hall);
    }

    /**
     * 更新影厅
     */
    @PutMapping("/halls/{id}")
    @Operation(summary = "更新影厅")
    public Result<Hall> updateHall(@PathVariable Long id, @Valid @RequestBody Hall hall) {
        hall.setId(id);
        hall.setTotalSeats(hall.getSeatRows() * hall.getSeatCols());
        hallMapper.updateById(hall);
        return Result.success("更新成功", hall);
    }

    /**
     * 删除影厅
     */
    @DeleteMapping("/halls/{id}")
    @Operation(summary = "删除影厅")
    public Result<Void> deleteHall(@PathVariable Long id) {
        hallMapper.deleteById(id);
        return Result.success("删除成功", null);
    }
}
