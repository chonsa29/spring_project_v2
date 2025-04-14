<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
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
                            <li><a href="/brand.do">회사 소개</a></li>ㅣ
                            <li><a href="/inquire.do?tab=faq">자주 묻는 질문</a></li>ㅣ
                            <li><a href="/inquire.do?tab=qna">문의하기</a></li>
                        </ul>
                    </nav>
                    <div class="copyright"> &copy; {{year}} MEALPICK. All Rights Reserved.</div>
                </div>
            </footer>
        </div>
    </body>
</html>
<script>
    const footer = Vue.createApp({
        data() {
            return {
                year : new Date().getFullYear()
            };
        },
        methods: {
            
        },
        mounted() {

            
        }
    });

    footer.mount('#footer');

</script>
    