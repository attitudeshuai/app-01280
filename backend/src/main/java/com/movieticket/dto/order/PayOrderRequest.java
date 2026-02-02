package com.movieticket.dto.order;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 支付订单请求
 */
@Data
@Schema(description = "支付订单请求")
public class PayOrderRequest {

    @NotBlank(message = "支付方式不能为空")
    @Schema(description = "支付方式: ALIPAY=支付宝, WECHAT=微信, MOCK=模拟", example = "MOCK")
    private String payType;
}
