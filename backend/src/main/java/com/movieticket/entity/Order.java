package com.movieticket.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 订单实体
 */
@Data
@TableName("`order`")  // order 是 MySQL 保留字, 需要反引号
@Schema(description = "订单实体")
public class Order implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @Schema(description = "订单ID")
    private Long id;

    @Schema(description = "订单号")
    private String orderNo;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "场次ID")
    private Long showtimeId;

    @Schema(description = "座位信息(JSON)")
    private String seatInfo;

    @Schema(description = "座位数量")
    private Integer seatCount;

    @Schema(description = "单价")
    private BigDecimal unitPrice;

    @Schema(description = "总金额")
    private BigDecimal totalAmount;

    @Schema(description = "状态: PENDING=待支付, PAID=已支付, USED=已取票, CANCELLED=已取消, REFUNDED=已退款")
    private OrderStatusEnum status;

    @Schema(description = "取票码")
    private String ticketCode;

    @Schema(description = "支付方式")
    private String payType;

    @Schema(description = "支付时间")
    private LocalDateTime payTime;

    @Schema(description = "订单过期时间")
    private LocalDateTime expireTime;

    @Schema(description = "陪伴类型: NONE-无, DOLL-玩偶, STRANGER-路人")
    private String companionType;

    @Schema(description = "陪伴记录ID")
    private Long companionId;

    @TableField(fill = FieldFill.INSERT)
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;

    // ===== 非数据库字段 =====

    @TableField(exist = false)
    @Schema(description = "用户信息")
    private User user;

    @TableField(exist = false)
    @Schema(description = "场次信息")
    private Showtime showtime;

    @TableField(exist = false)
    @Schema(description = "陪伴信息")
    private Companion companion;

    /**
     * 订单状态枚举
     */
    public enum OrderStatusEnum {
        PENDING,    // 待支付
        PAID,       // 已支付
        USED,       // 已取票
        CANCELLED,  // 已取消
        REFUNDED    // 已退款
    }
}
