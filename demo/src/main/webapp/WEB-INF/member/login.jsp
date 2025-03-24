<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="/css/member-css/login.css">
    <title>로그인 페이지</title>
    <style>
    </style>
</head>

<body>
    <div class="overlay"></div> <!-- 어두운 배경 -->
    <div class="login-container">
        <div class="arrow">
            <a href="#"><</a>
        </div>
        <h2 style="color: white;">Login</h2>
        <input type="text" placeholder="아이디 입력" class="login-input">
        <input type="password" placeholder="비밀번호 입력" class="login-input">
        <div class="checkbox-container">
            <label><input type="checkbox"> 아이디 저장</label>
        </div>
        <div class="bottom-links">
            <a href="#">회원가입 </a> 
            <a href="#">다른 계정 로그인 </a> 
            <a href="#">비밀번호 찾기</a>
        </div>
        <button class="login-btn">로그인</button>
        <div class="logo">
            @MEALPICK
        </div>
    </div>
</body>

</html>