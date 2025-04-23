<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .chartGroup1{
            border-radius: 2px;
            border: 1px solid #d3d3d3;
        }
        .chartGroup2{
            border-radius: 2px;
            border: 1px solid #d3d3d3;
        }
        .chartGroup3{
            border-radius: 2px;
            border: 1px solid #d3d3d3;
        }
    </style>
</head>

<body>
<%@ include file="/WEB-INF/views/layout/common/header/header.jsp" %>
<%@ include file="/WEB-INF/views/layout/common/topnav/topnav.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/WEB-INF/views/layout/common/sidebar/sidebar.jsp" %>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <%--            <h1 class="h2">게시판 통계</h1>--%>
            <div class="container">
                <div class="row">
                    <div  style="display: flex; flex-wrap: wrap; justify-content: center; padding-left: 0px;">
                        <div class="chartGroup1" style="flex: 0 0 35%; max-width: 50%; display: flex; justify-content: center;">
                            <%--게시글 최신순--%>
                            <canvas id="chart1" width="350" height="300" style="margin: 10px;"></canvas>
                        </div>
                        <div class="chartGroup2" style="flex: 0 0 30%; max-width: 50%; display: flex; justify-content: center;">
                            <%--게시글 인기순--%>
                            <canvas id="chart2" width="350" height="300" style="margin: 10px;"></canvas>
                        </div>
                        <div class="chartGroup3" style="flex: 0 0 30%; max-width: 50%; display: flex; justify-content: center;">
                            <%--유저 접속순 --%>
                            <canvas id="chart3" width="350" height="300" style="margin: 10px;"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <script>
                // 막대그래프
                fetch("/chart/boardRecent")
                    .then(res => res.json())
                    .then(data => {
                        const labels = data.map(item => item.day);         // 날짜 추출
                        const values = data.map(item => item.post_count);  // 게시글 수 추출

                        new Chart(document.getElementById('chart1'), {
                            type: 'bar',
                            data: {
                                labels: labels,  // 날짜별 라벨
                                datasets: [{
                                    label: '게시글 수',  // 그래프 레이블
                                    data: values,  // 게시글 수 데이터
                                    backgroundColor: 'rgba(54, 162, 235, 0.5)'  // 막대 색상
                                }]
                            },
                            options: {
                                responsive: true,
                                scales: {
                                    y: {
                                        beginAtZero: true,  // Y축 0부터 시작
                                        title: {
                                            display: true
                                        }
                                    }
                                }
                            }
                        });
                    });
                fetch("/chart/boardPopularity")
                    .then(res => res.json())
                    .then(data => {
                        const labels = data.map(item => item.title);       // 게시글 제목
                        const values = data.map(item => item.vc);           // 조회수

                        new Chart(document.getElementById('chart2'), {
                            type: 'doughnut',
                            data: {
                                labels: labels,
                                datasets: [{
                                    label: '게시글 인기순',
                                    data: values,
                                    backgroundColor: [
                                        'rgba(255, 99, 132, 0.6)',
                                        'rgba(54, 162, 235, 0.6)',
                                        'rgba(255, 206, 86, 0.6)',
                                        'rgba(75, 192, 192, 0.6)',
                                        'rgba(153, 102, 255, 0.6)'
                                    ]
                                }]
                            },
                            options: {
                                responsive: true,
                                plugins: {
                                    legend: {
                                        position: 'right'
                                    }
                                }
                            }
                        });
                    });
                fetch("/chart/userAccess")
                    .then(res => res.json())
                    .then(data => {
                        const bubbleData = data.map(item => ({
                            x: new Date(item.login_day).getTime(),       // X축: 날짜 (타임스탬프)
                            y: item.total_logins,                        // Y축: 로그인 수
                            r: Math.sqrt(item.unique_users) * 1          // 반지름: 유니크 유저 수 (스케일 조정)
                        }));

                        new Chart(document.getElementById('chart3'), {
                            type: 'bubble',
                            data: {
                                datasets: [{
                                    label: '일자별 로그인/유니크 유저',
                                    data: bubbleData,
                                    backgroundColor: 'rgba(255,99,132,0.5)'
                                }]
                            },
                            options: {
                                responsive: false,
                                scales: {
                                    x: {
                                        type: 'linear',
                                        position: 'bottom',
                                        ticks: {
                                            callback: function(value) {
                                                return new Date(value).toISOString().split('T')[0];
                                            }
                                        },
                                        title: {
                                            display: true,
                                            text: '날짜'
                                        }
                                    },
                                    y: {
                                        beginAtZero: true,
                                        title: {
                                            display: true
                                        }
                                    }
                                }
                            }
                        });
                    });

            </script>

            <h2>최신 글 </h2>
            <div class="table-responsive">
                <table class="table table-striped table-sm">
                    <thead>
                    <tr>
                        <th>번호</th>
                        <th>회원이름</th>
                        <th>글번호</th>
                        <th>제목</th>
                        <th>내용</th>
                        <th>작성자ID</th>
                        <th>작성일</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="board" items="${boardList}" varStatus="status">
                        <tr>
                            <td>${status.count}</td>
                            <td>${board.name}</td>
                            <td>${board.bno}</td>
                            <td>${board.title}</td>
                            <td>${board.content}</td>
                            <td>${board.writer}</td>
                            <td>${board.getFormattedRegDate()}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>
</body>
</html>
