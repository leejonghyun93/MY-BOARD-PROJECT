package com.example.board.service;

import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;

import java.util.List;

public interface UserService {
    UserDto getMember(String userid);

    void insert(UserDto userDto);



    UserDto login(String userid, String passwd);

    int getTotalCount(String searchValue);

    List<UserDto> listWithPaging(PageDTO pageDTO);

    UserDto getUserDetail(String userid);
}
