package com.movieticket.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 影院实体
 */
@Data
@TableName("cinema")
@Schema(description = "影院实体")
public class Cinema implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @Schema(description = "影院ID")
    private Long id;

    @Schema(description = "影院名称")
    private String name;

    @Schema(description = "城市")
    private String city;

    @Schema(description = "区域")
    private String district;

    @Schema(description = "详细地址")
    private String address;

    @Schema(description = "联系电话")
    private String phone;

    @Schema(description = "封面图")
    private String coverImage;

    @Schema(description = "影院简介")
    private String description;

    @Schema(description = "状态: 0=关闭, 1=营业")
    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;

    // ===== 非数据库字段 =====

    @TableField(exist = false)
    @Schema(description = "影厅列表")
    private List<Hall> halls;

    @TableField(exist = false)
    @Schema(description = "影厅数量")
    private Integer hallCount;
}
