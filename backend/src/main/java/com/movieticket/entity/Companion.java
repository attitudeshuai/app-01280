package com.movieticket.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 陪伴记录实体
 */
@Data
@TableName("companion")
@Schema(description = "陪伴记录")
public class Companion {

    @TableId(type = IdType.AUTO)
    private Long id;

    @Schema(description = "关联订单ID")
    private Long orderId;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "场次ID")
    private Long showtimeId;

    @Schema(description = "陪伴类型")
    private CompanionTypeEnum companionType;

    @Schema(description = "玩偶类型ID")
    private Long dollTypeId;

    @Schema(description = "陪伴座位ID")
    private Long companionSeatId;

    @Schema(description = "匹配到的用户ID")
    private Long matchUserId;

    @Schema(description = "匹配状态")
    private MatchStatusEnum matchStatus;

    @Schema(description = "额外费用")
    private BigDecimal extraPrice;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    // ========== 关联对象 (非数据库字段) ==========
    
    @TableField(exist = false)
    private DollType dollType;

    @TableField(exist = false)
    private Seat companionSeat;

    @TableField(exist = false)
    private User matchUser;

    // ========== 枚举 ==========

    public enum CompanionTypeEnum {
        DOLL,      // 玩偶陪伴
        STRANGER   // 路人匹配
    }

    public enum MatchStatusEnum {
        PENDING,    // 待匹配
        MATCHED,    // 已匹配
        FAILED,     // 失败
        CANCELLED   // 取消
    }
}
