package com.example.board.controller;


import com.example.board.dto.UserDto;
import com.example.board.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /**회원 목록 **/

    /** 회원 아이디 찾기**/
    @GetMapping(value = "/member/checkUserid", produces = "application/json")
    @ResponseBody
    public Map<String, Boolean> checkUserid(@RequestParam("userid") String userid) {
        System.out.println("입력한 아이디: " + userid);

        UserDto member = userService.getMember(userid);
        boolean isAvailable = (member == null);

        Map<String, Boolean> result = new HashMap<>();
        result.put("available", isAvailable);
        return result;
    }


    /**회원 등록 **/
    @GetMapping("/member/register")
    public String register() {
        return "user/register";
    }

    @PostMapping("/member/register")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerMember(@RequestBody UserDto  userDto) {
        Map<String, Object> response = new HashMap<>();

        if (userDto.getUserid() == null || userDto.getUserid().isEmpty() ||
                userDto.getPasswd() == null || userDto.getPasswd().isEmpty() ||
                userDto.getName() == null || userDto.getName().isEmpty()) {

            response.put("success", false);
            response.put("message", "필수 입력 항목이 누락되었습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        UserDto existingMember = userService.getMember(userDto.getUserid());
        if (existingMember != null) {
            response.put("success", false);
            response.put("message", "이미 존재하는 아이디입니다.");
            return ResponseEntity.badRequest().body(response);
        }
        if (userDto.getLoginTime() == null || userDto.getLoginTime().isEmpty()) {
            userDto.setLoginTime(LocalDateTime.now().toString());
        }

        userService.insert(userDto);

        response.put("success", true);
        response.put("message", "회원가입이 성공적으로 완료되었습니다.");
        response.put("redirectUrl", "/login");

        return ResponseEntity.ok(response);
    }

    /** 로그인 **/
    @GetMapping("/login")
    public String loginForm() {
        return "user/login";
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestParam String userid, @RequestParam String passwd, HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        if (userid == null || userid.isEmpty() || passwd == null || passwd.isEmpty()) {
            response.put("error", "아이디와 비밀번호는 필수입니다.");
            return ResponseEntity.badRequest().body(response);
        }

        UserDto loggedInMember = userService.login(userid, passwd);

        if (loggedInMember == null) {
            response.put("error", "아이디 또는 비밀번호가 잘못되었습니다.");
            return ResponseEntity.status(401).body(response); // Unauthorized 상태
        }

        session.setAttribute("member", loggedInMember);

        response.put("message", "로그인 성공");
        response.put("member", loggedInMember);
        response.put("redirectUrl", "/");
        return ResponseEntity.ok(response);
    }

    /** 로그아웃 **/

    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        session.invalidate();
        Map<String, Object> response = new HashMap<>();
        response.put("message", "로그아웃 성공");
        response.put("redirectUrl", "/loginForm");
        return ResponseEntity.ok(response);
    }


}
