<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="/css/member-css/login.css">
    <title>로그인 페이지</title>
    <script src="<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>"></script>
    <script src="/js/pageChange.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <style>
    </style>
</head>

<body>
    <div id="app">
    <div class="overlay"></div> <!-- 어두운 배경 -->
    <div class="login-container">
        <div class="arrow">
            <a href="/home.do"><</a>
        </div>
        <h2 style="color: white;">Login</h2>
        <input type="text" placeholder="아이디 입력" class="login-input" v-model="userId" @keyup.enter="fnLogin">
        <input type="password" placeholder="비밀번호 입력" class="login-input" v-model="password" @keyup.enter="fnLogin">
        <div class="checkbox-container">
            <label><input type="checkbox"> 아이디 저장</label>
        </div>
        <div class="bottom-links">
            <a href="#" @click="fnTermPg()">회원가입 </a> 
            <a href="#" @click="fnAnother">다른 계정 로그인 </a> 
            <a href="#">비밀번호 찾기</a>
        </div>
        <button class="login-btn" @click="fnLogin">로그인</button>
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
        return {
            userId: "",
            password: ""
        };
    },
    methods: {
        fnTermPg() {
            window.location.href = "/member/term.do";
        },
        fnLogin(){
				var self = this;
				var nparmap = {
                    userId : self.userId,
                    password : self.password
				};
				$.ajax({
					url:"/member/login.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        if(data.result == "fail"){
                            alert("아이디와 비밀번호를 확인해주세요.");
                        }else{
                            alert(data.member.userName + "님 환영합니다!");
                            location.href = "/home.do";
                        }
                     
					}
                    
				});
            },
            fnAnother(){
                location.href ="";
            }
    }
});

app.mount("#app");

</script>