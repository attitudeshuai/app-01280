package com.movieticket.controller;

import com.movieticket.common.Result;
import com.movieticket.dto.auth.LoginRequest;
import com.movieticket.dto.auth.LoginResponse;
import com.movieticket.dto.auth.RegisterRequest;
import com.movieticket.dto.user.UserVO;
import com.movieticket.entity.User;
import com.movieticket.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 认证控制器
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "认证接口", description = "用户注册、登录、退出等认证相关接口")
public class AuthController {

    private final AuthService authService;

    /**
     * 用户注册
     */
    @PostMapping("/register")
    @Operation(summary = "用户注册", description = "手机号和邮箱至少填写一个")
    public Result<UserVO> register(@Valid @RequestBody RegisterRequest request) {
        User user = authService.register(request);
        return Result.success("注册成功", UserVO.fromEntity(user));
    }

    /**
     * 用户登录
     */
    @PostMapping("/login")
    @Operation(summary = "用户登录", description = "使用手机号或邮箱登录，返回Token")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = authService.login(request);
        return Result.success("登录成功", response);
    }

    /**
     * 获取当前用户信息
     */
    @GetMapping("/info")
    @Operation(summary = "获取当前用户信息", description = "需要登录后调用")
    public Result<UserVO> getUserInfo() {
        User user = authService.getCurrentUser();
        return Result.success(UserVO.fromEntity(user));
    }

    /**
     * 退出登录
     */
    @PostMapping("/logout")
    @Operation(summary = "退出登录", description = "清除登录状态")
    public Result<Void> logout() {
        authService.logout();
        return Result.success("退出成功", null);
    }
}
