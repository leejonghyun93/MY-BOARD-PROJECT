package com.example.board.controller;

import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import com.example.board.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class UserApiController {

    @Autowired
    private UserService userService;

    /**
     * 회원 목록 (REST API 방식)
     **/
    @PostMapping("/memberList")
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
}
