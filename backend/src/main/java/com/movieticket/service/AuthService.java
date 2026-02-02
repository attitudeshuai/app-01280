package com.movieticket.service;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.movieticket.common.ResultCode;
import com.movieticket.dto.auth.LoginRequest;
import com.movieticket.dto.auth.LoginResponse;
import com.movieticket.dto.auth.RegisterRequest;
import com.movieticket.entity.User;
import com.movieticket.exception.BusinessException;
import com.movieticket.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

/**
 * 认证服务
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserMapper userMapper;

    /**
     * 用户注册
     */
    @Transactional
    public User register(RegisterRequest request) {
        // 校验手机号和邮箱至少填一个
        if (!StringUtils.hasText(request.getPhone()) && !StringUtils.hasText(request.getEmail())) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "手机号和邮箱至少填写一个");
        }

        // 检查手机号是否已存在
        if (StringUtils.hasText(request.getPhone())) {
            if (userMapper.countByPhone(request.getPhone()) > 0) {
                throw new BusinessException(ResultCode.PHONE_ALREADY_EXIST);
            }
        }

        // 检查邮箱是否已存在
        if (StringUtils.hasText(request.getEmail())) {
            if (userMapper.countByEmail(request.getEmail()) > 0) {
                throw new BusinessException(ResultCode.EMAIL_ALREADY_EXIST);
            }
        }

        // 创建用户
        User user = new User();
        user.setPhone(request.getPhone());
        user.setEmail(request.getEmail());
        user.setPassword(BCrypt.hashpw(request.getPassword())); // BCrypt 加密
        user.setNickname(StringUtils.hasText(request.getNickname()) 
                ? request.getNickname() 
                : "用户" + RandomUtil.randomNumbers(6));
        user.setAvatar("https://api.dicebear.com/7.x/avataaars/svg?seed=" + RandomUtil.randomString(8));
        user.setRole(User.RoleEnum.USER);
        user.setStatus(1);

        userMapper.insert(user);
        log.info("用户注册成功: id={}, phone={}", user.getId(), user.getPhone());

        return user;
    }

    /**
     * 用户登录
     */
    public LoginResponse login(LoginRequest request) {
        User user = null;

        // 根据手机号或邮箱查询用户
        if (StringUtils.hasText(request.getPhone())) {
            user = userMapper.selectByPhone(request.getPhone());
        } else if (StringUtils.hasText(request.getEmail())) {
            user = userMapper.selectByEmail(request.getEmail());
        }

        // 管理员账号特殊处理 (admin)
        if (user == null && "admin".equals(request.getPhone())) {
            user = userMapper.selectByPhone("admin");
        }

        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_EXIST);
        }

        // 验证密码
        if (!BCrypt.checkpw(request.getPassword(), user.getPassword())) {
            throw new BusinessException(ResultCode.PASSWORD_ERROR);
        }

        // 检查用户状态
        if (user.getStatus() != 1) {
            throw new BusinessException("账号已被禁用");
        }

        // SaToken 登录
        StpUtil.login(user.getId());
        String token = StpUtil.getTokenValue();

        log.info("用户登录成功: id={}, phone={}, token={}", user.getId(), user.getPhone(), token);

        return new LoginResponse(token, user);
    }

    /**
     * 获取当前登录用户信息
     */
    public User getCurrentUser() {
        Long userId = StpUtil.getLoginIdAsLong();
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_EXIST);
        }
        return user;
    }

    /**
     * 退出登录
     */
    public void logout() {
        StpUtil.logout();
    }
}
