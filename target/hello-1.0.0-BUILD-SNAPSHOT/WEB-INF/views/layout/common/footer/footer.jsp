<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Sticky Footer</title>
    <style>
        html, body {
            height: 100%;
            margin: 0;
        }

        body {
            display: flex;
            flex-direction: column;
        }

        main {
            flex: 1;
        }

        footer {
            background-color: #343a40;
            color: white;
            padding: 1rem 0;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            text-align: center;
        }

        .row {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .col {
            flex: 1;
            min-width: 250px;
            margin: 1rem 0;
        }

        .col h5 {
            margin-bottom: 0.5rem;
        }

        .col ul {
            list-style: none;
            padding: 0;
        }

        .col ul li {
            margin-bottom: 0.5rem;
        }

        .col a {
            color: rgba(255, 255, 255, 0.6);
            text-decoration: none;
        }

        .col a:hover {
            color: white;
        }

        hr {
            border: 1px solid rgba(255, 255, 255, 0.2);
            margin: 2rem 0;
        }

        .copy {
            margin-bottom: 0;
        }
    </style>
</head>
<body>

<main>
    <!-- 여기에 본문 내용이 들어갑니다 -->
</main>

<footer>
    <div class="container">
        <div class="row">
            <div class="col">
                <h5>커뮤니티</h5>
                <p>고객을 위한 최고의 msa 커뮤니티 경험을 제공합니다.</p>
            </div>
            <div class="col">
                <h5>바로가기</h5>
                <ul>
                    <li><a href="/">홈</a></li>
                    <li><a href="/about">회사 소개</a></li>
                    <li><a href="/contact">문의하기</a></li>
                </ul>
            </div>
            <div class="col">
                <h5>고객센터</h5>
                <p>전화: 1234-5678</p>
                <p>이메일: msa@example.com</p>
            </div>
        </div>

        <hr>

        <p class="copy">&copy; 2025. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
