package com.example.board.dao;

import com.example.board.dto.UserDto;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserDao {

    UserDto getMember(String userid);

    void insert(UserDto userDto);

    void setLoginTime(String userid);


    List<UserDto> selectPagedMembers();

    List<UserDto> selectPagedMembers(@Param("startRow") int startRow,
                                     @Param("pageSize") int pageSize,
                                     @Param("searchValue") String searchValue);

    int getTotalCount(@Param("searchValue") String searchValue);

    UserDto getSelectUserDetail(String userid);

    void increaseLoginFailCount(String userid);
    void resetLoginFailCount(String userid);
    void lockAccount(String userid);
    void unlockAccount(String userid); // 관리자 전용

    int update(UserDto userDto);

    void deleteUser(String userId);

    void updateWriterToNull(String userId);

    String findIdByNameAndEmail(String name, String email);

    int checkUser(String userid, String email);

    int updatePassword(String userid, String newPassword);
}
