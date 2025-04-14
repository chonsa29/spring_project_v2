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

            <div class="image-container">
                <img src="/img/brand.jpg" alt="MealPick 로고">
                <div class="logo-wrapper">
                    <div class="logo3">
                        <img src="/img/icon2.png" alt="MealPick 로고">
                    </div>
                    <div class="logo4">
                        <img src="/img/MEALPICK.png" alt="MealPick 로고">
                    </div>
                </div>
                <div class="text-overlay">건강한 한 끼, 젊음에 한 걸음</div>
                <div class="text-overlay2">
                    "슬로우에이징을 위한 건강한 한 끼, 웰에이징 밀키트"<br>
                    ✨ 자연에서 온 건강한 식재료로 몸과 마음을 지키세요.
                </div>
            </div>
            <div class="company-info">
                <h2>MealPick: 건강한 한 끼, 지속 가능한 삶</h2>
                <p>
                    MealPick은 고객의 건강과 웰빙을 최우선으로 생각하는 밀키트 브랜드입니다. 우리의 사명은
                    "슬로우에이징을 위한 건강한 한 끼"를 제공하는 것이며, 자연에서 온 신선한 재료로 여러분의
                    삶을 더 건강하고 젊게 만듭니다. MealPick은 모든 세대에 맞춤형 밀키트를 제공하여 바쁜 일상 속
                    에서도 건강한 식습관을 유지할 수 있도록 돕습니다.
                </p>
                <p class="highlight">
                    우리는 고객의 건강을 위해 무첨가, 유기농 원료만을 사용하며, 각 연령대에 맞춘 맞춤 메뉴로,
                    여러분의 웰에이징을 지원합니다.
                </p>
                <div class="intro-text">
                    MealPick은 바쁜 현대인을 위해 시간을 절약하면서도 영양가 있는 균형 잡힌 식사를 제공합니다.
                </div>

                <div class="values">
                    <div>
                        <i class="fas fa-seedling"></i>
                        <h3>자연에서 온 재료</h3>
                        <p>유기농 원료와 무첨가 제품으로 건강을 지키세요.</p>
                    </div>
                    <div>
                        <i class="fas fa-heart"></i>
                        <h3>맞춤형 식사</h3>
                        <p>연령대와 생활 패턴에 맞춘 최적의 식단을 제공합니다.</p>
                    </div>
                    <div>
                        <i class="fas fa-clock"></i>
                        <h3>편리한 배송</h3>
                        <p>빠르고 편리한 밀키트 배송 서비스로 시간을 절약하세요.</p>
                    </div>
                </div>
            </div>

            <div class="image-container2">
                <div class="introimg">
                    <img src="/img/brand2.jpg" alt="MealPick 로고">
                </div>
                <div class="intro">
                    "건강한 식습관은 웰에이징의 시작입니다."<br>
                    "신선한 재료와 균형 잡힌 영양 설계를 통해 바쁜 현대인을 위한 최적의 한 끼를 제공합니다."
                </div>
            </div>

            <div class="image-container3">
                <div class="intro2">
                    균형 잡힌 영양식 → 단백질·비타민·미네랄 강화<br>
                    연령별 맞춤식 → 30대/40대/50대 추천 메뉴<br>
                    무첨가·유기농 원료 사용
                </div>
                <div class="introimg">
                    <img src="/img/brand3.jpg" alt="MealPick 로고">
                </div>
            </div>

            <!-- <div class="mychart">
                <div id="chart"></div>
                <div class="chart-text">
                    <h3>슬로우에이징을 위한 투자</h3>
                    <p>설문조사 결과, 많은 사람들이 노화를 막기 위해 시간과 비용을 아끼지 않겠다고 답했습니다. 우리 밀키트는 이러한 요구에 맞춰, 건강한 식단을 제공합니다.</p>
                    <p>건강한 식습관을 통해 젊음을 유지하고, 웰에이징을 실현할 수 있습니다. MealPick은 여러분의 슬로우에이징을 지원합니다.</p>
                </div>
            </div>   -->

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