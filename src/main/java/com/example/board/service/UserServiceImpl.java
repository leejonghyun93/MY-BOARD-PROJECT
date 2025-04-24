package com.example.board.service;

import com.example.board.dao.UserDao;
import com.example.board.dto.NaverUserInfo;
import com.example.board.dto.PageDTO;
import com.example.board.dto.UserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class UserServiceImpl implements UserService  {

    @Autowired
    private UserDao userDao;

    @Autowired
    private PasswordEncoder passwordEncoder;

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
        // 1. 사용자 정보 조회
        UserDto member = userDao.getMember(userid);
        if (member == null) {
            System.out.println("존재하지 않는 아이디입니다.");
            return null;
        }

        // 2. 디버깅: 입력한 비밀번호와 DB에 저장된 비밀번호 출력
        System.out.println("입력된 비밀번호: " + passwd); // 평문 비밀번호
        System.out.println("DB에 저장된 암호화된 비밀번호: " + member.getPasswd());

        // 3. 비밀번호 일치 여부 확인
        boolean isMatch = passwordEncoder.matches(passwd, member.getPasswd());
        System.out.println("비밀번호 일치 여부: " + isMatch); // 비교 결과

        if (!isMatch) {
            // 로그인 실패 횟수 증가 및 계정 잠금 여부 처리
            userDao.increaseLoginFailCount(userid);
            UserDto updatedUser = userDao.getMember(userid);
            int failCount = updatedUser.getLoginFailCount();

            if (failCount >= 5) {
                userDao.lockAccount(userid);
                System.out.println("비밀번호 5회 오류로 계정이 잠겼습니다.");
            } else {
                System.out.println("비밀번호가 틀렸습니다. (" + failCount + "회 실패)");
            }

            return null;
        }

        // 로그인 성공: 로그인 시간 갱신
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
