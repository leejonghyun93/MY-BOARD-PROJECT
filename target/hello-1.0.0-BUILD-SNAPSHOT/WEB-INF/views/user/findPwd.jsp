<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>비밀번호 찾기</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
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
                    <form id="findPwForm" class="w-50 mx-auto border p-4 rounded shadow-sm bg-light">
                        <h4 class="mb-4 text-center">비밀번호 찾기</h4>

                        <div class="form-group">
                            <label for="userid">아이디</label>
                            <input type="text" class="form-control" id="userid" name="userid" required placeholder="아이디를 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="email">이메일</label>
                            <input type="email" class="form-control" id="email" name="email" required placeholder="이메일을 입력하세요">
                        </div>

                        <button type="submit" class="btn btn-primary btn-block mt-4">비밀번호 찾기</button>

                        <div class="text-center mt-3">
                            <a href="/login">로그인</a> | <a href="/user/findId">아이디 찾기</a>
                        </div>

                        <div id="resultMessage" class="mt-4 text-center text-info font-weight-bold"></div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>

<script>
    document.getElementById('findPwForm').addEventListener('submit', function (event) {
        event.preventDefault();

        const userid = document.getElementById('userid').value.trim();
        const email = document.getElementById('email').value.trim();

        fetch('/api/user/findPw', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ userid: userid, email: email })
        })
            .then(response => response.json())
            .then(data => {
                const resultDiv = document.getElementById('resultMessage');
                if (data.success) {
                    resultDiv.textContent = '임시 비밀번호가 이메일로 전송되었습니다.';
                    resultDiv.classList.remove('text-danger');
                    resultDiv.classList.add('text-info');
                } else {
                    resultDiv.textContent = '일치하는 회원 정보가 없습니다.';
                    resultDiv.classList.remove('text-info');
                    resultDiv.classList.add('text-danger');
                }
            })
            .catch(error => {
                console.error('오류 발생:', error);
                document.getElementById('resultMessage').textContent = '서버 오류가 발생했습니다.';
            });
    });
</script>
</body>
</html>
