package com.example.config;

import com.alibaba.dashscope.aigc.conversation.Conversation;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

@Configuration
public class ConversationConfig {
    @Bean
    @Scope(value = "singleton")
    public Conversation conversation() {
        return new Conversation();
    }
}
