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
                    <div style="display: flex; flex-wrap: wrap; justify-content: center;">
                        <div style="flex: 0 0 30%; max-width: 50%; display: flex; justify-content: center;">
                            <%--게시글 최신순--%>
                            <canvas id="chart1" width="300" height="300" style="margin: 10px;"></canvas>
                        </div>
                        <div style="flex: 0 0 30%; max-width: 50%; display: flex; justify-content: center;">
                            <%--게시글 인기순--%>
                            <canvas id="chart2" width="300" height="300" style="margin: 10px;"></canvas>
                        </div>
                        <div style="flex: 0 0 30%; max-width: 50%; display: flex; justify-content: center;">
                            <%--유저 접속순 --%>
                            <canvas id="chart3" width="300" height="300" style="margin: 10px;"></canvas>
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
                // 버블그래프
                new Chart(document.getElementById('chart3'), {
                    type: 'bubble',
                    data: {
                        datasets: [{
                            label: '버블그래프',
                            data: [
                                {x: 10, y: 20, r: 10},
                                {x: 15, y: 10, r: 15},
                                {x: 20, y: 30, r: 20}
                            ],
                            backgroundColor: 'rgba(255,99,132,0.5)'
                        }]
                    },
                    options: {responsive: false}
                });

            </script>

            <h2>Section title</h2>
            <div class="table-responsive">
                <table class="table table-striped table-sm">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Header</th>
                        <th>Header</th>
                        <th>Header</th>
                        <th>Header</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>1,001</td>
                        <td>Lorem</td>
                        <td>ipsum</td>
                        <td>dolor</td>
                        <td>sit</td>
                    </tr>
                    <tr>
                        <td>1,002</td>
                        <td>amet</td>
                        <td>consectetur</td>
                        <td>adipiscing</td>
                        <td>elit</td>
                    </tr>
                    <tr>
                        <td>1,003</td>
                        <td>Integer</td>
                        <td>nec</td>
                        <td>odio</td>
                        <td>Praesent</td>
                    </tr>
                    <tr>
                        <td>1,003</td>
                        <td>libero</td>
                        <td>Sed</td>
                        <td>cursus</td>
                        <td>ante</td>
                    </tr>
                    <tr>
                        <td>1,004</td>
                        <td>dapibus</td>
                        <td>diam</td>
                        <td>Sed</td>
                        <td>nisi</td>
                    </tr>
                    <tr>
                        <td>1,005</td>
                        <td>Nulla</td>
                        <td>quis</td>
                        <td>sem</td>
                        <td>at</td>
                    </tr>
                    <tr>
                        <td>1,006</td>
                        <td>nibh</td>
                        <td>elementum</td>
                        <td>imperdiet</td>
                        <td>Duis</td>
                    </tr>
                    <tr>
                        <td>1,007</td>
                        <td>sagittis</td>
                        <td>ipsum</td>
                        <td>Praesent</td>
                        <td>mauris</td>
                    </tr>
                    <tr>
                        <td>1,008</td>
                        <td>Fusce</td>
                        <td>nec</td>
                        <td>tellus</td>
                        <td>sed</td>
                    </tr>
                    <tr>
                        <td>1,009</td>
                        <td>augue</td>
                        <td>semper</td>
                        <td>porta</td>
                        <td>Mauris</td>
                    </tr>
                    <tr>
                        <td>1,010</td>
                        <td>massa</td>
                        <td>Vestibulum</td>
                        <td>lacinia</td>
                        <td>arcu</td>
                    </tr>
                    <tr>
                        <td>1,011</td>
                        <td>eget</td>
                        <td>nulla</td>
                        <td>Class</td>
                        <td>aptent</td>
                    </tr>
                    <tr>
                        <td>1,012</td>
                        <td>taciti</td>
                        <td>sociosqu</td>
                        <td>ad</td>
                        <td>litora</td>
                    </tr>
                    <tr>
                        <td>1,013</td>
                        <td>torquent</td>
                        <td>per</td>
                        <td>conubia</td>
                        <td>nostra</td>
                    </tr>
                    <tr>
                        <td>1,014</td>
                        <td>per</td>
                        <td>inceptos</td>
                        <td>himenaeos</td>
                        <td>Curabitur</td>
                    </tr>
                    <tr>
                        <td>1,015</td>
                        <td>sodales</td>
                        <td>ligula</td>
                        <td>in</td>
                        <td>libero</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>
</body>
</html>
