<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/payment-style.css">
	<title>첫번째 페이지</title>
</head>
<style>
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h1>결제하기</h1>
            <main>
                <section class="order-section">
                    <section class="order-info">
                        <h2>주문 상품 정보</h2>
                        <div class="product">
                            <img src="/images/product.jpg" alt="상품 이미지">
                            <div class="product-details">
                                <p class="product-name">앤더슨 블랙 보드 텀블러(2가지)</p>
                                <p class="product-price">₩ {{ info.pPrice }}</p>
                                <p class="product-quantity">수량: 1개</p>
                            </div>
                        </div>
                    </section>

                   
                    <section class="shipping">
                        <h2>배송 정보</h2>
                        <input type="text" v-model="shippingAddress" placeholder="배송 주소">
                        <input type="text" v-model="shippingMessage" placeholder="배송 요청 사항">
                    </section>  
                    
                    <section class="coupon">
                        <div>
                            <h2>쿠폰</h2>
                        </div>
                        <input type="text" v-model="coupon" placeholder="쿠폰 입력">
                        <div>
                            <button @click="applyCoupon">쿠폰 적용</button>
                        </div>
                    </section>

                   <section class="point">
                        <div>
                           <h2>포인트</h2> 
                        </div>
                        <input type="text" v-model="point" placeholder="">
                        <div>
                            <button @click="applyPoint">전액 사용</button>
                        </div>
                    </section>


                    <section class="order-details">
                        <h2>주문자 정보</h2>
                        <input type="text" v-model="ordererName" placeholder="이름">
                        <input type="text" v-model="ordererPhone" placeholder="연락처">
                    </section>
                </section>
                
                <section class="payment-section"> 
                    <section class="order-summary">
                        <h2>주문 요약</h2>
                        <div class="summary-details">
                            <p>상품 가격 <span>{{ info.pPrice }}</span></p>
                            <p>배송비 <span>+ 3,000원</span></p>
                            <p class="total-price">총 주문금액 <span>15,900원</span></p>
                        </div>
                    </section>
                  
                    <section class="payment">
                        <h2>결제 수단</h2>
                        <select v-model="paymentMethod">
                            <option value="card">{{ info.pWay }}</option>
                        </select>
                        <button class="pay-btn" @click="fnPayment">결제하기</button>
                    </section>
                </section>
            </main>
        </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
	</div>
</body>
</html>
<script>
    const userCode = "imp12222527"; 
    IMP.init(userCode);
    const app = Vue.createApp({
        data() {
            return {
                pNo: "${map.pNo}",
                info: {},
                sessionId : "${sessionId}"
            };
        },
        methods: {
            fnLogin(){
				var self = this;
				var nparmap = {
				};
				$.ajax({
					url:"login.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
					}
				});
            },
            fnPayment(){
                var self = this;
                IMP.request_pay({
                    pg: "html5_inicis",
                    pay_method: "card",
                    merchant_uid: "merchant_" + new Date().getTime(),
                    name: "테스트 결제",
                    amount: self.info.price,
                    buyer_tel: "010-0000-0000",
                    }	, function (rsp) { // callback
                    if (rsp.success) {
                        // 결제 성공 시
                        alert("성공");
                        console.log(rsp);
                        self.fnSave(rsp.merchant_uid);
                    } else {
                        // 결제 실패 시
                        alert("실패");
                        console.log(rsp);
                    }
                });
            },
            fnSave(merchant_uid) {
                var self = this;
                var nparmap = { 
                    pWay : merchant_uid,
                    userId : self.sessionId,
                    pPrice : self.info.pPrice,
                    pNo : self.info.pNo
                };
                $.ajax({
                    url: "/payment.dox",  
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