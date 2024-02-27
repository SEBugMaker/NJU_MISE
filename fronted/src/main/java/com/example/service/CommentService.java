package com.example.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.common.R;
import com.example.entity.Comment;
import org.springframework.web.bind.annotation.RequestBody;

public interface CommentService extends IService<Comment> {
    R<String> add(@RequestBody Comment comment);
    R<Page<Comment>> page(int page, int pageSize, Long postId);
}
