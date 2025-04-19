<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<c:set var="loginId" value="${sessionScope.userid != null ? sessionScope.userid : ''}"/>
<c:set var="loginName" value="${sessionScope.name != null ? sessionScope.name : ''}"/>
<c:set var="loginOutLink" value="${loginId == '' ? '/login' : ''}"/>
<c:set var="logout" value="${loginId == '' ? 'Login' : loginName}"/>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>회원 상세보기</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link href="dashboard.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 8px 12px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f4f4f4;
        }
        .btn {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/layout/common/header/header.jsp" %>
<%@ include file="/WEB-INF/views/layout/common/topnav/topnav.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/WEB-INF/views/layout/common/sidebar/sidebar.jsp" %>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
            <div class="container mt-5" id="content-area">
                <h2>회원 상세보기</h2>

                <!-- 회원 정보 테이블 -->
                <table>
                    <tr>
                        <th>아이디</th>
                        <td>${member.userid}</td>
                    </tr>
                    <tr>
                        <th>비밀번호</th>
                        <td>${member.passwd}</td>
                    </tr>
                    <tr>
                        <th>이름</th>
                        <td>${member.name}</td>
                    </tr>
                    <tr>
                        <th>나이</th>
                        <td>${member.age}</td>
                    </tr>
                    <tr>
                        <th>로그인 시간</th>
                        <td>${member.loginTime}</td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td>${member.address}</td>
                    </tr>
                    <tr>
                        <th>상세 주소</th>
                        <td>${member.detailAddress}</td>
                    </tr>
                    <tr>
                        <th>전체 주소</th>
                        <td>${member.fullAddress}</td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td>${member.phone}</td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td>${member.email}</td>
                    </tr>
                    <tr>
                        <th>등록일</th>
                        <td>${member.regDate}</td>
                    </tr>
                    <tr>
                        <th>수정일</th>
                        <td>${member.updateDate}</td>
                    </tr>
                </table>

                <!-- 수정 버튼 (수정 페이지로 이동) -->
                <a href="editMember?id=${member.userid}">
                    <button class="btn">회원 정보 수정</button>
                </a>

                <!-- 목록으로 돌아가기 버튼 -->
                <a href="memberList">
                    <button class="btn">회원 목록으로</button>
                </a>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>
</body>
</html>
