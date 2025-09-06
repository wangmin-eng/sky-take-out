package com.sky.service;

import com.sky.dto.ShoppingCartDTO;

/**
 * @author Wangmin
 * @date 2025/9/7
 * @Description
 */
public interface ShoppingCartService {

    /**
     * 添加购物车
     * @param shoppingCartDTO
     */
    void addShoppingCart(ShoppingCartDTO shoppingCartDTO);
}
