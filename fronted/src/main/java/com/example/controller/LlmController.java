package com.example.controller;

import com.example.common.R;
import com.example.dto.LlmDto;
import com.example.service.LlmService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/llm")
public class LlmController {

    @Autowired
    private LlmService llmService;

    /**
     *  调用大语言模型API
     */
    @PostMapping("/chat")
    public R<String> chat(@RequestBody LlmDto dto) {
        return llmService.chat(dto);
    }
}
