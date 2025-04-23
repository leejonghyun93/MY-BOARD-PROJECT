package com.example.board.dao;

import com.example.board.dto.NaverUserInfo;
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

    @Override
    public UserDto getSelectUserDetail(String userid){
        return sqlSession.selectOne(NAMESPACE + ".getSelectUserDetail", userid);
    }

    @Override
    public void increaseLoginFailCount(String userid) {
        sqlSession.update(NAMESPACE + ".increaseLoginFailCount", userid);
    }

    @Override
    public void resetLoginFailCount(String userid) {
        sqlSession.update(NAMESPACE + ".resetLoginFailCount", userid);
    }

    @Override
    public void lockAccount(String userid) {
        sqlSession.update(NAMESPACE + ".lockAccount", userid);
    }

    @Override
    public void unlockAccount(String userid) {
        sqlSession.update(NAMESPACE + ".unlockAccount", userid);
    }

    @Override
    public int update(UserDto userDto)  {
        return sqlSession.update(NAMESPACE + ".updateUser", userDto);
    }

    @Override
    public void deleteUser(String userId) {
        sqlSession.delete(NAMESPACE + ".deleteUser", userId);
    }
    @Override
    public void updateWriterToNull(String userId) {
        sqlSession.update(NAMESPACE + ".updateWriterToNull", userId);
    }

    @Override
    public String findIdByNameAndEmail(String name, String email) {
        Map<String, Object> params = new HashMap<>();
        params.put("name", name);
        params.put("email", email);
        return sqlSession.selectOne(NAMESPACE + ".findIdByNameAndEmail", params);
    }

    @Override
    public int checkUser(String userid, String email) {
        Map<String, String> paramMap = new HashMap<>();
        paramMap.put("userid", userid);
        paramMap.put("email", email);
        return sqlSession.selectOne(NAMESPACE + ".checkUser", paramMap);
    }

    @Override
    public int updatePassword(String userid, String newPassword) {
        Map<String, String> paramMap = new HashMap<>();
        paramMap.put("userid", userid);
        paramMap.put("password", newPassword);
        return sqlSession.update(NAMESPACE + ".updatePassword", paramMap);
    }

    @Override
    public NaverUserInfo findByNaverId(String naverId) {
        return sqlSession.selectOne(NAMESPACE + ".findByNaverId", naverId);
    }

    @Override
    public void insertNaverUser(NaverUserInfo user) {
        sqlSession.insert(NAMESPACE + ".insertNaverUser", user);
    }
}