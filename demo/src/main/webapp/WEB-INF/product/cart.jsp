<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/main.css">
    <title>MEALPICK - 장바구니</title>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
<div id="app">
    <!-- Progress bar -->
    <div class="cart-progress">
        <span>Cart Price</span>
        <span class="progress-bar"><div class="progress-fill"></div></span>
        <span>Free Delivery</span>
    </div>

    <!-- 장바구니 섹션 -->
    <div class="cart-page">
        <h1>장바구니</h1>

        <!-- 상품 리스트 -->
        <ul class="cart-list">
            <li class="cart-item">
                <input type="checkbox" class="select-product">
                <img src="/img/sample-product.jpg" alt="상품 이미지" class="product-img">
                <div class="product-details">
                    <p class="product-name">제품 이름 여세고 저세고</p>
                    <p class="product-description">배송 날짜: <span>2025-03-01</span></p>
                </div>
                <div class="quantity-selector">
                    <button class="quantity-btn">-</button>
                    <input type="text" value="1" class="quantity-input">
                    <button class="quantity-btn">+</button>
                </div>
                <div class="product-price">30,000원</div>
                <button class="remove-btn">X</button>
            </li>
        </ul>

        <!-- 주문 요약 -->
        <div class="order-summary">
            <h2>결제 요약</h2>
            <p>총 상품 금액: <span class="summary-value">30,000원</span></p>
            <p>할인 금액: <span class="summary-value">0원</span></p>
            <p>배송비: <span class="summary-value">2,500원</span></p>
            <p class="total">총 결제 금액: <span class="total-value">32,500원</span></p>
            <button class="checkout-btn">주문하기</button>
        </div>
    </div>
</div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {};
        },
        methods: {},
        mounted() {},
    });

    app.mount('#app');
</script>
