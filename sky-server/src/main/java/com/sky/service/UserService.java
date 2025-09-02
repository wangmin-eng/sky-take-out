package com.sky.service;

import com.sky.dto.UserLoginDTO;
import com.sky.entity.User;

/**
 * @author Wangmin
 * @date 2025/9/1
 * @Description
 */
public interface UserService {

    /**
     * 微信登录
     * @return
     */
    User wxLogin(UserLoginDTO userLoginDTO);
}
