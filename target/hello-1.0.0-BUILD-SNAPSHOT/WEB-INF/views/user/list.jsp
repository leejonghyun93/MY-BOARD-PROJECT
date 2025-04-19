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
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>회원 목록</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link href="dashboard.css" rel="stylesheet">

    <style>
        table.table {
            table-layout: fixed;
            width: 100%;
        }
        .col-check { width: 30px; }
        .col-num { width: 60px; }
        .col-id { width: 80px; }
        .col-name { width: 60px; }
        .col-email { width: 150px; }
        .col-address { width: 200px; }
        .col-login-time { width: 120px; }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/layout/common/header/header.jsp" %>
<%@ include file="/WEB-INF/views/layout/common/topnav/topnav.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/WEB-INF/views/layout/common/sidebar/sidebar.jsp" %>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
            <div class="container mt-5" id="content-area"> <%-- ★ 여기 추가 --%>
                <h2 class="mb-4">회원 목록</h2>
                <div class="table-responsive">
                    <table class="table table-hover align-middle text-center" style="background-color: white;">
                        <colgroup>
                            <col class="col-check">
                            <col class="col-num">
                            <col class="col-id">
                            <col class="col-name">
                            <col class="col-email">
                            <col class="col-address">
                            <col class="col-login-time">
                        </colgroup>
                        <thead style="background-color: #f2f2f2;">
                        <tr>
                            <th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"></th>
                            <th onclick="sortTable(1)">번호 ▲▼</th>
                            <th onclick="sortTable(2)">아이디 ▲▼</th>
                            <th onclick="sortTable(3)">이름 ▲▼</th>
                            <th>이메일</th>
                            <th>전체주소</th>
                            <th>로그인 시간</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="user" items="${memberList}" varStatus="status">
                            <tr>
                                <td><input type="checkbox" name="userCheck" value="${user.userid}"></td>
                                <td>${(pageDTO.page - 1) * pageDTO.pageSize + status.index + 1}</td>
                                <td>${user.userid}</td>
                                <td>${user.name}</td>
                                <td>${user.email}</td>
                                <td>${user.fullAddress}</td>
                                <td>${user.loginTime}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <%@ include file="/WEB-INF/views/layout/page/page.jsp" %>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>

<script>
    function toggleAll(source) {
        const checkboxes = document.getElementsByName('userCheck');
        for (let i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = source.checked;
        }
    }

    let sortDirection = {}; // 각 컬럼별 정렬 방향 저장

    function sortTable(columnIndex) {
        const table = document.querySelector("table");
        const tbody = table.querySelector("tbody");
        const rows = Array.from(tbody.rows);

        // 정렬 방향 설정 (기본은 오름차순)
        sortDirection[columnIndex] = !sortDirection[columnIndex];

        rows.sort((a, b) => {
            const aText = a.cells[columnIndex].innerText.trim();
            const bText = b.cells[columnIndex].innerText.trim();

            // 숫자 정렬 여부 확인
            const isNumeric = !isNaN(aText) && !isNaN(bText);

            if (isNumeric) {
                return sortDirection[columnIndex]
                    ? aText - bText
                    : bText - aText;
            } else {
                return sortDirection[columnIndex]
                    ? aText.localeCompare(bText)
                    : bText.localeCompare(aText);
            }
        });

        // 정렬된 row를 다시 tbody에 붙이기
        rows.forEach(row => tbody.appendChild(row));
    }
</script>

</body>
</html>
