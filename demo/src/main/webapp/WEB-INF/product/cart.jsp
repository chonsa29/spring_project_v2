<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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
                <div class="progress-bar" id="progress-bar"></div>
                <div class="progress-labels">
                <span class="label-left">0원</span>
                <span class="label-right">20,000원</span>
                </div>
            </div>

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
                            <span>{{ item.price }}원</span>
                        </div>
                        <div class="quantity">
                            <span>수량</span>
                            <input class="form-control" type="number" :value="item.cartCount" max="50" min="1" />
                            <button class="q-button">변경</button>
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
                        <span>할인 금액:</span>
                        <span>-10,000원</span>
                    </div>
                    <div class="summary-item">
                        <span>배송비:</span>
                        <span>3,000원</span>
                    </div>
                    <div class="summary-item total">
                        <span>총 결제 금액:</span>
                        <span>{{ (totalAmount - 10000 + 3000).toLocaleString() }}원</span>
                    </div>
                    <button class="order-button">주문하기</button>
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
                list: [], // 서버에서 가져올 상품 리스트
                totalAmount: 0, // 선택된 상품의 총 금액
                isAllSelected: false, // 전체 선택 체크박스 상태
            };
        },
        methods: {
            fnCartList() {
                // Ajax로 서버에서 데이터 가져오기
                $.ajax({
                    url: "/cart/list.dox",
                    dataType: "json",
                    type: "POST",
                    success: (data) => {
                        // 리스트 초기화 및 각 아이템에 checked 속성 추가
                        this.list = data.list.map(item => ({
                            ...item,
                            price: Number(item.price),
                            checked: false, // 초기 상태는 선택되지 않음
                        }));
                    },
                });
            },
            updateTotalAmount() {
                // 체크된 항목들의 가격을 합산
                this.totalAmount = this.list
                    .filter(item => item.checked) // 체크된 항목만 필터링
                    .reduce((sum, item) => sum + item.price, 0); // 가격 합산

                // 막대바 업데이트
                this.updateProgressBar();    
            },
            toggleAllSelection() {
                // 전체 선택 체크박스 상태에 따라 모든 항목 선택/해제
                this.list.forEach(item => {
                    item.checked = this.isAllSelected;
                });
                this.updateTotalAmount(); // 총 금액 업데이트
            },
            updateProgressBar() {
                const maxAmount = 20000; // 최대 금액
                const progressBar = document.getElementById('progress-bar');
                
                // 총 금액 비율 계산
                const percentage = Math.min((this.totalAmount / maxAmount) * 100, 100); // 100% 초과 방지
                progressBar.style.width = `${percentage}%`; // 막대바 너비 설정
            }
        },
        mounted() {
            this.fnCartList(); // 컴포넌트가 마운트될 때 데이터 가져오기
        },
    });

    app.mount('#app');
</script>
