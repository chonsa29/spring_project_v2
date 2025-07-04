<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결제</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="/js/pageChange.js"></script>
    <link rel="stylesheet" href="/css/pay.css">
</head>
<body>
<jsp:include page="/WEB-INF/common/header.jsp" />
<div id="app">
    <h1 class="pay-text">결제하기</h1>
        <main>
            <section class="order-section">
                <section class="order-info">
                    <h2 class="text">주문 상품 정보</h2>
                    <div class="product" v-for="(item, index) in productInfo" :key="index">
                        <img :src="item.filePath">
                        <div class="product-details">
                            <p class="product-name">{{ item.itemName }}</p>
                            <p class="product-quantity">
                                <span class="required-label">필수</span> {{ item.quantity }} 개
                            </p>
                            <p class="product-price">{{ isNaN(item.price * item.quantity) ? "0" : (item.price * item.quantity).toLocaleString() }} 원</p>
                        </div>
                    </div>
                     <div class="delivery-info">
                        <p>배송비 {{ shippingFee.toLocaleString() }} 원</p>
                    </div>
                </section>

                <section class="order-details">
                    <h2 class="text">주문자 정보</h2>
                    <input type="text" class="pay_ordererName" v-model="memberInfo.userName" placeholder="이름">
                    <input type="text" class="pay_ordererPhone" v-model="memberInfo.phone" placeholder="연락처">
                </section>

                <section class="shipping">
                    <h2 class="text">배송 정보</h2>
                    <div>
                        <input type="checkbox" class="check" v-model="sameAsOrderer">
                        <label>주문자 정보와 동일</label>
                    </div>
                    
                    <form autocomplete="off">
                        <input type="text" class="pay_ordererName" v-model="receiverName" placeholder="수령인">
                        <input type="text" class="pay_ordererPhone" v-model="receiverPhone" placeholder="연락처">
                        <input type="text" class="pay_zipcode" v-model="memberInfo.zipCode" placeholder="우편번호">
                        <input type="text" class="pay_address" v-model="memberInfo.address" placeholder="주소">
                        <input type="text" class="pay_detailAddress" v-model="detailAddress" placeholder="상세 주소">
                    </form>
                    
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
                        <input type="text" 
                        class="pay_point" 
                        v-model.number="displayPoint" 
                        placeholder="포인트 입력" 
                        @input="onPointInput">
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
                        <p>상품 가격 <span>{{ formattedTotalPrice }}</span></p>
                        <p>배송비 <span>{{ shippingFee.toLocaleString() }}</span></p>
                        <p v-if="memberInfo.discountAmount">
                            할인 금액 <span>{{ memberInfo.discountAmount }}</span>
                        </p>
                        <p v-if="memberInfo.usedPoint && memberInfo.usedPoint > 0">포인트 사용 
                            <span>{{ memberInfo.usedPoint }}</span>
                        </p>
                        <p v-if="gradeDiscountAmount > 0">
                            <span class="color">{{ memberInfo.gradeName }}</span>
                            <span class="color">{{ memberInfo.sale }} %</span>
                        </p>                        
                        <p class="total-price">
                            총 주문금액 <span>{{ formattedTotalOrderPrice }} 원</span>
                        </p>
                    </div>
                </section>
              
                <section class="payment">
                    <h2 class="text">결제 수단</h2>
                    <select class="pay_way" v-model="payWay">
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
                quantity: "${map.quantity}",
                productInfo: [],
                memberInfo: {},
                sessionId : "${sessionId}",
                displayPoint: null,
                paymentMethod : 'one',
                sameAsOrderer: false,
                receiverName: '',
                receiverPhone: '',
                detailAddress: '',
                shippingMessage: '',
                payWay: '신용카드',
                cartKey: '',
                productNumber: ''
            };
        },
        computed: {
            formattedTotalPrice() {
                return this.productInfo.reduce((total, item) => total + item.price * item.quantity, 0).toLocaleString();
            },
            discountRate() {
                const amount = this.memberInfo.discountAmount;
                if (!amount) return 0;
                return amount.toString().includes('%') ? parseFloat(amount) / 100 : parseFloat(amount);
            },
            shippingFee() {
                const totalPrice = this.productInfo.reduce((total, item) => total + item.price * item.quantity, 0);
                return totalPrice >= 30000 ? 0 : 3000;
            },
            gradeDiscountRate() {
                const sale = this.memberInfo.sale;
                return sale ? parseFloat(sale) / 100 : 0;
            },
            gradeDiscountAmount() {
                const total = this.productInfo.reduce((sum, item) => sum + item.price * item.quantity, 0);
                return Math.floor(total * this.gradeDiscountRate);
            },
            formattedTotalOrderPrice() {
                const originalPrice = this.productInfo.reduce((total, item) => total + item.price * item.quantity, 0);
                const discount = this.discountRate * originalPrice;
                const gradeDiscount = this.gradeDiscountAmount;
                const usedPoint = parseInt(this.memberInfo.usedPoint) || 0;
                const final = originalPrice - discount - gradeDiscount + this.shippingFee - usedPoint;
                return isNaN(final) ? '0' : Math.round(final).toLocaleString();
            }
        },
        watch: {
            displayPoint(val) {
                const parsed = parseInt(val) || 0;

                if (parsed > this.memberInfo.point) {
                    this.displayPoint = this.memberInfo.point;
                    this.memberInfo.usedPoint = this.memberInfo.point;
                } else if (parsed < 0) {
                    this.displayPoint = 0;
                    this.memberInfo.usedPoint = 0;
                } else {
                    this.memberInfo.usedPoint = parsed;
                }
            },
            sameAsOrderer(val) {
                this.receiverName = val ? this.memberInfo.userName : '';
                this.receiverPhone = val ? this.memberInfo.phone : '';
            },
            paymentMethod(val) {
                if (val === 'five') this.$nextTick(() => this.$refs.shippingInput?.focus());
            }
        },
        methods: {
            fnPayProduct(){
                var self = this;
				var nparmap = { 
                    itemNo : self.itemNo,
                };
				$.ajax({
					url:"/product.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
                        let quantity = parseInt(self.quantity, 10) || 1;
                        console.log("수량:", quantity);

                        if (quantity > 1) {
                            self.productInfo = [{
                                itemNo: data.productInfo.itemNo,
                                itemName: data.productInfo.itemName,
                                filePath: data.productInfo.filePath,
                                price: parseInt(data.productInfo.price, 10), 
                                quantity: quantity // 수량 반영
                            }];

                            self.productNumber = data.productInfo.itemNo

                        } else {
                            self.productInfo = Array.isArray(data.productInfo) 
                                ? data.productInfo.map(item => ({
                                    itemNo: item.itemNo,
                                    itemName: item.itemName,
                                    filePath: item.filePath,
                                    price: parseInt(item.price, 10), 
                                    quantity: parseInt(item.quantity, 10),
                                    cartKey: item.cartKey 
                                }))
                                : [{
                                    itemNo: data.productInfo.itemNo,
                                    itemName: data.productInfo.itemName,
                                    filePath: data.productInfo.filePath,
                                    price: parseInt(data.productInfo.price, 10), 
                                    quantity: parseInt(data.productInfo.quantity, 10) || 1
                                }];

                                self.productNumber = Array.isArray(data.productInfo)
                                    ? data.productInfo[0]?.itemNo
                                    : data.productInfo.itemNo;

                        }
                        console.log("상품 정보:", self.productInfo);
                    }
				});
            },
            fnMember(){
                var self = this;
				var nparmap = { 
                    userId : self.sessionId,
                    quantity : self.quantity
                };
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
            removeItemsFromCart(orderItems) {
                var self = this;
				var nparmap = { 
                    userId : self.sessionId,
                    quantity : self.quantity,
                    itemNo : self.itemNo,
                };
                $.ajax({
                    type: "POST",
                    url: "/deleteOrderedItems.dox", 
                    data: JSON.stringify(orderItems),
                    contentType: "application/json",
                    success: function(response) {
                        console.log("장바구니에서 삭제 성공", response);
                    },
                    error: function(error) {
                        console.error("장바구니 삭제 실패", error);
                        alert("장바구니 처리 중 오류가 발생했습니다.");
                    }
                });
            },
            fnPayment(){
                var self = this;

                localStorage.setItem("orderData", JSON.stringify(self.productInfo));
                sessionStorage.setItem("orderTempData", JSON.stringify(this.productInfo));

                if(!self.memberInfo.userName || !self.memberInfo.phone) {
                    alert("주문자 정보를 입력해주세요");
                    return;
                }

                if (!self.receiverName || !self.receiverPhone || !self.memberInfo.zipCode || !self.memberInfo.address || !self.detailAddress) {
                    alert("배송 정보를 입력해주세요");
                    return;
                }

                if (self.paymentMethod === 'five' && !self.shippingMessage.trim()) {
                    alert("배송 메모를 입력해 주세요.");
                    return;
                }

                const originalPrice = this.productInfo.reduce((total, item) => total + item.price * item.quantity, 0);
                const discount = this.discountRate * originalPrice;
                const gradeDiscount = this.gradeDiscountAmount;
                const usedPoint = parseInt(this.memberInfo.usedPoint) || 0;
                const totalPrice = originalPrice - discount - gradeDiscount + this.shippingFee - usedPoint;

                // 결제 직전에
                const orderData = JSON.parse(localStorage.getItem("orderData"));
                if (orderData) {
                    localStorage.setItem("lastOrderData", JSON.stringify(orderData));
                }

                IMP.request_pay({
                    pg: "html5_inicis",
                    pay_method: "card",
                    merchant_uid: "merchant_" + new Date().getTime(),
                    name:  (function () {
                        if (!self.productInfo || self.productInfo.length === 0) return "상품 없음";

                        var firstItemName = self.productInfo[0] && self.productInfo[0].itemName ? self.productInfo[0].itemName : "상품";
                        var count = self.productInfo.length;

                        return count > 1 
                            ? firstItemName + " 외 " + (count - 1) + "건"
                            : firstItemName;
                    })(),
                    amount: totalPrice,
                    buyer_tel: self.memberInfo.phone,
                    }	, function (rsp) { // callback
                    if (rsp.success) {
                        // 결제 성공 시
                        console.log(rsp);
                        self.fnSave(rsp.merchant_uid);
                    } else {
                        // 결제 실패 시
                        console.log(rsp);
                        alert("결제가 실패했습니다: " + rsp.error_msg);
                    }
                });
            },
            fnSave(merchant_uid) {
                var self = this;
                let totalPriceBeforePoint = 0;  
                let totalQuantity = 0;

                const discountRate = Number(self.discountRate); // computed 사용 가능
                const usedPoint = parseInt(self.memberInfo.usedPoint) || 0;

                // 주문 항목별 할인 적용 가격 계산
                const orderItems = self.productInfo.map(item => {
                    const quantity = Number(item.quantity) || 1;
                    const itemTotalPrice = Number(item.price) * quantity;
                    const discount = itemTotalPrice * discountRate;

                    totalPriceBeforePoint += itemTotalPrice
                    totalQuantity += quantity;

                    return {
                        itemNo: Number(item.itemNo),
                        itemName: item.itemName,
                        price: item.price,
                        quantity: quantity,
                        filePath: item.filePath
                    };
                });

                const gradeDiscount = self.gradeDiscountAmount; // computed에서 계산됨
                const discountAmount = isNaN(totalPriceBeforePoint * discountRate)
                    ? 0
                    : Math.floor(totalPriceBeforePoint * discountRate); // 쿠폰 할인

                const finalPrice = Math.max(0, (totalPriceBeforePoint - discountAmount - gradeDiscount + this.shippingFee - usedPoint));
                const shippingFee = self.shippingFee;
                const now = new Date();
                const orderDate = now.getFullYear() + '-' + 
                    ('0' + (now.getMonth() + 1)).slice(-2) + '-' + 
                    ('0' + now.getDate()).slice(-2) + ' ' + 
                    ('0' + now.getHours()).slice(-2) + ':' + 
                    ('0' + now.getMinutes()).slice(-2) + ':' + 
                    ('0' + now.getSeconds()).slice(-2);

                var nparmap = { 
                    itemNo : Number(self.itemNo),
                    cartKey: self.cartKey,
                    pWay : merchant_uid,
                    userId : self.sessionId,
                    price: finalPrice,
                    orderItems: JSON.stringify(orderItems),
                    discountAmount: Math.floor(discountAmount),
                    gradeDiscount: gradeDiscount,
                    usedPoint: usedPoint,
                    shippingFee: shippingFee,
                    card: this.payWay,
                    orderCount: totalQuantity,
                    zipCode: self.memberInfo.zipCode || self.inputZipCode, // 수동 입력 값
                    address: (self.memberInfo.address || '') + ' ' + self.detailAddress,
                    userName: self.memberInfo.userName || self.inputUserName,
                    phone: self.receiverPhone,
                    request: self.paymentMethod === 'five' ? self.shippingMessage : self.getShippingMemoText(self.paymentMethod),
                    pNo: Number(self.productNumber),
                    orderDate: orderDate, 
                    // cartList: JSON.stringify(this.orderItems)
                };

                if (!self.productInfo.cartKey || self.productInfo.cartKey === "") {
                    nparmap.cartKey = 12345; // 또는 유의미한 값
                    } else {
                    nparmap.cartKey = self.productInfo.cartKey;
                    }

                console.log("전송되는 nparmap:", nparmap);

                $.ajax({
                    url: "/payment.dox",  
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                            if (data.result === "success") {
                                const orderData = JSON.parse(localStorage.getItem("orderData")) || self.productInfo;

                                const orderItems = orderData.map(item => ({
                                    itemNo: item.itemNo,
                                    quantity: item.quantity,
                                    userId: self.sessionId,
                                }));
                                self.removeItemsFromCart(orderItems);

                                const savePoint = Math.floor(finalPrice * 0.1);  
                                console.log("적립될 포인트:", savePoint);

                                $.ajax({
                                    url: "/savePoint.dox",  
                                    type: "POST",
                                    dataType: "json",
                                    data: {
                                        userId: self.sessionId,
                                        point: savePoint,
                                        reason: "구매 적립",
                                        orderId: data.orderId 
                                    },
                                    success: function (res) {
                                        console.log("포인트 적립 성공:", res);
                                        console.log("포인트 적립 성공:", res);

                                        if (res.result === "success" && res.member) {
                                            // 적립된 포인트 반영해서 화면에 갱신
                                            self.memberInfo.point = res.member.point;
                                            console.log("갱신된 포인트:", self.memberInfo.point);
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("포인트 적립 실패:", error);
                                    }
                                });

                            setTimeout(function() {
                                window.location.href = "/paySuccess.do?orderId=" + data.orderId;
                            }, 500);
                        } else {
                            alert("결제 저장 실패: " + data.message);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("결제 저장 AJAX 에러:", error);
                        alert("서버와 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            onPointInput(event) {
                const val = parseInt(event.target.value.replace(/[^\d]/g, '')) || 0;
                this.displayPoint = val;
            },
            getShippingMemoText(code) {
                switch(code) {
                    case 'two': return '배송 전에 미리 연락 바랍니다.';
                    case 'three': return '부재 시 경비실에 맡겨 주세요.';
                    case 'four': return '부재 시 전화나 문자 남겨 주세요.';
                    default: return '배송 메모 없음';
                }
            },
            applyPoint() {
                if (this.memberInfo.usedPoint && this.memberInfo.usedPoint > 0) {
                    // 이미 포인트가 적용된 상태라면 초기화
                    this.displayPoint = null;
                    this.memberInfo.usedPoint = 0;
                } else {
                    // 포인트 적용
                    this.displayPoint = this.memberInfo.point || 0;
                    this.memberInfo.usedPoint = this.memberInfo.point || 0;
                }
            },

        },
        mounted() {
            const self = this;
    
            const orderSection = document.querySelector(".order-section");

            // 윈도우 스크롤 시 order-section 내부 스크롤 조정
            document.addEventListener("scroll", function () {
                orderSection.scrollTop = window.scrollY;
            });

            window.addEventListener("wheel", function (event) {
                const windowHeight = window.innerHeight;
                const documentHeight = document.documentElement.scrollHeight;
                const scrollPosition = window.scrollY + windowHeight;

                if (scrollPosition >= documentHeight - 1) {
                    if (orderSection.scrollTop + orderSection.clientHeight < orderSection.scrollHeight) {
                        orderSection.scrollBy({
                            top: event.deltaY,
                            behavior: "smooth"
                        });
                    } else {
                        window.scrollBy({
                            top: event.deltaY,
                            behavior: "smooth"
                        });
                    }
                }
            }, { passive: false });

            // orderData 확인 후 상품 정보 불러오기
            const orderData = JSON.parse(localStorage.getItem("orderData")) || JSON.parse(localStorage.getItem("lastOrderData") ||  JSON.parse(sessionStorage.getItem("orderTempData")));

            if (orderData && orderData.length > 0 && !(self.itemNo && self.quantity)) {
                // 장바구니 결제
                self.productInfo = orderData.map(item => ({
                    itemNo: item.itemNo,
                    itemName: item.itemName,
                    filePath: item.filePath,
                    price: item.price,
                    quantity: item.cartCount || 1
                }));
            } else if (self.itemNo && self.quantity) {
                // 상품 상세에서 바로 결제
                self.fnPayProduct();
            }

            self.fnMember();
        }
    });
    app.mount('#app');
</script>
​