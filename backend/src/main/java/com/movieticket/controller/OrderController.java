package com.movieticket.controller;

import com.movieticket.common.PageResult;
import com.movieticket.common.Result;
import com.movieticket.dto.order.CreateOrderRequest;
import com.movieticket.dto.order.PayOrderRequest;
import com.movieticket.entity.Order;
import com.movieticket.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 订单控制器
 */
@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
@Tag(name = "订单接口", description = "订单创建、支付、查询等接口")
public class OrderController {

    private final OrderService orderService;

    /**
     * 创建订单
     */
    @PostMapping
    @Operation(summary = "创建订单", description = "选座后创建订单，座位将被锁定15分钟")
    public Result<Order> createOrder(@Valid @RequestBody CreateOrderRequest request) {
        Order order = orderService.createOrder(request);
        return Result.success("订单创建成功，请在15分钟内完成支付", order);
    }

    /**
     * 支付订单
     */
    @PostMapping("/{id}/pay")
    @Operation(summary = "支付订单", description = "模拟支付，返回取票码")
    public Result<Order> payOrder(
            @Parameter(description = "订单ID") @PathVariable Long id,
            @Valid @RequestBody PayOrderRequest request
    ) {
        Order order = orderService.payOrder(id, request.getPayType());
        return Result.success("支付成功", order);
    }

    /**
     * 取消订单
     */
    @PostMapping("/{id}/cancel")
    @Operation(summary = "取消订单", description = "取消未支付的订单，释放座位")
    public Result<Void> cancelOrder(
            @Parameter(description = "订单ID") @PathVariable Long id
    ) {
        orderService.cancelOrder(id);
        return Result.success("订单已取消", null);
    }

    /**
     * 获取订单详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取订单详情")
    public Result<Order> getDetail(
            @Parameter(description = "订单ID") @PathVariable Long id
    ) {
        Order order = orderService.getDetail(id);
        return Result.success(order);
    }

    /**
     * 获取我的订单列表
     */
    @GetMapping("/my")
    @Operation(summary = "获取我的订单列表")
    public Result<PageResult<Order>> getMyOrders(
            @Parameter(description = "状态筛选") @RequestParam(required = false) String status,
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer page,
            @Parameter(description = "每页数量") @RequestParam(defaultValue = "10") Integer size
    ) {
        PageResult<Order> result = orderService.getMyOrders(status, page, size);
        return Result.success(result);
    }
}
