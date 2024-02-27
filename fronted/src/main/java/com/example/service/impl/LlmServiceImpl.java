package com.example.service.impl;

import com.alibaba.dashscope.exception.InputRequiredException;
import com.alibaba.dashscope.exception.NoApiKeyException;
import com.example.common.R;
import com.example.dto.LlmDto;
import com.example.service.LlmService;
import com.example.util.ApiUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LlmServiceImpl implements LlmService {

    @Autowired
    private ApiUtil apiUtil;

    @Override
    public R<String> chat(LlmDto dto) {
        String prompt = dto.getPrompt();
        String res = apiUtil.getAnswer(prompt);
        if (ApiUtil.MSG_SERVER_ERROR.equals(res) || ApiUtil.MSG_RETRY.equals(res)) {
            return R.serverError("大语言模型服务请求失败", res);
        } else {
            return R.success("大语言模型服务调用成功", res);
        }
    }
}
