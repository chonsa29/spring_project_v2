<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>

        <link rel="stylesheet" href="/css/product-css/product-info.css">
    </head>
    <style>

    </style>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div id="root">
                <a href="/home.do"> HOME </a> > <a href="/product.do"> PRODUCT </a> > {{info.category}} >
                {{info.itemName}}
            </div>
            <div class="info-container">
                <div id="product-box">
                    <img v-if="info.thumbNail === 'Y'" :src="info.filePath" class="product-mainimg" id="mainImage">
                </div>

                <div class="subimg-container">
                    <img v-for="(img, index) in filteredImgList" :src="img.filePath" alt="제품 썸네일"
                        @click="changeImage(img.filePath)" class="subimg">
                </div>
                <div id="product-Info">
                    <div id="item-Info">{{info.itemInfo}}</div>
                    <div id="product-name">{{info.itemName}}
                        <button class="product-like" :class="{ active: likedItems.has(info.itemNo) }"
                            @click="fnLike(info.itemNo)">
                            ❤
                        </button>
                        <!-- 좋아요 활성화 버튼 -->
                    </div>
                    <div v-if="showLikePopup" class="like-popup-overlay">
                        <div class="like-popup">좋아요 항목에 추가되었습니다</div>
                    </div>
                    <div v-else class="like-popup-overlay">
                        <div class="like-popup">좋아요 항목에서 제거되었습니다.</div>
                    </div>
                    <span v-if="allergensFlg" id="allergens-info">{{info.allergens}} 주의!</span>

                    <div v-if="review.length > 0" class="review-summary">
                        <div class="average-rating">
                            <div id="review">
                                <!-- 별과 점수를 감싸는 wrapper -->
                                <div class="star-wrapper">
                                    <div class="stars">
                                        <span v-for="n in 5" :key="n" class="star-container">
                                            <span class="star empty">★</span>
                                            <span class="star full" v-if="n <= Math.floor(reviewScore)">★</span>
                                            <span class="star half"
                                                v-else-if="n === Math.ceil(reviewScore) && reviewScore % 1 >= 0.5">★</span>
                                        </span>
                                    </div>
                                    <!-- 별점 숫자 -->
                                    <div class="review-score">
                                        {{ reviewScore.toFixed(1) }}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>





                    <p class="product-discount-style">{{formatPrice(info.price * 3) }}원</p>
                    <p class="product-discount">30%</p>
                    <div class="price">{{formattedPrice}} 원</div>
                    <div class="delivery">
                        <span id="delivery-price">배송비</span>
                        <span id="delicery-total">3,000원 </span>
                        <span> / 30,000원 이상 구매시 무료</span>
                    </div>

                    <div id="delivery-info">
                        <div id="delivery-day">
                            배송정보
                        </div>
                        <div>
                            오전 12시 이전 구매시
                            <b style="font-size: 16px;" id="day"></b> 도착
                        </div>
                    </div>

                    <div class="quantity-container">
                        <div class="quantity-box">
                            <span>{{info.itemName}}</span>
                            <div class="quantity-controls">
                                <button class="quantity-btn" @click="fnquantity('sub')">-</button>
                                <input type="text" class="quantity-input" v-model="quantity" @input="checkQuantity">
                                <button class="quantity-btn" @click="fnquantity('sum')">+</button>
                            </div>
                            <span class="quantity-price">{{formattedTotalPrice}}</span>
                        </div>
                    </div>

                    <!-- 합계 -->
                    <div class="total">
                        <span>합계</span>
                        <span id="price-total">{{formattedTotalPrice}}</span>
                    </div>

                    <!-- 좋아요, 장바구니, 구매하기 박스-->
                    <div class="buttons">
                        <button class="cart" @click="addToCart(info.itemNo)">장바구니</button>
                        <div v-if="showCartPopup" class="cart-popup-overlay">
                            <div id="cart-popup" class="cart-popup">
                                <p class="cart-popup-title">선택완료</p>
                                <hr class="cart-popup-divider">
                                <p>장바구니에 상품이 담겼습니다.</p>
                                <div class="cart-popup-buttons">
                                    <button @click="goToCart" class="Cart">장바구니로 이동</button>
                                    <button @click="closeCartPopup" class="Shopping">쇼핑 계속하기</button>
                                </div>
                            </div>
                        </div>
                        <button class="buy" @click="fnPay(info.itemNo)">
                            구매하기
                        </button>
                    </div>
                </div>
            </div>
            <div id="product-view">
                <div id="product-menu">
                    <div class="Info" @click="changeTab('info')">상품 정보</div>
                    <div class="Review" @click="changeTab('review')">상품 리뷰</div>
                    <div class="Inquiry" @click="changeTab('inquiry')">상품 문의</div>
                    <div class="Exchange-Return" @click="changeTab('exchange')">교환/환불</div>
                </div>

                <div id="product-view">
                    <!-- 상세정보 -->
                    <div v-show="selectedTab === 'info'">
                        <p>📦 상품의 상세 정보를 확인하세요!</p>
                    </div>

                    <!-- 상품 리뷰 -->
                    <div v-show="selectedTab === 'review'" class="review-container">

                        <!-- 리뷰 요약 -->
                        <div class="review-summary">
                            <div class="review-score-container">
                                <p class="review-total">총 {{ reviewCount }}건</p>
                                <p class="review-average" v-if="reviewScore !== undefined">{{ reviewScore.toFixed(1) }}점
                                </p>
                                <div class="review-stars">
                                    <span v-for="n in 5" :key="n" class="star"
                                        :class="{ 'filled': n <= Math.round(reviewScore || 0) }">★</span>
                                </div>
                            </div>
                            <div class="review-bar-container" v-if="ratingDistribution">
                                <div v-for="n in 5" :key="n" class="review-bar">
                                    <span class="review-bar-label">{{ 6 - n }}점</span>
                                    <div class="bar">
                                        <div class="filled-bar"
                                            :style="{ width: (ratingDistribution[5-n] || 0) + '%' }"></div>
                                    </div>
                                    <span class="review-bar-percent">{{ ratingDistribution[5-n] || 0 }}%</span>
                                </div>
                            </div>
                        </div>


                        <div v-if="review.length === 0" class="review-none">
                            <p>리뷰가 없습니다.</p>
                        </div>
                        <div class="review-item" v-for="review in review" :key="review.reviewId">
                            <div class="review-header">
                                <img src="../img/profil.png" alt="프로필 이미지" class="review-profile-img" />
                                <div class="review-user">{{ review.userName }}</div>
                                <div class="review-star">
                                    <span v-for="n in 5" :key="n">
                                        <span v-if="n <= Math.round(review.reviewScore)" class="filled-star">★</span>
                                        <span v-else class="empty-star">★</span>
                                    </span>
                                    <span class="reviewScore`">{{ review.reviewScore }}</span> <!-- 숫자 별점 표시 -->
                                </div>
                                <div class="review-date">{{ review.cDatetime }}</div>
                            </div>
                            <div class="review-title">{{ review.reviewTitle }}</div>
                            <div class="review-content">{{ review.reviewContents }}</div>
                            <div class="review-images">
                                <img v-for="image in review.images" :key="image" :src="image" alt="리뷰 이미지" />
                            </div>
                            <div class="review-helpful">👍 이 리뷰가 도움이 돼요!</div>
                        </div>
                    </div>

                    <!-- 상품 문의 -->
                    <div v-show="selectedTab === 'inquiry'">
                        <p>❓ 상품 문의 내용을 확인하고 작성할 수 있습니다.</p>
                    </div>

                    <!-- 교환/환불 내용 -->
                    <div v-show="selectedTab === 'exchange'" class="exchange">

                        <!-- 1 -->
                        <div>
                            <h3>주문 취소</h3>
                            <ul>
                                <li>입금확인 단계 : 마이페이지 > 주문/배송 조회·변경에서 직접 변경 및 취소하실 수 있습니다.</li>
                                <li>상품 준비중 단계부터는 주문 취소/변경이 제한됩니다.</li>
                                <li>카드 환불은 카드사 정책에 따르며, 운영일 기준으로 3~5일 정도 소요됩니다.</li>
                                <li>결제 취소시, 사용기한이 남은 적립금과 쿠폰은 다시 사용하실 수 있습니다.</li>
                                <li>환불이 지연될 경우 환불지연배상금 지급을 요청하실 수 있으며, 환불대상 여부는 고객지원센터(1800-1234)에서 확인 가능합니다.</li>
                                <li>기타 이상이 있는 경우 고객지원센터(1800-1234)로 문의 부탁드립니다.</li>
                            </ul>
                        </div>

                        <!-- 2 -->
                        <div>
                            <h3>교환/반품</h3>
                            <ul>
                                <li>상품이 고시된 내용 및 광고와 다를 때, 그 정도에 따라 재배송, 일부 환불, 전액 환불 처리가 진행됩니다.</li>
                            </ul>

                            <h4>신선/냉장/냉동 식품</h4>
                            <ol type="1">
                                <li>상품을 받은 날로부터 7일 이내에 상품의 상태를 확인할 수 있는 사진을 첨부해 1:1문의, 카카오톡 상담 및 고객지원센터(1800-1234)에
                                    접수해주세요. </li>
                                <li>상품 및 배송 문제로 인한 교환/반품 배송비는 MEALPICK에서 부담합니다.</li>
                                <li>상품 섭취 후 치료가 필요한 경우, 고객지원센터는 증빙(진료확인서, 진단서 등)을 요청할 수 있으며, 사실 확인 후 내부 보상기준에 따라 진행됩니다.
                                </li>
                                <li>단순변심, 주문실수에 의한 교환/반품 처리는 어렵습니다.</li>
                            </ol>

                            <h4>상온식품 및 기타상품</h4>
                            <ol TYPE="1">
                                <li>다음과 같은 경우 문제가 발생했다면, 상품의 상태를 확인할 수 있는 사진과 함께 1:1문의, 카카오톡 상담, 유선접수(1800-1234) 문자접수를
                                    남겨주세요.</li>
                                <div>- 상품을 받은 날로부터 3개월 이내 문제가 발생한 경우</div>
                                <div>- 상품에 문제가 있다는 사실을 알았거나 알 수 있었던 날로부터 30일 이내인 경우</div>
                                <li>단순 변심, 주문실수에 의한 교환/반품 신청의 경우, 배송비(상품별 배송비 정책에 따라 상이)는 고객님 본인이 부담하게 됩니다.</li>
                                <li>배송비 추가결제가 완료되면 해당 상품을 회수하여 상태를 확인할 수 교환/반품 절차가 진행됩니다.</li>
                                <li>고객님의 사정으로 회수가 지연될 경우, 교환/반품이 제한 또는 지연될 수 있습니다.</li>
                            </ol>

                            <h4>교환/반품 불가</h4>
                            <ol type="1">
                                <li>신선/냉장/냉동 식품의 주관적인 맛에 대한 불만</li>
                                <li>고객님의 실수로 오기재된 주소지에 배송된 경우</li>
                                <li>고객님의 사정에 의한 수취거부</li>
                                <li>고객님의 상품 포장 배공 및 사용으로 상품의 가치가 훼손된 경우(단, 내용 확인을 위한 포장 개봉인 경우는 제외)</li>
                                <li>고객님의 단순변심, 주문실수로 인한 교환/반품 신청이 상품을 받은 날로부터 7일이 경과한 경우</li>
                                <li>시간 경과에 따라 상품 등의 가치가 현저히 감소하여 재판매가 불가능한 경우</li>
                                <li>구매한 상품의 구성품이 누락된 경우</li>
                                <li>고객님이 이상 여부를 확인할 수 설치가 완료된 상품일 경우</li>
                                <li>가격변동으로 발생한 금액 차이에 대한 반품 및 보상 불가</li>
                                <li>설치 또는 사용하여 재판매가 어려운 경우, 액정이 있는 상품의 전원을 켠 경우</li>
                            </ol>
                        </div>

                        <!-- 3 -->
                        <div>
                            <h3>후환불 제도</h3>
                            <ul>
                                <li>단순변심, 주문실수에 의한 반품의 경우, 반품된 상품을 수령하여 상태를 점검한 후 환불처리 됩니다.</li>
                                <li>반품된 상품 점검 시 교환/반품불가 사유에 해당될 경우, 반품을 불가합니다 <br>
                                    이 때, 고객님께 별도로 안내되며, 배송비 추가결제가 완료되면 해당 상품을 다시 배송해 드립니다.
                                </li>
                            </ul>
                        </div>

                        <!-- 4 -->
                        <div>
                            <h3>미성년자 권리 보호</h3>
                            <ul>
                                <li>구매자가 미성년자일 경우, 법정대리인이 그 계약에 동의하지 아니하면 미성년자 본인 또는 법정대리인이 그 계약을 취소할 수 있습니다.</li>
                            </ul>
                        </div>

                        <!-- 5 -->
                        <div>
                            <h3>소비자 피해 보상,재화 등에 대한 불만 및 소비자와 사업자의 분쟁 처리에 관한 사항</h3>
                            <ul>
                                <li>소비자 불만 신청 : MEALPICK 고객지원센터(1800-1234) 또는 1:1문의, 카카오톡 상담</li>
                                <li>소비자 피해 분쟁 조정 : 공정거래위원회 및 공정거래위원회가 지정한 분쟁 조정기구</li>
                                <li>고객님께서 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위해서 피해보상처리 기구를 설치, 운영합니다.</li>
                            </ul>
                        </div>

                        <!-- 6 -->
                        <div>
                            <h3>구매안전서비스 설명</h3>
                            <ul>
                                <li>전자상거래 등에서 소비자 보호에 관한 법률 제 13조 결제대금예치 또는 같은 법 제 24조 소비사피해보상보험 계약 등을 해결하여 <br>
                                    고객님께서 현금 결제한 금액에 대해 안전거래를 보장하고 있음을 다음과 같이 증명합니다.
                                    <br>
                                    서비스 제공자: 나이스페이먼즈 서비스등록번호 제 A07-20200629-0023호
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </body>

    </html>
    <script>

        // 배송날짜
        setInterval(() => {
            let nowDate = new Date();
            nowDate.setDate(nowDate.getDate() + 3);  // 현재 날짜에서 +3일 추가

            let month = nowDate.getMonth() + 1;  // 월 (0부터 시작하므로 +1)
            let date = nowDate.getDate();  // 날짜
            let day = month + "월 " + date + "일";

            let obj = document.getElementById("day");
            if (obj) obj.innerHTML = day;
        }, 1000);

        const app = Vue.createApp({
            data() {
                return {
                    itemNo: "${map.itemNo}",
                    info: {}, // 단일 객체 가져오기
                    quantity: 1, // 재고 기본값
                    allergensFlg: false, // 알레르기 여부
                    count: 0, // 재고
                    price: 0, // 가격
                    showCartPopup: false, // 장바구니 추가 팝업
                    imgList: [], // 썸네일, 서브 이미지 리스트 가져오기
                    selectedTab: 'info', // 기본값은 "상품 정보"
                    review: [], // 리뷰 리스트 가져오기
                    reviewFlg: false, // 리뷰 표시 여부
                    userId: "${sessionId}", // 로그인 아이디
                    likedItems: new Set(),
                    showLikePopup: false, // 좋아요 표시
                    wish: [], // 좋아요 목록
                    reviewCount: 0, // 리뷰 총 토탈 개수
                    reviewScore: 0,

                };
            },

            methods: {
                fngetInfo() {
                    var self = this;
                    var nparmap = {
                        itemNo: self.itemNo,
                    };
                    $.ajax({
                        url: "/product/info.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result == "success") {
                                // 단일 상세 정보
                                self.info = data.info;

                                // 재고
                                self.count = data.count;

                                // 가격
                                self.price = data.info.price;

                                // 이미지들
                                self.imgList = data.imgList;

                                console.log(data.info);

                                if (data.info.allergens != "없음") {
                                    self.allergensFlg = true;
                                }

                            }
                        },
                    });
                },

                // 리뷰 메소드
                fnGetReview() {
                    var self = this;
                    var nparmap = {
                        itemNo: self.itemNo,
                    };
                    $.ajax({
                        url: "/product/review.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result == "success") {
                                self.review = data.review;
                                self.reviewCount = data.reviewCount;
                                console.log(data.reviewCount);

                                if (self.review && self.review.length > 0) {
                                    let totalScore = 0;
                                    self.review.forEach((review) => {
                                        totalScore += parseFloat(review.reviewScore) || 0;  // 숫자로 변환하여 합산
                                    });
                                    self.reviewScore = totalScore / self.review.length;  // 평균 계산
                                } else {
                                    self.reviewScore = 0;  // 리뷰가 없으면 평균 점수를 0으로 설정
                                }

                                console.log("평균 별점:", self.reviewScore);  // 평균 별점 출력

                            }
                        },
                    });
                },



                // 수량 조절 메소드(버튼 동작)
                fnquantity: function (action) {
                    var self = this;
                    console.log(self.count);
                    if (action === 'sum') {
                        if (self.quantity < self.count) {
                            self.quantity++;
                        } else {
                            alert("최대 수량입니다.");
                            return;
                        }
                    } else if (action === 'sub') {
                        if (self.quantity > 1) {
                            self.quantity--;
                        } else {
                            alert("1개 이상부터 구매할 수 있는 상품입니다.");
                            return;
                        }

                    }
                },

                // 수량 조절 메소드(직접 입력)
                checkQuantity() {
                    var self = this;
                    if (self.quantity > self.count) {
                        self.quantity = self.count;
                        alert("최대 수량으로 수정되었습니다.");
                    } else if (self.quantity < 1) {
                        self.quantity = 1;
                        alert("최소 수량은 1개입니다.");
                    }
                },

                // 장바구니에 담기
                addToCart(itemNo) {
                    var self = this;

                    var nparmap = {
                        cartCount: self.quantity,
                        userId: self.userId,
                        itemNo: itemNo
                    };
                    $.ajax({
                        url: "/cart/add.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            self.showCartPopup = true;
                        }
                    });

                },

                goToCart() {
                    window.location.href = '/cart.do'; // 장바구니로 이동
                },
                closeCartPopup() {
                    var self = this;
                    self.showCartPopup = false; // 쇼핑 계속하기
                },
                formatPrice(value) {
                    return value ? parseInt(value).toLocaleString() : "0"; // 가격 타입 변환(콤마 추가) 
                },

                fnPay(itemNo) {
                    var self = this;
                    pageChange("/pay.do", { itemNo: itemNo, quantity: self.quantity }); // 구매하기로 이동
                },

                changeImage(filePath) {
                    var self = this;
                    let mainImage = document.getElementById('mainImage').src; // 현재 메인 이미지
                    let clickedIndex = self.imgList.findIndex(img => img.filePath === filePath); // 클릭한 이미지의 인덱스

                    if (clickedIndex !== -1) {
                        // 클릭한 이미지와 메인 이미지 교체
                        self.imgList[clickedIndex].filePath = mainImage;
                        document.getElementById('mainImage').src = filePath;
                    }
                },

                changeTab(tab) {
                    var self = this;
                    self.selectedTab = tab; // 선택한 탭으로 변경
                },

                fnLike(itemNo) {
                    var self = this;

                    if (!self.userId) {
                        // 로그인 페이지로 리디렉션
                        location.href = "/member/login.do"; // 로그인 페이지 경로
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
                                    setTimeout(() => {
                                        self.showLikePopup = false;
                                    }, 2000);
                                }
                            } else if (data.result == "c") {  // 좋아요 취소
                                if (self.likedItems.has(itemNo)) {
                                    self.likedItems.delete(itemNo);  // 좋아요 취소
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

                fetchLikedItems() {
                    var self = this;
                    var nparmap = {
                        userId: self.userId
                    };
                    $.ajax({
                        url: "/product/getLikedItems.dox", // userId별 좋아요한 상품을 가져오는 API
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result == "success") {

                                // Wish 객체 리스트에서 itemNo만 추출하여 Set으로 변환
                                self.likedItems = new Set(data.wish.map(wish => wish.itemNo));
                            }
                        }
                    });
                },



            },
            computed: { // 가격 타입 변환(콤마 추가)
                formattedPrice() {
                    var self = this;
                    return parseInt(self.price).toLocaleString();
                },
                formattedTotalPrice() {
                    var self = this;
                    return (self.price * self.quantity).toLocaleString();
                },
                filteredImgList() {
                    var self = this;
                    return self.imgList.filter(img => img.thumbNail === 'N');
                    // thumbNail이 'N'인 이미지들만 필터링해서 반환
                },


            },
            mounted() {
                var self = this;
                self.fngetInfo();
                self.fnGetReview();
                self.fetchLikedItems();
            }
        });
        app.mount('#app');
    </script>
    ​