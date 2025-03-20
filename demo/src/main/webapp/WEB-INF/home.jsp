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
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
    
            <!-- 기존 메인 슬라이더 -->
            <div class="slider">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <img src="/img/main1.jpg" alt="슬라이드 이미지 1">
                        </div>
                        <div class="swiper-slide">
                            <img src="/img/main2.jpg" alt="슬라이드 이미지 2">
                        </div>
                        <div class="swiper-slide">
                            <img src="/img/main3.jpg" alt="슬라이드 이미지 3">
                        </div>
                    </div>
                    <!-- 페이지네이션 -->
                    <div class="swiper-pagination"></div>
                    <!-- 네비게이션 버튼 -->
                    <div class="swiper-button-prev custom"></div>
                    <div class="swiper-button-next custom"></div>
                </div>
            </div>

            <!-- 새 상품 섹션 슬라이더 -->
            <div class="product-section">
                <h2 class="product-title">PRODUCT(슬라이드 기능 구현)</h2>
                <div class="swiper-container product-swiper">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide product-box">
                            <img src="/img/product1.jpg" alt="상품 1">
                        </div>
                        <div class="swiper-slide product-box">
                            <img src="/img/product2.jpg" alt="상품 2">
                        </div>
                        <div class="swiper-slide product-box">
                            <img src="/img/product3.jpg" alt="상품 3">
                        </div>
                        <div class="swiper-slide product-box">
                            <img src="/img/product4.jpg" alt="상품 4">
                        </div>
                        <div class="swiper-slide product-box">
                            <img src="/img/product5.jpg" alt="상품 5">
                        </div>
                    </div>
                    <!-- 페이지네이션 -->
                    <div class="swiper-pagination product-pagination"></div>
                    <!-- 네비게이션 버튼 -->
                    <div class="swiper-button-prev product-prev"></div>
                    <div class="swiper-button-next product-next"></div>
                </div>
            </div>
    
            
    
        </div>
    </body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                swiper: null // Swiper 인스턴스를 저장할 변수
            };
        },
        methods: {
            // 향후 Swiper 관련 메서드를 추가할 공간
        },
        mounted() {
            // 기존 메인 슬라이더 초기화
            new Swiper('.swiper-container', {
                loop: true,
                autoplay: {
                    delay: 3000,
                    disableOnInteraction: false,
                },
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                },
                navigation: {
                    nextEl: '.swiper-button-next.custom',
                    prevEl: '.swiper-button-prev.custom',
                },
            });

            // 상품 슬라이더 초기화
            new Swiper('.product-swiper', {
                loop: true,
                slidesPerView: 5, // 화면에 보이는 슬라이드 수
                spaceBetween: 20, // 슬라이드 간 간격
                pagination: {
                    el: '.product-pagination', // 상품 섹션 페이지네이션
                    clickable: true,
                },
                navigation: {
                    nextEl: '.product-next', // 상품 섹션 다음 버튼
                    prevEl: '.product-prev', // 상품 섹션 이전 버튼
                },
                autoplay: {
                    delay: 3000,
                    disableOnInteraction: false,
                },
            });

        }
    });

    app.mount('#app');

</script>
    