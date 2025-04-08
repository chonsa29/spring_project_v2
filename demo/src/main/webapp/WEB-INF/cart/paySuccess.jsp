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
    <script src="/js/pageChange.js"></script>
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
                    <div class="recommend-buttons">
                        <button @click.stop="fnCart(item.itemNo, userId)">🛒</button>
                        <button @click.stop="fnLike(item.itemNo)">❤</button>
                    </div>
                </div>
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
                userId : "${sessionId}",
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

            formatRecommendPrice(price) {
                return price.toLocaleString();
            },
            fnCart(itemNo, userId) {
                if (!userId) {
                alert("로그인이 필요합니다.");
                return;
                }

                const nparmap = {
                    itemNo: itemNo,
                    userId: userId
                };

                $.ajax({
                    url: "/cart/add.dox", // 예시 URL (서버에서 이 URL로 장바구니 처리)
                    type: "POST",
                    data: nparmap,
                    dataType: "json",
                    success: function(data) {
                        if (data.result === "success") {
                            alert("장바구니에 담겼습니다!");
                            window.location.href = '/cart.do';
                        } else {
                            alert("장바구니 담기 실패!");
                        }
                    },
                    error: function() {
                        alert("서버 요청 실패");
                    }
                })
            },
            fnLike(itemNo) {
                var self = this;

                if (!self.userId) {
                    // 로그인 페이지로 리디렉션
                    alert("로그인 후 이용가능합니다."); // 로그인 페이지 경로
                    return; // 이후 코드 실행 방지
                }
                var nparmap = {
                    itemNo: itemNo,
                    userId: self.userId
                };
                console.log(itemNo);
                console.log(self.userId);

                // 서버에 요청 보내기 (좋아요 추가 또는 취소)
                $.ajax({
                    url: "/product/likeToggle.dox",  // 서버의 엔드포인트 (좋아요 추가/취소 처리)
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        if (data.result == "a") {  // 좋아요 추가
                            if (!self.likedItems.has(itemNo)) {
                                self.likedItems.add(itemNo);  // 좋아요 추가
                                self.showLikePopup = true;
                                self.likeAction = 'add';
                                setTimeout(() => {
                                    self.showLikePopup = false;
                                }, 2000);
                            }
                        } else if (data.result == "c") {  // 좋아요 취소
                            if (self.likedItems.has(itemNo)) {
                                self.likedItems.delete(itemNo);  // 좋아요 취소
                                self.likeAction = 'remove';
                                self.showLikePopup = false;
                            }
                        } else {
                            console.error("좋아요 처리 실패", data.message);
                        }
                    },
                    error: function () {
                        console.error("AJAX 요청 실패");
                    }
                });
            },
            fnInfo(itemNo) {
                pageChange("/product/info.do", { itemNo: itemNo });
            },
   
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

            setInterval(() => {
                const container = document.querySelector('.recommend-vertical');
                container.scrollBy({ top: 160, behavior: 'smooth' });
            }, 3000);

        }
    });
    app.mount('#app');
</script>
​