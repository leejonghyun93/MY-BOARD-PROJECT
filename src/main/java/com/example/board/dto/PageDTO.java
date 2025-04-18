package com.example.board.dto;

import lombok.Data;
import lombok.ToString;

import java.util.List;

@Data
@ToString
public class PageDTO<T> {
    private int page;           // 현재 페이지
    private int pageSize;       // 페이지당 항목 수
    private int totalCount;     // 전체 항목 수
    private int totalPage;      // 전체 페이지 수
    private int startRow;       // SQL LIMIT 시작 위치

    private int startPage;      // 보여줄 시작 페이지 번호
    private int endPage;        // 보여줄 끝 페이지 번호
    private final int pageBlock = 5; // 페이지 네비게이션에 표시할 페이지 수

    private String searchValue;

    private List<T> dataList;   // 실제 페이지 데이터 목록 (제네릭)

    public PageDTO(int page, int totalCount, int pageSize, String searchValue, List<T> dataList) {
        this.page = Math.max(1, page);
        this.totalCount = totalCount;
        this.pageSize = pageSize;
        this.searchValue = searchValue;
        this.dataList = dataList;

        // 전체 페이지 수 계산
        this.totalPage = (totalCount > 0) ? (int) Math.ceil((double) totalCount / pageSize) : 1;
        this.page = Math.min(this.page, this.totalPage); // 페이지 수 초과 방지
        this.startRow = (this.page - 1) * pageSize;

        // 페이지 블록 계산
        this.startPage = ((this.page - 1) / pageBlock) * pageBlock + 1;
        this.endPage = Math.min(startPage + pageBlock - 1, totalPage);
    }
}
