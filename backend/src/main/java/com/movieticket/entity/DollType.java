package com.movieticket.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 玩偶类型实体
 */
@Data
@TableName("doll_type")
@Schema(description = "玩偶类型")
public class DollType {

    @TableId(type = IdType.AUTO)
    private Long id;

    @Schema(description = "玩偶名称")
    private String name;

    @Schema(description = "描述")
    private String description;

    @Schema(description = "图片地址")
    private String imageUrl;

    @Schema(description = "租赁价格")
    private BigDecimal price;

    @Schema(description = "库存数量")
    private Integer stock;

    @Schema(description = "状态: 1-可用 0-下架")
    private Integer status;

    @Schema(description = "排序")
    private Integer sortOrder;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
