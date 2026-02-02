package com.movieticket.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.movieticket.common.Result;
import com.movieticket.entity.Companion;
import com.movieticket.entity.DollType;
import com.movieticket.entity.MatchPool;
import com.movieticket.service.CompanionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 陪伴功能控制器
 */
@RestController
@RequestMapping("/api/companion")
@RequiredArgsConstructor
@Tag(name = "陪伴功能", description = "玩偶陪伴和路人匹配")
public class CompanionController {

    private final CompanionService companionService;

    // ========== 玩偶陪伴 ==========

    /**
     * 获取可用玩偶列表
     */
    @GetMapping("/dolls")
    @Operation(summary = "获取可用玩偶列表")
    public Result<List<DollType>> getDolls() {
        List<DollType> dolls = companionService.getAvailableDolls();
        return Result.success(dolls);
    }

    /**
     * 获取玩偶详情
     */
    @GetMapping("/dolls/{id}")
    @Operation(summary = "获取玩偶详情")
    public Result<DollType> getDollDetail(@PathVariable Long id) {
        DollType doll = companionService.getDollById(id);
        return Result.success(doll);
    }

    // ========== 路人匹配 ==========

    /**
     * 加入匹配池
     */
    @PostMapping("/match/join")
    @Operation(summary = "加入匹配池")
    public Result<MatchPool> joinMatchPool(
            @RequestParam Long showtimeId,
            @RequestParam Long seatId
    ) {
        Long userId = StpUtil.getLoginIdAsLong();
        MatchPool pool = companionService.joinMatchPool(userId, showtimeId, seatId);
        return Result.success("已加入匹配池", pool);
    }

    /**
     * 查询匹配状态
     */
    @GetMapping("/match/status")
    @Operation(summary = "查询匹配状态")
    public Result<MatchPool> getMatchStatus(
            @RequestParam Long showtimeId
    ) {
        Long userId = StpUtil.getLoginIdAsLong();
        MatchPool pool = companionService.getMatchStatus(userId, showtimeId);
        return Result.success(pool);
    }

    /**
     * 取消匹配
     */
    @PostMapping("/match/cancel")
    @Operation(summary = "取消匹配")
    public Result<Void> cancelMatch(
            @RequestParam Long showtimeId
    ) {
        Long userId = StpUtil.getLoginIdAsLong();
        companionService.cancelMatch(userId, showtimeId);
        return Result.success("已取消匹配", null);
    }

    // ========== 陪伴记录 ==========

    /**
     * 获取订单的陪伴信息
     */
    @GetMapping("/order/{orderId}")
    @Operation(summary = "获取订单的陪伴信息")
    public Result<Companion> getCompanionByOrder(@PathVariable Long orderId) {
        Companion companion = companionService.getCompanionByOrderId(orderId);
        return Result.success(companion);
    }
}
