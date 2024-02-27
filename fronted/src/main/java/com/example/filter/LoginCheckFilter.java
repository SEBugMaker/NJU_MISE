package com.example.filter;

import com.alibaba.fastjson.JSON;
import com.example.common.BaseContext;
import com.example.common.R;
import com.example.common.SessionKey;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.AntPathMatcher;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;

/**
 * 检查访问相应页面的用户是否已登录
 */
@WebFilter(filterName = "loginCheckFilter", urlPatterns = "/*")
@Slf4j
public class LoginCheckFilter implements Filter {

    public static final AntPathMatcher ANT_PATH_MATCHER = new AntPathMatcher();

    private static final String[] ignoreURLs = new String[]{
            "/**",
            "/account/register",
            "/account/login",
            "/account/logout",
            "/backend/**",
            "/front/**",
            "/common/**",
            "/user/login",
            "/user/sendMsg"
    };

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest httpServletRequest = (HttpServletRequest) servletRequest;
        HttpServletResponse httpServletResponse = (HttpServletResponse) servletResponse;

        log.info("LoginCheckFilter doFilter, 线程ID: {}", Thread.currentThread().getId());

        // 1. 获取本次请求URI
        String requestURI = httpServletRequest.getRequestURI();
        log.info("拦截到请求: {}", requestURI);
        log.info("本次请求所属会话ID: {}", httpServletRequest.getSession().getId());

        // 2. 判断本次请求是否需要处理: 如果不需要处理，直接放行
        if (isIgnored(requestURI)) {
            filterChain.doFilter(httpServletRequest, httpServletResponse);
            log.info("请求{}不需要处理", requestURI);
        } else { // 3. 需要处理，判断登录状态
            // 4. 已登录的直接放行
            HttpSession session = httpServletRequest.getSession();
            Long userId = (Long) session.getAttribute(SessionKey.USER_KEY);
            if (userId != null) {
                // 让MetaHandler能够获取userId, 赋值要写在doFilter之前，保证顺序
                BaseContext.setUserId(userId);
                filterChain.doFilter(httpServletRequest, httpServletResponse);
                log.info("用户{}已登录", userId);
            } else { // 5. 未登录则返回未登录结果
                log.info("用户未登录");
                httpServletResponse.getWriter().write(JSON.toJSONString(R.clientError(R.MSG_NOT_LOGIN, null)));
            }
        }
        log.info("已处理完拦截的请求: {}", requestURI);
    }

    /**
     * 检查URI是否可以直接放行
     */
    private boolean isIgnored(String requestURI) {
        return Arrays.stream(ignoreURLs).anyMatch(url -> ANT_PATH_MATCHER.match(url, requestURI));
    }
}
