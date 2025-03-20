<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <title>MealPick - 밀키트 쇼핑몰</title>
    </head>
    <body>
        <div id="header">
            <header class="header">
                <div class="logo">
                    <img src="/img/icon.png" alt="MealPick 로고">
                </div>
                <div class="logo2">
                    <img src="/img/MEALPICK.png" alt="MealPick 로고">
                </div>
                <nav class="nav">
                    <a href="#">MENU1</a>
                    <a href="#">MENU2</a>
                    <a href="#">BRAND</a>
                    <a href="#">PRODUCT</a>
                    <a href="#">GRADE</a>
                </nav>
            </header>
    
            <div class="floating-icon">
                <img src="/img/icon.png" alt="아이콘">
            </div>
        </div>
    </body>
</html>
<script>
    const header = Vue.createApp({
        data() {
            return {
                
            };
        },
        methods: {
            
        },
        mounted() {

            // Floating 아이콘 hover 이벤트 추가
            const floatingIcon = document.querySelector(".floating-icon img");

            // 마우스를 올렸을 때 이미지 변경
            floatingIcon.parentElement.addEventListener("mouseover", function () {
                floatingIcon.src = "/img/icon2.png"; // hover 상태 이미지 경로
            });

            // 마우스를 뗐을 때 원래 이미지 복원
            floatingIcon.parentElement.addEventListener("mouseout", function () {
                floatingIcon.src = "/img/icon.png"; // 기본 상태 이미지 경로
            });
        }
    });

    header.mount('#app');

</script>
    