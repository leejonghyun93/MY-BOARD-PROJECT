<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page session="false" %>



<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>보드 게시판</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        table {
            table-layout: fixed;
            width: 100%;
        }
        td, th {
            word-wrap: break-word;
            word-break: break-all;
            white-space: normal;
        }
        .col-check {
            width: 30px;
        }

        .col-num {
            width: 50px;
        }

        .col-title {
            width: 150px;
        }

        .col-writer {
            width: 80px;
        }

        .col-date {
            width: 100px;
        }

        .col-view {
            width: 50px;
        }

        .col-private {
            width: 50px;
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
                <div style="display: flex; justify-content: space-between; align-items: center;" class="mb-4">
                    <h2>게시판 목록</h2>
                </div>

                <!-- 페이지 사이즈 선택 -->
                <form id="sizeForm" method="post" action="/boardList">
                    <div class="page-size-selector">
                        <label for="size">게시판 글 수 :</label>
                        <select name="size" id="size" onchange="document.getElementById('sizeForm').submit()">
                            <c:set var="sizeOptions" value="10,20,30,40,100"/>
                            <c:forTokens var="size" items="${sizeOptions}" delims=",">
                                <option value="${size}" ${pageDTO.pageSize == size ? 'selected' : ''}>${size}</option>
                            </c:forTokens>
                        </select>
                        <input type="hidden" name="page" value="${pageDTO.page}"/>
                        <input type="hidden" name="searchValue" value="${fn:escapeXml(pageDTO.searchValue)}"/>
                    </div>
                </form>

                <!-- 검색어 입력 -->
                <!-- 검색어 입력 + 버튼 -->
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <form method="post" action="/boardList" style="display: flex; align-items: center;">
                        <label for="searchValue" style="margin-right: 8px;">검색어:</label>
                        <input type="text" name="searchValue" id="searchValue"
                               value="${fn:escapeXml(pageDTO.searchValue)}" style="margin-right: 8px;"/>
                        <input type="hidden" name="page" value="1"/>
                        <input type="hidden" name="size" value="${pageDTO.pageSize}"/>
                        <input type="submit" value="검색">
                    </form>

                    <div style="display: flex; gap: 10px;">
                        <a href="/board/write" class="btn btn-primary">글쓰기</a>
                        <c:if test="${userRole eq 'ADMIN'}">
                            <button id="toggleVisibility" class="btn btn-info" onclick="toggleVisibility()">공개여부 전환
                            </button>
                        </c:if>
                    </div>
                </div>

                <div class="table-responsive" style="max-height: 600px; overflow-y: auto;">
                    <table class="table table-hover align-middle text-center" style="background-color: white;">
                        <colgroup>
                            <c:if test="${userRole eq 'ADMIN'}">
                                <col class="col-check">
                            </c:if>
                            <col class="col-num">
                            <col class="col-title">
                            <col class="col-writer">
                            <col class="col-date">
                            <col class="col-view">
                            <c:if test="${userRole eq 'ADMIN'}">
                                <col class="col-private">
                            </c:if>
                        </colgroup>
                        <thead style="background-color: #f2f2f2;">
                        <tr>
                            <c:if test="${userRole eq 'ADMIN'}">
                                <th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"></th>
                            </c:if>
                            <th onclick="sortTable(1)">번호 ▲▼</th>
                            <th onclick="sortTable(2)">제목 ▲▼</th>
                            <th onclick="sortTable(3)">작성자 ▲▼</th>
                            <th onclick="sortTable(4)">작성일 ▲▼</th>
                            <th onclick="sortTable(5)">조회수 ▲▼</th>
                            <c:if test="${userRole eq 'ADMIN'}">
                                <th onclick="sortTable(6)">공개여부 ▲▼</th>
                            </c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty boardList}">
                                <tr>
                                    <td colspan="7">게시글이 존재하지 않습니다.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="board" items="${boardList}" varStatus="status">
                                    <tr>
                                        <c:if test="${userRole eq 'ADMIN'}">
                                            <td><input type="checkbox" name="boardCheck" value="${board.bno}"></td>
                                        </c:if>
                                        <td>${(pageDTO.page - 1) * pageDTO.pageSize + status.index + 1}</td>
                                        <td><a href="javascript:void(0);"
                                               onclick="loadBoardDetail(${board.bno})">${board.title}</a></td>
                                        <td>${board.writerName != null ? board.writerName : board.nickName}</td>
                                        <td>${board.formatLocalDateTime(board.regDate)}</td>
                                        <td>${board.viewCount}</td>
                                        <c:if test="${userRole eq 'ADMIN'}">
                                            <td>${board.isPrivate}</td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>

                    <%@ include file="/WEB-INF/views/layout/page/page.jsp" %>
                    <div id="user-detail-container" class="mt-4"></div>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>

<script>
    function toggleVisibility() {
        // 선택된 게시글이 있는지 확인
        const selectedBoards = document.querySelectorAll('input[name="boardCheck"]:checked');
        if (selectedBoards.length === 0) {
            alert('변경할 게시글을 선택해주세요.');
            return;
        }

        // 선택된 게시글 ID 배열 생성
        const boardIds = Array.from(selectedBoards).map(input => input.value);

        // 공개여부 전환 요청
        fetch('/api/board/toggleVisibility', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({boardIds: boardIds})
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('공개 여부가 성공적으로 변경되었습니다.');
                    location.reload(); // 페이지 새로 고침
                } else {
                    alert('공개 여부 변경에 실패했습니다.');
                }
            })
            .catch(error => {
                alert('공개 여부 변경 중 오류가 발생했습니다.');
                console.error('Error:', error);
            });
    }

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

    function toggleAll(source) {
        const checkboxes = document.getElementsByName('boardCheck');
        for (let i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = source.checked;
        }
    }

    let sortDirection = {};

    function sortTable(columnIndex) {
        const table = document.querySelector("table");
        const tbody = table.querySelector("tbody");
        const rows = Array.from(tbody.rows);

        sortDirection[columnIndex] = !sortDirection[columnIndex];

        rows.sort((a, b) => {
            const aText = a.cells[columnIndex].innerText.trim();
            const bText = b.cells[columnIndex].innerText.trim();
            const isNumeric = !isNaN(aText) && !isNaN(bText);

            if (isNumeric) {
                return sortDirection[columnIndex] ? aText - bText : bText - aText;
            } else {
                return sortDirection[columnIndex]
                    ? aText.localeCompare(bText)
                    : bText.localeCompare(aText);
            }
        });

        rows.forEach(row => tbody.appendChild(row));
    }
</script>

</body>
</html>
