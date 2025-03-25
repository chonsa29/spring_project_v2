<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/brand.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <title>MealPick - 밀키트 쇼핑몰</title>
    </head>
    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            
            <div class="introduce">
                <div class="logo3">
                    <img src="/img/icon.png" alt="MealPick 로고">
                </div>
                <div class="logo4">
                    <img src="/img/MEALPICK.png" alt="MealPick 로고">
                </div>
                <h2 style="margin-bottom: 20px;">건강한 한 끼, 젊음에 한 걸음</h2>
                <span>- 밀픽은 저속노화 트렌드와 함께 건강한 식단에 대한 수요가 증가하는 시장 변화에 발맞춰, 
                    개인의 건강 상태와 선호도에 맞춘 맞춤형 건강 밀키트를 제공하고 있습니다. 
                    회원별 알레르기 및 비선호 식품을 고려한 식단 구성, 회원 등급 및 그룹 구매 혜택, 
                    충전형 결제 시스템, 그리고 건강 커뮤니티 운영 등을 통해 소비자들에게 차별화된 가치를 제공합니다. 
                    지속가능하고 건강한 삶을 지원하는 다양한 서비스를 개발하고 있습니다.</span>
            </div>
            <div>
                <img src="/img/intro.jpg" alt="MealPick 로고">
            </div>
            <div>
                <img src="/img/intro2.jpg" alt="MealPick 로고">
            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                
            };
        },
        methods: {
            
        },
        mounted() {
            
        },
    });

    app.mount('#app');
</script>