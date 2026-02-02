package com.movieticket.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 影片实体
 */
@Data
@TableName("movie")
@Schema(description = "影片实体")
public class Movie implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @Schema(description = "影片ID")
    private Long id;

    @Schema(description = "影片名称")
    private String title;

    @Schema(description = "海报URL")
    private String poster;

    @Schema(description = "类型")
    private String genre;

    @Schema(description = "时长(分钟)")
    private Integer duration;

    @Schema(description = "评分")
    private BigDecimal rating;

    @Schema(description = "影片简介")
    private String description;

    @Schema(description = "导演")
    private String director;

    @Schema(description = "主演")
    private String actors;

    @Schema(description = "上映日期")
    private LocalDate releaseDate;

    @Schema(description = "制片国家")
    private String country;

    @Schema(description = "语言")
    private String language;

    @Schema(description = "状态: COMING=即将上映, SHOWING=热映中, OFFLINE=已下架")
    private StatusEnum status;

    @TableField(fill = FieldFill.INSERT)
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;

    /**
     * 影片状态枚举
     */
    public enum StatusEnum {
        COMING,     // 即将上映
        SHOWING,    // 热映中
        OFFLINE     // 已下架
    }
}
