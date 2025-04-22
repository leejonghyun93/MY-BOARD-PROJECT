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
    <title>게시글 등록</title>
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

        .form-group {
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 8px 10px;
            box-sizing: border-box;
            border-radius: 5px;
            border: 1px solid #aaa;
        }

        textarea {
            height: 200px;
            resize: vertical;
        }

        button {
            margin-top: 20px;
            padding: 10px 30px;
            background-color: #28a745;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            display: block;
            margin-left: auto;
        }

        button:hover {
            background-color: #218838;
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
                    <h2>게시글 등록</h2>
                    <form id="createForm">
                        <div class="form-group">
                            <label for="title">제목</label>
                            <input type="text" name="title" id="title" required>
                        </div>

                        <div class="form-group">
                            <label for="content">내용</label>
                            <textarea name="content" id="content" required></textarea>
                        </div>

                        <div class="form-group">
                            <label for="writer">작성자</label>

                            <c:choose>
                                <c:when test="${loginId != ''}">
                                    <!-- 회원일 경우 writer로 전송 -->
                                    <input type="text" name="writer" id="writer" value="${loginName}" readonly>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" name="nickName" id="nickName" placeholder="작성자 이름을 입력하세요" required>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="form-group">
                            <label for="lockNo">잠금 번호</label>
                            <input type="text" name="passwd" id="lockNo" placeholder="잠금 번호를 입력하세요" required>
                        </div>

                        <button type="submit">등록 완료</button>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('createForm').addEventListener('submit', function (e) {
            e.preventDefault();

            const title = document.getElementById('title').value.trim();
            const content = document.getElementById('content').value.trim();
            const passwd = document.getElementById('lockNo').value.trim();
            let writer = "";

            const nickNameInput = document.getElementById('nickName');
            const writerInput = document.getElementById('writer');


            console.log("Nickname Input Value: ", nickNameInput ? nickNameInput.value.trim() : "없음");
            console.log("Writer Input Value: ", writerInput ? writerInput.value.trim() : "없음");


            if (nickNameInput && nickNameInput.value.trim() !== "") {
                writer = nickNameInput.value.trim();
            } else if (writerInput && writerInput.value.trim() !== "") {
                writer = writerInput.value.trim();
            }

            if (title === "" || content === "" || passwd === "" || writer === "") {
                alert("모든 필드를 입력해주세요.");
                return;
            }

            const newBoard = {
                title: title,
                content: content,
                writer: writer,
                passwd: passwd,
                nickName: nickNameInput ? nickNameInput.value.trim() : null
            };

            fetch('/api/board/write', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(newBoard)
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message || "게시글이 성공적으로 등록되었습니다.");
                        window.location.href = data.redirectUrl || '/board/list';
                    } else {
                        alert(data.message || "등록에 실패했습니다.");
                    }
                })
                .catch(err => {
                    alert("등록 중 오류가 발생했습니다.");
                    console.error(err);
                });
        });
    });
</script>

</body>
</html>
