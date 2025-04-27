<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>


<c:set var="userRole" value="${requestScope.userRole}" />

<nav class="col-md-2 d-none d-md-block bg-light sidebar">
    <div class="sidebar-sticky">
        <ul class="nav flex-column">

            <!-- 관리자일 때만 보이게 -->
            <c:if test="${userRole == 'ADMIN'}">
                <li class="nav-item">
                    <a class="nav-link" href="/memberList">
                        <span data-feather="users"></span> 회원 목록
                    </a>
                </li>
            </c:if>

            <li class="nav-item">
                <a class="nav-link" href="/boardList">
                    <span data-feather="file-text"></span> 게시판 목록
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="javascript:void(0);" onclick="loadUserDetail('${loginId}')">
                    <span data-feather="user"></span> 회원 상세보기
                </a>
            </li>

        </ul>
    </div>
</nav>
<script>
    function loadUserDetail(userid) {
        if (!userid) {
            alert("사용자 정보가 없습니다.");
            return;
        }
        const encodedId = encodeURIComponent(userid);
        window.location.href = "/detail/" + encodedId;
    }
</script>