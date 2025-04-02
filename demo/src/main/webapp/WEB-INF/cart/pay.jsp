<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link rel="stylesheet" href="/css/pay.css">
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script src="/js/pageChange.js"></script>
	<title>결제 페이지</title>
</head>
<style>
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h1 class="pay-text">결제하기</h1>
            <main>
                <section class="order-section">
                    <section class="order-info">
                        <h2 class="text">주문 상품 정보</h2>
                        <div class="product" v-if="productInfo && productInfo.filePath">
                            <img :src="productInfo.filePath">
                            <div class="product-details">
                                <p class="product-name">{{ productInfo.itemName }}</p>
                                <p class="product-quantity">
                                    <span class="required-label">필수</span> {{ productInfo.quantity }}
                                </p>
                                <p class="product-price">{{ productInfo.price }} 원</p>
                            </div>
                        </div>
                         <div class="delivery-info">
                            <p>배송비 3,000 원</p>
                        </div>
                    </section>

                    <section class="order-details">
                        <h2 class="text">주문자 정보</h2>
                        <input type="text" class="pay_ordererName" v-model="memberInfo.userName" placeholder="이름">
                        <input type="text" class="pay_ordererPhone" v-model="memberInfo.phone" placeholder="연락처">
                    </section>

                    <section class="shipping">
                        <h2 class="text">배송 정보</h2>
                        <input type="text" class="pay_address" v-model="memberInfo.address" placeholder="주소">
                        <input type="text" class="pay_detailAddress" placeholder="상세 주소">
                    </section>  

                    <section class="shipping-memo">
                        <div>
                            <h2 class="text">배송 메모</h2>
                        </div>
                        <div>
                            <select v-model="paymentMethod" class="pay_memo">
                                <option value="one">배송 메모를 선택해 주세요.</option>
                                <option value="two">배송 전에 미리 연락 바랍니다.</option>
                                <option value="three">부재 시 경비실에 맡겨 주세요.</option>
                                <option value="four">부재 시 전화나 문자 남겨 주세요.</option>
                                <option value="five">직접 입력</option>
                            </select>
                            <input type="text"
                                class="pay_shippingMessage"
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
                        <select class="pay_coupon">
                            <option>{{ memberInfo.couponName }}</option>
                        </select>
                    </section>

                   <section class="point">
                        <div>
                           <h2 class="text">포인트</h2> 
                        </div>
                        <div>
                            <input type="text" class="pay_point" v-model="displayPoint" placeholder="포인트 입력">
                            <button class="point_btn" @click="applyPoint">전액 사용</button>
                        </div>
                        <div class="point_text">
                            보유 포인트 {{ memberInfo.point }}
                        </div>
                    </section>
                </section>
                
                <section class="payment-section"> 
                    <section class="order-summary">
                        <h2 class="text">주문 요약</h2>
                        <div class="summary-details">
                            <p>상품 가격 <span>{{ productInfo.price }}</span></p>
                            <p>배송비 <span>+ 3,000</span></p>
                            <p v-if="memberInfo.usedPoint && memberInfo.usedPoint > 0">포인트 사용 
                                <span> - {{ memberInfo.usedPoint }}</span>
                            </p>
                            <p class="total-price">
                                총 주문금액 <span>{{ (parseInt(productInfo.price) || 0) + 3000 - (memberInfo.usedPoint || 0) }} 원</span>
                            </p>
                        </div>
                    </section>
                  
                    <section class="payment">
                        <h2 class="text">결제 수단</h2>
                        <select class="pay_way">
                            <option>신용카드</option>
                            <option>실시간 계좌이체</option>
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
                quantity : "${map.quantity}",
                payList: [],
                productInfo: {},
                memberInfo: {},
                deliveryInfo: [],
                sessionId : "${sessionId}",
                displayPoint: null,
                paymentMethod : 'one',
            };
        },
        methods: {
            fnPayProduct(){
                var self = this;
				var nparmap = { 
                    itemNo : self.itemNo,
                    quantity : self.quantity
                };
				$.ajax({
					url:"/product.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
                        self.productInfo = data.productInfo;
						console.log(data);
                        console.log(this.productInfo);
					}
				});
            },
            fnMember(){
                var self = this;
				var nparmap = { userId : self.sessionId };
				$.ajax({
					url:"/member.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
                        self.memberInfo = data.memberInfo;
						console.log(data);
					}
				});
            },
            fnPayment(){
                var self = this;
                const totalPrice = parseInt(self.productInfo.price) + 3000 - parseInt(self.memberInfo.usedPoint || 0);
                IMP.request_pay({
                    pg: "html5_inicis",
                    pay_method: "card",
                    merchant_uid: "merchant_" + new Date().getTime(),
                    name: "테스트 결제",
                    amount: totalPrice,
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
                    price : self.productInfo.price,
                    pNo : self.payList.pNo
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
            applyPoint() {
                this.displayPoint = this.memberInfo.point || 0;
                if (this.memberInfo.point > 0) {
                    this.displayPoint = this.memberInfo.point || 0;  // 입력 칸에 반영
                    this.memberInfo.usedPoint = this.memberInfo.point; // 주문 요약에 반영할 포인트 사용 값 설정
                }
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
            self.fnPayProduct();  
            self.fnMember();  

            document.addEventListener("scroll", function() {
                const orderSection = document.querySelector(".order-section");
                orderSection.scrollTop = window.scrollY;
            });

        }
    });
    app.mount('#app');
</script>
​