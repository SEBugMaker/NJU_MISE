package com.example.controller;

import com.example.common.R;
import com.example.entity.Account;
import com.example.service.AccountService;
import javax.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/account")
public class AccountController {

    @Autowired
    private AccountService accountService;

    /**
     * 用户登录
     */
    @PostMapping("/login")
    public R<Account> login(HttpServletRequest request, @RequestBody Account inputAccount) {
        return accountService.login(request, inputAccount);
    }

    /**
     * 退出登录
     */
    @PostMapping("/logout")
    public R<String> logout(HttpServletRequest request) {
        return accountService.logout(request);
    }

    /**
     * 用户注册
     */
    @PostMapping("/register")
    public R<String> register(@RequestBody Account inputAccount) {
        return accountService.register(inputAccount);
    }

    /**
     * 更新账号信息
     */
    @PostMapping("/updateInfo")
    public R<String> updateInfo(@RequestBody Account input) {
        return accountService.update(input);
    }

    /**
     * 通过ID获取账号信息
     */
    @PostMapping("/getInfo")
    public R<Account> getInfo(@RequestBody Account input) {
        return accountService.getInfoById(input.getId());
    }
}
