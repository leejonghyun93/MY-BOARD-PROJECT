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

    private final String CLIENT_ID = "개인정보";
    private final String CLIENT_SECRET = "개인정보";
    private final String REDIRECT_URI = "http://localhost:8088/naverLogin.do";

    @RequestMapping("/naverLogin.do")
    public String naverCallback(@RequestParam("code") String code,
                                @RequestParam("state") String state,
                                HttpSession session, Model model) throws Exception {

        // 1. AccessToken 받기
        String accessToken = getAccessToken(code, state);

        // 2. 사용자 정보 가져오기
        NaverUserInfo userInfo = getUserInfo(accessToken);

        // 3. DB 저장 or 로그인 처리
        NaverUserInfo result = userService.findOrCreateNaverUser(userInfo);

        // 4. 세션 저장naverId
        session.setAttribute("loginUser", result);
        session.setAttribute("name", result.getName());
        session.setAttribute("email", result.getEmail());
        session.setAttribute("userid", result.getNaverId());

//        System.out.println("세션 확인 - userid: " + session.getAttribute("userid"));
//        System.out.println("세션 확인 - name: " + session.getAttribute("name"));
//        System.out.println("세션 확인 - email: " + session.getAttribute("email"));
        System.out.println("세션 확인 - name: " + session.getAttribute("loginUser"));
        return "redirect:/"; // 메인 페이지로 이동
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
        StringBuilder response = new StringBuilder();
        String inputLine;
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

        // 네이버 API 응답 읽기
        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
        StringBuilder response = new StringBuilder();
        String inputLine;
        while ((inputLine = br.readLine()) != null) {
            response.append(inputLine);
        }
        br.close();

        // 응답을 콘솔에 출력하여 확인하기
        System.out.println("네이버 API 응답: " + response.toString());

        // 응답 JSON 파싱
        JSONObject responseObject = new JSONObject(response.toString()).getJSONObject("response");

        // 필요한 정보 추출
        String email = responseObject.has("email") ? responseObject.getString("email") : null;
        String id = responseObject.getString("id");
        String name = responseObject.getString("name");

        // 디버깅용으로 id, email, name을 출력
        System.out.println("id: " + id);
        System.out.println("email: " + email);
        System.out.println("name: " + name);

        return new NaverUserInfo(id, email, name);
    }
}