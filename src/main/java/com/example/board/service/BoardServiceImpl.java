package com.example.board.service;


import com.example.board.dao.BoardDao;
import com.example.board.dto.BoardDto;
import com.example.board.dto.PageDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardDao boardDao;

    @Override
    public int getTotalCount(String searchValue) {
        return boardDao.getTotalCount(searchValue);
    }

    @Override
    public List<BoardDto> listWithPaging(PageDTO pageDTO) {
        int startRow = pageDTO.getStartRow();
        int pageSize = pageDTO.getPageSize();
        String searchValue = pageDTO.getSearchValue();

        return boardDao.selectPagedBoards(startRow, pageSize, searchValue);
    }

    @Override
    public BoardDto getBoardDetail(Integer bno){
        return boardDao.getSelectBoardDetail(bno);
    }

    @Override
    public void increaseViewCount(Integer bno) {
        boardDao.updateViewCount(bno);
    }

    @Override
    public int updateBoard(BoardDto boardDto){
        BoardDto existingBoard = boardDao.getSelectBoardDetail(boardDto.getBno());
        if (existingBoard == null || !existingBoard.getPasswd().equals(boardDto.getPasswd())) {
            throw new RuntimeException("비밀번호가 틀립니다.");
        }

        return boardDao.update(boardDto);
    }
    @Override
    public int deleteBoard(BoardDto boardDto) {
        int result = boardDao.delete(boardDto);
        if (result == 0) {
            throw new RuntimeException("비밀번호가 틀리거나 게시물이 존재하지 않습니다.");
        }
        return result;
    }
}
