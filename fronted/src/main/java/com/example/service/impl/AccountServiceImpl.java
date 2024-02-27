package com.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.common.R;
import com.example.common.SessionKey;
import com.example.entity.Account;
import com.example.mapper.AccountMapper;
import com.example.service.AccountService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;

@Service
@Slf4j
public class AccountServiceImpl extends ServiceImpl<AccountMapper, Account>
        implements AccountService {

    /**
     *  用户登录
     */
    @Override
    public R<Account> login(HttpServletRequest request, Account inputAccount) {
        log.info("user login: {}", inputAccount);

        if (inputAccount != null) {
            //1、根据页面提交的信息（phone/email）查询数据库
            LambdaQueryWrapper<Account> queryWrapper = new LambdaQueryWrapper<>();
            if (StringUtils.isNotBlank(inputAccount.getPhoneNumber())) {
                queryWrapper.eq(Account::getPhoneNumber, inputAccount.getPhoneNumber());
            } else if (StringUtils.isNotBlank(inputAccount.getEmail())){
                queryWrapper.eq(Account::getEmail, inputAccount.getEmail());
            } else if (StringUtils.isNotBlank(inputAccount.getUsername())) {
                queryWrapper.eq(Account::getUsername, inputAccount.getUsername());
            }
            Account account = this.getOne(queryWrapper);

            if(account == null){
                return R.clientError(R.MSG_LOGIN_FAILURE, null);
            }
            // 处理用户名大小写不一致的情况
            if (!account.getUsername().equals(inputAccount.getUsername())) {
                account = null;
            }

            //2、如果没有查询到则返回登录失败结果
            if(account == null){
                return R.clientError(R.MSG_LOGIN_FAILURE, null);
            }

            //3、将页面提交的密码password进行md5加密处理
            String password = inputAccount.getPassword();
            password = DigestUtils.md5DigestAsHex(password.getBytes());

            //4、密码比对，如果不一致则返回登录失败结果
            if(!password.equals(account.getPassword())){
                return R.clientError(R.MSG_PASSWORD_FAILURE, null);
            }

            //5、登录成功，将员工id存入Session并返回登录成功结果
            request.getSession().setAttribute(SessionKey.USER_KEY, account.getId());
            return R.success(R.MSG_LOGIN_SUCCESS, account);
        }
        return R.clientError(R.MSG_LOGIN_FAILURE, null);
    }

    /**
     *  退出登录
     */
    @Override
    public R<String> logout(HttpServletRequest request) {
        //清理Session中保存的当前登录用户的id
        log.info("user logout, request: {}", request);
        request.getSession().removeAttribute(SessionKey.USER_KEY);
        return R.success("退出成功", null);
    }

    /**
     * 用户注册
     */
    @Override
    public R<String> register(Account inputAccount) {
        log.info("account register: {}", inputAccount);
        LambdaQueryWrapper<Account> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Account::getUsername, inputAccount.getUsername());
        Account exist = this.getOne(queryWrapper);
        if (exist != null) {
            return R.clientError("该用户名已注册", null);
        }
        inputAccount.setPassword(DigestUtils.md5DigestAsHex(inputAccount.getPassword().getBytes()));
        if (this.save(inputAccount)) {
            return R.success("注册成功",null);
        } else {
            return R.serverError("服务器异常，请稍后注册", null);
        }
    }

    /**
     * 账号信息更新
     */
    @Override
    public R<String> update(Account account) {
        log.info("account update, account: {}", account);
        account.setUpdateTime(LocalDateTime.now());
        if (this.updateById(account)) {
            return R.success("信息更新成功", null);
        } else {
            return R.serverError("信息更新失败", null);
        }
    }

    /**
     * 通过ID获取账号信息
     */
    @Override
    public R<Account> getInfoById(Long id) {
        log.info("account getInfoById, id: {}", id);
        if (id != null) {
            Account result = this.getById(id);
            if (result != null) {
                return R.success("通过ID查询账号信息成功", result);
            } else {
                return R.serverError("未查询到对应ID的账号信息", null);
            }
        } else {
            return R.clientError("传入ID异常", null);
        }
    }
}
