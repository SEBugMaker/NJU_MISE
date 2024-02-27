package com.example.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
public class Post implements Serializable {

    private static final long serialVersionUID = 1L;

    //帖子ID
    private Long id;
    //标题
    private String title;
    //发帖用户ID
    private Long userId;
    //发帖用户名
    private String username;
    //帖子内容
    private String content;
    //评论数
    private Integer commentNumber;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
