package com.example.board.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class BoardDto {

    private Integer bno;
    private String title;
    private String content;
    private String writer;
    private String guestWriter;
    private String passwd;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regDate;
    private int viewCount;
    private String nickName;
    private String isPrivate;

    public String getFormattedRegDate() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return regDate != null ? regDate.format(formatter) : "";
    }
}
