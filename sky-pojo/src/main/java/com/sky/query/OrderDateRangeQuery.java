package com.sky.query;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * @author Wangmin
 * @date 2025/9/16
 * @Description
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDateRangeQuery {
    private LocalDateTime begin;
    private LocalDateTime end;
    private Integer status;
}
