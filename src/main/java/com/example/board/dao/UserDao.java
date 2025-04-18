package com.example.board.dao;

import com.example.board.dto.UserDto;

public interface UserDao {

    UserDto getMember(String userid);

    void insert(UserDto userDto);

    void setLoginTime(String userid);
}
