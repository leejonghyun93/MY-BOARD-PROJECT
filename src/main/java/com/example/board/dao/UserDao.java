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
}
