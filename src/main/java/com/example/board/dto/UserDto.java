package com.example.board.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;
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
    private String loginTime;
    private String address;
    private String detailAddress;
    private String fullAddress;
    private String phone;
    private String email;
    private String regDate;
    private String updateDate;

    public boolean isValid() {
        return userid != null && !userid.trim().isEmpty();
    }

    public boolean isDuplicate(List<UserDto> memberList) {
        if (userid == null || userid.trim().isEmpty()) return false;

        return memberList.stream()
                .anyMatch(m -> userid.equals(m.getUserid()));
    }

}
