<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page session="false" %>

<c:set var="loginId" value="${sessionScope.userid != null ? sessionScope.userid : ''}"/>
<c:set var="loginName" value="${sessionScope.name != null ? sessionScope.name : ''}"/>
<c:set var="loginOutLink" value="${loginId == '' ? '/login' : ''}"/>
<c:set var="logout" value="${loginId == '' ? 'Login' : loginName}"/>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세정보</title>
<%--    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">--%>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function() {

            const editButton = document.getElementById("editButton");
            if (editButton) {
                const loginId = editButton.getAttribute("data-login-id");
                const writer = editButton.getAttribute("data-writer");

                editButton.addEventListener("click", function (event) {
                    if (loginId !== writer) {
                        event.preventDefault();
                        alert("작성자 본인만 수정할 수 있습니다.");
                    }
                });
            }
        });
    </script>

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
            padding-bottom: 40px;
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
            background-color: #f1f3f5;
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
                <div id="detailBoardFragment">
                    <h4>📝 게시글 정보</h4>
                    <table class="table table-hover align-middle text-center" style="background-color: white;">
                        <tr>
                            <th>글번호</th>
                            <td>${board.bno}</td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td>${fn:escapeXml(board.title)}</td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td>${fn:escapeXml(board.content)}</td>
                        </tr>
                        <tr>
                            <th>작성자</th>
                            <td>${board.writer}</td>
                        </tr>
                        <tr>
                            <th>작성일</th>
                            <td>${board.formatLocalDateTime(board.regDate)}</td>
                        </tr>
                        <tr>
                            <th>조회수</th>
                            <td><c:out value="${board.viewCount}"/></td>
                        </tr>
                    </table>

                    <div class="d-flex justify-content-start gap-2 mt-4">
                        <!-- 목록 버튼 -->
                        <a href="/boardList" class="btn btn-secondary mr-2">목록</a>

                        <!-- 수정 버튼 -->
                        <form method="get" action="/board/editForm" class="d-inline">
                            <input type="hidden" name="bno" value="${board.bno}"/>
                            <input type="submit" value="수정" class="btn btn-primary"
                                   id="editButton"
                                   data-login-id="${loginId}" data-writer="${board.writer}"/>
                        </form>
                    </div>

                    <form method="post" action="/board/delete" id="deleteForm">
                        <input type="hidden" name="bno" value="${board.bno}" />
                        <input type="hidden" name="writer" value="${board.writer}" />
                        <div class="form-group mt-2">
                            <label for="passwd">비밀번호 확인:</label>
                            <input type="password" class="form-control" id="passwd" name="passwd" required />
                        </div>
                        <input type="submit" value="삭제" class="btn btn-danger mt-2"
                               onclick="return confirm('정말 삭제하시겠습니까?');"/>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>
<script>
    const msg = "${msg}";
    if (msg !== "") {
        alert(msg);
    }
</script>

</body>
</html>
