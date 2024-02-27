package com.example.util;

import com.alibaba.dashscope.aigc.generation.GenerationOutput;
import com.alibaba.dashscope.exception.ApiException;
import com.alibaba.dashscope.exception.InputRequiredException;
import com.alibaba.dashscope.exception.NoApiKeyException;
import com.alibaba.dashscope.utils.Constants;
import com.alibaba.dashscope.aigc.conversation.Conversation;
import com.alibaba.dashscope.aigc.conversation.ConversationParam;
import com.alibaba.dashscope.aigc.conversation.ConversationResult;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import java.util.List;

/**
 * 通义千问API调用工具类
 */
@Component
@Slf4j
public class ApiUtil {

    @Autowired
    Conversation conversation;

    public static final String MSG_SERVER_ERROR = "大语言模型服务异常，请稍后再试";
    public static final String MSG_RETRY = "生成文本失败，请重新输入内容";

    public String getAnswer(String prompt){
        log.info("ApiUtil getAnswer, prompt: {}", prompt);
        Constants.apiKey = "sk-ddf30f0d118a445ba3e6f81c7ed05c64";
        ConversationParam param = ConversationParam
                .builder()
                .model(Conversation.Models.QWEN_TURBO)
                .prompt(prompt)
                .build();
        ConversationResult result;
        try {
            result = conversation.call(param);
        } catch (NoApiKeyException | InputRequiredException e) {
            return MSG_SERVER_ERROR;
        }
        log.info("ApiUtil getAnswer, result: {}", result);
        String text = result.getOutput().getText();
        if (StringUtils.isBlank(text)) {
            return MSG_RETRY;
        } else {
            return text;
        }
    }
}