<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/css/cart.css">
    <title>MEALPICK - 장바구니</title>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <!-- 장바구니 섹션 -->
        <div class="cart-page">
            <h1>CART</h1>

            <div class="progress-container">
                <div class="progress-bar" id="progress-bar" :style="progressBarStyle"></div>
                <div class="progress-labels">
                    <span class="label-left">0원</span>
                    <span class="label-right">30,000원</span>
                </div>
            </div>

            <!-- 무료배송 남은 금액 안내 -->
            <p v-if="remainingAmount > 0" class="shipping-info">{{ remainingAmount.toLocaleString() }}원 이상 구매 시 무료배송! 🚚</p>
            <p v-else class="shipping-info" style="color: #ff5733;">무료배송 혜택을 받을 수 있습니다! 🎉</p>

            <div class="notCart" v-if="list.length === 0">
                <span>담은 상품이 없습니다</span>
                <div>
                    <button class="n-button" @click="fnProduct">상품 구경하러 가기</button>
                </div>
            </div>

            <div v-else>
                <div class="cart-check">
                    <input type="checkbox" id="select-all" v-model="isAllSelected" @change="toggleAllSelection" /> 전체 선택
                </div>

                <!-- 상품 리스트 -->
                <div class="cart-item" v-for="(item, index) in list" :key="item.itemNo">
                    <div class="product-header">
                        <input type="checkbox" v-model="item.checked" @change="updateTotalAmount" />
                        <h3 class="product-name">{{ item.itemName }}</h3>
                    </div>
                    <div class="product-content">
                        <img class="product-image" :src="item.filePath" alt="상품 이미지" />
                        <div class="product-details">
                            <div class="price-row">
                                <h3>PRICE</h3>
                                <span>
                                    {{ item.price.toLocaleString() }}원
                                </span>
                            </div>
                            <div class="quantity">
                                <span>수량</span>
                                <input class="form-control" type="number" v-model="item.cartCount" max="50" min="1" />
                                <button class="q-button" @click="fnCount(item)">변경</button>
                                <button class="r-button" @click="fnRemove(item)">삭제</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 주문 요약 -->
                <div class="checkout-summary">
                    <div class="summary-details">
                        <div class="summary-item">
                            <span>총 상품 금액:</span>
                            <span>{{ totalAmount.toLocaleString() }}원</span>
                        </div>

                        <div class="summary-item">
                            <span>배송비:</span>
                            <span>{{ totalShippingFee.toLocaleString() }}원</span>
                        </div>
                        <div class="summary-item total">
                            <span>총 결제 금액:</span>
                            <span>{{ finalAmount.toLocaleString() }}원</span>
                        </div>
                        <div class="orbutton">
                            <button class="order-button" @click="fnGoPay">주문하기</button>
                            <button class="remove-button" @click="fnRemoveAll">삭제</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                list: [],
                totalAmount: 0,
                isAllSelected: false,
                userId : "${sessionId}",
                count : "",
                selectList : [],
                shippingFee: 3000,
            };
        },
        computed: {
            totalShippingFee() {
                return this.totalAmount >= 30000 ? 0 : this.shippingFee;
            },
            finalAmount() {
                return this.totalAmount + this.totalShippingFee;
            },
            progressBarStyle() {
                const maxAmount = 30000;
                const percentage = Math.min((this.totalAmount / maxAmount) * 100, 100);
                return {
                    width: percentage + "%",
                    backgroundColor: percentage >= 100 ? "#ff5733" : "#C1E8C7"
                };
            },
            remainingAmount() {
                const maxAmount = 30000;
                return maxAmount - this.totalAmount > 0 ? maxAmount - this.totalAmount : 0;
            }
        },
        methods: {
            fnCartList() {
                var self = this;
                var params = {
                    userId : self.userId
                };

                const checkedMap = {};
                self.list.forEach(item => {
                    checkedMap[item.itemNo] = item.checked;
                });

                $.ajax({
                    url: "/cart/list.dox",
                    dataType: "json",
                    type: "POST",
                    data : params,
                    success: (data) => {
                        this.list = data.list.map(item => ({
                            ...item,
                            price: Number(item.price),
                            cartCount: Number(item.cartCount),
                            checked: checkedMap[item.itemNo] || false,
                        }));

                        console.log(this.list);
                        this.updateTotalAmount();
                    },
                });
            },
            fnCount(item) { 
                var self = this;
                var nparmap = {
                    count: item.cartCount, 
                    userId: self.userId,
                    itemNo: item.itemNo 
                };
                $.ajax({
                    url: "/cart/count.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                        alert("수량이 변경되었습니다");
                        self.fnCartList(); 
                    }
                });
            },
            fnRemove(item) { 
                var self = this;
                var nparmap = {
                    userId: self.userId,
                    itemNo: item.itemNo 
                };
                $.ajax({
                    url: "/cart/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                        alert("장바구니에서 제거되었습니다.");
                        self.fnCartList(); 
                    }
                });
            },
            fnRemoveAll() {
                var self = this;
                var selectedItems = self.list
                    .filter(item => item.checked)
                    .map(item => item.itemNo);

                if (selectedItems.length === 0) {
                    alert("삭제할 상품을 선택하세요.");
                    return;
                }

                var param = { 
                    selectList: JSON.stringify(selectedItems),
                    userId: self.userId
                };

                $.ajax({
                    url: "/cart/remove-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        alert("선택한 상품이 장바구니에서 제거되었습니다.");
                        self.fnCartList();
                    }
                });
            },
            fnProduct() {
                location.href = "/product.do";
            },
            updateTotalAmount() {
                console.log('updateTotalAmount 호출됨');
                this.totalAmount = this.list
                    .filter(item => item.checked)
                    .reduce((sum, item) => sum + (item.price * item.cartCount), 0);

                console.log("계산된 totalAmount:", this.totalAmount);

                this.$nextTick(() => {
                    this.updateProgressBar();
                });
            },
            updateProgressBar() {
                this.$nextTick(() => {
                    const maxAmount = 30000;
                    const progressBar = document.getElementById('progress-bar');

                    if (!progressBar) {
                        console.error("progressBar 요소를 찾을 수 없습니다.");
                        return;
                    }

                    const percentage = Math.min((this.totalAmount / maxAmount) * 100, 100);
                    progressBar.style.width = percentage + "%";

                    progressBar.style.display = "none";
                    progressBar.offsetHeight;
                    progressBar.style.display = "block";

                    progressBar.style.backgroundColor = percentage >= 100 ? "#ff5733" : "#C1E8C7";
                });
            },
            toggleAllSelection() {
                this.list.forEach(item => {
                    item.checked = this.isAllSelected;
                });
                this.updateTotalAmount();
            },
            fnGoPay() {
                const selectedItems = this.list.filter(item => item.checked);
                if (selectedItems.length === 0) {
                    alert("주문할 상품을 선택해주세요.");
                    return;
                }

                localStorage.setItem('orderData', JSON.stringify(selectedItems));
                location.href = '/pay.do';
            }
        },
        mounted() {
            this.fnCartList();
        },
    });

    app.mount('#app');
</script>
