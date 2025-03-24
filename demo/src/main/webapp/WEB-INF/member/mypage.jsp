<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/member-css/mypage.css">
        <title>첫번째 페이지</title>
    </head>
    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div class="user-container">
                <div class="user-info">
                    <div class="user-details">
                        <p>등급: <span>></span></p>
                        <p>그룹: 없음</p>
                        <p>포인트: <button>충전하기</button></p>
                        <p>쿠폰: 쿠폰</p>
                        <p>주문내역: <span>></span></p>
                    </div>
                    <div class="user-profile">
                        <img src="../../img/profile_sample.png" alt="사용자 프로필">
                        <p>사용자 이름</p>
                    </div>
                </div>
                <div class="shipping-status">
                    <div>주문 확인</div>
                    <div>배송 중</div>
                    <div>배송 완료</div>
                </div>
                <div class="user-like-product">
                    <div></div>
                    <div></div>
                    <div></div>
                    <div></div>
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
                    userId: "",
                    pwd: ""
                };
            },
            methods: {
                fnLogin() {
                    var self = this;
                    var nparmap = {
                    };
                    $.ajax({
                        url: "login.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                        }
                    });
                }
            },
            mounted() {
                var self = this;
            }
        });
        app.mount('#app');
    </script>
    ​