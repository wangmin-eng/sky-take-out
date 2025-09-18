package com.sky.query;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author Wangmin
 * @date 2025/9/18
 * @Description 存储销量查询接收对象
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SalesTopResult {
    private String dishName;
    private Integer dishNumber;
}
