package com.example.board.controller;

import com.example.board.dto.BoardDto;
import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import com.example.board.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class BoardApiController {

    @Autowired
    private BoardService boardService;

    @PostMapping("/boardList")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> list(@RequestParam(defaultValue = "1") int page,
                                                    @RequestParam(defaultValue = "10") int size,
                                                    @RequestParam(required = false) String searchValue) {

        // 총 회원 수 가져오기
        int totalCount = boardService.getTotalCount(searchValue);

        // PageDTO 객체 생성 (페이징 처리된 DTO)
        PageDTO<BoardDto> pageDTO = new PageDTO<>(page, totalCount, size, searchValue, null);

        // 페이징 처리된 회원 리스트 가져오기
        List<BoardDto> list = boardService.listWithPaging(pageDTO);

        // 결과를 담을 Map
        Map<String, Object> result = new HashMap<>();
        result.put("boards", list);   // 회원 리스트
        result.put("pageDTO", pageDTO); // 페이징 정보

        // ResponseEntity로 반환
        return ResponseEntity.ok(result);
    }
    @PostMapping("/board/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateUser(@RequestBody BoardDto boardDto) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 게시글 수정
            boardService.updateBoard(boardDto);
            response.put("success", true);
            response.put("message", "수정되었습니다.");
            response.put("redirectUrl", "/boardList");
        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/board/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteBoard(@RequestBody BoardDto boardDto) {
        Map<String, Object> response = new HashMap<>();
        try {
            boardService.deleteBoard(boardDto);
            response.put("success", true);
            response.put("message", "게시글이 삭제되었습니다.");
            response.put("redirectUrl", "/boardList");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return ResponseEntity.ok(response);
    }
}
