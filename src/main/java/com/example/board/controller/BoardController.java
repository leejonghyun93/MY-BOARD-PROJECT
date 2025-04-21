package com.example.board.controller;

import com.example.board.dto.BoardDto;
import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import com.example.board.service.BoardService;
import com.example.board.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class BoardController {

    @Autowired
    private BoardService boardService;


    /**회원 목록 **/
    @RequestMapping("/boardList")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size,
                       @RequestParam(required = false) String searchValue,
                       Model model) {

        int totalCount = boardService.getTotalCount(searchValue);
        PageDTO<BoardDto> pageDTO = new PageDTO<>(page, totalCount, size, searchValue, null);
        List<BoardDto> list = boardService.listWithPaging(pageDTO);

        model.addAttribute("boardList", list);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("listUrl", "/boardList");
        model.addAttribute("searchValue", searchValue);

        return "board/list";
    }

    @PostMapping("/board/detail/{bno}")
    public String boardDetail(@PathVariable Integer bno, HttpSession session, Model model) {
        // 세션에서 로그인된 사용자 아이디를 가져옴
//        String userid = (String) session.getAttribute("userid");
//
//        // userid가 없으면 로그인 페이지로 리다이렉트
//        if (userid == null) {
//            model.addAttribute("message","로그인 후 이용 가능합니다.");
//            return "redirect:/login";
//        }
        boardService.increaseViewCount(bno);
        // 사용자 상세 정보를 가져옴
        BoardDto board = boardService.getBoardDetail(bno);

        // 모델에 사용자 정보를 추가
        model.addAttribute("board", board);

        // 상세 페이지로 이동
        return "board/detail";
    }

    @GetMapping("/board/editForm")
    public String editForm(@RequestParam("bno") int bno, Model model, HttpSession session, RedirectAttributes rttr) {
        String userid = (String) session.getAttribute("userid");

        // 게시글 가져오기
        BoardDto board = boardService.getBoardDetail(bno);

        if (board == null) {
            rttr.addFlashAttribute("msg", "존재하지 않는 게시글입니다.");
            return "redirect:/boardList"; // redirect일 경우 flash 사용
        }

        if (userid == null || !userid.equals(board.getWriter())) {
            rttr.addFlashAttribute("msg", "작성자 본인만 수정할 수 있습니다.");
            return "redirect:/boardList";
        }

        model.addAttribute("board", board);
        return "board/editForm";
    }
}
