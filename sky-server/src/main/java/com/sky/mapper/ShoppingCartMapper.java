package com.sky.mapper;

import com.sky.entity.ShoppingCart;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * @author Wangmin
 * @date 2025/9/7
 * @Description
 */
@Mapper
public interface ShoppingCartMapper {

    /**
     *动态查询
     * @param shoppingCart
     * @return
     */
    List<ShoppingCart> list(ShoppingCart  shoppingCart);

    /**
     * 修改数量
     * @param shoppingCart
     */
    @Update("update shopping_cart set number = #{number} where id = #{id}")
    void updateNumberById(ShoppingCart shoppingCart);

    /**
     * 插入购物车
     * @param shoppingCart
     */
    @Insert("insert into shopping_cart (name, image, user_id, dish_id, setmeal_id, dish_flavor, amount, create_time)" +
            " VALUES (#{name}, #{image}, #{userId}, #{dishId}, #{setmealId}, #{dishFlavor}, #{amount}, #{createTime}) ")
    void insert(ShoppingCart shoppingCart);
}

