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
        <div id="footer">
            <footer class="footer">
                <div class="container">
                    <h2>MEALPICK</h2>
                    <p>건강과 편리를 위한 최고의 선택</p>
                    <nav>
                        <ul>
                            <li><a href="/about">회사 소개</a></li>ㅣ
                            <li><a href="/community">고객센터</a></li>ㅣ
                            <li><a href="/faq">자주 묻는 질문</a></li>ㅣ
                            <li><a href="/contact">문의하기</a></li>
                        </ul>
                    </nav>
                    <div class="copyright">&copy; <script>document.write(new Date().getFullYear());</script> MEALPICK. All Rights Reserved.</div>
                </div>
            </footer>
        </div>
    </body>
</html>
<script>
    const header = Vue.createApp({
        data() {
            return {
                
            };
        },
        methods: {
            
        },
        mounted() {

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

    header.mount('#app');

</script>
    