package com.sky.service.impl;

import com.sky.entity.Orders;
import com.sky.mapper.OrderDetailMapper;
import com.sky.mapper.OrderMapper;
import com.sky.mapper.UserMapper;
import com.sky.query.*;
import com.sky.service.ReportService;
import com.sky.service.WorkspaceService;
import com.sky.vo.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

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

    @Autowired
    private OrderDetailMapper orderDetailMapper;

    @Autowired
    private WorkspaceService workspaceService;

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

        List<OrderDateRangeResult> orderDRRList = orderMapper.sumAmountByDateMapBatch(dateRangeQuery);

        /*for (LocalDate localDate : dateList){
            //防止orderDRRList返回 null
            if(orderDRRList.isEmpty()){
                turnoverList.add(BigDecimal.ZERO);
            } else {
                for (OrderDateRangeResult orderDateRangeResult : orderDRRList){
                    if(localDate.equals(orderDateRangeResult.getDate())){
                        turnoverList.add(orderDateRangeResult.getAmount());
                        break;
                    } else {
                        turnoverList.add(BigDecimal.ZERO);

                        break;
                    }
                }
            }

        }*/
        for (int i = 0; i < dateList.size(); i++) {
            if (orderDRRList.isEmpty()){
                turnoverList.add(BigDecimal.ZERO);
            } else {
                turnoverList.add(BigDecimal.ZERO);
                for (OrderDateRangeResult orderDateRangeResult : orderDRRList) {
                    if (dateList.get(i).equals(orderDateRangeResult.getDate())){
                        turnoverList.set(i,orderDateRangeResult.getAmount());
                        break;
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
        UserDateRangeQuery rangeQuery = UserDateRangeQuery.builder()
                .beginTime(beginTime)
                .endTime(endTime)
                .build();

        List<UserDateRangeResult> resultList = userMapper.countUserBatch(rangeQuery);

        for  (int i = 0; i < dateList.size(); i++){
            if(resultList.isEmpty()){
                newList.add(0);
            }else  {
                newList.add(0);
                for (UserDateRangeResult result : resultList){
                    if(dateList.get(i).equals(result.getDate())){
                        newList.set(i,result.getTotal());
                        break;
                    }
                }
            }
        }
        //查询截止时间所有用户
        Integer totalBefore = userMapper.countUserBeforeDate(beginTime);
        for (Integer newUser : newList) {
            totalBefore = totalBefore + newUser;
            userList.add(totalBefore);
        }

        return UserReportVO.builder()
                .dateList(StringUtils.join(dateList, ","))
                .totalUserList(StringUtils.join(userList, ","))
                .newUserList(StringUtils.join(newList, ","))
                .build();
    }

    /**
     * 订单统计
     * @param begin
     * @param end
     * @return
     */
    @Override
    public OrderReportVO getOrderStatistics(LocalDate begin, LocalDate end) {
        //日期
        List<LocalDate> dateList = new ArrayList<>();

        //每日订单数
        List<Integer> orderCountList = new ArrayList<>();

        //每日有效订单数，以逗号分隔，例如：20,21,10
        List<Integer> validOrderCountList = new ArrayList<>();

        //订单总数
        Integer totalOrderCount;

        //有效订单数
        Integer validOrderCount;

        //订单完成率
        Double orderCompletionRate;

        //数据日期时间区间
        LocalDateTime beginTime = LocalDateTime.of(begin, LocalTime.MIN);
        LocalDateTime endTime = LocalDateTime.of(end, LocalTime.MAX);

        //日期数据处理
        dateList.add(begin);
        while ( !begin.equals(end) ) {
            begin = begin.plusDays(1);
            dateList.add(begin);
        }

        //封装了的查询参数 beginTime endTime status
        OrderDateCountQuery countQuery = new OrderDateCountQuery();
        countQuery.setBeginTime(beginTime);
        countQuery.setEndTime(endTime);

        //订单总数
        totalOrderCount = orderMapper.countOrderTotalByDateAndStatus(countQuery);

        //每日总订单
        List<OrderDateCountDailyResult> dailyTotalResultList = orderMapper.countOrderDailyByDate(countQuery);

        //设置完成参数
        countQuery.setStatus(Orders.COMPLETED);

        //有效订单数
        validOrderCount = orderMapper.countOrderTotalByDateAndStatus(countQuery);

        //订单完成率
        try {
            orderCompletionRate = validOrderCount.doubleValue() / totalOrderCount.doubleValue();
        }  catch (Exception e) {
            orderCompletionRate = null;
            throw new RuntimeException("除数不能为0");
        }


        //每日有效订单
        List<OrderDateCountDailyResult> dailyValidResultList = orderMapper.countOrderDailyByDate(countQuery);

        for (int i = 0; i < dateList.size(); i++) {
            //每日总订单
            if(dailyTotalResultList.isEmpty()){
                orderCountList.add(0);
            } else {
                orderCountList.add(0);
                for (OrderDateCountDailyResult dailyTotalResult : dailyTotalResultList){
                    if(dateList.get(i).equals(dailyTotalResult.getDate())){
                        orderCountList.set(i,dailyTotalResult.getCount());
                        break;
                    }
                }
            }

            //每日有效订单
            if (dailyValidResultList.isEmpty()){
                validOrderCountList.add(0);
            } else {
                validOrderCountList.add(0);
                for (OrderDateCountDailyResult dailyValidResult : dailyValidResultList){
                    if(dateList.get(i).equals(dailyValidResult.getDate())){
                        validOrderCountList.set(i,dailyValidResult.getCount());
                        break;
                    }
                }
            }
        }

        return OrderReportVO.builder()
                .dateList(StringUtils.join(dateList, ","))
                .orderCountList(StringUtils.join(orderCountList, ","))
                .validOrderCountList(StringUtils.join(validOrderCountList, ","))
                .totalOrderCount(totalOrderCount)
                .validOrderCount(validOrderCount)
                .orderCompletionRate(orderCompletionRate)
                .build();
    }

    /**
     * 统计指定时间销量排名前10
     * @param begin
     * @param end
     * @return
     */
    @Override
    public SalesTop10ReportVO getSalesTop10(LocalDate begin, LocalDate end) {

        LocalDateTime beginTime = LocalDateTime.of(begin, LocalTime.MIN);
        LocalDateTime endTIme = LocalDateTime.of(end, LocalTime.MAX);

        //商品名称列表
        List<String> nameList = new ArrayList<>();

        //商品销量
        List<Integer> numberList = new ArrayList<>();

        //查询条件封装成类
        SalesTopQuery salesTopQuery = SalesTopQuery.builder()
                .beginTime(beginTime)
                .endTime(endTIme)
                .status(Orders.COMPLETED)
                .build();
        //获取查询结果
        List<SalesTopResult> salesTopResults = orderDetailMapper.countDishNumber(salesTopQuery);
        for (SalesTopResult salesTopResult : salesTopResults) {
            nameList.add(salesTopResult.getDishName());
            numberList.add(salesTopResult.getDishNumber());
        }

        return SalesTop10ReportVO.builder()
                .nameList(StringUtils.join(nameList, ","))
                .numberList(StringUtils.join(numberList, ","))
                .build();
    }

    /**
     * 导出营业数据报表
     * @param response
     */
    @Override
    public void exportBusinessData(HttpServletResponse response) {
        // 1.查询数据库
        LocalDate dateBegin = LocalDate.now().minusDays(30);
        LocalDate dateEnd = LocalDate.now().minusDays(1);

        BusinessDataVO businessDataVO = workspaceService.getBusinessData(LocalDateTime.of(dateBegin, LocalTime.MIN), LocalDateTime.of(dateEnd, LocalTime.MAX));

        //通过poi将数据写入
        InputStream in = this.getClass().getClassLoader().getResourceAsStream("template/运营数据报表模板.xlsx");

        try {
            XSSFWorkbook excel = new XSSFWorkbook(in);

            //获取sheet1
            XSSFSheet sheet1 = excel.getSheet("Sheet1");
            //填充时间
            sheet1.getRow(1).getCell(1).setCellValue("时间：" + dateBegin + "至" + dateEnd );

            //第四行
            XSSFRow row = sheet1.getRow(3);
            row.getCell(2).setCellValue(businessDataVO.getTurnover().doubleValue());
            row.getCell(4).setCellValue(businessDataVO.getOrderCompletionRate());
            row.getCell(6).setCellValue(businessDataVO.getNewUsers());

            //第五行
            row = sheet1.getRow(4);
            row.getCell(2).setCellValue(businessDataVO.getValidOrderCount());
            row.getCell(4).setCellValue( businessDataVO.getUnitPrice().doubleValue());

            //填充明细数据，一天一天查
            //TODO 优化查询，不要循环查询 部分数据存在错误 比如完成率
            for (int i = 0 ; i < 30 ; i++){
                LocalDate date = dateBegin.plusDays(i);

                BusinessDataVO businessData = workspaceService.getBusinessData(LocalDateTime.of(date, LocalTime.MIN), LocalDateTime.of(date, LocalTime.MAX));

                row = sheet1.getRow(7 + i);
                row.getCell(1).setCellValue(date.toString());
                row.getCell(2).setCellValue(businessData.getTurnover().doubleValue());
                row.getCell(3).setCellValue(businessData.getValidOrderCount());
                row.getCell(4).setCellValue(businessData.getValidOrderCount());
                row.getCell(5).setCellValue( businessData.getUnitPrice().doubleValue());
                row.getCell(6).setCellValue(businessData.getNewUsers());

            }

            //通过输出流将数据下载到客户端
            ServletOutputStream outputStream = response.getOutputStream();
            excel.write(outputStream);

            //关闭数据
            outputStream.close();
            excel.close();
        } catch (IOException e){
            e.printStackTrace();
        }


    }
}
