package com.movieticket.config;

import cn.dev33.satoken.stp.StpInterface;
import com.movieticket.entity.User;
import com.movieticket.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Sa-Token 权限认证接口实现
 */
@Component
@RequiredArgsConstructor
public class StpInterfaceImpl implements StpInterface {

    private final UserMapper userMapper;

    /**
     * 返回指定账号 id 所拥有的权限码集合
     * @param loginId 账号id
     * @param loginType 账号类型
     * @return 权限码集合
     */
    @Override
    public List<String> getPermissionList(Object loginId, String loginType) {
        // 本系统暂不使用细粒度权限控制, 返回空列表
        return new ArrayList<>();
    }

    /**
     * 返回指定账号 id 所拥有的角色标识集合
     * @param loginId 账号id
     * @param loginType 账号类型
     * @return 角色标识集合
     */
    @Override
    public List<String> getRoleList(Object loginId, String loginType) {
        List<String> roles = new ArrayList<>();
        
        // 查询用户角色
        Long userId = Long.parseLong(loginId.toString());
        User user = userMapper.selectById(userId);
        
        if (user != null && user.getRole() != null) {
            roles.add(user.getRole().name());
        }
        
        return roles;
    }
}
