package com.example.board.service;

import com.example.board.dto.BoardDto;
import com.example.board.dto.PageDTO;

import java.util.List;

public interface BoardService {
    int getTotalCount(String searchValue);

    List<BoardDto> listWithPaging(PageDTO pageDTO);

    BoardDto getBoardDetail(Integer bno);

    void increaseViewCount(Integer bno);

    int updateBoard(BoardDto boardDto);

    int deleteBoard(BoardDto boardDto);
}
