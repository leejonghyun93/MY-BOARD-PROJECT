<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<c:set var="loginId"
       value="${pageContext.request.getSession(false) != null && pageContext.request.session.getAttribute('userId') != null ? pageContext.request.session.getAttribute('userId') : ''}"/>
<c:set var="loginOutLink" value="${loginId == '' ? '/login/login' : ''}"/>
<c:set var="logout" value="${loginId == '' ? 'Login' : loginId}"/>

<nav class="col-md-2 d-none d-md-block bg-light sidebar">
    <div class="sidebar-sticky">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link active" href="/admin/dashboard">
                    <span data-feather="home"></span> 관리자 대시보드
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/admin/memberList">
                    <span data-feather="users"></span> 회원 목록
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/admin/boardList">
                    <span data-feather="file-text"></span> 게시판 목록
                </a>
            </li>
        </ul>
    </div>
</nav>