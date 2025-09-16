package com.sky.service.impl;

import com.sky.entity.Orders;
import com.sky.mapper.OrderMapper;
import com.sky.mapper.UserMapper;
import com.sky.query.OrderDataRangeResult;
import com.sky.query.OrderDateRangeQuery;
import com.sky.query.UserDataRangeQuery;
import com.sky.query.UserDataRangeResult;
import com.sky.service.ReportService;
import com.sky.vo.TurnoverReportVO;
import com.sky.vo.UserReportVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Wangmin
 * @date 2025/9/16
 * @Description
 */
@Service
public class ReportServiceImpl implements ReportService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private UserMapper userMapper;
    /**
     *营业额统计
     * @param begin
     * @param end
     * @return
     */
    @Override
    public TurnoverReportVO getTurnoverStatistics(LocalDate begin, LocalDate end) {

        List<LocalDate> dateList = new ArrayList<>();
        //金额查询
        List<BigDecimal> turnoverList = new ArrayList<>();

        LocalDateTime beginTime = LocalDateTime.of(begin, LocalTime.MIN);
        LocalDateTime endTime = LocalDateTime.of(end, LocalTime.MAX);

        dateList.add(begin);
        while ( !begin.equals(end) ) {
            begin = begin.plusDays(1);
            dateList.add(begin);
        }


        //旧版本
/*        for (LocalDate date: dateList) {
            LocalDateTime beginTime = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime endTime = LocalDateTime.of(date, LocalTime.MAX);

            Map dateMap = new HashMap();
            dateMap.put("begin", beginTime);
            dateMap.put("end", endTime);
            dateMap.put("status", Orders.COMPLETED);

            BigDecimal turnover = orderMapper.sumAmountByDateMap(dateMap);
            if (turnover == null) {
                turnover = BigDecimal.ZERO;
            }
            turnoverList.add(turnover);
        }*/

        //DONE ：2025年9月16日23点52分 优化查询逻辑 直接给初始和结束日期，返回一个List列表按时间升序给出 营业总金额
        OrderDateRangeQuery dateRangeQuery = OrderDateRangeQuery.builder()
                .begin(beginTime)
                .end(endTime)
                .status(Orders.COMPLETED)
                .build();

        List<OrderDataRangeResult> orderDRRList = orderMapper.sumAmountByDateMapBatch(dateRangeQuery);
        for (LocalDate localDate : dateList){
            //防止orderDRRList返回 null
            if(orderDRRList.isEmpty()){
                turnoverList.add(BigDecimal.ZERO);
            } else {
                for (OrderDataRangeResult  orderDataRangeResult : orderDRRList){
                    if(localDate.equals(orderDataRangeResult.getDate())){
                        turnoverList.add(orderDataRangeResult.getAmount());
                    }else {
                        turnoverList.add(BigDecimal.ZERO);
                    }
                }
            }
        }

        return TurnoverReportVO.builder()
                .dateList(StringUtils.join(dateList, ","))
                .turnoverList(StringUtils.join(turnoverList, ","))
                .build();
    }

    /**
     * 用户统计
     * @param begin
     * @param end
     * @return
     */
    @Override
    public UserReportVO userStatistics(LocalDate begin, LocalDate end) {
        //日期
        List<LocalDate> dateList = new ArrayList<>();
        //每日总人数
        List<Integer> userList = new ArrayList<>();
        //新增用户
        List<Integer> newList = new ArrayList<>();

        LocalDateTime beginTime = LocalDateTime.of(begin, LocalTime.MIN);
        LocalDateTime endTime = LocalDateTime.of(end, LocalTime.MAX);

        //日期数据处理
        dateList.add(begin);
        while ( !begin.equals(end) ) {
            begin = begin.plusDays(1);
            dateList.add(begin);
        }

        //旧版本
        /*for (LocalDate date: dateList) {
            LocalDateTime beginTime = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime endTime = LocalDateTime.of(date, LocalTime.MAX);

            //每日总人数处理
            HashMap dateMap = new HashMap();
            dateMap.put("end", endTime);
            Integer totalUser = userMapper.countUserByTimeMap(dateMap);

            if (totalUser == null) {
                totalUser = 0;
            }
            userList.add(totalUser);

            //新增用户处理
            dateMap.put("begin", beginTime);
            Integer newUser = userMapper.countUserByTimeMap(dateMap);
            if (newUser == null) {
                newUser = 0;
            }
            newList.add(newUser);
        }*/

        //DONE 2025年9月17日00点40分 似乎可以优化查询问题
        //查询新增用户
        UserDataRangeQuery rangeQuery = UserDataRangeQuery.builder()
                .beginTime(beginTime)
                .endTime(endTime)
                .build();

        List<UserDataRangeResult> resultList = userMapper.countUserBatch(rangeQuery);
        for  (LocalDate localDate : dateList){
            if(resultList.isEmpty()){
                newList.add(0);
            }else  {
                for (UserDataRangeResult result : resultList){
                    if(localDate.equals(result.getDate())){
                        newList.add(result.getTotal());
                    }else {
                        newList.add(0);
                    }
                }
            }
        }
        //查询截止时间所有用户
        Integer totalBefore = userMapper.countUserBeforeDate(beginTime);
        for (Integer newUser : newList) {
            Integer sumUser = totalBefore + newUser;
            userList.add(sumUser);
        }

        return UserReportVO.builder()
                .dateList(StringUtils.join(dateList, ","))
                .totalUserList(StringUtils.join(userList, ","))
                .newUserList(StringUtils.join(newList, ","))
                .build();
    }
}
