package com.movieticket.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.movieticket.entity.Order;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

/**
 * 订单 Mapper
 */
@Mapper
public interface OrderMapper extends BaseMapper<Order> {

    /**
     * 根据订单号查询订单
     */
    @Select("SELECT * FROM `order` WHERE order_no = #{orderNo}")
    Order selectByOrderNo(String orderNo);

    /**
     * 根据取票码查询订单
     */
    @Select("SELECT * FROM `order` WHERE ticket_code = #{ticketCode}")
    Order selectByTicketCode(String ticketCode);

    /**
     * 取消过期未支付订单
     */
    @Update("UPDATE `order` SET status = 'CANCELLED', updated_at = NOW() " +
            "WHERE status = 'PENDING' AND expire_time < NOW()")
    int cancelExpiredOrders();
}
