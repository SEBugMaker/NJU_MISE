package com.example.common;

/**
 * 基于ThreadLocal封装的工具类, 用于获取和保存当前登录用户的ID
 */
public class BaseContext {
    private static final ThreadLocal<Long> tlUserId = new ThreadLocal<>();

    public static void setUserId(Long userId) {
        tlUserId.set(userId);
    }

    public static Long getUserId() {
        return tlUserId.get();
    }
}