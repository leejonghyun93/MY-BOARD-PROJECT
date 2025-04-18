<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<c:set var="loginId"
       value="${pageContext.request.getSession(false) != null && pageContext.request.session.getAttribute('userId') != null ? pageContext.request.session.getAttribute('userId') : ''}"/>
<c:set var="loginOutLink" value="${loginId == '' ? '/login' : ''}"/>
<c:set var="logout" value="${loginId == '' ? 'Login' : loginId}"/>
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

    <!-- Custom styles for this template -->
    <link href="dashboard.css" rel="stylesheet">
<style>
    body {
        background-color: #F3F4F9;
        margin: 0;
        padding: 0;
        font-family: Verdana, Geneva, Tahoma, sans-serif;
    }

    #form-container {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    #form-inner-container {
        background-color: white;
        max-width: 70%;
        border-radius: 8px;
        box-shadow: 0 0 20px gainsboro;
    }

    #sign-up-container, #sign-in-container {
        padding: 60px 80px;
        width: 320px;
        display: inline-block;
    }

    form input:not(:last-of-type) {
        display: block;
        margin-bottom: 20px;
        border: 1px solid #E5E9F5;
        background-color: #F6F7FA;
        padding: 20px;
        margin-top: 10px;
        border-radius: 10px;
        width: 100%;
    }

    #form-controls {
        margin-bottom: 20px;
    }


    h3 {
        color: red;
        font-size: 150%;
        font-weight: 500;
    }

    label {
        color: #7369AB;
    }

    ::placeholder {
        color: #C0C7DB;
        font-size: larger;
        letter-spacing: 1.2px;
    }

    #form-controls button {
        border: none;
        font-size: 120%;
    }

    #form-controls button:hover {
        cursor: pointer;
    }

    button[type="submit"] {
        padding: 16px 75px;
        background-color: #ED4B5E;
        border-radius: 10px;
        color: white;
    }

    button[type="submit"]:hover {
        background-color: #ff6678;
    }

    button[type="button"] {
        padding: 16px 0 16px 35px;
        background-color: transparent;
        color: #ED4B5E;
    }

    #terms {
        width: 30px;
        height: 30px;
        appearance: none;
        border: 2px solid #7369AB;
        border-radius: 4px;
        position: relative;
    }

    #terms:checked:after {
        content: '\2713';
        color: #7369AB;
        font-size: 24px;
        position: absolute;
        top: 0;
        left: 3px;
    }

    label[for="terms"] {
        display: inline-block;
        width: 80%;
        margin-left: 10px;
    }

    .termsLink {
        color: #EF7886;
        text-decoration: none;
    }

    .hide {
        display: none!important;
    }

    #animation-container {
        display: inline-block;
    }

    /* responsive display */

    @media(max-width:1438px) {
        lottie-player {
            width: 300px!important;
        }
    }

    @media(max-width:1124px) {
        #animation-container {
            display: none;
        }

        #form-inner-container{
            display: flex;
            justify-content: center;
        }
    }

    @media(max-width: 684px) {
        #form-controls {
            text-align: center;
            margin: 0;
            padding: 0;
        }

        button {
            width: 100%;
        }

        form input:not(:last-of-type) {
            width: 85%;
        }

        #toggleSignIn, #toggleSignUp {
            padding: 16px 75px;
        }

        #terms {
            width: 20px;
            height: 20px;
        }

        label[for="terms"] {
            display: inline-block;
            font-size: smaller;
        }
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
            <div class="mt-5">
                <div class="register-container container mt-5">
                    <div id="form-container">
                        <div id="form-inner-container">
                            <!-- Sign up form -->
                            <div id="sign-up-container">
                                <h3>Get Started</h3>
                                <form>
                                    <label for="name">Name</label>
                                    <input type="text" name="name" id="name" placeholder="Name">

                                    <label for="email">Email</label>
                                    <input type="email" name="email" id="email" placeholder="Email">

                                    <label for="password">Password</label>
                                    <input type="password" name="password" id="password" placeholder="&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;">

                                    <div id="form-controls">
                                        <button type="submit">Sign Up</button>
                                        <button type="button" id="toggleSignIn">Sign In</button>
                                    </div>

                                    <input type="checkbox" name="terms" id="terms">
                                    <label for="terms">I agree to the <a href="#" class="termsLink">Terms of service</a> and <a href="#" class="termsLink">Privacy Policy</a>.</label>
                                </form>
                            </div>

                            <!-- Sign in form -->
                            <div id="sign-in-container" class="hide">
                                <h3>Welcome Back</h3>
                                <form>
                                    <label for="username">Username</label>
                                    <input type="text" name="username" id="username" placeholder="user@example.com">

                                    <label for="password">Password</label>
                                    <input type="password" name="password" id="password" placeholder="&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;">

                                    <div id="form-controls">
                                        <button type="submit">Sign In</button>
                                        <button type="button" id="toggleSignUp">Sign Up</button>
                                    </div>

                                    <input type="checkbox" name="terms" id="terms">
                                    <label for="terms">I agree to the <a href="#" class="termsLink">Terms of service</a> and <a href="#" class="termsLink">Privacy Policy</a>.</label>
                                </form>
                            </div>

                            <!-- Lottie animation -->
                            <div id="animation-container">
                                <lottie-player src="https://assets3.lottiefiles.com/packages/lf20_aesgckiv.json"  background="transparent"  speed="1"  style="width: 520px; height: 520px;" loop autoplay></lottie-player>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </main>
    </div>
</div>
</body>

<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>
<script type="text/JavaScript" src="./my-script.js"></script>

<%@ include file="/WEB-INF/views/layout/common/footer/footer.jsp" %>
<script>
    const signInBtn = document.querySelector('#toggleSignIn');
    const signUpBtn = document.querySelector('#toggleSignUp');

    const signUpForm = document.querySelector('#sign-up-container');
    const signInForm = document.querySelector('#sign-in-container');

    // Change form when clicking on button
    const changeForm = (form1, form2) => {
        form1.classList.toggle('hide');
        form2.classList.toggle('hide');
    }

    // Show the Sign In form
    signInBtn.addEventListener('click', () => {
        changeForm(signUpForm, signInForm);
    });

    // Show the Sign Up form
    signUpBtn.addEventListener('click', () => {
        changeForm(signUpForm, signInForm);
    });
</script>
</html>
