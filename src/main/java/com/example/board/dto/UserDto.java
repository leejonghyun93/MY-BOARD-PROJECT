package com.example.board.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;


@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class UserDto {

    private String userid;
    private String passwd;
    private String name;
    private int age;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime loginTime;
    private String address;
    private String detailAddress;
    private String fullAddress;
    private String phone;
    private String email;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regDate;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateDate;
    private String role;

    // 로그인 실패 횟수 추가
    private int loginFailCount;

    // 계정 잠금 여부 추가
    private int  accountLocked;

    public boolean isAccountLocked() {
        return accountLocked == 1;
    }


    public boolean isValid() {
        return userid != null && !userid.trim().isEmpty();
    }

    public boolean isDuplicate(List<UserDto> memberList) {
        if (userid == null || userid.trim().isEmpty()) return false;

        return memberList.stream()
                .anyMatch(m -> userid.equals(m.getUserid()));
    }

    public String formatLocalDateTime(LocalDateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return dateTime != null ? dateTime.format(formatter) : "";
    }

    // regDate 포맷팅 메서드
    public String getFormattedRegDate() {
        return formatLocalDateTime(regDate);
    }

    // updateDate 포맷팅 메서드
    public String getFormattedUpdateDate() {
        return formatLocalDateTime(updateDate);
    }

    // loginTime 포맷팅 메서드
    public String getFormattedLoginTime() {
        return formatLocalDateTime(loginTime);
    }

}
