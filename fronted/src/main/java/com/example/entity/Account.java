package com.example.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
public class Account implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    //用户名
    private String username;
    //密码
    private String password;
    //手机号
    private String phoneNumber;
    //电子邮箱
    private String email;
    //头像
    private String avatar;
    //状态 0:禁用，1:正常
    private Integer status;
    //性别
    private String gender;
    //简介
    private String intro;
    //年龄
    private Integer age;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
