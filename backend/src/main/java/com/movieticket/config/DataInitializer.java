package com.movieticket.config;

import cn.hutool.crypto.digest.BCrypt;
import com.movieticket.entity.User;
import com.movieticket.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * 数据初始化器 - 确保测试用户密码正确
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserMapper userMapper;
    
    // 测试密码 (明文)
    private static final String TEST_PASSWORD = "123456";

    @Override
    public void run(String... args) {
        log.info("========== 初始化测试数据 ==========");
        
        // 生成正确的 BCrypt 密码
        String hashedPassword = BCrypt.hashpw(TEST_PASSWORD);
        log.info("BCrypt hash 生成成功");
        
        // 更新测试用户密码
        updateUserPassword("13800138000", hashedPassword);
        updateUserPassword("13900139000", hashedPassword);
        updateUserPassword("admin", hashedPassword);
        
        log.info("========== 测试数据初始化完成 ==========");
        log.info("测试账号: 13800138000 / 123456 (普通用户)");
        log.info("测试账号: admin / 123456 (管理员)");
    }
    
    private void updateUserPassword(String phone, String hashedPassword) {
        User user = userMapper.selectByPhone(phone);
        if (user != null) {
            user.setPassword(hashedPassword);
            userMapper.updateById(user);
            log.info("已更新用户 {} 的密码", phone);
        } else {
            log.warn("用户 {} 不存在，跳过密码更新", phone);
        }
    }
}
