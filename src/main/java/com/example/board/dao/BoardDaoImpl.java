package com.example.board.dao;

import com.example.board.dto.BoardDto;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class BoardDaoImpl implements BoardDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.example.board.dao.BoardDao";

    @Override
    public List<BoardDto> selectPagedBoards(@Param("startRow") int startRow,
                                            @Param("pageSize") int pageSize,
                                            @Param("searchValue") String searchValue) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("startRow", startRow);
        paramMap.put("pageSize", pageSize);
        paramMap.put("searchValue", searchValue);

        return sqlSession.selectList(NAMESPACE + ".selectPagedBoards", paramMap);
    }

    @Override
    public int getTotalCount(@Param("searchValue") String searchValue){
        return sqlSession.selectOne(NAMESPACE + ".getTotalCount", searchValue);
    }

    @Override
    public BoardDto getSelectBoardDetail(Integer bno){
        return sqlSession.selectOne(NAMESPACE + ".getSelectBoardDetail", bno);
    }


    @Override
    public void updateViewCount(Integer bno) {
        sqlSession.update(NAMESPACE + ".updateViewCount", bno);
    }

    @Override
    public int update(BoardDto boardDto)  {
        return sqlSession.update(NAMESPACE + ".updateBoard", boardDto);
    }
    @Override
    public int delete(BoardDto boardDto) {
        return sqlSession.delete(NAMESPACE + ".deleteBoard", boardDto);
    }

    @Override
    public Optional<BoardDto> findById(Integer bno) {
        BoardDto board = sqlSession.selectOne(NAMESPACE + ".findById", bno);
        return Optional.ofNullable(board);
    }

    @Override
    public boolean checkPassword(Integer bno, String passwd) {
        // 비밀번호가 맞는지 확인
        Integer result = sqlSession.selectOne(NAMESPACE + ".checkPassword", Map.of("bno", bno, "passwd", passwd));
        return result != null && result > 0;
    }

    @Override
    public void insert(BoardDto boardDto)  {
        sqlSession.insert(NAMESPACE + ".insert", boardDto);
    }

    @Override
    public boolean updateBoardVisibility(List<Long> boardIds) {
        int updatedCount = sqlSession.update(NAMESPACE + ".updateBoardVisibility", boardIds);
        return updatedCount > 0;
    }

    @Override
    public List<Map<String, Object>> getChartData() {
        return sqlSession.selectList(NAMESPACE + ".getChartData");
    }

    @Override
    public List<Map<String, Object>> getChartPopularity() {
        return sqlSession.selectList(NAMESPACE + ".getChartPopularity");
    }


}
