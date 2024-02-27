package com.example.service;

import com.example.common.R;
import com.example.dto.LlmDto;
import org.springframework.web.bind.annotation.RequestBody;

public interface LlmService {
    R<String> chat(@RequestBody LlmDto dto);
}
