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
                    <!-- <div class="swiper-pagination product-pagination"></div> -->
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

                // Swiper 초기화: 데이터 로드 완료 후 실행
                self.$nextTick(() => {
                    self.productSwiper = new Swiper('.product-swiper', {
                    loop: true, // 무한 루프 활성화
                    slidesPerView: "auto", // 컨테이너 크기에 맞게 자동 조절
                    spaceBetween: 20, // 슬라이드 간 간격
                    centeredSlides: true, // 현재 활성화된 슬라이드를 중앙에 배치
                    autoplay: {
                        delay: 3000,
                        disableOnInteraction: false,
                    },
                    pagination: {
                        el: '.product-pagination',
                        clickable: true,
                    },
                    navigation: {
                        nextEl: '.product-next',
                        prevEl: '.product-prev',
                    },
                });


                    console.log('상품 슬라이더 초기화 완료:', self.productSwiper); // 디버깅용 로그
                });
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

            this.fnProductList();
        },
    });

    app.mount('#app');
</script>

    