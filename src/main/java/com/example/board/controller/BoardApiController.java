package com.example.board.controller;

import com.example.board.dto.BoardDto;
import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import com.example.board.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
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

    @PostMapping("/board/write")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerMember(@RequestBody BoardDto boardDto, HttpSession httpSession) {
        Map<String, Object> response = new HashMap<>();

        // 필수 항목 검사
        if (boardDto.getTitle() == null || boardDto.getTitle().isEmpty() ||
                boardDto.getPasswd() == null || boardDto.getPasswd().isEmpty() ||
                boardDto.getContent() == null || boardDto.getContent().isEmpty()) {

            response.put("success", false);
            response.put("message", "필수 입력 항목이 누락되었습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        String loginUserId = (String) httpSession.getAttribute("userid");

        if (loginUserId != null) {
            boardDto.setWriter(loginUserId);  // 회원이면 OK
            boardDto.setNickName(null);  // 회원이므로 NickName은 null
        } else {
            // 비회원일 경우 닉네임을 입력하지 않으면 오류 메시지 반환
            if (boardDto.getNickName() == null || boardDto.getNickName().isEmpty()) {
                response.put("success", false);
                response.put("message", "작성자 이름을 입력해주세요.");
                return ResponseEntity.badRequest().body(response);
            }
            boardDto.setWriter(null);  // 비회원은 writer를 null로 설정
        }

        // boardService 호출
        boardService.insert(boardDto);

        // 성공 응답
        response.put("success", true);
        response.put("message", "게시글이 성공적으로 등록되었습니다.");
        response.put("redirectUrl", "/boardList");

        return ResponseEntity.ok(response);
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

//    @DeleteMapping("/board/delete/{bno}")
//    public ResponseEntity deleteBoard(
//            @PathVariable("bno") Integer bno,
//            @RequestBody BoardDto boardDto) {
//
//        Map<String, Object> response = new HashMap<>();
//        try {
//            boardDto.setBno(bno); // 경로 변수로 넘어온 bno 설정
//            boardService.deleteBoard(bno); // 게시글 삭제 수행
//
//            response.put("success", true);
//            response.put("message", "게시글이 삭제되었습니다.");
//            response.put("redirectUrl", "/boardList");
//        } catch (Exception e) {
//            response.put("success", false);
//            response.put("message", e.getMessage());
//        }
//
//        return ResponseEntity.ok(response);
//    }

}
