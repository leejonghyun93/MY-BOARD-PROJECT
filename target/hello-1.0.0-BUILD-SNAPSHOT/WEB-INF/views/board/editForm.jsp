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
    <title>게시글 수정</title>
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
        input[type="password"],
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
                    <h2>게시글 수정</h2>
                    <form id="editForm" method="post" action="/board/update">
                        <!-- 게시글 번호 (숨김 처리) -->
                        <input type="hidden" name="bno" id="bno" value="${board.bno}">

                        <div class="form-group">
                            <label for="title">제목</label>
                            <input type="text" name="title" id="title" value="${board.title}" required>
                        </div>

                        <div class="form-group">
                            <label for="content">내용</label>
                            <textarea name="content" id="content" required>${board.content}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="writer">작성자</label>
                            <input type="text" name="writer" id="writer" value="${board.writerName != null ? board.writerName : board.nickName}" readonly>
                        </div>

                        <div class="form-group">
                            <label for="lockNo">잠금 번호</label>
                            <input type="text" name="passwd" id="lockNo" placeholder="잠금 번호를 입력하세요">
                        </div>

                        <div class="form-group">
                            <!-- 수정 완료, 목록, 뒤로가기 버튼을 같은 줄에 배치 -->
                            <div class="d-flex justify-content-between">
                                <!-- 수정 완료 버튼 -->
                                <button type="submit" class="btn btn-primary">수정 완료</button>

                                <!-- 목록으로 버튼 -->
                                <a href="/boardList" class="btn btn-secondary">목록</a>

                                <!-- 뒤로가기 버튼 -->
                                <a href="javascript:void(0);" class="btn btn-secondary" onclick="loadBoardDetail('${board.bno}')">뒤로가기</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>
<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>
</body>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('editForm').addEventListener('submit', function (e) {
            e.preventDefault(); // 기본 제출 막기

            const title = document.getElementById('title').value.trim();
            const content = document.getElementById('content').value.trim();
            const passwd = document.getElementById('lockNo').value.trim();

            if (title === "") {
                alert("제목을 입력해주세요.");
                return;
            }

            if (content === "") {
                alert("내용을 입력해주세요.");
                return;
            }

            if (passwd === "") {
                alert("비밀번호를 입력해주세요.");
                return;
            }

            const boardData = {
                bno: parseInt(document.getElementById('bno').value),
                title: title,
                content: content,
                passwd: passwd
            };

            fetch('/api/board/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(boardData)
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message || "게시글이 성공적으로 수정되었습니다.");
                        window.location.href = data.redirectUrl || '/board/list';
                    } else {
                        alert(data.message || "수정에 실패했습니다.");
                    }
                })
                .catch(err => {
                    alert("수정 중 오류가 발생했습니다.");
                    console.error(err);
                });
        });
    });
    function loadBoardDetail(bno) {
        fetch(`/board/detail/` + bno, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
        })
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newContentArea = doc.querySelector('#content-area');
                if (newContentArea) {
                    document.querySelector('#content-area').innerHTML = newContentArea.innerHTML;
                }
            })
            .catch(error => {
                alert('게시글 정보를 불러오는 데 실패했습니다.');
                console.error('Error:', error);
            });
    }
</script>
</html>
