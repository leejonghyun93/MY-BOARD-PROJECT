package com.example.board.service;

import com.example.board.dto.BoardDto;
import com.example.board.dto.PageDTO;

import java.util.List;
import java.util.Map;

public interface BoardService {
    int getTotalCount(String searchValue);

    List<BoardDto> listWithPaging(PageDTO pageDTO);

    BoardDto getBoardDetail(Integer bno);

    void increaseViewCount(Integer bno);

    int updateBoard(BoardDto boardDto);

    int deleteBoard(BoardDto boardDto);

    boolean checkPassword(Integer bno, String passwd);

    void insert(BoardDto boardDto);

    boolean toggleVisibility(List<Long> boardIds);


    List<Map<String, Object>> getChartData();


    List<Map<String, Object>> getChartPopularity();
}
