package com.example.board.controller;

import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import com.example.board.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /**회원 등록 **/
    @GetMapping("/member/register")
    public String register(HttpSession session) {
        // 로그인 상태 확인 후 리다이렉트
        if (session.getAttribute("userid") != null) {
            return "redirect:/";
        }

        return "user/register";
    }

    /** 로그인 **/
    @GetMapping("/login")
    public String loginForm(HttpSession session) {
        if (session.getAttribute("userid") != null) {
            // 이미 로그인된 상태 → 홈이나 원하는 페이지로 리다이렉트
            return "redirect:/";
        }
        return "user/login"; // 로그인 JSP 페이지로 이동
    }

    /**회원 목록 **/
    @RequestMapping("/memberList")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size,
                       @RequestParam(required = false) String searchValue,
                       Model model) {

        int totalCount = userService.getTotalCount(searchValue);
        PageDTO<UserDto> pageDTO = new PageDTO<>(page, totalCount, size, searchValue, null);
        List<UserDto> list = userService.listWithPaging(pageDTO);

        model.addAttribute("memberList", list);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("listUrl", "/memberList");
        model.addAttribute("searchValue", searchValue);

        return "user/list"; // JSP 위치: /WEB-INF/views/user/list.jsp
    }

    @PostMapping("/detail")
    public String userDetail(HttpSession session, Model model) {
        // 세션에서 로그인된 사용자 아이디를 가져옴
        String userid = (String) session.getAttribute("userid");

        // userid가 없으면 로그인 페이지로 리다이렉트
        if (userid == null) {
            model.addAttribute("message","로그인 후 이용 가능합니다.");
            return "redirect:/login";
        }

        // 사용자 상세 정보를 가져옴
        UserDto user = userService.getUserDetail(userid);

        // 모델에 사용자 정보를 추가
        model.addAttribute("user", user);

        // 상세 페이지로 이동
        return "user/detail";
    }
}

