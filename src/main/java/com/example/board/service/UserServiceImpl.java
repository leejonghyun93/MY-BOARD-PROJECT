package com.example.board.service;

import com.example.board.dao.UserDao;
import com.example.board.dto.NaverUserInfo;
import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

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

    @Override
    public UserDto getUserDetail(String userid){
        return userDao.getSelectUserDetail(userid);
    }

    // 로그인 시간 설정 메서드
    @Override
    public void setLoginTime(String userid) {
        userDao.setLoginTime(userid);
    }

    // 로그인 실패 횟수 증가 메서드
    @Override
    public void increaseLoginFailCount(String userid) {
        userDao.increaseLoginFailCount(userid);
    }

    // 로그인 실패 횟수 초기화 메서드
    @Override
    public void resetLoginFailCount(String userid) {
        userDao.resetLoginFailCount(userid);
    }

    // 계정 잠금 메서드
    @Override
    public void lockAccount(String userid) {
        userDao.lockAccount(userid);
    }

    // 계정 잠금 해제 메서드
    @Override
    public void unlockAccount(String userid) {
        userDao.unlockAccount(userid);
    }

    // 수정화면
    @Override
    public int updateUser(UserDto userDto){
        return userDao.update(userDto);
    }
    @Override
    @Transactional
    public void deleteUser(String userId) {

        userDao.updateWriterToNull(userId);
        userDao.deleteUser(userId);
    }

    @Override
    public String findIdByNameAndEmail(String name, String email) {
        return userDao.findIdByNameAndEmail(name, email);
    }

    @Override
    public boolean checkUserForPw(String userid, String email) {
        return userDao.checkUser(userid, email) > 0;
    }

    @Override
    public String createTemporaryPassword(String userid) {
        String tempPw = generateTempPassword(); // 임시 비밀번호 생성
        userDao.updatePassword(userid, tempPw); // 비밀번호 업데이트
        // 이메일 발송 로직은 필요시 여기에 작성
        return tempPw;
    }

    private String generateTempPassword() {
        // 간단한 임시 비밀번호 생성 로직 (예: 8자리 무작위 문자열)
        return UUID.randomUUID().toString().substring(0, 8);
    }

    @Override
    public NaverUserInfo findOrCreateNaverUser(NaverUserInfo user) {
        NaverUserInfo existing = userDao.findByNaverId(user.getNaverId());

        if (existing == null) {
            userDao.insertNaverUser(user);
            return user;
        }
        return existing;
    }
}
