package com.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.common.R;
import com.example.entity.Post;
import com.example.mapper.PostMapper;
import com.example.service.PostService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@Slf4j
public class PostServiceImpl extends ServiceImpl<PostMapper, Post>
        implements PostService {
    @Override
    public R<String> add(Post post) {
        log.info("Post add, post: {}", post);
        if (this.save(post)) {
            return R.success("成功发帖", null);
        } else {
            return R.serverError("发帖失败，请稍后重试", null);
        }
    }

    @Override
    public R<Page<Post>> page(int page, int pageSize) {
        log.info("Post page, page: {}, pageSize: {}", page, pageSize);
        // 分页构造器
        Page<Post> pageInfo = new Page<>(page, pageSize);
        // 查询过滤器
        LambdaQueryWrapper<Post> queryWrapper = new LambdaQueryWrapper<>();
        // 排序
        queryWrapper.orderByDesc(Post::getUpdateTime);
        this.page(pageInfo, queryWrapper);
        return R.success("分页查询成功", pageInfo);
    }

    @Override
    public R<String> update(Post post) {
        log.info("Post update, post: {}", post);
        post.setUpdateTime(LocalDateTime.now());
        if (this.updateById(post)) {
            return R.success("帖子信息更新成功", null);
        } else {
            return R.serverError("帖子信息更新失败", null);
        }
    }

    @Override
    public R<Post> getPostById(Long id) {
        log.info("Post getPostById, id: {}", id);
        if (id != null) {
            Post result = this.getById(id);
            if (result != null) {
                return R.success("通过ID查询帖子信息成功", result);
            } else {
                return R.serverError("未查询到对应ID的帖子信息", null);
            }
        } else {
            return R.clientError("传入帖子ID异常", null);
        }
    }
}
