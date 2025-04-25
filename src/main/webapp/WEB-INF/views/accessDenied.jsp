<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>접근 거부</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
        }
        .message {
            background-color: #f44336;
            color: white;
            padding: 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="message">
    <h2>접근 거부</h2>
    <p>관리자만 접근할 수 있는 페이지입니다.</p>
    <p><a href="/">홈페이지로 돌아가기</a></p>
</div>
</body>
</html>