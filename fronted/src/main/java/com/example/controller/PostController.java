package com.example.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.common.R;
import com.example.entity.Post;
import com.example.service.PostService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/post")
public class PostController {

    @Autowired
    private PostService postService;

    /**
     *  发帖
     */
    @PostMapping("/add")
    public R<String> add(@RequestBody Post post) {
        return postService.add(post);
    }

    /**
     * 帖子分页查询
     */
    @GetMapping("/page")
    public R<Page<Post>> page(int page, int pageSize) {
        return postService.page(page, pageSize);
    }

}
