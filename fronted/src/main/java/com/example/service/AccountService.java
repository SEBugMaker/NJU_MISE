package com.example.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.common.R;
import com.example.entity.Account;
import org.springframework.web.bind.annotation.RequestBody;

import javax.servlet.http.HttpServletRequest;

public interface AccountService extends IService<Account> {
    R<Account> login(HttpServletRequest request, @RequestBody Account inputAccount);
    R<String> logout(HttpServletRequest request);
    R<String> register(@RequestBody Account inputAccount);
    R<String> update(@RequestBody Account account);
    R<Account> getInfoById(@RequestBody Long id);
}
