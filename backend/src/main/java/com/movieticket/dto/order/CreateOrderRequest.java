package com.movieticket.dto.order;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

/**
 * 创建订单请求
 */
@Data
@Schema(description = "创建订单请求")
public class CreateOrderRequest {

    @NotNull(message = "场次ID不能为空")
    @Schema(description = "场次ID", example = "1")
    private Long showtimeId;

    @NotEmpty(message = "座位不能为空")
    @Schema(description = "座位ID列表", example = "[1, 2, 3]")
    private List<Long> seatIds;

    // ========== 陪伴功能扩展 ==========

    @Schema(description = "陪伴类型: NONE-无, DOLL-玩偶, STRANGER-路人匹配", example = "NONE")
    private String companionType = "NONE";

    @Schema(description = "玩偶类型ID (仅玩偶陪伴时需要)", example = "1")
    private Long dollTypeId;
}
