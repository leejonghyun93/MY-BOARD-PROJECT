package com.example.board.service;

import com.example.board.dto.UserDto;

public interface UserService {
    UserDto getMember(String userid);

    void insert(UserDto userDto);



    UserDto login(String userid, String passwd);
}
