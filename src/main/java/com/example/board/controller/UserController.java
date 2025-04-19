package com.example.board.controller;


import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import com.example.board.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
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
    public String register(HttpSession session) {
        // 로그인 상태 확인 후 리다이렉트
        if (session.getAttribute("userid") != null) {
            return "redirect:/";
        }

        return "user/register";
    }

    @PostMapping("/member/register")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerMember(@RequestBody UserDto userDto) {
        Map<String, Object> response = new HashMap<>();

        // 필수 항목 검사
        if (userDto.getUserid() == null || userDto.getUserid().isEmpty() ||
                userDto.getPasswd() == null || userDto.getPasswd().isEmpty() ||
                userDto.getName() == null || userDto.getName().isEmpty()) {

            response.put("success", false);
            response.put("message", "필수 입력 항목이 누락되었습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        // 이미 존재하는 아이디인지 검사
        UserDto existingMember = userService.getMember(userDto.getUserid());
        if (existingMember != null) {
            response.put("success", false);
            response.put("message", "이미 존재하는 아이디입니다.");
            return ResponseEntity.badRequest().body(response);
        }

        // 로그인 시간 기본값 설정
        if (userDto.getLoginTime() == null || userDto.getLoginTime().isEmpty()) {
            userDto.setLoginTime(LocalDateTime.now().toString());
        }

        // 회원가입 진행
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
    public ResponseEntity<Map<String, Object>> login(@RequestParam String userid, @RequestParam String passwd, HttpSession session, HttpServletResponse response) {

        Map<String, Object> result = new HashMap<>();

        if (userid == null || userid.isEmpty() || passwd == null || passwd.isEmpty()) {
            result.put("error", "아이디와 비밀번호는 필수입니다.");
            return ResponseEntity.badRequest().body(result);
        }

        UserDto loggedInMember = userService.login(userid, passwd);

        if (loggedInMember == null) {
            result.put("error", "아이디 또는 비밀번호가 잘못되었습니다.");
            return ResponseEntity.status(401).body(result); // Unauthorized 상태
        }

        // 로그인 성공 시, 세션에 member 저장
        session.setAttribute("userid", loggedInMember.getUserid());
        session.setAttribute("name", loggedInMember.getName());

        // 리다이렉트 URL로 명시적으로 지정
//        result.put("message", "로그인 성공");

        // 클라이언트에게 리다이렉션 지시

        result.put("redirectUrl", "/"); // 리다이렉트할 URL

        return ResponseEntity.ok(result);
    }

    /** 로그아웃 **/

    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        session.invalidate();
        Map<String, Object> response = new HashMap<>();
        response.put("message", "로그아웃 성공");
        response.put("redirectUrl", "/");  // 홈으로 이동
        return ResponseEntity.ok(response);
    }

    /**회원 목록 **/
    @RequestMapping ("/memberList")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size,
                       @RequestParam(required = false) String searchValue,
                       Model model) {

        int totalCount = userService.getTotalCount(searchValue); // 검색 조건 포함된 count
        PageDTO<UserDto> pageDTO = new PageDTO<>(page, totalCount, size, searchValue, null);

        List<UserDto> list = userService.listWithPaging(pageDTO);

        model.addAttribute("memberList", list);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("listUrl", "/memberList");
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("searchValue", searchValue); // 이 라인을 추가해야 합니다!

        return "user/list";
    }

}
