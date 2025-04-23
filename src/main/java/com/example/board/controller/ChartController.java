package com.example.board.controller;

import com.example.board.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/chart")
public class ChartController {

    @Autowired
    private BoardService boardService;

    @GetMapping("/boardRecent")
    @ResponseBody
    public List<Map<String, Object>> getChartData() {
        return boardService.getChartData();
    }

    @GetMapping("/boardPopularity")
    @ResponseBody
    public List<Map<String, Object>> getChartPopularity() {
        return boardService.getChartPopularity();
    }

    @GetMapping("/")
}