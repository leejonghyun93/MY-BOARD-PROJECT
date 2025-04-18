package com.example.board.dao;

import com.example.board.dto.UserDto;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.example.board.dao.UserDao";

    @Override
    public UserDto getMember(String userid){
        return sqlSession.selectOne(NAMESPACE + ".getMember", userid);
    }

    @Override
    public void insert(UserDto userDto)  {
        sqlSession.insert(NAMESPACE + ".insert", userDto);
    }

    @Override
    public void setLoginTime(String userid){
        sqlSession.update(NAMESPACE + ".setLoginTime", userid);
    }

    @Override
    public List<UserDto> selectPagedMembers(){
        return sqlSession.selectList(NAMESPACE + ".selectPagedMembers");
    }

    @Override
    public List<UserDto> selectPagedMembers(@Param("startRow") int startRow,
                                            @Param("pageSize") int pageSize,
                                            @Param("searchValue") String searchValue) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("startRow", startRow);
        paramMap.put("pageSize", pageSize);
        paramMap.put("searchValue", searchValue);

        return sqlSession.selectList(NAMESPACE + ".selectPagedMembers", paramMap);
    }

    @Override
    public int getTotalCount(@Param("searchValue") String searchValue){
        return sqlSession.selectOne(NAMESPACE + ".getTotalCount", searchValue);
    }
}