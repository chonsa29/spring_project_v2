<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/product-css/product-info.css">
    </head>
    <style>

    </style>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div id="root">
                <a href="/home.do">HOME</a> > <a href="/product.do">PRODUCT</a> > {{info.itemName}}
            </div>
            <div class="info-container">
                <div id="product-box">
                    <img :src="info.filePath" alt="info.itemName" class="product-mainimg">
                </div>
                <div class="subimg-container">
                    <div class="subimg"></div>
                    <div class="subimg"></div>
                    <div class="subimg"></div>
                </div>
                <div id="product-Info">
                    <div id="item-Info">{{info.itemInfo}}</div>
                    <div id="product-name">{{info.itemName}}</div>
                    <span v-if="allergensFlg" id="allergens-info">{{info.allergens}} 주의!</span>
                    <div id="review">
                        <span class="stars">★★★★★</span>
                        <span>4.3</span>
                    </div>
                    <div class="price">{{price}}</div>
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
                            <b style="font-size: 16px;" id="day"></b> 도착
                        </div>
                    </div>

                    <div class="quantity-container">
                        <div class="quantity-box">
                            <span>{{info.itemName}}</span>
                            <div class="quantity-controls">
                                <button class="quantity-btn" @click="fnquantity('sub')">-</button>
                                <input type="text" class="quantity-input" v-model="quantity">
                                <button class="quantity-btn" @click="fnquantity('sum')">+</button>
                            </div>
                            <span class="quantity-price">{{price * quantity}}</span>
                        </div>
                    </div>

                    <!-- 합계 -->
                    <div class="total">
                        <span>합계</span>
                        <span id="price-total">{{price * quantity}}</span>
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

        // 배송날짜
        setInterval(() => {
            let NowDate = new Date();
            let month = NowDate.getMonth() + 1;  // 월
            let date = NowDate.getDate() + 3;  // 날짜
            let day = month + "월 " + date + "일";
            let obj = document.getElementById("day");
            obj.innerHTML = day;
        }, 1000);


        const app = Vue.createApp({
            data() {
                return {
                    itemNo: "${map.itemNo}",
                    info: {},
                    quantity: 1,
                    allergensFlg: false,
                    count: 0,
                    price : 0,
                };
            },
            methods: {
                fngetInfo() {
                    var self = this;
                    var nparmap = {
                        itemNo: self.itemNo
                    };
                    $.ajax({
                        url: "/product/info.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result == "success") {
                                self.info = data.info;
                                self.count = data.count;
                                self.price = data.info.price

                                if (data.info.allergens != "없음") {
                                    self.allergensFlg = true;
                                }

                            }
                        },
                    });
                },
                fnquantity: function (action) {
                    var self = this;
                    console.log(self.count);
                    if (action === 'sum') {
                        if (self.quantity < self.count) {
                            self.quantity++;
                        } else {
                            alert("최대 수량입니다.");
                            return;
                        }
                    } else if (action === 'sub' && self.quantity > 1) {
                        self.quantity--;

                    }
                }
            },
            mounted() {
                var self = this;
                self.fngetInfo();
            }
        });
        app.mount('#app');
    </script>
    ​