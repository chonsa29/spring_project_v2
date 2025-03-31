<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>"></script>
    <link rel="stylesheet" href="/css/pay.css">
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
	<title>결제 페이지</title>
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
                        <h2 class="text">주문 상품 정보</h2>
                        <div class="product">
                            <img :src="info.filePath">
                            <div class="product-details">
                                <p class="product-name">{{ info.itemName }}</p>
                                <p class="product-price">₩ {{ info.Price }}</p>
                                <p class="product-quantity">수량: {{ info.itemCount }}</p>
                            </div>
                        </div>
                    </section>
                    
                    <section class="shipping">
                        <h2 class="text">배송 정보</h2>
                        <input type="checkbox"> 주문자 정보와 동일
                        <input type="text" v-model="" placeholder="주소">
                        <input type="text" v-model="" placeholder="상세 주소">
                        <div>
                            <h2 class="text">배송 메모</h2>
                        </div>
                        <div>
                            <select v-model="paymentMethod">
                                <option value="one">배송 메모를 선택해 주세요.</option>
                                <option value="two">배송 전에 미리 연락 바랍니다.</option>
                                <option value="three">부재 시 경비실에 맡겨 주세요.</option>
                                <option value="four">부재 시 전화나 문자 남겨 주세요.</option>
                                <option value="five">직접 입력</option>
                            </select>
                            <input type="text"
                                v-if="paymentMethod === 'five'" 
                                ref="shippingInput" 
                                v-model="shippingMessage" 
                                placeholder="배송 메모를 입력해 주세요.">
                        </div>
                        
                    </section>  
                    
                    <section class="coupon">
                        <div>
                            <h2 class="text">쿠폰</h2>
                        </div>
                        <input type="text" v-model="coupon" placeholder="쿠폰 코드를 입력해 주세요">
                        <div>
                            <button @click="applyCoupon">코드 확인</button>
                        </div>
                    </section>

                   <section class="point">
                        <div>
                           <h2 class="text">포인트</h2> 
                        </div>
                        <input type="text" v-model="point" placeholder="0">
                        <div>
                            <button @click="applyPoint">전액 사용</button>
                        </div>
                        <div>
                            사용 가능 포인트 1000 / 보유 포인트 1000
                        </div>
                    </section>

                    <section class="order-details">
                        <h2 class="text">주문자 정보</h2>
                        <input type="text" v-model="ordererName" placeholder="이름">
                        <input type="text" v-model="ordererPhone" placeholder="연락처">
                    </section>
                </section>
                
                <section class="payment-section"> 
                    <section class="order-summary">
                        <h2 class="text">주문 요약</h2>
                        <div class="summary-details">
                            <p>상품 가격 <span>{{ info.pPrice }}</span></p>
                            <p>배송비 <span>+ 3,000원</span></p>
                            <p class="total-price">총 주문금액 <span>15,900원</span></p>
                        </div>
                    </section>
                  
                    <section class="payment">
                        <h2 class="text">결제 수단</h2>
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
                itemNo: "${map.itemNo}",
                info: {},
                sessionId : "${sessionId}",
                paymentMethod: "one", 
                shippingMessage: ""
            };
        },
        methods: {
            fnPay(){
				var self = this;
				var nparmap = { itemNo: self.itemNo };
				$.ajax({
					url:"/pay.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
                        self.info = data.info;
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
                    amount: self.info.pPrice,
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
                    pUid : self.sessionId,
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
            },
        },
        watch: {
            paymentMethod(newVal) {
                if (newVal === "five") {
                    this.$nextTick(() => {
                        this.$refs.shippingInput?.focus();
                    });
                }
            }
        },
        mounted() {
            var self = this;
            self.fnPay();
        }
    });
    app.mount('#app');
</script>
​