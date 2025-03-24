<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <title>첫번째 페이지</title>
    </head>
    <style>

        #root {
            margin : 0 0 30px 18vw;
            text-align: left;
        }

        .info-container {
            display: flex;
            gap: 10px;
            max-width: 1200px;
            margin: 0 0 50px 18vw;
        }

        #product-box {
            width: 500px;
            height: 500px;
            background-color: #ddd;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
        }

        .subimg-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-right: 50px;
        }

        .subimg {
            width: 80px;
            height: 80px;
            background-color: #aaa;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 12px;
            font-weight: bold;
            text-align: center;
            margin: 0 0 10px 10px;
        }

        #product-Info {
            margin-left: 50px;
        }


        #product-Info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            text-align: left;
        }

        #product-name {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .stars {
            color: #272727;
            font-size: 30px;
            margin-bottom: 30px;
            margin-right: 10px;
        }

        .price {
            font-size: 20px;
            font-weight: bold;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .delivery {
            display: flex;
            font-size: 14px;
            color: #ccc;
            margin-bottom: 15px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }

        #delicery-total {
            font-weight: bold;
            color: #ccc;
            margin-right: 5px;
        }

        #delivery-price {
            margin-right: 30px;
        }

        #delivery-info {
            display: flex;
            font-size: 14px;
            color: #000000;
            margin-bottom: 15px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            display: flex;
            flex-direction: column;
        }

        #delivery-day {
            border: 2px solid black;
            width: 80px;
            padding: 3px;
            border-radius: 30px;
            background-color: #fff;
            text-align: center;
            margin-bottom: 10px;

        }

        /* 수량 체크 css */

        .quantity-container {
            width: 100%;
            display: flex;
            justify-content: flex-start;
            margin-bottom: 20px;
        }

        .quantity-box {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 400px;
            background-color: #eee;
            padding: 10px 15px;
            border-radius: 8px;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
        }

        .quantity-btn {
            width: 30px;
            height: 30px;
            border: none;
            background-color: #ddd;
            font-size: 16px;
            cursor: pointer;
            margin: 0 5px;
            border-radius: 4px;
        }

        .quantity-btn:hover {
            background-color: #ccc;
        }

        .quantity-input {
            width: 40px;
            text-align: center;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .quantity-price {
            font-weight: bold;
        }

        .total {
            display: flex;
            justify-content: space-between;
            font-size: 18px;
            font-weight: bold;
            /* border-top: 1px solid #ddd; */
            padding-top: 10px;
        }

        .buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .buttons button {
            flex: 1;
            padding: 15px;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }


        .like {
            background: #ffffff;
            color: #ccc;
        }

        .like:active {
            color: red;
        }

        .cart {
            background: #ddd;
        }

        .cart:hover {
            font-weight: bold;
        }

        .buy {
            background: black;
            color: white;
        }

        .buy:hover {
            font-weight: bold;
        }

        .buy>a {
            text-decoration: none;
            color: white;
        }

        #product-view{
            margin-top: 30px;
        }

        #product-menu {
            display: flex;
            margin: 30px 0 30px 5vw;
            justify-content: space-around;
            align-items: center;
        }

        #product-view-img {
            width: 1300px;
            height: 800px;
            background-color: #aaa;
            margin-left: 18vw;
        }



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