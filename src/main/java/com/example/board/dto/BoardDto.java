package com.example.board.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;


@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class BoardDto {

    private Integer bno;
    private String title;
    private String content;
    private String writer;
    private String passwd;
    private String regDate;
    private int viewCount;
}
