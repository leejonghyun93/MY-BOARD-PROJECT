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

    void setLoginTime(String userid);
    void increaseLoginFailCount(String userid);
    void resetLoginFailCount(String userid);
    void lockAccount(String userid);
    void unlockAccount(String userid);

    // 수정화면
    int updateUser(UserDto userDto);

    void deleteUser(String userId);

    String findIdByNameAndEmail(String name, String email);

    boolean checkUserForPw(String userid, String email);

    String createTemporaryPassword(String userid);
}
