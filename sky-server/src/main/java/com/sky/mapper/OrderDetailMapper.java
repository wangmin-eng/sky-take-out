package com.sky.mapper;

import com.sky.entity.OrderDetail;
import com.sky.query.SalesTopQuery;
import com.sky.query.SalesTopResult;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * @author Wangmin
 * @date 2025/9/8
 * @Description
 */
@Mapper
public interface OrderDetailMapper {
    /**
     * 批量插入订单明细数据
     * @param orderDetailList
     */
    void insertBatch(List<OrderDetail> orderDetailList);

    /**
     * 根据订单id查询
     * @param ordersId
     * @return
     */
    @Select("select * from order_detail where order_id = #{ordersId}")
    List<OrderDetail> getByOrderId(Long ordersId);

    /**
     * 统计菜品销售数量
     * @param salesTopQuery
     * @return
     */
    List<SalesTopResult> countDishNumber(SalesTopQuery salesTopQuery);
}
