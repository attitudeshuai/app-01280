package com.movieticket.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 匹配池实体
 */
@Data
@TableName("match_pool")
@Schema(description = "匹配池")
public class MatchPool {

    @TableId(type = IdType.AUTO)
    private Long id;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "场次ID")
    private Long showtimeId;

    @Schema(description = "已选座位ID")
    private Long seatId;

    @Schema(description = "状态")
    private MatchStatusEnum status;

    @Schema(description = "匹配到的匹配池记录ID")
    private Long matchedWithId;

    @Schema(description = "过期时间")
    private LocalDateTime expireTime;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    // ========== 关联对象 ==========
    
    @TableField(exist = false)
    private User user;

    @TableField(exist = false)
    private Seat seat;

    // ========== 枚举 ==========

    public enum MatchStatusEnum {
        WAITING,    // 等待匹配
        MATCHED,    // 已匹配
        EXPIRED,    // 已过期
        CANCELLED   // 已取消
    }
}
