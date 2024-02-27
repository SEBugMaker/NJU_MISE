package com.example.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.common.R;
import com.example.entity.HealthInfo;
import com.example.service.HealthInfoService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/healthInfo")
public class HealthInfoController {
    @Autowired
    private HealthInfoService healthInfoService;

    /**
     * 发布健康信息
     */
    @PostMapping("/add")
    public R<String> add(@RequestBody HealthInfo healthInfo) {
        return healthInfoService.add(healthInfo);
    }

    /**
     * 健康信息分页查询
     */
    @GetMapping("/page")
    public R<Page<HealthInfo>> page(int page, int pageSize, String type,  Long userId) {
        return healthInfoService.page(page, pageSize, type, userId);
    }

    /**
     * 健康信息获取最新的一个
     */
    @GetMapping("/latest")
    public R<Page<HealthInfo>> latest(String type,  Long userId) {
        return healthInfoService.latest(type, userId);
    }

    /**
     * 健康信息删除
     */
    @DeleteMapping("/delete")
    public R<String> delete(@RequestBody HealthInfo healthInfo) {
        return healthInfoService.delete(healthInfo);
    }
}
