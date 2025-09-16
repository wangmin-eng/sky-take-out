package com.sky.mapper;

import com.sky.entity.User;
import com.sky.query.UserDataRangeQuery;
import com.sky.query.UserDataRangeResult;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;

/**
 * @author Wangmin
 * @date 2025/9/1
 * @Description
 */
@Mapper
public interface UserMapper {

    /**
     * 根据openid查询用户
     * @param openid
     * @return
     */
    @Select("select * from user where openid = #{openid}")
    User getByOpenid(String openid);

    /**
     * 插入数据
     * @param user
     */
    void insert(User user);

    /**
     * 根据id查询
     * @param id
     * @return
     */
    @Select("select * from user where id = #{id}")
    User getById(Long id);

    /**
     * 用户统计
     * @param dateMap
     * @return
     */
    Integer countUserByTimeMap(HashMap dateMap);

    /**
     * 获取批量统计数据
     * @param rangeQuery
     * @return
     */
    List<UserDataRangeResult> countUserBatch(UserDataRangeQuery rangeQuery);

    /**
     * 统计该日期之前一共有多少用户
     * @param beginTime
     * @return
     */
    @Select("select count(id) as total from user where create_time < #{beginTime}")
    Integer countUserBeforeDate(LocalDateTime beginTime);
}
