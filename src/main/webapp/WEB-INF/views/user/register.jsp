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
            <div class="mt-5">
                <div class="container mt-5">
                    <div class="row justify-content-center">
                        <div class="col-md-6 col-lg-5">
                            <h2 class="text-center mb-4">회원가입</h2>
                            <form action="/member/register" method="post" onsubmit="return showAlert()"
                                  id="registerForm">
                                <div class="form-group">
                                    <label for="userid">아이디</label>
                                    <div class="input-group">
                                        <input type="text" id="userid" name="userid" class="form-control" required
                                               placeholder="아이디를 입력하세요">
                                        <div class="input-group-append">
                                            <button type="button" id="validUserid" class="btn btn-outline-secondary">
                                                중복 확인
                                            </button>
                                        </div>
                                        <c:if test="${not empty errorMessage}">
                                            <div class="text-danger mt-2" style="font-size: 0.9em;">
                                                    ${errorMessage}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="userPwd">비밀번호</label>
                                    <input type="password" id="userPwd" name="userPwd" class="form-control" required
                                           placeholder="비밀번호를 입력하세요">
                                </div>

                                <div class="form-group">
                                    <label for="confirmPwd">비밀번호 확인</label>
                                    <input type="password" id="confirmPwd" name="confirmPwd" class="form-control"
                                           required
                                           placeholder="비밀번호 확인을 입력하세요">
                                </div>

                                <div class="form-group">
                                    <label for="userName">이름</label>
                                    <input type="text" id="userName" name="userName" class="form-control" required
                                           placeholder="이름을 입력하세요">
                                </div>
                                <div class="form-group">
                                    <label for="age">나이</label>
                                    <input type="number" id="age" name="age" class="form-control" required
                                           placeholder="나이를 입력하세요">
                                </div>
                                <div class="form-group">
                                    <label for="userAddress">주소</label>
                                    <div class="input-group">
                                        <input type="text" id="userAddress" name="userAddress" class="form-control"
                                               required
                                               placeholder="주소를 입력하세요" readonly>
                                        <div class="input-group-append">
                                            <button type="button" onclick="execDaumPostcode()"
                                                    class="btn btn-outline-secondary">주소 찾기
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="detailAddress">나머지 주소</label>
                                    <input type="text" id="detailAddress" name="detailAddress" class="form-control"
                                           placeholder="나머지 주소를 입력하세요">
                                </div>

                                <input type="hidden" id="fullAddress" name="fullAddress">

                                <div class="form-group">
                                    <label for="userPhone">전화번호</label>
                                    <input type="text" id="userPhone" name="userPhone" class="form-control" required
                                           placeholder="전화번호를 입력하세요">
                                </div>

                                <div class="form-group">
                                    <label for="userEmail">이메일</label>
                                    <input type="email" id="userEmail" name="userEmail" class="form-control" required
                                           placeholder="이메일을 입력하세요">
                                </div>

                                <button type="submit" class="btn btn-primary btn-block">회원가입</button>
                            </form>

                            <div class="login-link text-center mt-3">
                                <p>이미 계정이 있으신가요? <a href="<c:url value='/login' />">로그인</a></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
</body>

<!-- Daum 우편번호 서비스 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
    let isUseridChecked = false;
    const idPattern = /^.{8,}$/; // 아이디는 8자 이상
    const passwordPattern = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$/; // 비밀번호는 영문, 숫자, 특수문자 포함 8자 이상

    document.querySelector("#validUserid").addEventListener("click", function () {
        const userid = document.querySelector("#userid").value.trim();
        console.log("입력한 아이디:", userid);
        if (!userid) {
            alert("아이디를 입력해주세요.");
            return;
        }

        fetch('/api/member/checkUserid?userid=' + userid)
            .then(res => res.json())
            .then(data => {
                if (data.available === true) {
                    alert("사용 가능한 아이디입니다.");
                    isUseridChecked = true;
                } else {
                    alert("이미 존재하는 아이디입니다.");
                    isUseridChecked = false;
                }
            })
            .catch(err => {
                console.error("에러 발생:", err);
                alert("중복 확인 중 오류가 발생했습니다.");
            });
    });

    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('registerForm').addEventListener('submit', function (e) {
            e.preventDefault(); // 기본 제출 막기
            combineAddress();

            const username = document.getElementById('userid').value.trim();
            const password = document.getElementById('userPwd').value.trim();
            const confirmPassword = document.getElementById('confirmPwd').value.trim();
            const email = document.getElementById('userEmail').value.trim();
            const phone = document.getElementById('userPhone').value.trim();
            const userAddress = document.getElementById('userAddress').value.trim();
            const detailAddress = document.getElementById('detailAddress').value.trim();
            const age = document.getElementById('age').value.trim();

            // 유효성 검사
            if (age === "" || isNaN(age) || parseInt(age) <= 0) {
                alert("나이를 올바르게 입력해주세요.");
                return false;
            }
            if (username === "") {
                alert("아이디를 입력해주세요.");
                return false;
            }
            if (!idPattern.test(username)) {
                alert("아이디는 최소 8자 이상이어야 합니다.");
                return false;
            }

            if (!passwordPattern.test(password)) {
                alert("비밀번호는 최소 8자 이상, 영문/숫자/특수문자를 포함해야 합니다.");
                return false;
            }
            if (password === "") {
                alert("비밀번호를 입력해주세요.");
                return false;
            }

            if (confirmPassword === "") {
                alert("비밀번호 확인을 입력해주세요.");
                return false;
            }
            if (userAddress === "") {
                alert("주소를 입력해주세요.");
                return false;
            }
            if (detailAddress === "") {
                alert("상세주소를 입력해주세요.");
                return false;
            }
            if (password !== confirmPassword) {
                alert("비밀번호가 일치하지 않습니다.");
                return false;
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert("이메일 주소가 유효하지 않습니다.");
                return false;
            }

            const phoneRegex = /^[0-9]+$/;
            if (!phoneRegex.test(phone)) {
                alert("전화번호는 숫자만 입력할 수 있습니다.");
                return false;
            }

            // 서버로 데이터 전송
            const userData = {
                userid: document.getElementById('userid').value,
                passwd: document.getElementById('userPwd').value,
                name: document.getElementById('userName').value,
                age: parseInt(document.getElementById('age').value),
                address: document.getElementById('userAddress').value,
                detailAddress: document.getElementById('detailAddress').value,
                fullAddress: document.getElementById('fullAddress').value,
                phone: document.getElementById('userPhone').value,
                email: document.getElementById('userEmail').value
            };

            fetch('/api/member/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(userData)
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        window.location.href = data.redirectUrl;
                    } else {
                        alert(data.message);
                    }
                })
                .catch(err => {
                    alert("회원가입 중 오류가 발생했습니다.");
                    console.error(err);
                });
        });
    });

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                document.getElementById("userAddress").value = data.roadAddress || data.jibunAddress;
                combineAddress();
            }
        }).open();
    }

    function combineAddress() {
        const addr = document.getElementById("userAddress").value;
        const detail = document.getElementById("detailAddress").value;
        document.getElementById("fullAddress").value = addr + " " + detail;
    }

    document.getElementById("userAddress").addEventListener("input", combineAddress);
    document.getElementById("detailAddress").addEventListener("input", combineAddress);

</script>


<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>

</html>
