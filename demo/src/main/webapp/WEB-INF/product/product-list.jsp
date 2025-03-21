
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/style.css">
        <title>첫번째 페이지</title>
    </head>
    <style>
        /* 기본 스타일 설정 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            color: #333;
            margin: 0 0 0 0;
            padding: 0;
            display: flex;
            justify-content: center;
        }

        .product-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: left;
            margin: 30px 0 30px 0;
        }

        .product {
            width: 250px;
            background-color: #fff;
            border-radius: 15px;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
            overflow: hidden;
            transform-origin: center;
            border-radius: 8px;
            margin: 0 10px 0 10px;
            box-shadow: 0 2px 8px #eee;
            padding: 20px;
        }

        .product:hover {
            transform: scale(1.05);
        }

        a {
            text-decoration: none;
            color: black;

        }

        #serach {
            border-radius: 50px;
            border: 1px solid #ccc;
            width: 50%;
            height: 50px;
            margin: 30px 0 30px 0;
        }

        input {
            text-align: center;
        }

        input::placeholder {
            text-align: center;
            padding: 10px;
        }

        input:focus{
            outline : none;
        }

        #name {
            text-align: left;
        }

        .product-image {
            height: 150px;
            background-color: #bbb;
        }

        .product-name,
        .product-price {
            text-align: left;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        #product-count {
            text-align: left;
        }

        #selectproduct {
            font-weight: bold;
            margin-right: 10px;
        }
        #rootname {
            text-align: left;
            color: #bbb;
            margin-bottom: 20px;
        }
    </style>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        
        <div id="app">
            <div id="rootname">
                <div>HOME>PRODUCT</div>
            </div>
            <div id="name">
                <h2>product</h2>
            </div>
            <div>
                <input type="text" placeholder="검색하기" id="serach">
            </div>
            <div id="product-count">
                <span id="selectproduct">전체개수</span>
                <span>(14건)</span>
            </div>

            <div class="product-list">
                <div class="product">
                    <a href="#">
                        <div class="product-image"></div>
                        <h4 class="product-name">이름 : 이름</h4>
                        <p class="product-price">가격 : 15,000원</p>
                    </a>
                </div>
                <br>
                <div class="product">
                    <a href="#">
                        <div class="product-image"></div>
                        <h4 class="product-name">이름 : 이름</h4>
                        <p class="product-price">가격 : 15,000원</p>
                    </a>
                </div>
                <div class="product">
                    <a href="#">
                        <div class="product-image"></div>
                        <h4 class="product-name">이름 : 이름</h4>
                        <p class="product-price">가격 : 15,000원</p>
                    </a>
                </div>
                <div class="product">
                    <a href="#">
                        <div class="product-image"></div>
                        <h4 class="product-name">이름 : 이름</h4>
                        <p class="product-price">가격 : 15,000원</p>
                    </a>
                </div>
                <div class="product">
                    <a href="#">
                        <div class="product-image"></div>
                        <h4 class="product-name">이름 : 이름</h4>
                        <p class="product-price">가격 : 15,000원</p>
                    </a>
                </div>
                <br>

            </div>
            <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
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