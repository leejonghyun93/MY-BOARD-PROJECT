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

        boardService.increaseViewCount(bno);
        // 사용자 상세 정보를 가져옴
        BoardDto board = boardService.getBoardDetail(bno);

        // 모델에 사용자 정보를 추가
        model.addAttribute("board", board);

        // 상세 페이지로 이동
        return "board/detail";
    }

    @GetMapping("/board/write")
    public String register(HttpSession session) {
        // 로그인 상태 확인 후 리다이렉트
//        if (session.getAttribute("userid") != null) {
//            return "/board/write";
//        }

        return "/board/write";
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
    @PostMapping("/board/delete")
    public String deleteBoard(@RequestParam("bno") int bno,
                              @RequestParam("writer") String writer,
                              @RequestParam("passwd") String passwd,
                              HttpSession session,
                              RedirectAttributes redirectAttributes,
                              Model model) {

        String loginId = (String) session.getAttribute("userid");

        if (!writer.equals(loginId)) {
            model.addAttribute("msg", "삭제 권한이 없습니다.");
            return "redirect:/boardList";
        }

        BoardDto dto = new BoardDto();
        dto.setBno(bno);
        dto.setPasswd(passwd);

        boolean isCorrect = boardService.checkPassword(bno, passwd);
        if (!isCorrect) {
            model.addAttribute("msg", "비밀번호가 일치하지 않습니다.");
            return "redirect:/boardList";
        }

        int result = boardService.deleteBoard(dto);

        if (result > 0) {
            model.addAttribute("msg", "게시글이 삭제되었습니다.");
            return "redirect:/boardList";
        } else {
            model.addAttribute("msg", "게시글 삭제에 실패했습니다.");
            return "redirect:/boardList";
        }
    }



}
