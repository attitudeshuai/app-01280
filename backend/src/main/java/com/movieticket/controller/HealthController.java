package com.movieticket.controller;

import com.movieticket.common.Result;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 健康检查控制器
 */
@RestController
@RequestMapping("/api/public")
@Tag(name = "公共接口", description = "无需登录即可访问的公共接口")
public class HealthController {

    @GetMapping("/ping")
    @Operation(summary = "服务存活检查", description = "返回服务状态")
    public Result<Map<String, Object>> ping() {
        Map<String, Object> data = new HashMap<>();
        data.put("status", "UP");
        data.put("timestamp", LocalDateTime.now());
        data.put("service", "movie-ticket-backend");
        data.put("version", "1.0.0");
        return Result.success(data);
    }

    @GetMapping("/info")
    @Operation(summary = "服务信息", description = "返回服务详细信息")
    public Result<Map<String, Object>> info() {
        Map<String, Object> data = new HashMap<>();
        data.put("name", "电影票预订系统");
        data.put("version", "1.0.0");
        data.put("description", "在线电影票预订平台后端服务");
        data.put("features", new String[]{
                "用户认证 (SaToken)",
                "影院管理",
                "影片管理",
                "场次管理",
                "在线选座",
                "订单支付"
        });
        return Result.success(data);
    }
}
