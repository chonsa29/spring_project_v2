<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>"></script>
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
                                <span>{{ (item.price * item.cartCount).toLocaleString() }}원</span>
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
                        <div class="orbutton">
                            <button class="order-button">주문하기</button>
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
                list: [], // 서버에서 가져올 상품 리스트
                totalAmount: 0, // 선택된 상품의 총 금액
                isAllSelected: false, // 전체 선택 체크박스 상태
                userId : "${sessionId}",
                count : "",
                selectList : []
            };
        },
        computed: { // computed 속성 추가
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
                // Ajax로 서버에서 데이터 가져오기
                $.ajax({
                    url: "/cart/list.dox",
                    dataType: "json",
                    type: "POST",
                    data : params,
                    success: (data) => {
                        // 리스트 초기화 및 각 아이템에 checked 속성 추가
                        this.list = data.list.map(item => ({
                            ...item,
                            price: Number(item.price),
                            cartCount: Number(item.cartCount),
                            checked: false, // 초기 상태는 선택되지 않음
                        }));

                        console.log(this.list);
                        // 데이터 로드 후 초기화
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

                // 체크된 상품들의 itemNo를 배열로 수집
                var selectedItems = self.list
                    .filter(item => item.checked)  // 체크된 상품만 필터링
                    .map(item => item.itemNo);  // itemNo 값만 추출

                if (selectedItems.length === 0) {
                    alert("삭제할 상품을 선택하세요.");
                    return;
                }

                var param = { selectList: JSON.stringify(selectedItems),
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
                        self.fnCartList();  // 장바구니 목록 새로고침
                    }
                });
            },
            fnProduct : function(){
                location.href = "/product.do";
            },
            updateTotalAmount() {
                console.log('updateTotalAmount 호출됨'); // 디버깅용 로그 추가

                // 체크된 항목들의 가격을 합산
                this.totalAmount = this.list
                    .filter(item => item.checked) // 체크된 항목만 필터링
                    .reduce((sum, item) => sum + (item.price * item.cartCount), 0); // 가격 합산

                console.log("계산된 totalAmount:", this.totalAmount); // totalAmount 값 확인

                // Vue가 DOM을 업데이트한 후 실행 (반영 지연 방지)
                this.$nextTick(() => {
                    this.updateProgressBar();
                });
            },

            updateProgressBar() {
                this.$nextTick(() => { // Vue가 DOM 업데이트 후 실행하도록 보장
                    const maxAmount = 30000;
                    const progressBar = document.getElementById('progress-bar');

                    if (!progressBar) {
                        console.error("progressBar 요소를 찾을 수 없습니다.");
                        return;
                    }

                    // 총 금액 비율 계산 (최대 100% 초과 방지)
                    const percentage = Math.min((this.totalAmount / maxAmount) * 100, 100);

                    // width 값 적용 (이전에 빈값이 나왔던 문제 해결)
                    progressBar.style.width = percentage + "%";

                    // 강제 리페인트 적용 (브라우저 최적화로 인해 무시되는 경우 방지)
                    progressBar.style.display = "none";
                    progressBar.offsetHeight; // 트릭: 리플로우 강제 실행
                    progressBar.style.display = "block";

                    // 색상 변경
                    progressBar.style.backgroundColor = percentage >= 100 ? "#ff5733" : "#C1E8C7";

                });
            },

            toggleAllSelection() {
                // 전체 선택 체크박스 상태에 따라 모든 항목 선택/해제
                this.list.forEach(item => {
                    item.checked = this.isAllSelected;
                });
                this.updateTotalAmount(); // 총 금액 업데이트

            }
        },
        mounted() {
            this.fnCartList(); // 컴포넌트가 마운트될 때 데이터 가져오기
        },
    });

    app.mount('#app');
</script>