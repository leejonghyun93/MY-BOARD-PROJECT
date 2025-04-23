<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page session="false" %>
<html>
<head>
    <style>
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
        <c:if test="${pageDTO.startPage > 1}">
            <li><a href="javascript:goPage(${pageDTO.startPage - 1})">&laquo;</a></li>
        </c:if>

        <c:forEach var="i" begin="${pageDTO.startPage}" end="${pageDTO.endPage}">
            <li class="${i == pageDTO.page ? 'active' : ''}">
                <a href="javascript:goPage(${i})">${i}</a>
            </li>
        </c:forEach>

        <c:if test="${pageDTO.endPage < pageDTO.totalPage}">
            <li><a href="javascript:goPage(${pageDTO.endPage + 1})">&raquo;</a></li>
        </c:if>
    </ul>
</div>
</body>
<script>
    function goPage(pageNum) {
        const params = new URLSearchParams();
        params.append('page', pageNum);
        params.append('size', '${pageDTO.pageSize}');
        params.append('searchValue', '${fn:escapeXml(pageDTO.searchValue)}');

        const contextPath = '<%= request.getContextPath() %>';
        const listUrl = '${listUrl}';

        fetch(contextPath + listUrl, {
            method: 'POST',
            body: params,
        })
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');

                // 전체 컨텐츠 영역 업데이트
                const newContentArea = doc.querySelector('#content-area');
                if (newContentArea) {
                    const currentContentArea = document.querySelector('#content-area');
                    if (currentContentArea) {
                        currentContentArea.innerHTML = newContentArea.innerHTML;
                    }

                    addTableEventListeners();
                    addPaginationEventListeners();
                }
            })
            .catch(error => console.error('오류:', error));
    }

    function addTableEventListeners() {
        const checkAll = document.getElementById('checkAll');
        if (checkAll) {
            checkAll.addEventListener('click', function() {
                toggleAll(this);
            });
        }
    }

    function addPaginationEventListeners() {
        const paginationLinks = document.querySelectorAll('.pagination li a');
        paginationLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const hrefAttr = this.getAttribute('href');
                const pageNum = hrefAttr.match(/goPage\((\d+)\)/)[1];
                goPage(pageNum);
            });
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        addTableEventListeners();
        addPaginationEventListeners();
    });
</script>
</html>
