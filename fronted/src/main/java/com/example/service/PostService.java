package com.example.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.common.R;
import com.example.entity.Post;
import org.springframework.web.bind.annotation.RequestBody;

public interface PostService extends IService<Post> {
    R<String> add(@RequestBody Post post);
    R<Page<Post>> page(int page, int pageSize);
    R<String> update(@RequestBody Post post);
    R<Post> getPostById(Long id);
}
