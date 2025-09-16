package com.sky.query;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * @author Wangmin
 * @date 2025/9/17
 * @Description
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDataRangeResult {
    private LocalDate date;
    private Integer total;

}
