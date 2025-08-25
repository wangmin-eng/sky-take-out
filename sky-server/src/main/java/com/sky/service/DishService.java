package com.sky.service;

import com.sky.dto.DishDTO;

/**
 * @author Wangmin
 * @date 2025/8/25
 * @Description
 */
public interface DishService {

    /**
     * 新增菜品和口味
     * @param dishDTO
     */
    public void saveWithFlavor(DishDTO dishDTO);
}
