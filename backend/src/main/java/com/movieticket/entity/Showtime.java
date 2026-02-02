package com.movieticket.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * 场次实体
 */
@Data
@TableName("showtime")
@Schema(description = "场次实体")
public class Showtime implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @Schema(description = "场次ID")
    private Long id;

    @Schema(description = "影片ID")
    private Long movieId;

    @Schema(description = "影厅ID")
    private Long hallId;

    @Schema(description = "放映日期")
    private LocalDate showDate;

    @Schema(description = "开始时间")
    private LocalTime startTime;

    @Schema(description = "结束时间")
    private LocalTime endTime;

    @Schema(description = "票价")
    private BigDecimal price;

    @Schema(description = "剩余座位数")
    private Integer availableSeats;

    @Schema(description = "状态: 0=已取消, 1=正常")
    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;

    // ===== 非数据库字段 =====

    @TableField(exist = false)
    @Schema(description = "影片信息")
    private Movie movie;

    @TableField(exist = false)
    @Schema(description = "影厅信息")
    private Hall hall;

    @TableField(exist = false)
    @Schema(description = "影院信息")
    private Cinema cinema;
}
