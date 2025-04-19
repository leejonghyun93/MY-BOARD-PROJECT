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
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="/docs/4.0/assets/img/favicons/favicon.ico">

    <title>게시판 목록</title>

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
        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
            <div class="container mt-5">
                <h2 class="mb-4">회원 목록</h2>
                <div class="table-responsive">
                    <table class="table table-hover align-middle text-center" style="background-color: white;">
                        <colgroup>
                            <col style="width: 30px;"> <!-- 체크박스 -->
                            <col style="width: 50px;">
                            <col style="width: 100px;">
                            <col style="width: 60px;">
                            <col style="width: 60px;">
                            <col style="width: 180px;">
<%--                            <col style="width: 120px;">--%>
<%--                            <col style="width: 150px;">--%>
                            <col style="width: 150px;">
                            <col style="width: 180px;">
                            <col style="width: 120px;">
<%--                            <col style="width: 120px;">--%>
<%--                            <col style="width: 120px;">--%>
                        </colgroup>
                        <thead style="background-color: #f2f2f2;">
<%--                            <th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"></th>--%>
<%--                            <th>번호</th>--%>
<%--                            <th>아이디</th>--%>
<%--                            <th>이름</th>--%>
<%--                            <th>나이</th>--%>
<%--                            <th>이메일</th>--%>
<%--                            <th>전화번호</th>--%>
<%--                            <th>주소</th>--%>
<%--                            <th>상세주소</th>--%>
<%--                            <th>전체주소</th>--%>
<%--                            <th>로그인 시간</th>--%>
<%--                            <th>가입일</th>--%>
<%--                            <th>수정일</th>--%>
                        <tr>
                            <th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"></th>
                            <th onclick="sortTable(1)">번호 ▲▼</th>
                            <th onclick="sortTable(2)">아이디 ▲▼</th>
                            <th onclick="sortTable(3)">이름 ▲▼</th>
                            <th>나이</th>
                            <th>이메일</th>
                            <th>전화번호</th>
                            <th>전체주소</th>
                            <th>로그인 시간</th>
                        </tr>

                        </thead>
                        <tbody>
                        <c:forEach var="user" items="${memberList}" varStatus="status">
                            <tr>
                                <td><input type="checkbox" name="userCheck" value="${user.userid}"></td>
                                <td>${(currentPage - 1) * pageSize + status.index + 1}</td>
                                <td>${user.userid}</td>
                                <td>${user.name}</td>
                                <td>${user.age}</td>
                                <td>${user.email}</td>
                                <td>${user.phone}</td>
<%--                                <td>${user.address}</td>--%>
<%--                                <td>${user.detailAddress}</td>--%>
                                <td>${user.fullAddress}</td>
                                <td>${user.loginTime}</td>
<%--                                <td>${user.regDate}</td>--%>
<%--                                <td>${user.updateDate}</td>--%>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>


                    <!-- 페이징 영역 -->
                    <%@ include file="/WEB-INF/views/layout/page/page.jsp" %>

                </div>
            </div>
        </main>
    </div>
</div>
</body>

<!-- Daum 우편번호 서비스 -->


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
</html>
