<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<c:set var="loginId" value="${sessionScope.userid != null ? sessionScope.userid : ''}"/>
<c:set var="loginName" value="${sessionScope.name != null ? sessionScope.name : ''}"/>
<c:set var="loginOutLink" value="${loginId == '' ? '/login' : ''}"/>
<c:set var="logout" value="${loginId == '' ? 'Login' : loginName}"/>
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
        </ul>
    </div>
</nav>