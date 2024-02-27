package com.example.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
public class Comment implements Serializable {

    private static final long serialVersionUID = 1L;

    //评论ID
    private Long id;
    //评论用户ID
    private Long userId;
    //评论用户名
    private String username;
    //评论所属帖子ID
    private Long postId;
    //评论内容
    private String content;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
