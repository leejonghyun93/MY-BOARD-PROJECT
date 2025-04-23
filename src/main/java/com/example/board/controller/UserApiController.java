package com.example.board.controller;

import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import com.example.board.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class UserApiController {

    @Autowired
    private UserService userService;

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
        if (userDto.getLoginTime() == null) {
            userDto.setLoginTime(LocalDateTime.now());
        }

        // 회원가입 진행
        userService.insert(userDto);

        response.put("success", true);
        response.put("message", "회원가입이 성공적으로 완료되었습니다.");
        response.put("redirectUrl", "/login");

        return ResponseEntity.ok(response);
    }

    /**
     * 회원 목록 (REST API 방식)
     **/
    @PostMapping("/memberList")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> list(@RequestParam(defaultValue = "1") int page,
                                                    @RequestParam(defaultValue = "10") int size,
                                                    @RequestParam(required = false) String searchValue) {

        // 총 회원 수 가져오기
        int totalCount = userService.getTotalCount(searchValue);

        // PageDTO 객체 생성 (페이징 처리된 DTO)
        PageDTO<UserDto> pageDTO = new PageDTO<>(page, totalCount, size, searchValue, null);

        // 페이징 처리된 회원 리스트 가져오기
        List<UserDto> list = userService.listWithPaging(pageDTO);

        // 결과를 담을 Map
        Map<String, Object> result = new HashMap<>();
        result.put("members", list);   // 회원 리스트
        result.put("pageDTO", pageDTO); // 페이징 정보

        // ResponseEntity로 반환
        return ResponseEntity.ok(result);
    }

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
    @PostMapping("/login")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> login(@RequestParam String userid, @RequestParam String passwd, HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        UserDto user = userService.getMember(userid);

        if (user == null) {
            result.put("error", "존재하지 않는 아이디입니다.");
            return ResponseEntity.status(401).body(result);
        }

        // 계정 잠금 상태 확인
        if (user.isAccountLocked()) {
            result.put("error", "계정이 잠금 상태입니다. 관리자에게 문의하세요.");
            return ResponseEntity.status(403).body(result);
        }

        // 비밀번호 틀림
        if (!user.getPasswd().equals(passwd)) {
            userService.increaseLoginFailCount(userid);

            // 🔄 DB에서 최신 로그인 실패 횟수 다시 조회
            UserDto updatedUser = userService.getMember(userid);
            int failCount = updatedUser.getLoginFailCount();

            if (failCount >= 5) {
                userService.lockAccount(userid);
                result.put("error", "비밀번호 5회 오류로 계정이 잠겼습니다.");
            } else {
                result.put("error", "비밀번호가 틀렸습니다. (" + failCount + "회 실패)");
            }

            return ResponseEntity.status(401).body(result);
        }

        // 로그인 성공
        userService.resetLoginFailCount(userid);
        userService.setLoginTime(userid);

        session.setAttribute("userid", user.getUserid());
        session.setAttribute("name", user.getName());
        session.setAttribute("userRole", user.getRole());
        System.out.println("세션에 저장된 role: " + session.getAttribute("userRole"));

        // request에 userRole 값을 추가
//        request.setAttribute("userRole", user.getRole());
        result.put("redirectUrl", "/");
        return ResponseEntity.ok(result);

    }

    /** 로그아웃 **/
    @PostMapping("/logout")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        session.invalidate();
        Map<String, Object> response = new HashMap<>();
        response.put("message", "로그아웃 성공");
        response.put("redirectUrl", "/");  // 홈으로 이동
        return ResponseEntity.ok(response);
    }

//    @GetMapping("/user/{userid}")
//    public ResponseEntity<UserDto> getUserInfo(@PathVariable String userid) {
//        UserDto user = userService.getUserDetail(userid);
//        return ResponseEntity.ok(user);
//    }
    @PostMapping(value = "/unlockAccount", produces = "text/plain; charset=UTF-8")
    @ResponseBody
    public String unlockAccount(@RequestParam("userid") String userid, HttpSession session) {
        String userRole = (String) session.getAttribute("userRole");

        if (!"ADMIN".equals(userRole)) {
            return "권한이 없습니다. 관리자만 사용 가능합니다.";
        }

        try {
            userService.unlockAccount(userid);
            return "계정 잠금이 성공적으로 해제되었습니다.";
        } catch (Exception e) {
            return "계정 잠금 해제 중 오류가 발생했습니다.";
        }
    }

    @PostMapping("/user/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateUser(@RequestBody UserDto userDto) {
        Map<String, Object> response = new HashMap<>();

        // 유효성 검사 및 데이터 업데이트
        userService.updateUser(userDto);

        response.put("success", true);
        response.put("message", "수정되었습니다.");
        response.put("redirectUrl", "/memberList");

        return ResponseEntity.ok(response);
    }

    @PostMapping("/user/delete")
    public String deleteUser(HttpSession session, RedirectAttributes rttr) {
        String userId = (String) session.getAttribute("userid");

        if (userId != null) {
            userService.deleteUser(userId);
            session.invalidate(); // 세션 제거
            rttr.addFlashAttribute("message", "회원 탈퇴가 완료되었습니다.");
        }

        return "redirect:/";
    }

    @PostMapping("/user/findId")
    @ResponseBody
    public Map<String, Object> findId(@RequestBody Map<String, String> request) {
        String name = request.get("name");
        String email = request.get("email");

        // DB 조회
        String userId = userService.findIdByNameAndEmail(name, email);

        Map<String, Object> result = new HashMap<>();
        if (userId != null) {
            result.put("success", true);
            result.put("userid", userId);
        } else {
            result.put("success", false);
        }

        return result;
    }

    @PostMapping("/user/findPw")
    @ResponseBody
    public Map<String, Object> findPw(@RequestBody Map<String, String> request) {
        String userid = request.get("userid");
        String email = request.get("email");

        Map<String, Object> result = new HashMap<>();

        // 비밀번호 찾기 로직 수행
        boolean isUserExist = userService.checkUserForPw(userid, email);

        if (isUserExist) {
            String tempPw = userService.createTemporaryPassword(userid);
            result.put("success", true);
            // 메일 전송 로직 호출 가능
        } else {
            result.put("success", false);
        }

        return result;
    }
}
