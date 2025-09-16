package com.sky.query;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * @author Wangmin
 * @date 2025/9/16
 * @Description
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDataRangeResult {
    private LocalDate date;
    private BigDecimal amount;
}
