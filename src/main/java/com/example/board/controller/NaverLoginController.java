package com.example.board.controller;

import com.example.board.dto.NaverUserInfo;
import com.example.board.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.net.URLEncoder;
import java.util.Map;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
@Controller
public class NaverLoginController {

    @Autowired
    private UserService userService;



    @RequestMapping("/naverLogin.do")
    public String naverCallback(@RequestParam("code") String code,
                                @RequestParam("state") String state,
                                HttpSession session, Model model) throws Exception {
        String accessToken = getAccessToken(code, state);
        NaverUserInfo userInfo = getUserInfo(accessToken);

        // 회원 DB 등록 or 로그인 처리
        NaverUserInfo result = userService.findOrCreateNaverUser(userInfo);
        session.setAttribute("loginUser", result);
//        session.setAttribute("userid", result.getUserid());
        session.setAttribute("name", result.getName());
        return "redirect:/"; // 메인으로 이동
    }

    private String getAccessToken(String code, String state) throws Exception {
        String apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code"
                + "&client_id=" + CLIENT_ID
                + "&client_secret=" + CLIENT_SECRET
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&code=" + code
                + "&state=" + state;

        URL url = new URL(apiURL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");

        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();
        while ((inputLine = br.readLine()) != null) {
            response.append(inputLine);
        }
        br.close();

        JSONObject json = new JSONObject(response.toString());
        return json.getString("access_token");
    }
    private NaverUserInfo getUserInfo(String accessToken) throws Exception {
        String apiURL = "https://openapi.naver.com/v1/nid/me";

        URL url = new URL(apiURL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("Authorization", "Bearer " + accessToken);

        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();
        while ((inputLine = br.readLine()) != null) {
            response.append(inputLine);
        }
        br.close();
        String jsonResponse = response.toString();

        // JSON 파싱 (네이버 API에서 응답 형식은 { "response" : {...} })
        JSONObject jsonObject = new JSONObject(jsonResponse);
        JSONObject responseObject = jsonObject.getJSONObject("response");

        // 이메일이 있는지 체크 후 값 가져오기
        String email = responseObject.has("email") ? responseObject.getString("email") : null;

        String naverId = responseObject.getString("id");
        String name = responseObject.getString("name");

        // NaverUserInfo 객체 생성 후 반환
        return new NaverUserInfo(naverId, email, name);
    }
}