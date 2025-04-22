package com.example.board.dao;

import com.example.board.dto.BoardDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface BoardDao {

    List<BoardDto> selectPagedBoards(@Param("startRow") int startRow,
                                     @Param("pageSize") int pageSize,
                                     @Param("searchValue") String searchValue);

    int getTotalCount(@Param("searchValue") String searchValue);

    BoardDto getSelectBoardDetail(Integer bno);

    void updateViewCount(Integer bno);

    int update(BoardDto boardDto);

    int delete(BoardDto boardDto);

    Optional<BoardDto> findById(Integer bno);

    boolean checkPassword(Integer bno, String passwd);

    void insert(BoardDto boardDto);

    boolean updateBoardVisibility(List<Long> boardIds);
}
