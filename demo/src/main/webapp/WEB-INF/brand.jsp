<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <script src="<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>"></script>
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

            <div class="mychart">
                <div id="chart"></div>
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