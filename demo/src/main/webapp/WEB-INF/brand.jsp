<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/brand.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
        <title>MealPick - 밀키트 쇼핑몰</title>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">

            <!-- 히어로 이미지 -->
            <div class="hero-container">
                <img src="/img/brand-hero.jpg" alt="메인 이미지" class="hero-bg" />
                <div class="hero-overlay">
                    <div class="hero-centered-box">
                        <div class="hero-content">
                            <img src="/img/icon3.png" alt="아이콘" class="hero-icon" />
                            <h2 class="hero-title">BRAND STORY</h2>
                            <p class="hero-sub">슬로우 에이징을 위한 건강한 한 끼, 웰에이징 밀키트</p>
                            <p class="hero-desc">자연에서 온 건강한 식재료로 몸과 마음을 지키세요.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 브랜드 스토리 01 -->
            <div class="story-section">
                <div class="story-block left">
                    <img src="/img/story1.jpg" alt="story image01" class="story-img" />
                    <div class="story-text">
                        <div class="story-number"><span class="story-line"></span>01</div>
                        <p class="story-paragraph">
                            MEALPICK은 고객의 건강과 웰빙을 최우선으로 생각하는 밀키트 브랜드입니다. 우리의 사명은
                            "슬로우에이징을 위한 건강한 한 끼"를 제공하는 것이며, 자연에서 온 신선한 재료로 여러분의
                            삶을 더 건강하고 젊게 만듭니다.
                        </p>
                        <p class="story-paragraph">
                            MEALPICK은 모든 세대에 맞춤형 밀키트를 제공하여 바쁜 일상 속에서도 건강한 식습관을 유지할 수 있도록 돕습니다.
                        </p>
                    </div>
                </div>
            </div>

            <!-- 브랜드 스토리 02 -->
            <div class="story-section">
                <div class="story-block right">
                    <img src="/img/story2.jpg" alt="story image02" class="story-img" />
                    <div class="story-text">
                        <div class="story-number"><span class="story-line"></span>02</div>
                        <p class="story-paragraph">
                            우리는 고객의 건강을 위해 무첨가, 유기농 원료만을 사용하며,<br>
                            각 연령대에 맞춘 맞춤 메뉴로 여러분의 웰에이징을 지원합니다.
                        </p>
                    </div>
                </div>
            </div>

            <!-- 브랜드 스토리 03 -->
            <div class="story-section">
                <div class="story-block left">
                    <img src="/img/story3.jpg" alt="story image03" class="story-img" />
                    <div class="story-text">
                        <div class="story-number"><span class="story-line"></span>03</div>
                        <p class="story-paragraph">
                            MEALPICK은 바쁜 현대인을 위해 시간을 절약하면서도<br>
                            영양가 있는 균형 잡힌 식사를 제공합니다.
                        </p>
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
                    options: {
                        series: [67.2, 32.8],
                        chart: {
                            width: 380,
                            type: 'pie',
                        },
                        labels: ['노화를 막을 수 있다면 시간과 비용을 투자할 의향이 있다.', 'X'],
                        responsive: [{
                            breakpoint: 480,
                            options: {
                                chart: {
                                    width: 200,
                                },
                                legend: {
                                    position: 'bottom',
                                },
                            },
                        }],
                    },
                };
            },
            methods: {

            },
            mounted() {
                var chart = new ApexCharts(document.querySelector("#chart"), this.options);
                chart.render();
            },
        });

        app.mount('#app');
    </script>