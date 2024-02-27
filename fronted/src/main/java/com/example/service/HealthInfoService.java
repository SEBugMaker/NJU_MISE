package com.example.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.example.common.R;
import com.example.entity.HealthInfo;
import org.springframework.web.bind.annotation.RequestBody;

public interface HealthInfoService extends IService<HealthInfo> {
    R<String> add(@RequestBody HealthInfo healthInfo);

    R<Page<HealthInfo>> page(int page, int pageSize, String type, Long userId);

    R<Page<HealthInfo>> latest(String type,  Long userId);

    R<String> delete(@RequestBody HealthInfo healthInfo);

}
