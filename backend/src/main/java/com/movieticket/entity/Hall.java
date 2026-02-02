package com.movieticket.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 影厅实体
 */
@Data
@TableName("hall")
@Schema(description = "影厅实体")
public class Hall implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @Schema(description = "影厅ID")
    private Long id;

    @Schema(description = "所属影院ID")
    private Long cinemaId;

    @Schema(description = "影厅名称")
    private String name;

    @Schema(description = "影厅类型: NORMAL=普通, IMAX=IMAX, VIP=VIP厅")
    private String hallType;

    @Schema(description = "座位行数")
    private Integer seatRows;

    @Schema(description = "座位列数")
    private Integer seatCols;

    @Schema(description = "座位布局配置(JSON)")
    private String seatLayout;

    @Schema(description = "总座位数")
    private Integer totalSeats;

    @Schema(description = "状态: 0=关闭, 1=正常")
    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;

    // ===== 非数据库字段 =====

    @TableField(exist = false)
    @Schema(description = "所属影院")
    private Cinema cinema;
}
