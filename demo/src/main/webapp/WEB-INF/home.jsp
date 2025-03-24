<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/style.css">
        <link rel="stylesheet" href="/css/main.css">
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
                        <div class="swiper-slide product-box" v-for="item in list">
                            <img src="/img/menu.jpg" alt="상품 1">
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
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                swiper: null, // Swiper 인스턴스를 저장할 변수
                productSwiper: null, // 상품 슬라이더 인스턴스를 저장할 변수
                list: []
            };
        },
        methods: {
            fnProductList() {
                let self = this;

                $.ajax({
                    url: "/main/list.dox",
                    dataType: "json",
                    type: "POST",
                    success: (data) => {
                        console.log(data);
                        self.list = data.list;
                    },
                });
            }
        },
        mounted() {
            // 기존 메인 슬라이더 초기화
            this.swiper = new Swiper('.swiper-container', {
                loop: true, // 슬라이드 반복
                autoplay: {
                    delay: 3000, // 자동 재생 시간
                    disableOnInteraction: false, // 사용자 인터랙션 후에도 자동 재생 유지
                },
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true, // 페이지네이션 클릭 가능
                },
                navigation: {
                    nextEl: '.swiper-button-next.custom',
                    prevEl: '.swiper-button-prev.custom',
                },
            });

            // 상품 슬라이더 초기화
            this.productSwiper = new Swiper('.product-swiper', {
                loop: false, // 복제 슬라이드 제거
                slidesPerView: 4, // 한 화면에 보이는 슬라이드 수
                spaceBetween: 20,
                autoplay: {
                    delay: 3000,
                    disableOnInteraction: false,
                    stopOnLastSlide: false,
                },
                pagination: {
                    el: '.product-pagination',
                    clickable: true,
                    type: 'bullets',
                    dynamicBullets: true,
                },
                navigation: {
                    nextEl: '.product-next',
                    prevEl: '.product-prev',
                },
            });

            this.fnProductList();
        },
    });

    app.mount('#app');
</script>

    