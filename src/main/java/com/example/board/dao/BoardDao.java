package com.example.board.dao;

import com.example.board.dto.BoardDto;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class BoardDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.example.board.dao.BoardDao";

    public List<BoardDto> selectPagedBoards(int startRow, int pageSize, String searchValue) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("startRow", startRow);
        paramMap.put("pageSize", pageSize);
        paramMap.put("searchValue", searchValue);

        return sqlSession.selectList(NAMESPACE + ".selectPagedBoards", paramMap);
    }

    public int getTotalCount(String searchValue){
        return sqlSession.selectOne(NAMESPACE + ".getTotalCount", searchValue);
    }

    public BoardDto getSelectBoardDetail(Integer bno){
        return sqlSession.selectOne(NAMESPACE + ".getSelectBoardDetail", bno);
    }

    public void updateViewCount(Integer bno) {
        sqlSession.update(NAMESPACE + ".updateViewCount", bno);
    }

    public int update(BoardDto boardDto)  {
        return sqlSession.update(NAMESPACE + ".updateBoard", boardDto);
    }

    public int delete(BoardDto boardDto) {
        return sqlSession.delete(NAMESPACE + ".deleteBoard", boardDto);
    }

    public Optional<BoardDto> findById(Integer bno) {
        BoardDto board = sqlSession.selectOne(NAMESPACE + ".findById", bno);
        return Optional.ofNullable(board);
    }

    public boolean checkPassword(Integer bno, String passwd) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("bno", bno);
        paramMap.put("passwd", passwd);

        Integer result = sqlSession.selectOne(NAMESPACE + ".checkPassword", paramMap);
        return result != null && result > 0;
    }

    public void insert(BoardDto boardDto)  {
        sqlSession.insert(NAMESPACE + ".insert", boardDto);
    }

    public boolean updateBoardVisibility(List<Long> boardIds) {
        int updatedCount = sqlSession.update(NAMESPACE + ".updateBoardVisibility", boardIds);
        return updatedCount > 0;
    }

    public List<Map<String, Object>> getChartData() {
        return sqlSession.selectList(NAMESPACE + ".getChartData");
    }

    public List<Map<String, Object>> getChartPopularity() {
        return sqlSession.selectList(NAMESPACE + ".getChartPopularity");
    }

    public List<Map<String, Object>> getChartUserAccess() {
        return sqlSession.selectList(NAMESPACE + ".getChartUserAccess");
    }

    public List<BoardDto> selectMainBoard() {
        return sqlSession.selectList(NAMESPACE + ".selectMainBoard");
    }
}
