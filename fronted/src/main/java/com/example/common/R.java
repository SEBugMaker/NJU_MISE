package com.example.common;

import lombok.Data;
import java.util.HashMap;
import java.util.Map;

/**
 * 通用返回结果，服务端响应的数据最终都会封装成此对象
 * @param <T>
 */

@Data
public class R<T> {

    // 编码：1成功，其它数字为失败
    private Integer code;
    // 错误信息
    private String msg;
    // 数据
    private T data;
    // 动态数据
    private Map<String,Object> map = new HashMap<>();

    private static final int CODE_SUCCESS = 1;

    private static final int CODE_FAILURE = 2;

    private static final int CODE_INTERNAL_ERROR = 2;

    private static final int CODE_CLIENT_ERROR = 2;

    public static final String MSG_LOGIN_FAILURE = "登录失败";

    public static final String MSG_PASSWORD_FAILURE = "密码错误";

    public static final String MSG_ACCOUNT_BANNED = "账号已禁用";

    public static final String MSG_LOGIN_SUCCESS = "登录成功";

    public static final String MSG_NOT_LOGIN = "NOT_LOGIN";

    public static final String MSG_FAIL = "请求失败";

    public static <T> R<T> success(String msg, T data) {
        R<T> r = new R<>();
        r.code = CODE_SUCCESS;
        r.msg = msg;
        r.data = data;
        return r;
    }

    public static <T> R<T> fail(String msg, T data) {
        R<T> r = new R<>();
        r.code = CODE_FAILURE;
        r.msg = msg;
        r.data = data;
        return r;
    }

    public static <T> R<T> serverError(String msg, T data) {
        R<T> r = new R<>();
        r.code = CODE_INTERNAL_ERROR;
        r.msg = msg;
        r.data = data;
        return r;
    }

    public static <T> R<T> clientError(String msg, T data) {
        R<T> r = new R<>();
        r.code = CODE_CLIENT_ERROR;
        r.msg = msg;
        r.data = data;
        return r;
    }

    public R<T> add(String key, Object value) {
        this.map.put(key, value);
        return this;
    }

}
