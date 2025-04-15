<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/member-css/login.css">
        <title>로그인 페이지</title>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="/js/pageChange.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <style>
        </style>
    </head>

    <body>
        <div id="app">
            <div class="overlay"></div> <!-- 어두운 배경 -->
            <div class="login-container">
                <div class="arrow">
                    <a href="/home.do">
                        < </a>
                </div>
                <h2 style="color: white;">Login</h2>
                <input type="text" placeholder="아이디 입력" class="login-input" v-model="userId" @keyup.enter="fnLogin">
                <input type="password" placeholder="비밀번호 입력" class="login-input" v-model="password"
                    @keyup.enter="fnLogin">
                <div class="checkbox-container">
                    <label><input type="checkbox"> 아이디 저장</label>
                </div>
                <div class="bottom-links">
                    <a href="#" @click="fnTermPg()">회원가입 </a>

                    <a href="#" @click=" fnFindPassword()">비밀번호 찾기</a>
                </div>

                <div style="margin-top: 10px; text-align: center;">
                    <a href="javascript:kakaoLogin();">
                        <img src=../img/kakao.png style="width: 150px; height: auto; margin: 10px 0;">
                    </a>
                    

                </div>
                <button class="login-btn" @click="fnLogin" style="margin-top: 15px;">로그인</button>
                <div class="logo">
                    @MEALPICK
                </div>
            </div>
        </div>
    </body>

    </html>
    <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
    <script>  window.Kakao.init("06f48e08a80c9ffa75ffe2b6ae79d5bc");

        function kakaoLogin() {
            const clientId = "06f48e08a80c9ffa75ffe2b6ae79d5bc";
            const redirectUri = "http://localhost:8080/home.do";

            location.href = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=" + clientId + "&redirect_uri=" + redirectUri;

            // window.Kakao.Auth.login({
            //     scope: 'profile',
            //     success: function (authObj) {
            //         console.log(authObj);
            //         window.Kakao.API.request({
            //             url: '/v2/user/me',
            //             success: res => {
            //                 const kakao_account = res.kakao_account;
            //                 console.log(kakao_account);
            //             }
            //         });
            //     }
            // });
        }
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

                fnFindPassword() {
                    window.location.href = "/member/repwd.do";  // 비밀번호 찾기 페이지로 이동
                },
                fnLogin() {
                    var self = this;
                    var nparmap = {
                        userId: self.userId,
                        password: self.password
                    };
                    $.ajax({
                        url: "/member/login.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        xhrFields: {
                            withCredentials: true
                        },
                        success: function (data) {
                            console.log(data);
                            if (data.result == "fail") {
                                alert("아이디와 비밀번호를 확인해주세요.");
                            } else {
                                alert(data.member.userName + "님 환영합니다!");
                                location.href = "/home.do";
                            }

                        }

                    });
                },
                fnAnother() {
                    location.href = "";
                }
            }
        });

        app.mount("#app");

    </script>