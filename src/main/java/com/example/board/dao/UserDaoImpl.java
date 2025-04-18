package com.example.board.dao;

import com.example.board.dto.UserDto;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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

}