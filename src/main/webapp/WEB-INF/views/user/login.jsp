<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<c:set var="loginId" value="${pageContext.request.getSession(false) != null && pageContext.request.session.getAttribute('userid') != null ? pageContext.request.session.getAttribute('userid') : ''}"/>
<c:set var="loginName" value="${pageContext.request.getSession(false) != null && pageContext.request.session.getAttribute('name') != null ? pageContext.request.session.getAttribute('name') : ''}"/>
<c:set var="loginOutLink" value="${loginId == '' ? '/login' : ''}"/>
<c:set var="logout" value="${loginId == '' ? 'Login' : loginName}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="/docs/4.0/assets/img/favicons/favicon.ico">

    <title>로그인</title>

    <link rel="canonical" href="https://getbootstrap.com/docs/4.0/examples/dashboard/">

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">

    <!-- Custom styles for this template -->
    <link href="dashboard.css" rel="stylesheet">
</head>

<body>
<%@ include file="/WEB-INF/views/layout/common/header/header.jsp" %>
<%@ include file="/WEB-INF/views/layout/common/topnav/topnav.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/WEB-INF/views/layout/common/sidebar/sidebar.jsp" %>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <div class="mt-5">
                <div class="register-container container mt-5">
                    <form id="loginForm" class="w-50 mx-auto border p-4 rounded shadow-sm bg-light">
                        <h2 class="text-center mb-4">로그인</h2>

                        <div class="form-group">
                            <label for="userid">아이디</label>
                            <input type="text" class="form-control" id="userid" name="userid" placeholder="아이디를 입력하세요" required>
                        </div>

                        <div class="form-group mt-3">
                            <label for="passwd">비밀번호</label>
                            <input type="password" class="form-control" id="passwd" name="passwd" placeholder="비밀번호를 입력하세요" required>
                        </div>

                        <div id="errorMessage" class="text-danger text-center mt-2" style="display: none;"></div>

                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" class="btn btn-primary w-100">로그인</button>
                        </div>

                        <div class="text-center mt-3">
                            <a href="/user/findId" class="me-3">아이디 찾기</a>
                            <a href="/user/findPw" class="me-3">비밀번호 찾기</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>
<script>
    document.getElementById("loginForm").addEventListener("submit", function (e) {
        e.preventDefault();

        const userid = document.getElementById("userid").value.trim();
        const passwd = document.getElementById("passwd").value.trim();

        const formData = new URLSearchParams();
        formData.append('userid', userid);
        formData.append('passwd', passwd);

        fetch("api/login", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.redirectUrl) {
                    window.location.href = window.location.origin + data.redirectUrl;
                } else if (data.error) {
                    const errorDiv = document.getElementById("errorMessage");
                    errorDiv.style.display = "block";
                    errorDiv.textContent = data.error;
                }
            })
            .catch(error => {
                console.error("로그인 오류:", error);
                alert("로그인 처리 중 문제가 발생했습니다.");
            });
    });
</script>
</body>
</html>
