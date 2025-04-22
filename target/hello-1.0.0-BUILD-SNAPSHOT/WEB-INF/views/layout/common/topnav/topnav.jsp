<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<!-- 로그인된 사용자 정보 확인 -->
<c:set var="loginId" value="${pageContext.request.getSession(false) != null && pageContext.request.session.getAttribute('userid') != null ? pageContext.request.session.getAttribute('userid') : ''}"/>
<c:set var="loginName" value="${pageContext.request.getSession(false) != null && pageContext.request.session.getAttribute('name') != null ? pageContext.request.session.getAttribute('name') : ''}"/>
<c:set var="loginOutLink" value="${loginId == '' ? '/login' : ''}"/>
<c:set var="logout" value="${loginId == '' ? 'Login' : loginName}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>전체 화면 네비게이션</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container-fluid {
            display: flex;
            flex-direction: column;
            height: 100%;
            padding: 0px;
        }

        .navbar {
            z-index: 1;
        }

        .custom-navbar {
            background-color: #343a40;
            height: 60px;
            padding-left: 15px;
            padding-right: 15px;
        }

        .custom-navbar .navbar-brand {
            font-size: 20px;
            font-weight: bold;
            color: #fff;
        }

        .custom-search {
            width: 30% !important;
            max-width: 300px;
            margin: 0 auto;
        }

        .navbar-nav .nav-link {
            color: #fff !important;
        }
    </style>
</head>
<body>


    <!-- 네비게이션 바 -->
    <nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0 custom-navbar">
        <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="/">홈</a>
        <input class="form-control form-control-dark w-100 custom-search" type="text" placeholder="Search"
               aria-label="Search">
        <ul class="navbar-nav px-3 flex-row">
            <li class="nav-item text-nowrap ml-3">
                <a class="nav-link"  href="<c:url value='${loginOutLink}'/>">${loginId == '' ? '로그인' : loginName}</a>
            </li>
            <c:if test="${not empty loginId}">
                <li class="nav-item text-nowrap ml-3">
                    <form action="<c:url value='/logout'/>" method="post">
                        <button type="submit" class="nav-link btn btn-link" style="color: #fff; border: none; background: none;">
                            로그아웃
                        </button>
                    </form>
                </li>
            </c:if>
            <c:if test="${empty loginId}">
                <li class="nav-item text-nowrap ml-3">
                    <a class="nav-link" href="<c:url value='/member/register'/>">회원가입</a>
                </li>
            </c:if>
        </ul>
    </nav>


<script>
    document.addEventListener("DOMContentLoaded", function () {
        const logoutForm = document.querySelector("form[action='/logout']");

        if (logoutForm) {
            logoutForm.addEventListener("submit", function (e) {
                e.preventDefault();

                fetch("/api/logout", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.redirectUrl) {
                            window.location.href = data.redirectUrl;
                        } else {
                            alert("로그아웃 실패");
                        }
                    })
                    .catch(error => {
                        console.error("로그아웃 오류:", error);
                        alert("오류 발생");
                    });
            });
        }
    });

</script>

<!-- Bootstrap JavaScript 포함 -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
</body>
</html>
