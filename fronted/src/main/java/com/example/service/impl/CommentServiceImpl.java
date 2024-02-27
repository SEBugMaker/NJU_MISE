package com.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.common.R;
import com.example.entity.Comment;
import com.example.entity.Post;
import com.example.mapper.CommentMapper;
import com.example.service.CommentService;
import com.example.service.PostService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
@Slf4j
public class CommentServiceImpl extends ServiceImpl<CommentMapper, Comment>
        implements CommentService {

    @Autowired
    private PostService postService;

    @Override
    @Transactional
    public R<String> add(Comment comment) {
        log.info("Comment add, comment: {}", comment);
        if (!this.save(comment)) {
            return R.serverError("发布评论失败", null);
        }
        Post post = postService.getPostById(comment.getPostId()).getData();
        post.setCommentNumber(post.getCommentNumber() + 1);
        post.setUpdateTime(LocalDateTime.now());
        if (postService.update(post).getCode() != 1) {
            return R.serverError("更新关联帖子信息失败", null);
        } else {
            return R.success("发布评论成功", null);
        }
    }

    @Override
    public R<Page<Comment>> page(int page, int pageSize, Long postId) {
        log.info("Comment page, page: {}, pageSize: {}", page, pageSize);
        // 分页构造器
        Page<Comment> pageInfo = new Page<>(page, pageSize);
        // 查询过滤器，筛选对应帖子下的评论
        LambdaQueryWrapper<Comment> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Comment::getPostId, postId);
        // 排序
        queryWrapper.orderByAsc(Comment::getUpdateTime);
        this.page(pageInfo, queryWrapper);
        return R.success("分页查询成功", pageInfo);
    }
}
