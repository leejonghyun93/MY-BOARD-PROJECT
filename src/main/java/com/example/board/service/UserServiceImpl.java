package com.example.board.service;

import com.example.board.dao.UserDao;
import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService  {

    @Autowired
    private UserDao userDao;

    @Override
    public UserDto getMember(String userid) {
        return userDao.getMember(userid);
    }

    @Override
    public void insert(UserDto userDto) {
        userDao.insert(userDto);
    }

    @Override
    public UserDto login(String userid, String passwd) {
        UserDto member = userDao.getMember(userid);
        if (member == null) return null;

        boolean result = member.getPasswd().equals(passwd);
        if (result == false) return null;

        userDao.setLoginTime(userid);

        return member;
    }

    @Override
    public int getTotalCount(String searchValue) {
        return userDao.getTotalCount(searchValue);
    }

    @Override
    public List<UserDto> listWithPaging(PageDTO pageDTO) {
        int startRow = pageDTO.getStartRow();
        int pageSize = pageDTO.getPageSize();
        String searchValue = pageDTO.getSearchValue();

        return userDao.selectPagedMembers(startRow, pageSize, searchValue);
    }

}
