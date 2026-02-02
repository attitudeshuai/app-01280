package com.movieticket.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.movieticket.common.PageResult;
import com.movieticket.common.Result;
import com.movieticket.entity.User;
import com.movieticket.mapper.UserMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

/**
 * 管理后台 - 用户管理
 */
@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
@SaCheckRole("ADMIN")
@Tag(name = "管理后台-用户管理", description = "用户查询和管理")
public class AdminUserController {

    private final UserMapper userMapper;

    /**
     * 获取用户列表 (分页)
     */
    @GetMapping
    @Operation(summary = "获取用户列表")
    public Result<PageResult<User>> list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String role,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "20") Integer size
    ) {
        Page<User> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w
                    .like(User::getNickname, keyword)
                    .or()
                    .like(User::getPhone, keyword)
            );
        }
        if (StringUtils.hasText(role)) {
            wrapper.eq(User::getRole, User.RoleEnum.valueOf(role));
        }
        
        wrapper.orderByDesc(User::getCreatedAt);
        Page<User> result = userMapper.selectPage(pageParam, wrapper);
        
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取用户详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取用户详情")
    public Result<User> getById(@PathVariable Long id) {
        User user = userMapper.selectById(id);
        return Result.success(user);
    }

    /**
     * 更新用户状态 (启用/禁用)
     */
    @PutMapping("/{id}/status")
    @Operation(summary = "更新用户状态")
    public Result<Void> updateStatus(
            @PathVariable Long id,
            @RequestParam Integer status
    ) {
        User user = new User();
        user.setId(id);
        user.setStatus(status);
        userMapper.updateById(user);
        return Result.success(status == 1 ? "用户已启用" : "用户已禁用", null);
    }

    /**
     * 更新用户角色
     */
    @PutMapping("/{id}/role")
    @Operation(summary = "更新用户角色")
    public Result<Void> updateRole(
            @PathVariable Long id,
            @RequestParam String role
    ) {
        User user = new User();
        user.setId(id);
        user.setRole(User.RoleEnum.valueOf(role));
        userMapper.updateById(user);
        return Result.success("角色更新成功", null);
    }
}
