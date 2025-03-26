<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        <!-- 메인 슬라이더 -->
        <div class="slider">
            <div class="swiper-container main-swiper">
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
                <div class="swiper-button-prev main-prev"></div>
                <div class="swiper-button-next main-next"></div>
            </div>
        </div>

        <!-- 새 상품 섹션 슬라이더 -->
        <div class="product-section">
            <div class="title-container">
                <h2 class="product-title">베스트 상품</h2>
                <h4>한 주 동안 많이 팔린 제품</h4>
            </div>
            <div class="swiper-container product-swiper">
                <div class="swiper-wrapper">
                    <div class="swiper-slide product-box" v-for="item in list">
                        <img :src="item.filePath" alt="상품">
                        <div class="product-info">
                            <span class="product-name">{{ item.itemName }}</span>
                            <span class="product-price">{{ item.price }}원</span>
                        </div>
                    </div>
                </div>
                <!-- 네비게이션 버튼 -->
                <div class="swiper-button-prev product-prev"></div>
                <div class="swiper-button-next product-next"></div>
            </div>
        </div>

        <!-- 이번 달 추천 상품 섹션 -->
        <div class="monthly-pick">
            <div class="monthly-banner">
                <img src="/img/main4.png" alt="추천 상품 배너">
            </div>
            <div class="monthly-products">
                <div class="product-box1" v-for="item in monthlyList">
                    <img :src="item.filePath" alt="상품 이미지">
                    <p class="product-name">{{ item.name }}</p>
                    <p class="product-price">{{ item.price.toLocaleString() }}원</p>
                </div>
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
            swiper: null, // 메인 슬라이더 인스턴스
            productSwiper: null, // 상품 슬라이더 인스턴스
            list: [],
            sessionStatus: "${sessionStatus}",
            userId: "${sessionId}",
            monthlyList: []
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

                    // 데이터가 반영된 후 Swiper 초기화
                    self.$nextTick(() => {
                        if (self.productSwiper) {
                            self.productSwiper.destroy(); // 기존 인스턴스 제거
                        }
                        self.productSwiper = new Swiper('.product-swiper', {
                            loop: true,
                            slidesPerView: "auto",
                            spaceBetween: 20,
                            centeredSlides: true,
                            autoplay: {
                                delay: 3000,
                                disableOnInteraction: false,
                            },
                            navigation: {
                                nextEl: '.product-next',
                                prevEl: '.product-prev',
                            },
                        });

                        console.log('상품 슬라이더 초기화 완료:', self.productSwiper);
                    });
                },
            });
        },
        fnMonthlyPick() {
            let self = this;
            $.ajax({
                url: "/main/list.dox",
                dataType: "json",
                type: "POST",
                success: (data) => {
                    console.log("이번 달 추천 상품:", data);
                    self.monthlyList = data.list;
                }
            });
        }
    },
    mounted() {
        console.log(this.sessionStatus);
        console.log(this.userId);

        // 메인 슬라이더 초기화
        this.swiper = new Swiper('.main-swiper', {
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
                nextEl: '.main-next',
                prevEl: '.main-prev',
            },
        });

        // 상품 리스트 가져와서 Swiper 적용
        this.fnProductList();
        this.fnMonthlyPick();
    },
});

app.mount('#app');
</script>