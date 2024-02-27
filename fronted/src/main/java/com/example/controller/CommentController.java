package com.example.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.common.R;
import com.example.entity.Comment;
import com.example.service.CommentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;

    /**
     * 发布评论
     */
    @PostMapping("/add")
    public R<String> add(@RequestBody Comment comment) {
        return commentService.add(comment);
    }

    /**
     * 评论分页查询
     */
    @GetMapping("/page")
    public R<Page<Comment>> page(int page, int pageSize, Long postId) {
        return commentService.page(page, pageSize, postId);
    }
}
