package com.movieticket.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 座位实体
 */
@Data
@TableName("seat")
@Schema(description = "座位实体")
public class Seat implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @Schema(description = "座位ID")
    private Long id;

    @Schema(description = "场次ID")
    private Long showtimeId;

    @Schema(description = "行号")
    private String rowNum;

    @Schema(description = "列号")
    private Integer colNum;

    @Schema(description = "座位标签")
    private String seatLabel;

    @Schema(description = "座位类型: NORMAL=普通, VIP=VIP, COUPLE=情侣座, DISABLED=无障碍")
    private SeatTypeEnum seatType;

    @Schema(description = "状态: AVAILABLE=可选, LOCKED=锁定中, SOLD=已售, COMPANION=陪伴座")
    private SeatStatusEnum status;

    @Schema(description = "锁定过期时间")
    private LocalDateTime lockedUntil;

    @Schema(description = "锁定用户ID")
    private Long lockedBy;

    @TableField(fill = FieldFill.INSERT)
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;

    /**
     * 座位类型枚举
     */
    public enum SeatTypeEnum {
        NORMAL,     // 普通座
        VIP,        // VIP座
        COUPLE,     // 情侣座
        DISABLED    // 无障碍座
    }

    /**
     * 座位状态枚举
     */
    public enum SeatStatusEnum {
        AVAILABLE,  // 可选
        LOCKED,     // 锁定中
        SOLD,       // 已售
        COMPANION   // 陪伴座
    }
}
