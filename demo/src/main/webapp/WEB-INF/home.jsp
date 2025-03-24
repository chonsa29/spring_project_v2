<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/style.css">
        <link rel="stylesheet" href="/css/main.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        
        <title>MealPick - 밀키트 쇼핑몰</title>
    </head>
    <style>
        .product-slider {
            position: relative;
            width: 100%;
            max-width: 600px;
            margin: auto;
            overflow: hidden;
        }

        .slides {
            display: flex;
            transition: transform 0.5s ease-in-out;
        }

        .slides img {
            width: calc(100% / 3);
            /* 화면에 표시할 이미지 개수에 따라 수정 */
            border: 2px solid #fff;
        }

        .navigation {
            position: absolute;
            top: 50%;
            width: 100%;
            display: flex;
            justify-content: space-between;
            transform: translateY(-50%);
        }

        .navigation button {
            background-color: rgba(0, 0, 0, 0.5);
            border: none;
            color: white;
            padding: 10px;
            cursor: pointer;
        }
    </style>

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
            <div class="product-slider">
                <div class="slides" :style="{ transform: `translateX(-${currentIndex * (100 / visibleImages)}%)` }">
                    <img v-for="(image, index) in images" :key="index" :src="image" alt="슬라이드 이미지">
                </div>
                <div class="navigation">
                    <button @click="prevSlide">&#10094;</button>
                    <button @click="nextSlide">&#10095;</button>
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
                    swiper: null, // Swiper 인스턴스를 저장할 변수
                    productSwiper: null, // 상품 슬라이더 인스턴스를 저장할 변수
                    list: [],
                    currentIndex: 0,
                    visibleImages: 3, // 화면에 표시할 이미지 수
                    images: [
                        "image1.jpg",
                        "image2.jpg",
                        "image3.jpg",
                        "image4.jpg",
                        "image5.jpg",
                        "image6.jpg",
                        "image7.jpg",
                        "image8.jpg",
                    ]
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
                },
                nextSlide() {
                    const maxIndex = Math.ceil(this.images.length / this.visibleImages) - 1;
                    this.currentIndex = this.currentIndex === maxIndex ? 0 : this.currentIndex + 1;
                },
                prevSlide() {
                    const maxIndex = Math.ceil(this.images.length / this.visibleImages) - 1;
                    this.currentIndex = this.currentIndex === 0 ? maxIndex : this.currentIndex - 1;
                }
            },
            mounted() {
                // 기존 메인 슬라이더 초기화
                this.swiper = new Swiper('.swiper-container', {
                    loop: true, // 슬라이드 반복
                    autoplay: {
                        delay: 3000, // 자동 재생 시간
                        disableOnInteraction: false, // 사용자 인터랙션 후에도 자동 재생 유지
                    }
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