<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page session="false" %>
<html>
<head>
    <style>
        /* 페이징 스타일 */
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }

        .pagination {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .pagination li {
            margin: 0 3px;
        }

        .pagination li a {
            display: block;
            padding: 8px 12px;
            text-decoration: none;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .pagination li a:hover {
            background-color: #f1f1f1;
        }

        .pagination li.active a {
            background-color: #009688;
            color: white;
            border-color: #009688;
        }

        .pagination li.disabled a {
            color: #ccc;
            cursor: not-allowed;
        }

        /* 페이지당 표시 개수 선택 */
        .page-size-selector {
            margin-top: 20px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .page-size-selector select {
            margin-left: 10px;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<div class="pagination-container">
    <ul class="pagination">
        <!-- 이전 블록 -->
        <c:if test="${pageDTO.startPage > 1}">
            <li><a href="javascript:goPage(${pageDTO.startPage - 1})">&laquo;</a></li>
        </c:if>

        <!-- 페이지 번호 -->
        <c:forEach var="i" begin="${pageDTO.startPage}" end="${pageDTO.endPage}">
            <li class="${i == pageDTO.page ? 'active' : ''}">
                <a href="javascript:goPage(${i})">${i}</a>
            </li>
        </c:forEach>

        <!-- 다음 블록 -->
        <c:if test="${pageDTO.endPage < pageDTO.totalPage}">
            <li><a href="javascript:goPage(${pageDTO.endPage + 1})">&raquo;</a></li>
        </c:if>
    </ul>
</div>
</body>
<script>
    function goPage(pageNum) {
        const form = document.createElement('form');
        form.method = 'post';

        // contextPath + listUrl (예: /board/list)
        const contextPath = '<%= request.getContextPath() %>';
        const listUrl = '${listUrl}';  // ← 컨트롤러에서 받은 동적 경로
        form.action = contextPath + listUrl;

        const params = {
            page: pageNum,
            size: '${pageDTO.pageSize}',
            searchValue: '${fn:escapeXml(pageDTO.searchValue)}'
        };

        for (const key in params) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = params[key];
            form.appendChild(input);
        }

        document.body.appendChild(form);
        form.submit();
    }
</script>
</html>
