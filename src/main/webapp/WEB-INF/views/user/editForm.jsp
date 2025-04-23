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
    <title>회원 정보 수정</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .container {
           margin-top: 5%;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background-color: #f0f0f0;
            text-align: left;
            padding: 10px;
            width: 30%;
            border: 1px solid #ccc;
        }

        td {
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #fff;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="number"],
        input[type="password"] {
            width: 100%;
            padding: 8px 10px;
            box-sizing: border-box;
            border-radius: 5px;
            border: 1px solid #aaa;
        }

        button {
            margin-top: 20px;
            padding: 10px 30px;
            background-color: #007bff;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            display: block;
            margin-left: auto;
        }

        button:hover {
            background-color: #0056b3;
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
                <div class="container">
                    <h2>회원 정보 수정</h2>
                    <form id="editForm" method="post" action="/user/update">
                        <div class="form-group">
                            <label for="userid">아이디</label>
                            <input type="text" name="userid" id="userid" value="${user.userid}" readonly class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="userPwd">비밀번호</label>
                            <input type="password" name="userPwd" id= "userPwd" class="form-control" required placeholder="새로운 비밀번호를 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="confirmPwd">비밀번호 확인</label>
                            <input type="password" name="confirmPwd" id="confirmPwd" class="form-control" required placeholder="비밀번호를 다시 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="userName">이름</label>
                            <input type="text" name="name" id="userName"value="${user.name}" required class="form-control" placeholder="이름을 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="age">나이</label>
                            <input type="number" name="age" id="age" value="${user.age}" required class="form-control" placeholder="나이를 입력하세요">
                        </div>


                        <div class="form-group">
                            <label for="userAddress">주소</label>
                            <div class="input-group">
                                <input type="text" id="userAddress" name="userAddress" class="form-control"
                                       value="${user.fullAddress}" required placeholder="주소를 입력하세요" readonly>
                                <div class="input-group-append">
                                    <button type="button" onclick="execDaumPostcode()"
                                            class="btn btn-outline-secondary">주소 찾기
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="form-group" id="detailAddressGroup" style="display: none;">
                            <label for="detailAddress">나머지 주소</label>
                            <input type="text" id="detailAddress" name="detailAddress" class="form-control"
                                   placeholder="나머지 주소를 입력하세요">
                        </div>

                        <input type="hidden" id="fullAddress" name="fullAddress">

                        <div class="form-group">
                            <label for="userPhone">전화번호</label>
                            <input type="tel" name="phone" value="${user.phone}" id="userPhone"class="form-control" placeholder="전화번호를 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="userEmail">이메일</label>
                            <input type="email" name="email" value="${user.email}" id="userEmail" class="form-control" placeholder="이메일을 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="regDate">가입일</label>
                            <input type="text" name="regDate" value="${user.formatLocalDateTime(user.regDate)}" id="regDate" readonly class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="updateDate">수정일</label>
                            <input type="text" name="updateDate" value="${user.formatLocalDateTime(user.updateDate)}" id="updateDate" readonly class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="role">권한</label>
                            <input type="text" name="role" value="${user.role}" id="role"class="form-control" placeholder="사용자 권한을 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="loginFailCount">로그인 실패 횟수</label>
                            <input type="number" name="loginFailCount" id="loginFailCount" value="${user.loginFailCount}" readonly class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="accountLocked">계정 잠금 여부</label>
                            <input type="text" class="form-control" id="accountLocked" value="${user.accountLocked ? 'Y' : 'N'}" readonly>
                        </div>
                    </form>
                    <div class="d-flex justify-content-between">
                        <div>
                            <button type="submit" class="btn btn-primary">수정</button>
                        </div>
                        <div>
                            <a href="/memberList" class="btn btn-secondary">목록으로</a>
                            <a href="javascript:void(0);" class="btn btn-secondary" onclick="loadUserDetail('${user.userid}')">뒤로가기</a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>
</body>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
    const passwordPattern = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$/; // 비밀번호는 영문, 숫자, 특수문자 포함 8자 이상
    function loadUserDetail(userid) {
        fetch(`/detail/` + encodeURIComponent(userid), {
            method: 'GET',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        })
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newContentArea = doc.querySelector('#content-area');
                if (newContentArea) {
                    document.querySelector('#content-area').innerHTML = newContentArea.innerHTML;

                    // 주소창도 변경
                    history.pushState(null, '', `/detail/${userid}`);
                    currentUserId = userid; // 전역 변수 갱신
                }
            })
            .catch(error => {
                alert('사용자 정보를 불러오는 데 실패했습니다.');
                console.error('Error:', error);
            });
    }
    document.addEventListener('DOMContentLoaded', function () {
        function showAlert() {
            combineAddress();

            const password = document.getElementById('userPwd').value.trim();
            const confirmPassword = document.getElementById('confirmPwd').value.trim();
            const email = document.getElementById('userEmail').value.trim();
            const phone = document.getElementById('userPhone').value.trim();
            const userAddress = document.getElementById('userAddress').value.trim();
            const detailAddress = document.getElementById('detailAddress').value.trim();
            const age = document.getElementById('age').value.trim();

            if (age === "" || isNaN(age) || parseInt(age) <= 0) {
                alert("나이를 올바르게 입력해주세요.");
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

            alert("회원이 성공적으로 수정되었습니다.");
            return true;
        }

        document.getElementById('editForm').addEventListener('submit', function (e) {
            e.preventDefault(); // 기본 제출 막기
            combineAddress();

            const userData = {
                userid: document.getElementById('userid').value,
                passwd: document.getElementById('userPwd').value,
                name: document.getElementById('userName').value,
                age: parseInt(document.getElementById('age').value),
                address: document.getElementById('userAddress').value,
                detailAddress: document.getElementById('detailAddress').value,
                fullAddress: document.getElementById('fullAddress').value,
                phone: document.getElementById('userPhone').value,
                email: document.getElementById('userEmail').value,
                role : document.getElementById('role').value
            };

            fetch('/api/user/update', {
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
                    alert("수정 중 오류가 발생했습니다.");
                    console.error(err);
                });
        });

    });

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 도로명 주소나 지번 주소 선택에 따라 주소 결정
                var fullAddress = data.roadAddress ? data.roadAddress : data.jibunAddress;

                // 주소 입력창에 주소 넣기
                document.getElementById('userAddress').value = fullAddress;

                // 숨겨진 '나머지 주소' 입력창 보이게 하기
                document.getElementById('detailAddressGroup').style.display = 'block';

                // 커서를 '나머지 주소' 입력란으로 자동 이동
                document.getElementById('detailAddress').focus();
            }
        }).open();
    }
    function combineAddress() {
        const address = document.getElementById("userAddress").value;
        const detail = document.getElementById("detailAddress").value;
        document.getElementById("fullAddress").value = address + " " + detail;
    }
    function updateFullAddress() {
        const address = document.getElementById("userAddress").value;
        const detail = document.getElementById("detailAddress").value;

        document.getElementById("fullAddress").value = address + " " + detail;
    }

    // 상세 주소 입력할 때마다 fullAddress 갱신
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("detailAddress").addEventListener("input", updateFullAddress);
    });
</script>
</html>
