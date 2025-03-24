<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/product-info.css">
        <title>첫번째 페이지</title>
    </head>
    <style>

    </style>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div id="root">
                HOME > PRODUCT > PRODUCT-TYPE
            </div>
            <div class="info-container">
                <div id="product-box">
                </div>
                <div class="subimg-container">
                    <div class="subimg"></div>
                    <div class="subimg"></div>
                    <div class="subimg"></div>
                </div>
                <div id="product-Info">
                    <div id="product-name">상품 이름</div>
                    <div id="review">
                        <span class="stars">★★★★★</span>
                        <span>4.3</span>
                    </div>
                    <div class="price">₩15,000</div>
                    <div class="delivery">
                        <span id="delivery-price">배송비</span>
                        <span id="delicery-total">3,000원 </span>
                        <span> / 30,000원 이상 구매시 무료</span>
                    </div>

                    <div id="delivery-info">
                        <div id="delivery-day">
                            배송정보
                        </div>
                        <div>
                            오전 12시 이전 구매시
                            <b style="font-size: 16px;">3월 26일</b> 도착
                        </div>
                    </div>

                    <!-- 수량 체크 박스-->
                    <div class="quantity-container">
                        <div class="quantity-box">
                            <span>상품 이름</span>
                            <div class="quantity-controls">
                                <button class="quantity-btn">-</button>
                                <input type="text" class="quantity-input" value="1">
                                <button class="quantity-btn">+</button>
                            </div>
                            <span class="quantity-price">18,000</span>
                        </div>
                    </div>

                    <!-- 합계 -->
                    <div class="total">
                        <span>합계</span>
                        <span>₩18,000</span>
                    </div>

                    <!-- 좋아요, 장바구니, 구매하기 박스-->
                    <div class="buttons">
                        <button class="like">❤</button>
                        <button class="cart">장바구니</button>
                        <button class="buy">
                            <a href="#">
                                구매하기
                            </a>
                        </button>
                    </div>
                </div>
            </div>
            <div id="product-view">
                <div id="product-menu">
                    <div class="Info">상품 정보</div>
                    <div class="Review">상품 리뷰</div>
                    <div class="Inquiry">상품 문의</div>
                    <div class="Exchange-Return">교환/환불</div>
                </div>
                <div id="product-view-img">

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