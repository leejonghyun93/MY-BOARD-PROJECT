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

    @RequestMapping("/boardList")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size,
                       @RequestParam(required = false) String searchValue,
                       HttpSession session,
                       Model model) {

        int totalCount = boardService.getTotalCount(searchValue);
        PageDTO<BoardDto> pageDTO = new PageDTO<>(page, totalCount, size, searchValue, null);
        List<BoardDto> list = boardService.listWithPaging(pageDTO);

        model.addAttribute("boardList", list);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("listUrl", "/boardList");
        model.addAttribute("searchValue", searchValue);

        return "board/list"; // 비동기 처리 시 'board/list'에서 필요한 부분만 반환하도록 수정 필요
    }

    @RequestMapping(value = "/boardList/ajax", method = RequestMethod.GET)
    @ResponseBody
    public PageDTO<BoardDto> listWithAjax(@RequestParam(defaultValue = "1") int page,
                                          @RequestParam(defaultValue = "10") int size,
                                          @RequestParam(required = false) String searchValue) {
        int totalCount = boardService.getTotalCount(searchValue);
        PageDTO<BoardDto> pageDTO = new PageDTO<>(page, totalCount, size, searchValue, null);
        List<BoardDto> list = boardService.listWithPaging(pageDTO);

        pageDTO.setDataList(list);  // 페이지 DTO에 게시판 목록 추가
        return pageDTO;  // PageDTO로 반환
    }

    @GetMapping("/board/detail/{bno}")
    public String boardDetail(@PathVariable Integer bno, Model model) {

        boardService.increaseViewCount(bno);

        BoardDto board = boardService.getBoardDetail(bno);

        // 모델에 사용자 정보를 추가
        model.addAttribute("board", board);

        // 상세 페이지로 이동
        return "board/detail";
    }

    @GetMapping("/board/write")
    public String register() {
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
    public String deleteBoard(
            @RequestParam("bno") int bno,
            @RequestParam("writer") String writer,
            @RequestParam("passwd") String passwd,
            HttpSession session,
            RedirectAttributes rttr) {

        String loginId = (String) session.getAttribute("userid");

        if (!writer.equals(loginId)) {
            rttr.addFlashAttribute("msg", "삭제 권한이 없습니다.");
            return "redirect:/boardList";
        }

        if (!boardService.checkPassword(bno, passwd)) {
            rttr.addFlashAttribute("msg", "비밀번호가 일치하지 않습니다.");
            return "redirect:/board/detail/" + bno;  // 상세 페이지로 돌아감
        }

        BoardDto dto = new BoardDto();
        dto.setBno(bno);
        dto.setPasswd(passwd);
        int delResult = boardService.deleteBoard(dto);

        if (delResult > 0) {
            rttr.addFlashAttribute("msg", "게시글이 삭제되었습니다.");
            return "redirect:/boardList";  // 삭제 성공 시 목록으로
        } else {
            rttr.addFlashAttribute("msg", "게시글 삭제에 실패했습니다.");
            return "redirect:/board/detail/" + bno;  // 삭제 실패 시 상세 페이지로
        }
    }
//    @PostMapping("/board/delete")
//    @ResponseBody
//    public String deleteBoard(@RequestParam("bno") int bno,
//                              @RequestParam("writer") String writer,
//                              @RequestParam("passwd") String passwd,
//                              HttpSession session,
//                              RedirectAttributes redirectAttributes,
//                              Model model) {
//
//        String loginId = (String) session.getAttribute("userid");
//
//        if (!writer.equals(loginId)) {
//            redirectAttributes.addFlashAttribute("msg", "삭제 권한이 없습니다.");
//            return "board/detail";
//        }
//
//        BoardDto dto = new BoardDto();
//        dto.setBno(bno);
//        dto.setPasswd(passwd);
//
//        boolean isCorrect = boardService.checkPassword(bno, passwd);
//        if (!isCorrect) {
//            redirectAttributes.addFlashAttribute("msg", "비밀번호가 일치하지 않습니다.");
//            return "board/detail";
//        }
//
//        int result = boardService.deleteBoard(dto);
//
//        if (result > 0) {
//            redirectAttributes.addFlashAttribute("msg", "게시글이 삭제되었습니다.");
//        } else {
//            redirectAttributes.addFlashAttribute("msg", "게시글 삭제에 실패했습니다.");
//        }
//        return "board/detail";
//    }



}
