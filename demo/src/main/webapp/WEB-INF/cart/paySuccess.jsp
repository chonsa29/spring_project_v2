<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String orderItemsJson = (String) session.getAttribute("orderItems");

    int discountAmount = 0;
    int usedPoint = 0;
    int shippingFee = 0;
    int memberSale = 0; 

    if (session.getAttribute("discountAmount") != null) {
        discountAmount = Integer.parseInt(session.getAttribute("discountAmount").toString());
    }
    if (session.getAttribute("usedPoint") != null) {
        usedPoint = Integer.parseInt(session.getAttribute("usedPoint").toString());
    }
    if (session.getAttribute("shippingFee") != null) {
        shippingFee = Integer.parseInt(session.getAttribute("shippingFee").toString());
    }
    if (session.getAttribute("gradeDiscount") != null) {
        memberSale = Integer.parseInt(session.getAttribute("gradeDiscount").toString());
    }    
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <script src="/js/pageChange.js"></script>
    <link rel="stylesheet" href="/css/pay.css">
    <script type="application/json" id="order-data">
        <%= "{" %>
          "items": <%= orderItemsJson %>,
          "discountAmount": <%= discountAmount %>,
          "usedPoint": <%= usedPoint %>,
          "shippingFee": <%= shippingFee %>,
          "memberSale": <%= memberSale %>
        <%= "}" %>
    </script>
	<title>결제 완료</title>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <div class="complete-wrapper">
            <div class="complete-container">
                <h1 class="txt">결제가 완료되었습니다!</h1>

                <ul class="item-details">
                    <h2 class="txthree">구매 상품</h2>
                    <li class="item-detail" v-for="(item, index) in orderItems" :key="index">
                        <img :src="item.filePath" class="item-img">
                        <div class="item-info">
                            <p class="item-name">{{ item.itemName }}</p><br>
                            <p class="item-quantity">
                                <span class="required-label">필수</span> {{ item.quantity }} 개
                            </p>
                            <p class="item-price">{{ totalProductPrice.toLocaleString() }} 원</p>
                        </div>
                    </li>
                </ul>

                <p class="txtwo">구매해 주셔서 감사합니다.</p>

                <div class="payment-summary">
                    <h2 class="txtfour">결제 정보</h2>
                    <p>총 상품 금액: {{ totalProductPrice.toLocaleString() }} 원</p>
                    <p>할인 금액: - {{ discountAmount.toLocaleString() }} 원</p>
                    <p>사용한 포인트: - {{ usedPoint.toLocaleString() }} 원</p>
                    <p>회원 등급 할인: - {{ memberSale.toLocaleString() }} 원</p>
                    <p>배송비: + {{ shippingFee.toLocaleString() }} 원</p>
                    <p class="item-finalPrice"><strong>최종 결제 금액: {{ finalPayment.toLocaleString() }} 원</strong></p>
                </div>

                <a href="/home.do" class="btn">메인으로 가기</a>
            </div>

            <!-- 오른쪽 추천 상품 -->
            <div class="recommend-side">
                <h3 class="recommend-title">이런 상품은 어때요?</h3>
                <div class="recommend-vertical">
                    <div class="recommend-item" v-for="(item, index) in recommendedItems" :key="index"
                        @click="fnInfo(item.itemNo)">
                    <img :src="item.filePath" class="recommend-thumb">
                    <div class="recommend-info">
                        <p class="recommend-name">{{ item.itemName }}</p>
                        <p class="recommend-price">{{ formatRecommendPrice(item.price) }}원</p>
                    </div>
                </div>
                <button class="btn" @click="loadMore">더보기</button>
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
                orderItems: [],
                discountAmount: 0,
                usedPoint: 0,
                shippingFee: 0,
                recommendedItems: [],
                userId: '<%= session.getAttribute("sessionId") != null ? session.getAttribute("sessionId") : "" %>',
                memberSale: 0,
                likedItems: new Set(),
                showLikePopup: false,
                likeAction: ''
            };
        },
        computed: {
            totalProductPrice() {
                return this.orderItems.reduce((sum, item) => {
                    return sum + (item.price * item.quantity);
                }, 0);
            },
            finalPayment() {
                return this.totalProductPrice - this.discountAmount - this.usedPoint - this.memberSale + this.shippingFee;
            }
        },
        methods: {

            formatRecommendPrice(price) {
                return price.toLocaleString();
            },
            fnInfo(itemNo) {
                pageChange("/product/info.do", { itemNo: itemNo });
            },
            loadMore() {
                location.href="/product.do"
            }
   
        },
        mounted() {
            const jsonData = document.getElementById("order-data").textContent.trim();
            try {
                const parsed = JSON.parse(jsonData);
                this.orderItems = parsed.items;
                this.discountAmount = parsed.discountAmount;
                this.usedPoint = parsed.usedPoint;
                this.shippingFee = parsed.shippingFee;
                this.memberSale = parsed.memberSale;
            } catch (e) {
                console.error("주문 데이터 파싱 오류:", e);
            }

              // 추천 상품 데이터 요청
            fetch("/recommendedProducts.do")
                .then(res => res.json())
                .then(data => {
                    this.recommendedItems = data;
                })
                .catch(err => console.error("추천 상품 요청 실패:", err));
            
            // 팡파레 효과
            confetti({
                particleCount: 200,
                spread: 120,
                origin: { y: 0.6 }
            });

            const container = document.querySelector('.recommend-vertical');
            setInterval(() => {
                const maxScroll = container.scrollHeight - container.clientHeight;
                const currentScroll = container.scrollTop;

                if (currentScroll >= maxScroll) {
                    container.scrollTo({ top: 0, behavior: 'smooth' }); // 다시 위로
                    return;
                }

                container.scrollBy({ top: 160, behavior: 'smooth' });
            }, 3000);

        }
    });
    app.mount('#app');
</script>
​