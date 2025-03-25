<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
        <script src="/js/pageChange.js"></script>
        <title>MealPick - 밀키트 쇼핑몰</title>
    </head>

    <body>
        <div id="appHeader">
            <header class="header">
                <div class="logo-container">
                    <a href="/home.do">
                        <div class="logo-contents">
                            <div class="logo">
                                <img src="/img/icon.png" alt="MealPick 로고">
                            </div>
                            <div class="logo2">
                                <img src="/img/MEALPICK.png" alt="MealPick 로고">
                            </div>
                        </div>
                    </a>
                    <!-- nav를 logo-container 내부에 포함 -->
                    <nav class="nav">
                        <a href="#">MENU1</a>
                        <a href="/product.do">PRODUCT</a>
                        <a href="#">BRAND</a>
                        <a href="#">COMMUNITY</a>
                        <a href="/inquire.do">HELP</a>
                    </nav>

                    <div class="right-container">
                        <div class="login-container">
                            <a href="/member/mypage.do" v-if="sessionStatus=='A'">ADMIN</a>
                            <a href="/member/mypage.do" v-if="sessionStatus">MYPAGE</a>
                            <a href="/member/login.do" v-if="!sessionStatus">LOGIN</a>
                            <a href="/home.do" v-else @click="fnLogout">LOGOUT</a>
                            <a  href="javascript:;" @click="fnCart(sessionId)">CART</a>
                        </div>
                        <div class="search-container">
                            <a href="#"><span class="material-symbols-outlined">
                                search
                            </span></a>
                            <input type="text" placeholder="Search">
                        </div>
                    </div>
                </div>


            </header>

            <div class="floating-icon">
                <img src="/img/icon.png" alt="아이콘">
            </div>
        </div>
    </body>

    </html>

    <script>
        window.addEventListener("scroll", function () {
            const header = document.querySelector(".header");
            if (window.scrollY > 50) {
                header.classList.add("shrink"); // 스크롤 내리면 shrink 클래스 추가
            } else {
                header.classList.remove("shrink"); // 맨 위로 올라가면 원래 크기로 복귀
            }
        });

        const appHeader = Vue.createApp({
            data() {
                return {
                    sessionStatus : "${sessionStatus}",
                    sessionId : "${sessionId}"
                };
            },
            methods: {
                fnLogout(){
                    var self = this;
                    var nparmap = {
                    };
                    $.ajax({
                        url:"/member/logout.dox",
                        dataType:"json",	
                        type : "GET", 
                        data : nparmap,
                        success : function(data) { 
                            alert("로그아웃 되었습니다!");
                        }
                        
                    });
                },
                fnCart : function(userId) {
                    pageChange("/cart.do", {userId : userId});
                },
            },
            mounted() {
                const floatingIcon = document.querySelector(".floating-icon img");
                if (floatingIcon && floatingIcon.parentElement) { // 요소가 있는지 확인
                    floatingIcon.parentElement.addEventListener("mouseover", function () {
                        floatingIcon.src = "/img/icon2.png"; // hover 상태 이미지 경로
                    });

                    floatingIcon.parentElement.addEventListener("mouseout", function () {
                        floatingIcon.src = "/img/icon.png"; // 기본 상태 이미지 경로
                    });
                }
            },
        });

        appHeader.mount('#appHeader');
    </script>