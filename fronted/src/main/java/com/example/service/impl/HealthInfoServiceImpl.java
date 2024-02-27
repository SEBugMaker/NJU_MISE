package com.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.common.R;
import com.example.entity.Comment;
import com.example.entity.HealthInfo;
import com.example.mapper.HealthInfoMapper;
import com.example.service.HealthInfoService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
@Slf4j
public class HealthInfoServiceImpl extends ServiceImpl<HealthInfoMapper, HealthInfo> implements HealthInfoService {


    @Override
    public R<String> add(HealthInfo healthInfo){
        log.info("HealthInfo add, healthInfo: {}", healthInfo);
        if (this.save(healthInfo)) {
            return R.success("成功添加健康信息", null);
        } else {
            return R.serverError("添加健康信息失败，请稍后重试", null);
        }
    }

    @Override
    public R<Page<HealthInfo>> page(int page, int pageSize, String type, Long userId) {
        log.info("HealthInfo page, page: {}, pageSize: {}, type: {}, userId: {}", page, pageSize, type, userId);
        // 分页构造器
        Page<HealthInfo> pageInfo = new Page<>(page, pageSize);
        // 查询过滤器，筛选对应健康信息
        LambdaQueryWrapper<HealthInfo> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(HealthInfo::getType, type)
                .eq(HealthInfo::getUserId, userId);
        // 排序
        queryWrapper.orderByDesc(HealthInfo::getUpdateTime);
        this.page(pageInfo, queryWrapper);

        // 获取前pageSize个降序排序的数据
        List<HealthInfo> records = pageInfo.getRecords().subList(0, Math.min(pageSize, pageInfo.getRecords().size()));

        // 将数据按顺序输出
        List<HealthInfo> orderedRecords = new ArrayList<>(records);
        orderedRecords.sort(Comparator.comparing(HealthInfo::getUpdateTime));

        pageInfo.setRecords(orderedRecords);
        return R.success("分页查询成功", pageInfo);
    }

    @Override
    public R<Page<HealthInfo>> latest(String type,  Long userId) {
        log.info("HealthInfo the latest, type: {}, userId: {}", type, userId);
        Page<HealthInfo> pageInfo = new Page<>(1, 1);
        LambdaQueryWrapper<HealthInfo> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(HealthInfo::getType, type)
                .eq(HealthInfo::getUserId, userId);
        // 排序
        queryWrapper.orderByDesc(HealthInfo::getUpdateTime);
        this.page(pageInfo, queryWrapper);

        if (pageInfo.getRecords().isEmpty()) {
            return R.fail("查询无数据", pageInfo);
        } else {
            return R.success("查询最新成功", pageInfo);
        }
    }

    @Override
    public R<String> delete(@RequestBody HealthInfo healthInfo){
        Long userId = healthInfo.getUserId();
        String type = healthInfo.getType();
        LocalDateTime createTime = healthInfo.getCreateTime();
        LambdaQueryWrapper<HealthInfo> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(HealthInfo::getType, type)
                .eq(HealthInfo::getUserId, userId)
                .eq(HealthInfo::getCreateTime, createTime);

        if (this.remove(queryWrapper)) {
            return R.success("成功删除健康信息", null);
        } else {
            return R.serverError("删除健康信息失败，请稍后重试", null);
        }

    }

}
