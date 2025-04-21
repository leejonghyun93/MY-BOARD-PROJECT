package com.example.board.dao;

import com.example.board.dto.BoardDto;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
}
