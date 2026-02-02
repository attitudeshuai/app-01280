package com.movieticket.common;

import lombok.Getter;

/**
 * 响应状态码枚举
 */
@Getter
public enum ResultCode {

    // ===== 成功 =====
    SUCCESS(200, "操作成功"),

    // ===== 客户端错误 4xx =====
    FAIL(400, "操作失败"),
    PARAM_ERROR(400, "参数错误"),
    PARAM_NOT_VALID(400, "参数校验失败"),
    UNAUTHORIZED(401, "未登录或登录已过期"),
    FORBIDDEN(403, "无权限访问"),
    NOT_FOUND(404, "资源不存在"),
    METHOD_NOT_ALLOWED(405, "请求方法不允许"),
    
    // ===== 业务错误 =====
    USER_NOT_EXIST(1001, "用户不存在"),
    USER_ALREADY_EXIST(1002, "用户已存在"),
    PASSWORD_ERROR(1003, "密码错误"),
    PHONE_ALREADY_EXIST(1004, "手机号已被注册"),
    EMAIL_ALREADY_EXIST(1005, "邮箱已被注册"),
    
    CINEMA_NOT_EXIST(2001, "影院不存在"),
    HALL_NOT_EXIST(2002, "影厅不存在"),
    MOVIE_NOT_EXIST(2003, "影片不存在"),
    SHOWTIME_NOT_EXIST(2004, "场次不存在"),
    
    SEAT_NOT_AVAILABLE(3001, "座位不可选"),
    SEAT_ALREADY_LOCKED(3002, "座位已被锁定"),
    SEAT_ALREADY_SOLD(3003, "座位已售出"),
    SEAT_LOCK_EXPIRED(3004, "座位锁定已过期"),
    
    ORDER_NOT_EXIST(4001, "订单不存在"),
    ORDER_ALREADY_PAID(4002, "订单已支付"),
    ORDER_EXPIRED(4003, "订单已过期"),
    ORDER_CANCELLED(4004, "订单已取消"),
    PAY_FAILED(4005, "支付失败"),
    
    // ===== 服务器错误 5xx =====
    SYSTEM_ERROR(500, "系统错误"),
    SERVICE_UNAVAILABLE(503, "服务不可用");

    private final Integer code;
    private final String message;

    ResultCode(Integer code, String message) {
        this.code = code;
        this.message = message;
    }
}
