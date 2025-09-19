package com.sky.service.impl;

import com.sky.constant.StatusConstant;
import com.sky.entity.Orders;
import com.sky.mapper.DishMapper;
import com.sky.mapper.OrderMapper;
import com.sky.mapper.SetmealMapper;
import com.sky.mapper.UserMapper;
import com.sky.query.OrderDateCountDailyResult;
import com.sky.query.OrderDateCountQuery;
import com.sky.query.OrderDateRangeQuery;
import com.sky.query.OrderDateRangeResult;
import com.sky.service.WorkspaceService;
import com.sky.vo.BusinessDataVO;
import com.sky.vo.DishOverViewVO;
import com.sky.vo.OrderOverViewVO;
import com.sky.vo.SetmealOverViewVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class WorkspaceServiceImpl implements WorkspaceService {

    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private DishMapper dishMapper;
    @Autowired
    private SetmealMapper setmealMapper;

//    //获得当天的开始时间
//    private final LocalDateTime beginTime = LocalDateTime.now().with(LocalTime.MIN);
//    //获得当天的结束时间
//    private final LocalDateTime endTime = LocalDateTime.now().with(LocalTime.MAX);
    /**
     * 根据时间段统计营业数据
     * @return
     */
    public BusinessDataVO getBusinessData(LocalDateTime beginTime,LocalDateTime endTime) {
        /**
         * 营业额：当日已完成订单的总金额
         * 有效订单：当日已完成订单的数量
         * 订单完成率：有效订单数 / 总订单数
         * 平均客单价：营业额 / 有效订单数
         * 新增用户：当日新增用户的数量
         */


        //营业额
        BigDecimal turnover;
        //有效订单数
        Integer validOrderCount;
        //订单完成率
        Double orderCompletionRate;
        //平均客单价
        BigDecimal unitPrice;
        //新增用户数
        Integer newUsers;

        //营业额
        OrderDateRangeQuery dateRangeQuery = OrderDateRangeQuery.builder()
                .begin(beginTime)
                .end(endTime)
                .status(Orders.COMPLETED)
                .build();
        List<OrderDateRangeResult>  orderDateRangeResultList = orderMapper.sumAmountByDateMapBatch(dateRangeQuery);
        if(orderDateRangeResultList.isEmpty()){
            turnover =  BigDecimal.ZERO;
        }else {
            turnover = orderDateRangeResultList.get(0).getAmount();
        }

        //有效订单
        OrderDateCountQuery orderDateCountQuery = OrderDateCountQuery.builder()
                .beginTime(beginTime)
                .endTime(endTime)
                .status(Orders.COMPLETED)
                .build();
        List<OrderDateCountDailyResult> orderDateCountDailyResultList = orderMapper.countOrderDailyByDate(orderDateCountQuery);
        if(orderDateCountDailyResultList.isEmpty()){
            validOrderCount = 0;
        }else {
            validOrderCount = orderDateCountDailyResultList.get(0).getCount();
        }

        //总订单数
        Integer totalOrderCount = orderMapper.countOrderTotalByDateAndStatus(orderDateCountQuery);

        orderCompletionRate = validOrderCount.doubleValue() / totalOrderCount;

        //平均客单价

        try {
            if (validOrderCount == 0) {
                unitPrice = BigDecimal.ZERO;
            } else {
                unitPrice = turnover.divide(new BigDecimal(validOrderCount), 2, RoundingMode.HALF_UP);
            }
        } catch (Exception e){
            e.printStackTrace();
            unitPrice = BigDecimal.ZERO;
        }

        //新增用户数
        HashMap<String, Object> map = new HashMap<>();
        map.put("begin", beginTime);
        map.put("end", endTime);
        newUsers = userMapper.countUserByTimeMap(map);


        return BusinessDataVO.builder()
                .turnover(turnover)
                .validOrderCount(validOrderCount)
                .orderCompletionRate(orderCompletionRate)
                .unitPrice(unitPrice)
                .newUsers(newUsers)
                .build();
    }



    /**
     * 查询订单管理数据
     *
     * @return
     */
    public OrderOverViewVO getOrderOverView(LocalDateTime beginTime,LocalDateTime endTime) {
        OrderDateCountQuery countQuery = OrderDateCountQuery.builder()
                .beginTime(beginTime)
                .endTime(endTime)
                .build();

        //TODO 优化为单次查询


        //待接单
        Integer waitingOrders;
        countQuery.setStatus(Orders.TO_BE_CONFIRMED);
        List<OrderDateCountDailyResult> results = orderMapper.countOrderDailyByDate(countQuery);
        if (results.isEmpty()) {
            waitingOrders = 0;
        }else {
            waitingOrders = results.get(0).getCount();
        }


        //待派送
        Integer deliveredOrders;
        countQuery.setStatus(Orders.CONFIRMED);
        results = orderMapper.countOrderDailyByDate(countQuery);
        if (results.isEmpty()) {
            deliveredOrders = 0;
        } else {
            deliveredOrders = results.get(0).getCount();
        }


        //已完成
        Integer completedOrders;
        countQuery.setStatus(Orders.COMPLETED);
        results = orderMapper.countOrderDailyByDate(countQuery);
        if (results.isEmpty()) {
            completedOrders = 0;
        } else {
            completedOrders = results.get(0).getCount();
        }


        //已取消
        Integer cancelledOrders;
        countQuery.setStatus(Orders.CANCELLED);
        results = orderMapper.countOrderDailyByDate(countQuery);
        if (results.isEmpty()) {
            cancelledOrders = 0;
        }  else {cancelledOrders = results.get(0).getCount();
        }


        //全部订单
        Integer allOrders;
        countQuery.setStatus(null);
        results = orderMapper.countOrderDailyByDate(countQuery);
        if (results.isEmpty()) {
            allOrders = 0;
        } else {
            allOrders = results.get(0).getCount();
        }


        return OrderOverViewVO.builder()
                .waitingOrders(waitingOrders)
                .deliveredOrders(deliveredOrders)
                .completedOrders(completedOrders)
                .cancelledOrders(cancelledOrders)
                .allOrders(allOrders)
                .build();
    }

    /**
     * 查询菜品总览
     *
     * @return
     */
    public DishOverViewVO getDishOverView() {
        Map map = new HashMap();
        map.put("status", StatusConstant.ENABLE);
        Integer sold = dishMapper.countByMap(map);

        map.put("status", StatusConstant.DISABLE);
        Integer discontinued = dishMapper.countByMap(map);

        return DishOverViewVO.builder()
                .sold(sold)
                .discontinued(discontinued)
                .build();
    }

    /**
     * 查询套餐总览
     *
     * @return
     */
    public SetmealOverViewVO getSetmealOverView() {
        Map map = new HashMap();
        map.put("status", StatusConstant.ENABLE);
        Integer sold = setmealMapper.countByMap(map);

        map.put("status", StatusConstant.DISABLE);
        Integer discontinued = setmealMapper.countByMap(map);

        return SetmealOverViewVO.builder()
                .sold(sold)
                .discontinued(discontinued)
                .build();
    }
}
