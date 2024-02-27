package com.example.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
public class HealthInfo implements Serializable {
    private static final long serialVersionUID = 1L;

    //健康信息ID
    private Long id;

    //用户ID
    private Long userId;

    //用户名
    private String username;

    //健康信息类型
    private String type;

    //健康信息数值
    private String data;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
