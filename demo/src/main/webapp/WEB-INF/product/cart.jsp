<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
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
              <span class="label-right">30,000원</span>
            </div>
        </div>

        <div class="cart-check">
            <input type="checkbox" id="select-all"/> 전체 선택
        </div>
        <!-- 상품 리스트 -->
        <div class="cart-item">
            <div class="product-header">
              <input type="checkbox" class="item-checkbox"/>
              <h3 class="product-name">상품 이름</h3>
            </div>
            <div class="product-content">
              <img class="product-image" src="../img/menu.jpg" alt="상품 이미지" />
              <div class="product-details">
                <div class="price-row">
                  <h3>PRICE</h3>
                  <span>30,000원</span>
                </div>
                <div class="quantity">
                    <span>수량</span> 
                    <input class="form-control" id="quantity_value" type="number" name="" value="1" max="50" min="1" />
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
                <span>50,000원</span>
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
                <span>43,000원</span>
              </div>
              <button class="order-button">주문하기</button>
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
            return {};
        },
        methods: {},
        mounted() {
            function updateProgressBar(totalAmount, maxAmount) {
                const progressBar = document.getElementById('progress-bar');
                const progressPercentage = (totalAmount / maxAmount) * 100;
                progressBar.style.width = progressPercentage + '%';
            }

            // 예제: 총 상품 금액을 기반으로 진행바 업데이트
            updateProgressBar(43000, 50000); // 결제 금액 43,000원, 최대 금액 50,000원

            // 전체 선택 체크박스와 개별 체크박스들 가져오기
const selectAllCheckbox = document.getElementById('select-all');
const itemCheckboxes = document.querySelectorAll('.item-checkbox');

// 전체 선택 체크박스 클릭 시
selectAllCheckbox.addEventListener('change', function () {
    const isChecked = this.checked; // 전체 선택 체크박스의 상태 (true 또는 false)
    itemCheckboxes.forEach((checkbox) => {
        checkbox.checked = isChecked; // 모든 개별 체크박스 상태 변경
    });
});

// 개별 체크박스 클릭 시
itemCheckboxes.forEach((checkbox) => {
    checkbox.addEventListener('change', function () {
        // 모든 체크박스가 선택되었는지 확인
        const allChecked = Array.from(itemCheckboxes).every((cb) => cb.checked);
        // 전체 선택 체크박스 상태 업데이트
        selectAllCheckbox.checked = allChecked;

        // 개별 체크박스 중 일부만 체크된 경우 중간 상태 처리
        const someChecked = Array.from(itemCheckboxes).some((cb) => cb.checked);
        selectAllCheckbox.indeterminate = !allChecked && someChecked; // 일부 체크된 경우
    });
});


        
        },
    });

    app.mount('#app');
</script>
