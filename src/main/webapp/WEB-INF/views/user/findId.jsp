<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="/docs/4.0/assets/img/favicons/favicon.ico">

    <title>아이디 찾기</title>

    <link rel="canonical" href="https://getbootstrap.com/docs/4.0/examples/dashboard/">

    <!-- Bootstrap core CSS -->
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
                    <form id="findIdForm" class="w-50 mx-auto border p-4 rounded shadow-sm bg-light">
                        <h4 class="mb-4 text-center">아이디 찾기</h4>

                        <div class="form-group">
                            <label for="name">이름</label>
                            <input type="text" class="form-control" id="name" name="name" required placeholder="이름을 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="email">이메일</label>
                            <input type="email" class="form-control" id="email" name="email" required placeholder="이메일을 입력하세요">
                        </div>

                        <button type="submit" class="btn btn-primary btn-block mt-4">아이디 찾기</button>

                        <div class="text-center mt-3">
                            <a href="/login">로그인</a> | <a href="/user/findPw">비밀번호 찾기</a>
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
    document.getElementById('findIdForm').addEventListener('submit', function (event) {
        event.preventDefault(); // 기본 폼 제출 막기

        const name = document.getElementById('name').value.trim();
        const email = document.getElementById('email').value.trim();

        fetch('/api/user/findId', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ name: name, email: email })
        })
            .then(response => response.json())
            .then(data => {
                const resultDiv = document.getElementById('resultMessage');
                if (data.success) {
                    resultDiv.textContent = '당신의 아이디는: ' + data.userid;
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
