package com.sky.query;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

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
public class OrderDateCountQuery {
    private LocalDateTime beginTime;
    private LocalDateTime endTime;
    private Integer status;

}
