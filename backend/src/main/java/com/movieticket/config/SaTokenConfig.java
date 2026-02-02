package com.movieticket.config;

import cn.dev33.satoken.interceptor.SaInterceptor;
import cn.dev33.satoken.router.SaRouter;
import cn.dev33.satoken.stp.StpUtil;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Sa-Token 配置
 */
@Configuration
public class SaTokenConfig implements WebMvcConfigurer {

    /**
     * 注册 Sa-Token 拦截器
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new SaInterceptor(handle -> {
            // 登录校验 -- 排除不需要登录的接口
            SaRouter.match("/**")
                    .notMatch(
                            // 静态资源
                            "/favicon.ico",
                            "/error",
                            // Swagger/Knife4j 文档
                            "/doc.html",
                            "/webjars/**",
                            "/swagger-resources/**",
                            "/v3/api-docs/**",
                            // 健康检查
                            "/actuator/**",
                            // 认证接口
                            "/api/auth/login",
                            "/api/auth/register",
                            "/api/auth/captcha",
                            // 公开接口 (无需登录)
                            "/api/public/**",
                            "/api/cinemas",
                            "/api/cinemas/**",
                            "/api/movies",
                            "/api/movies/**",
                            "/api/showtimes",
                            "/api/showtimes/**"
                    )
                    .check(r -> StpUtil.checkLogin());
            
            // 管理员权限校验
            SaRouter.match("/api/admin/**")
                    .check(r -> StpUtil.checkRole("ADMIN"));
                    
        })).addPathPatterns("/**");
    }
}
