package com.movieticket.config;

import com.movieticket.common.Result;
import com.movieticket.common.ResultCode;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.TimeUnit;

/**
 * 接口限流配置
 */
@Slf4j
@Configuration
@RequiredArgsConstructor
public class RateLimitConfig implements WebMvcConfigurer {

    private final RedisTemplate<String, Object> redisTemplate;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new RateLimitInterceptor())
                .addPathPatterns("/api/**")
                .excludePathPatterns("/api/public/**", "/api/doc.html", "/api/v3/**");
    }

    /**
     * 限流拦截器
     */
    private class RateLimitInterceptor implements HandlerInterceptor {
        
        // 限流配置: 每分钟最大请求数
        private static final int MAX_REQUESTS_PER_MINUTE = 100;
        
        // 登录接口更严格: 每分钟最多5次
        private static final int MAX_LOGIN_PER_MINUTE = 5;

        @Override
        public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
            String ip = getClientIp(request);
            String uri = request.getRequestURI();
            
            // 登录接口特殊限流
            if (uri.contains("/auth/login")) {
                return checkLimit(ip, "login", MAX_LOGIN_PER_MINUTE, response);
            }
            
            // 通用接口限流
            return checkLimit(ip, "api", MAX_REQUESTS_PER_MINUTE, response);
        }
        
        private boolean checkLimit(String ip, String type, int maxRequests, HttpServletResponse response) throws IOException {
            String key = "rate_limit:" + type + ":" + ip;
            
            Long count = redisTemplate.opsForValue().increment(key);
            if (count == null) {
                count = 1L;
            }
            
            // 第一次访问，设置过期时间
            if (count == 1) {
                redisTemplate.expire(key, 1, TimeUnit.MINUTES);
            }
            
            // 超过限制
            if (count > maxRequests) {
                log.warn("Rate limit exceeded: ip={}, type={}, count={}", ip, type, count);
                writeErrorResponse(response);
                return false;
            }
            
            return true;
        }
        
        private String getClientIp(HttpServletRequest request) {
            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
                ip = request.getHeader("X-Real-IP");
            }
            if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
                ip = request.getRemoteAddr();
            }
            // 取第一个IP
            if (ip != null && ip.contains(",")) {
                ip = ip.split(",")[0].trim();
            }
            return ip;
        }
        
        private void writeErrorResponse(HttpServletResponse response) throws IOException {
            response.setStatus(429);
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter writer = response.getWriter();
            writer.write("{\"code\":429,\"message\":\"请求过于频繁，请稍后再试\",\"data\":null}");
            writer.flush();
        }
    }
}
