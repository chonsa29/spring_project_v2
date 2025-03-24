<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="/css/member-css/login.css">
    <title>로그인 페이지</title>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
    </style>
</head>

<body>
    <div id="app">
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
            <a href="#" @click="fnTermPg()">회원가입 </a> 
            <a href="#">다른 계정 로그인 </a> 
            <a href="#">비밀번호 찾기</a>
        </div>
        <button class="login-btn">로그인</button>
        <div class="logo">
            @MEALPICK
        </div>
    </div>
    </div>
</body>
</html>
<script>
const app = Vue.createApp({
    data() {
        return {};
    },
    methods: {
        fnTermPg() {
            window.location.href = "/member/term.do";
        }
    }
});

app.mount("#app");

</script>