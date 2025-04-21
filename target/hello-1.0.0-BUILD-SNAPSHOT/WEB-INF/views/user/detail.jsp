<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<c:set var="loginId" value="${sessionScope.userid != null ? sessionScope.userid : ''}"/>
<c:set var="loginName" value="${sessionScope.name != null ? sessionScope.name : ''}"/>
<c:set var="loginOutLink" value="${loginId == '' ? '/login' : ''}"/>
<c:set var="logout" value="${loginId == '' ? 'Login' : loginName}"/>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>회원 상세정보</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">

    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        .container-fluid {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .row {
            flex: 1;
            display: flex;
            flex-direction: row;
        }

        main {
            flex: 1;
            background-color: #fff;
            padding-bottom: 40px; /* 여유 공간 */
        }

        footer {
            flex-shrink: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 16px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            border: 1px solid #ccc;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 14px 18px;
            text-align: left;
            vertical-align: middle;
        }

        th {
            background-color: #f1f3f5; /* 밝은 회색 */
            font-weight: 600;
            color: #333;
            width: 20%;
        }

        td {
            background-color: #fff;
            color: #222;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/layout/common/header/header.jsp" %>
<%@ include file="/WEB-INF/views/layout/common/topnav/topnav.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/WEB-INF/views/layout/common/sidebar/sidebar.jsp" %>

        <main class="col-md-9 ml-sm-auto col-lg-10 px-4">
            <div class="container mt-5" id="content-area">
                <div id="detailFragment">
                    <h4>👤 회원 상세 정보</h4>
                    <table class="table table-hover align-middle text-center" style="background-color: white;">
                        <tr>
                            <th>아이디</th>
                            <td>${user.userid}</td>
                        </tr>
                        <tr>
                            <th>이름</th>
                            <td>${user.name}</td>
                        </tr>
                        <tr>
                            <th>이메일</th>
                            <td>${user.email}</td>
                        </tr>
                        <tr>
                            <th>주소</th>
                            <td>${user.fullAddress}</td>
                        </tr>
                        <tr>
                            <th>로그인 시간</th>
                            <td>${user.loginTime}</td>
                        </tr>
                        <tr>
                            <th>나이</th>
                            <td>${user.age}</td>
                        </tr>
                        <tr>
                            <th>전화번호</th>
                            <td>${user.phone}</td>
                        </tr>
                        <tr>
                            <th>이메일</th>
                            <td>${user.email}</td>
                        </tr>
                    </table>
                    <form method="get" action="/user/editForm">
                        <input type="submit" value="수정" class="btn btn-primary"/>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const editButton = document.getElementById("editButton");

        if (editButton) {
            editButton.addEventListener("click", function () {
                fetch("/user/editForm")
                    .then(response => {
                        if (!response.ok) {
                            throw new Error("HTTP error " + response.status);
                        }
                        return response.text();
                    })
                    .then(data => {
                        const contentArea = document.getElementById("content-area");
                        if (contentArea) {
                            contentArea.innerHTML = data;
                        } else {
                            console.warn("content-area 요소를 찾을 수 없음");
                        }
                    })
                    .catch(error => {
                        console.error("수정 폼을 불러오는 중 오류 발생:", error);
                    });
            });
        } else {
            console.warn("editButton 요소를 찾을 수 없습니다.");
        }
    });
</script>
</body>
</html>
