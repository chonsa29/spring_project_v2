<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/product-css/product-info.css">
    </head>
    <style>

    </style>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div id="root">
                <a href="/home.do"> HOME </a> > <a href="/product.do"> PRODUCT </a> > {{info.itemName}}
                <select name="category" id="selectMenu" v-model="info.itemName">
                    <option value="info.itemName"></option>
                </select>
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
                    <div id="product-name">{{info.itemName}} <button class="like">❤</button></div>
                    <span v-if="allergensFlg" id="allergens-info">{{info.allergens}} 주의!</span>
                    <div id="review">
                        <span class="stars">★★★★★</span>
                        <span>4.3</span>
                    </div>
                    <p class="product-discount-style">{{formatPrice(info.price * 3) }}</p>
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
                                <input type="text" class="quantity-input" v-model="quantity">
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
                        <button class="buy">
                            <div @click="fnPay(info.itemNo)">
                                구매하기
                            </div>
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
                        <div v-if="review.length === 0" class="review-none">
                            <p>리뷰가 없습니다.</p>
                        </div>
                        <div v-else v-for="review in review" class="review-item">
                            <div class="review-header">
                                <img :src="review.userProfileImage" alt="프로필 이미지" class="review-profile-img" />
                                <div class="review-user">{{review.userName}}</div>
                                <div class="review-stars">★★★★★</div>
                                <div class="review-date">{{review.cDatetime}}</div>
                            </div>
                            <div class="review-title">{{review.reviewTitle}}</div>
                            <div class="review-content">{{review.reviewContents}}</div>
                            <div class="review-images">
                                <img v-for="image in review.images" :key="image" :src="image" alt="리뷰 이미지" />
                            </div>
                            <div class="review-helpful">
                                👍 이 리뷰가 도움이 돼요!
                            </div>
                        </div>
                    </div>

                    <!-- 상품 문의 -->
                    <div v-show="selectedTab === 'inquiry'">
                        <p>❓ 상품 문의 내용을 확인하고 작성할 수 있습니다.</p>
                    </div>

                    <!-- 교환/환불 내용 -->
                    <div v-show="selectedTab === 'exchange'" class="exchange">
                        <div>
                            <h3>주문 취소</h3>
                            <ul>
                                <li>입금확인 단계 : 마이페이지 > 주문/배송 조회.변경에서 직접 변경 및 취소하실 수 있습니다.</li>
                                <li>상품 준비중 단계부터는 주문 취소/변경이 제한됩니다.</li>
                                <li>카드 환불은 카드사 정책에 따르며, 운영일 기준으로 3~5일 정도 소요됩니다.</li>
                                <li>결제 취소시, 사용기한이 남은 적립금과 쿠폰은 다시 사용하실 수 있습니다.</li>
                                <li>환불이 지연될 경우 환불지연배상금 지급을 요청하실 수 있으며, 환불대상 여부는 고객지원센터(1800-1234)에서 확인 가능합니다.</li>
                                <li>기타 이상이 있는 경우 고객지원센터(1800-1234)로 문의 부탁드립니다.</li>
                            </ul>
                        </div>
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
                                - 상품을 받은 날로부터 3개월 이내 문제가 발생한 경우 <br>
                                - 상품에 문제가 있다는 사실을 알았거나 알 수 있었던 날로부터 30일 이내인 경우
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
                        <div>
                            <h3>후환불 제도</h3>
                            <ul>
                                <li>단순변심, 주문실수에 의한 반품의 경우, 반품된 상품을 수령하여 상태를 점검한 후 환불처리 됩니다.</li>
                                <li>반품된 상품 점검 시 교환/반품불가 사유에 해당될 경우, 반품을 불가합니다 <br>
                                    이 때, 고객님께 별도로 안내되며, 배송비 추가결제가 완료되면 해당 상품을 다시 배송해 드립니다.
                                </li>
                            </ul>
                        </div>
                        <div>
                            <h3>미성년자 권리 보호</h3>
                            <ul>
                                <li>구매자가 미성년자일 경우, 법정대리인이 그 계약에 동의하지 아니하면 미성년자 본인 또는 법정대리인이 그 계약을 취소할 수 있습니다.</li>
                            </ul>
                        </div>
                        <div>
                            <h3>소비자 피해 보상,재화 등에 대한 불만 및 소비자와 사업자의 분쟁 처리에 관한 사항</h3>
                            <ul>
                                <li>소비자 불만 신청 : MEALPICK 고객지원센터(1800-1234) 또는 1:1문의, 카카오톡 상담</li>
                                <li>소비자 피해 분쟁 조정 : 공정거래위원회 및 공정거래위원회가 지정한 분쟁 조정기구</li>
                                <li>고객님께서 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위해서 피해보상처리 기구를 설치, 운영합니다.</li>
                            </ul>
                        </div>
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
                        <div>

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
            let NowDate = new Date();
            let month = NowDate.getMonth() + 1;  // 월
            let date = NowDate.getDate() + 3;  // 날짜
            let day = month + "월 " + date + "일";
            let obj = document.getElementById("day");
            obj.innerHTML = day;
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
                    review : [], // 리뷰 리스트 가져오기
                    reviewFlg : false,

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
                                self.info = data.info;
                                self.count = data.count;
                                self.price = data.info.price;
                                self.imgList = data.imgList;
                                console.log(data.info);

                                if (data.info.allergens != "없음") {
                                    self.allergensFlg = true;
                                }

                            }
                        },
                    });
                },

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
                                console.log(data.review);
                                if(data.review.reviewNo != '') {
                                    reviewFlg = true;
                                }

                            }
                        },
                    });
                },

                // 수량 조절 메소드
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
                    } else if (action === 'sub' && self.quantity > 1) {
                        self.quantity--;

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
                    this.showCartPopup = false; // 쇼핑 계속하기
                },
                formatPrice(value) {
                    return value ? parseInt(value).toLocaleString() : "0"; // 가격 타입 변환(콤마 추가) 
                },

                fnPay(itemNo) {
                    pageChange("/pay.do", { itemNo: itemNo }); // 구매하기로 이동
                },

                changeImage(filePath) {
                    let mainImage = document.getElementById('mainImage').src; // 현재 메인 이미지
                    let clickedIndex = this.imgList.findIndex(img => img.filePath === filePath); // 클릭한 이미지의 인덱스

                    if (clickedIndex !== -1) {
                        // 클릭한 이미지와 메인 이미지 교체
                        this.imgList[clickedIndex].filePath = mainImage;
                        document.getElementById('mainImage').src = filePath;
                    }
                },

                changeTab(tab) {
                    this.selectedTab = tab; // 선택한 탭으로 변경
                }
            },
            computed: { // 가격 타입 변환(콤마 추가)
                formattedPrice() {
                    return parseInt(this.price).toLocaleString();
                },
                formattedTotalPrice() {
                    return (this.price * this.quantity).toLocaleString();
                },
                filteredImgList() {
                    return this.imgList.filter(img => img.thumbNail === 'N');
                    // thumbNail이 'N'인 이미지들만 필터링해서 반환
                },


            },
            mounted() {
                var self = this;
                console.log(self.itemNo);
                self.fngetInfo();
                self.fnGetReview();
            }
        });
        app.mount('#app');
    </script>
    ​