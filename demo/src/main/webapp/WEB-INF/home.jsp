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
        <div id="app">
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
    
            <div class="product-section">
                <h2 class="product-title">PRODUCT(슬라이드 기능 구현)</h2>
                <div class="product-container">
                    <div class="product-box">상품 1</div>
                    <div class="product-box">상품 2</div>
                    <div class="product-box">상품 3</div>
                    <div class="product-box">상품 4</div>
                    <div class="product-box">상품 5</div>
                </div>
            </div>
    
            <div class="plan-section">
                <div class="plan-card">
                    <h3>비회원</h3>
                    <ul>
                        <li>✅ 혜택</li>
                        <li>✅ 혜택</li>
                    </ul>
                    <p class="price">0 원</p>
                    <button class="btn green">현재 선택</button>
                </div>
                <div class="plan-card">
                    <h3>플랜1</h3>
                    <ul>
                        <li>✅ 혜택</li>
                        <li>✅ 혜택</li>
                        <li>✅ 혜택</li>
                    </ul>
                    <p class="price">15,000 원</p>
                    <button class="btn blue">구입하기</button>
                </div>
                <div class="plan-card">
                    <h3>플랜2</h3>
                    <ul>
                        <li>✅ 혜택</li>
                        <li>✅ 혜택</li>
                        <li>✅ 혜택</li>
                        <li>✅ 혜택</li>
                    </ul>
                    <p class="price">30,000 원</p>
                    <button class="btn orange">구입하기</button>
                </div>
            </div>
    
            <div class="floating-icon">
                <img src="/img/icon.png" alt="아이콘">
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
            // Swiper 초기화
            this.swiper = new Swiper('.swiper-container', {
                loop: true, // 슬라이드 반복
                autoplay: {
                    delay: 3000, // 자동 재생 시간
                    disableOnInteraction: false, // 사용자 인터랙션 후에도 자동 재생 유지
                },
                pagination: {
                    el: '.swiper-pagination', // 페이지네이션 요소
                    clickable: true, // 페이지네이션 클릭 가능
                },
                navigation: {
                    nextEl: '.swiper-button-next.custom', // next 버튼에 custom 클래스 포함
                    prevEl: '.swiper-button-prev.custom', // prev 버튼에 custom 클래스 포함
                },
            });
            console.log("Swiper 초기화 완료:", this.swiper); // 디버깅용 로그

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

    app.mount('#app');

</script>
    