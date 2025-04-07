<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String orderItemsJson = (String) session.getAttribute("orderItems");

    int discountAmount = 0;
    int usedPoint = 0;
    int shippingFee = 0;

    if (session.getAttribute("discountAmount") != null) {
        discountAmount = Integer.parseInt(session.getAttribute("discountAmount").toString());
    }
    if (session.getAttribute("usedPoint") != null) {
        usedPoint = Integer.parseInt(session.getAttribute("usedPoint").toString());
    }
    if (session.getAttribute("shippingFee") != null) {
        shippingFee = Integer.parseInt(session.getAttribute("shippingFee").toString());
    }
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <script type="application/json" id="order-data">
        <%= "{" %>
          "items": <%= orderItemsJson %>,
          "discountAmount": <%= discountAmount %>,
          "usedPoint": <%= usedPoint %>,
          "shippingFee": <%= shippingFee %>
        <%= "}" %>
    </script>
    <link rel="stylesheet" href="/css/pay.css">
	<title>결제 완료</title>
</head>
<style>
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <div class="complete-container">
            <h1 class="txt">결제가 완료되었습니다!</h1>
            <p class="txtwo">구매해 주셔서 감사합니다.</p>

           
            <ul class="item-details">
                <h2 class="txthree">주문하신 상품</h2>
                <li class="item-detail" v-for="(item, index) in orderItems" :key="index">
                    <img :src="item.filePath" class="item-img">
                    <div class="item-info">
                        <p class="item-name">{{ item.itemName }}</p><br>
                        <p class="item-quantity">
                            <span class="required-label">필수</span> {{ item.quantity }} 개
                        </p>
                        <p class="item-price">{{ finalPayment.toLocaleString() }} 원</p>
                    </div>
                </li>
            </ul>

            <a href="/home.do" class="btn">메인으로 가기</a>
        </div>
	</div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                orderItems: [],
                discountAmount: 0,
                usedPoint: 0,
                shippingFee: 0
            };
        },
        computed: {
            totalProductPrice() {
                return this.orderItems.reduce((sum, item) => {
                    return sum + (item.price * item.quantity);
                }, 0);
            },
            finalPayment() {
                return this.totalProductPrice - this.discountAmount - this.usedPoint + this.shippingFee;
            }
        },
        methods: {
   
        },
        mounted() {
            const jsonData = document.getElementById("order-data").textContent.trim();
            try {
                const parsed = JSON.parse(jsonData);
                this.orderItems = parsed.items;
                this.discountAmount = parsed.discountAmount;
                this.usedPoint = parsed.usedPoint;
                this.shippingFee = parsed.shippingFee;
            } catch (e) {
                console.error("주문 데이터 파싱 오류:", e);
            }
            
            // 팡파레 효과
            confetti({
                particleCount: 200,
                spread: 120,
                origin: { y: 0.6 }
            });

            console.log("items:", this.orderItems);
            console.log("discountAmount:", this.discountAmount);
            console.log("usedPoint:", this.usedPoint);
            console.log("shippingFee:", this.shippingFee);
            console.log("totalProductPrice:", this.totalProductPrice);
            console.log("finalPayment:", this.finalPayment);

        }
    });
    app.mount('#app');
</script>
​