package com.sky.service.impl;

import com.sky.entity.Orders;
import com.sky.mapper.OrderMapper;
import com.sky.mapper.UserMapper;
import com.sky.query.OrderDateRangeQuery;
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

        dateList.add(begin);
        while ( !begin.equals(end) ) {
            begin = begin.plusDays(1);
            dateList.add(begin);
        }



        for (LocalDate date: dateList) {
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
        }

        //TODO优化查询逻辑 直接给初始和结束日期，返回一个List列表按时间升序给出 营业总金额
        /*List<OrderDateRangeQuery> dateTimeList = new ArrayList<>();
        for (LocalDate date: dateList) {
            LocalDateTime beginTime = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime endTime = LocalDateTime.of(date, LocalTime.MAX);

            OrderDateRangeQuery dateRangeQuery = OrderDateRangeQuery.builder()
                    .begin(beginTime)
                    .end(endTime)
                    .status(Orders.COMPLETED)
                    .build();

            dateTimeList.add(dateRangeQuery);

        }
        turnoverList = orderMapper.sumAmountByDateMapBatch(dateTimeList);
        for (BigDecimal turnover: turnoverList ) {
            if (turnover == null) {
                turnover = BigDecimal.ZERO;
            }
            turnoverList.add(turnover);
        }*/





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

        //日期数据处理
        dateList.add(begin);
        while ( !begin.equals(end) ) {
            begin = begin.plusDays(1);
            dateList.add(begin);
        }



        for (LocalDate date: dateList) {
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
        }

        //TODO 似乎可以优化查询问题


        return UserReportVO.builder()
                .dateList(StringUtils.join(dateList, ","))
                .totalUserList(StringUtils.join(userList, ","))
                .newUserList(StringUtils.join(newList, ","))
                .build();
    }
}
