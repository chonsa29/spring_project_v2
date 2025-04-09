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
                        <!-- 좋아요 활성화 버튼 -->
                        <button class="product-like" :class="{ active: likedItems.has(info.itemNo) }"
                            @click="fnLike(info.itemNo)">
                            ❤
                        </button>
                    </div>
                    <div v-if="showLikePopup" class="like-popup-overlay">
                        <div class="like-popup">
                            {{ likeAction === 'add' ? '좋아요 항목에 추가되었습니다' : '좋아요 항목에서 취소되었습니다.' }}
                        </div>
                    </div>
                    <span v-if="allergensFlg" id="allergens-info">{{info.allergens}} 주의!</span>

                    <!-- <div v-if="review.length > 0" class="review-summary">
                        <div class="average-rating">
                            <div id="review">
                                별과 점수를 감싸는 wrapper
                                <div class="star-wrapper">
                                    <div class="stars">
                                        <span v-for="n in 5" :key="n" class="star-container-main">
                                            <span class="star empty">★</span>
                                            <span class="star full" v-if="n <= Math.floor(reviewScore)">★</span>
                                            반 별 (조건 추가)
                                            <span class="star half"
                                                v-else-if="n === Math.ceil(reviewScore) && (reviewScore % 1) >= 0.5">
                                                ★
                                            </span>
                                        </span>
                                    </div>
                                    별점 숫자
                                    <div class="review-score">
                                        {{ reviewScore.toFixed(1) }}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> -->

                    <div class="discount-info">
                        <span class="product-discount-style">{{formatPrice(info.price * 3) }}원</span>
                        <span class="price">{{formattedPrice}}원</span>
                        <span class="discount">
                            <span @click="toggleDiscount" class="discount-toggle">
                                <span>혜택 정보</span>
                                <span class="caret-icon">
                                    <span v-if="isDiscountOpen">▲</span>
                                    <span v-else>▼</span>
                                </span>
                            </span>

                            <!-- 팝업: caret-icon 기준으로 absolute 위치 -->
                            <div v-if="isDiscountOpen" class="discount-popup">
                                <div class="popup-header">
                                    <span>혜택 정보</span>
                                    <button class="custom-close-btn" @click="toggleDiscount">✕</button>
                                </div>
                                <div class="popup-content">
                                    <div class="price-row">
                                        <span class="label">판매가</span>
                                        <span class="value">{{ formatPrice(info.price * 3) }}원</span>
                                    </div>
                                    <div class="discount-detail">
                                        <span>ㄴ 세일 (25.04.01 ~ 25.05.31)</span>
                                        <span class="discount-amount">- {{ formatPrice((info.price * 3) - info.price)
                                            }}원</span>
                                    </div>
                                    <div class="final-price">
                                        <span>최적가</span>
                                        <span class="final-value">{{ formattedPrice }}원</span>
                                    </div>
                                </div>
                            </div>

                        </span>
                    </div>
                    <div class="delivery">
                        <span id="delivery-price">배송비</span>
                        <span id="delicery-total">3,000원 </span>
                        <span> / 30,000원 이상 구매시 배송비 무료</span>
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
                            <span>구매 수량</span>
                            <div class="quantity-controls">
                                <button class="quantity-btn" @click="fnquantity('sub')">-</button>
                                <input type="text" class="quantity-input" v-model="quantity" @input="checkQuantity">
                                <button class="quantity-btn" @click="fnquantity('sum')">+</button>
                            </div>
                        </div>
                    </div>

                    <!-- 합계 -->
                    <div class="total">
                        <span>합계</span>
                        <span id="price-total">{{formattedTotalPrice}}</span>
                    </div>

                    <!-- 장바구니, 구매하기 박스-->
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
                        <button class="buy" @click="fnPay(info.itemNo, quantity)">
                            구매하기
                        </button>
                    </div>
                </div>
            </div>

            <!-- 추천 상품 영역 -->
            <div class="recommend-section">
                <h3 class="recommend-title">이런 상품은 어때요?</h3>

                <div class="recommend-wrapper">
                    <!-- 왼쪽 버튼 -->
                    <button class="arrow left" v-if="isSliderActive" @click="slideLeft">&#10094;</button>

                    <!-- 추천상품 뷰포트 -->
                    <div class="recommend-viewport"
                        :style="{ width: (itemWidth * visibleCount - 24) + 'px', overflow: 'hidden' }">
                        <!-- recommend 대신 duplicatedRecommend 사용 -->
                        <div class="recommend-list" :style="getSlideStyle()">
                            <div class="recommend-item" v-for="(item, index) in duplicatedRecommend" :key="index"
                                @mouseenter="hoveredIndex = index" @mouseleave="hoveredIndex = null"
                                @click="fnInfo(item.itemNo)">

                                <div class="image-wrapper">
                                    <img :src="item.filePath" alt="item.itemName" class="recommend-thumb">
                                    <div class="icon-buttons">
                                        <button @click.stop="addToCart(item.itemNo)" class="recommend-cart"
                                            @click="fnCart(item.itemNo, userId)">🛒</button>
                                        <button @click.stop="fnLike(item.itemNo)" class="recommend-like"
                                            :class="{ active: likedItems.has(item.itemNo) }">❤</button>
                                    </div>
                                </div>

                                <p class="recommend-name">{{ item.itemName }}</p>
                                <p class="recommend-discount-style">{{formatRecommendPrice(item.price * 3) }}원</p>
                                <p class="recommend-price">{{ formatRecommendPrice(item.price) }}원</p>
                            </div>

                        </div>
                    </div>
                    <!-- 오른쪽 버튼 -->
                    <button class="arrow right" v-if="isSliderActive" @click="slideRight">&#10095;</button>
                </div>
            </div>




            <div id="product-view">
                <div id="product-menu">
                    <div :class="['Info', selectedTab === 'info' ? 'active-tab' : '']" @click="changeTab('info')">상품 정보
                    </div>
                    <div :class="['Review', selectedTab === 'review' ? 'active-tab' : '']" @click="changeTab('review')">
                        상품 리뷰 ({{reviewCount}})</div>
                    <div :class="['Inquiry', selectedTab === 'inquiry' ? 'active-tab' : '']"
                        @click="changeTab('inquiry')">상품 문의 ({{QuestionCount}})</div>
                    <div :class="['Exchange-Return', selectedTab === 'exchange' ? 'active-tab' : '']"
                        @click="changeTab('exchange')">교환/환불</div>

                </div>

                <div id="product-view">
                    <!-- 상세정보 -->
                    <div v-show="selectedTab === 'info'" class="preparing-info">
                        <p>아직 준비중인 상품입니다.</p>

                    </div>


                    <!-- 상품 리뷰 -->
                    <div v-show="selectedTab === 'review'" class="review-container">

                        <!-- 리뷰 요약 -->
                        <div class="review-score-summary">
                            <div class="review-score-container">
                                <p class="review-total">총 {{ reviewCount }}건</p>
                                <p class="review-average" v-if="reviewScore !== undefined">{{ reviewScore.toFixed(1) }}점
                                </p>
                                <div class="review-stars">
                                    <span v-for="n in 5" :key="'star-' + n" class="star-container">
                                        <span class="star"
                                            :class="{ 'filled': n <= Math.floor(reviewScore || 0) }">★</span>
                                        <span class="star half-filled"
                                            v-if="n === Math.ceil(reviewScore || 0) && (reviewScore % 1 >= 0.5)">★</span>
                                    </span>
                                </div>
                            </div>
                            <div class="review-bar-container" v-show="ratingDistribution">
                                <div v-for="n in 5" :key="n" class="review-bar">
                                    <span class="review-bar-label">{{ 6 - n }}점</span>
                                    <div class="bar">
                                        <div class="filled-bar"
                                            :style="{ width: (ratingDistribution[6-n] || 0) + '%' }"></div>
                                    </div>
                                    <span class="review-bar-percent">
                                        {{ ratingDistribution[6-n] ? Math.round(ratingDistribution[6-n]) + '%' : '0%' }}
                                    </span>
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
                                <div class="review-date">{{ review.cDatetime.substring(0, 10) }}</div>
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
                        <div class="inquiry-container">
                            <p class="inquiry-notice">★ 상품 문의사항이 아닌 반품/교환관련 문의는 1:1 채팅, 또는 고객센터(1800-1234)를 이용해주세요.
                                <button @click="openInquiryPopup" class="inquiry-button">상품 문의하기</button>
                            </p>
                            <!-- 상품 문의하기 버튼 -->
                            <div>
                                <!-- 상품 문의 팝업 -->
                                <div v-if="isPopupOpen" class="inquiry-popup-overlay" @click="closePopup">
                                    <div class="inquiry-popup" @click.stop>
                                        <div class="popup-content">
                                            <h2>상품 Q&A 작성</h2>
                                            <div class="product-info">{{ info.itemName }}</div>
                                            <div class="textarea-container-title">
                                                <textarea v-model="iqTitle" placeholder="문의 제목을 입력하세요."
                                                    @input="limitText"></textarea>
                                                <div class="char-count">{{ iqTitle.length }}/50자</div>
                                            </div>
                                            <div class="textarea-container-contents">
                                                <textarea v-model="iqContents" placeholder="문의 내용을 입력하세요."
                                                    @input="limitText" @keyup.enter="fnAddInquiry"></textarea>
                                                <div class="char-count">{{ iqContents.length }}/250자</div>
                                            </div>
                                            <div class="inquiry-button-container">
                                                <button class="cancel-btn" @click="closePopup">취소</button>
                                                <button class="submit-btn" @click="fnAddInquiry">등록</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <div class="inquiry-list">
                                <!-- 문의 항목 -->
                                <div v-if="inquiry.length > 0">
                                    <div v-for="(inquiry, index) in inquiry" :key="inquiry.iqNo" class="inquiry-inquiry"
                                        @click="changeInquiry(inquiry.iqNo)">
                                        <div class="inquiry-title">
                                            <span class="badge-answered" v-if="inquiry.iqStatus === 'Y'">답변완료</span>
                                            <span class="badge-pending" v-else>답변대기</span>
                                            <span class="question-text">{{ inquiry.iqTitle }}</span>
                                            <span class="user-info">{{ maskUserId(inquiry.userId) }}</span>
                                            <span class="date">{{ inquiry.cDateTime.substring(0, 10) }}</span>
                                        </div>

                                        <div class="inquiry-content" v-show="answer === inquiry.iqNo">
                                            <div class="question-content">
                                                <div class="question-icon">Q</div>
                                                <p>{{ inquiry.iqContents }}</p>
                                            </div>
                                            <br>
                                            <hr>
                                            <br>
                                            <div class="answer-content" v-if="inquiry.iqStatus === 'Y'">
                                                <div class="answer-icon">A</div>
                                                <div class="answer-text">
                                                    <p>{{ inquiry.iqContents }}</p>
                                                </div>
                                            </div>
                                            <div class="answer-content" v-else>
                                                <div class="answer-icon">A</div>
                                                <p>아직 답변이 등록되지 않았습니다.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 문의 내역이 없을때 -->
                                <div v-else class="no-inquiry">
                                    등록된 문의가 없습니다.
                                </div>
                            </div>
                        </div>

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
                                <li>상품을 받은 날로부터 7일 이내에 상품의 상태를 확인할 수 있는 사진을 첨부해 1:1채팅, 카카오톡 상담 및 고객지원센터(1800-1234)에
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
                                <li>배송비 추가결제가 완료되면 해당 상품을 회수하여 상태를 확인한 후 교환/반품 절차가 진행됩니다.</li>
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
                    info: {}, // 단일 객체 가져오기
                    itemNo: "${map.itemNo}",
                    userId: "${sessionId}", // 로그인 아이디

                    quantity: 1, // 재고 기본값
                    allergensFlg: false, // 알레르기 여부
                    count: 0, // 재고
                    price: 0, // 가격

                    isDiscountOpen: false, // 할인 팝업

                    imgList: [], // 썸네일, 서브 이미지 리스트 가져오기

                    recommend: [], // 추천상품 목록 들고오기
                    itemWidth: 200 + 24, // 224px
                    visibleCount: 4,
                    currentIndex: 0,
                    hoveredIndex: null, // 추천 상품 hover

                    duplicatedRecommend: [], // 앞뒤 복제된 리스트 (무한 슬라이드용)
                    isSliding: false, // transition 중 중복 방지
                    isSliderActive: false,

                    selectedTab: 'info', // 기본값은 "상품 정보"

                    showCartPopup: false, // 장바구니 추가 팝업

                    likedItems: new Set(),
                    likedItemsLoaded: false, // 좋아요 로딩 완료 여부
                    showLikePopup: false, // 좋아요 표시
                    wish: [], // 좋아요 목록
                    likeAction: '', // 'add' 또는 'remove'

                    review: [], // 리뷰 리스트 가져오기
                    reviewFlg: false, // 리뷰 표시 여부
                    reviewCount: 0, // 리뷰 총 토탈 개수
                    reviewScore: 0,
                    ratingDistribution: { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 }, // 기본값 추가

                    answer: null, // 문의 표시 여부 기본값은 없음.

                    isPopupOpen: false,  // 팝업 열림 여부
                    iqContents: "",  // 문의 내용 입력값
                    iqTitle: "", // 문의 제목 입력값

                    inquiry: [], // 문의 내역 가져오기
                    QuestionCount: 0, // 문의 개수 가져오기
                };
            },

            methods: {

                // 상세 정보 가져오기
                fngetInfo() {
                    var self = this;
                    self.showLikePopup = false;
                    if (!self.likedItemsLoaded) {
                        return;
                    }

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

                                self.filterAndPrepareRecommend(data.recommend);

                                // 알레르기 표시 여부
                                if (data.info.allergens != "없음") {
                                    self.allergensFlg = true;
                                }

                            }
                        },
                    });
                },


                filterAndPrepareRecommend(recommendList) {
                    var self = this;

                    let filtered = recommendList.filter(item => {
                        return item.itemNo !== self.itemNo && !self.likedItems.has(item.itemNo);
                    });

                    let shuffled = self.shuffleArray(filtered);

                    // 슬라이드 비활성 조건: 추천 상품 수가 visibleCount보다 적을 때
                    self.isSliderActive = shuffled.length >= self.visibleCount;

                    // 최대 6개만 선택 (슬라이드든 아니든)
                    shuffled = shuffled.slice(0, 6);

                    self.recommend = shuffled;

                    if (self.isSliderActive) {
                        // 무한 슬라이드를 위한 duplicated 구성
                        self.duplicatedRecommend = [
                            ...shuffled.slice(-self.visibleCount),
                            ...shuffled,
                            ...shuffled.slice(0, self.visibleCount)
                        ];
                        self.currentIndex = self.visibleCount;
                    } else {
                        // 슬라이드 비활성 시 복제 없이 원본만 사용
                        self.duplicatedRecommend = [...shuffled];
                        self.currentIndex = 0;
                    }
                },


                // 배열 섞기 메소드 (Fisher–Yates)
                shuffleArray(array) {
                    let shuffled = [...array];
                    for (let i = shuffled.length - 1; i > 0; i--) {
                        const j = Math.floor(Math.random() * (i + 1));
                        [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
                    }
                    return shuffled;
                },

                slideLeft() {
                    var self = this;
                    if (self.isSliding) return;
                    self.isSliding = true;
                    self.currentIndex--;

                    setTimeout(() => {
                        // 복제 리스트의 앞쪽에 도달한 경우 → 원본 마지막 위치로 점프
                        if (self.currentIndex === 0) {
                            self.currentIndex = self.recommend.length;
                        }
                        self.isSliding = false;
                    }, 300); // transition 시간과 맞춤
                },
                slideRight() {
                    var self = this;
                    if (self.isSliding) return;
                    self.isSliding = true;
                    self.currentIndex++;

                    // 복제 리스트의 뒷쪽 끝에 도달한 경우 → 원본 시작 위치로 점프
                    setTimeout(() => {
                        if (self.currentIndex === self.recommend.length + self.visibleCount) {
                            // 오른쪽 끝 도달 → 원본 리스트 시작으로 점프
                            self.currentIndex = self.visibleCount;
                        }
                        self.isSliding = false;
                    }, 300);
                },


                getSlideStyle() {
                    var self = this;

                    if (!self.isSliderActive) {
                        return {
                            transform: 'none',
                            transition: 'none',
                            width: (self.duplicatedRecommend.length * self.itemWidth) + 'px'
                        };
                    }

                    return {
                        transform: 'translateX(' + -(self.currentIndex * self.itemWidth) + 'px)',
                        transition: self.isSliding ? 'transform 0.3s ease' : 'none',
                        width: (self.duplicatedRecommend.length * self.itemWidth) + 'px'
                    };
                },

                fnInfo(itemNo) {
                    pageChange("/product/info.do", { itemNo: itemNo });
                },

                toggleDiscount() {
                    this.isDiscountOpen = !this.isDiscountOpen;
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

                                // 리뷰 평균 계산
                                if (self.review && self.review.length > 0) {
                                    let totalScore = 0;
                                    self.review.forEach((review) => {
                                        console.log(review.reviewScore)
                                        totalScore += parseFloat(review.reviewScore) || 0;  // 숫자로 변환하여 합산
                                    });
                                    self.reviewScore = totalScore / self.review.length;  // 평균 계산
                                } else {
                                    self.reviewScore = 0;  // 리뷰가 없으면 평균 점수를 0으로 설정
                                }

                                console.log("평균 별점:", self.reviewScore);  // 평균 별점 출력
                                self.updateRatingDistribution();

                            }
                        },
                    });
                },

                updateRatingDistribution() { // 총점 리뷰 정리
                    var self = this;
                    // 별점 분포 초기화 (모든 별점 0으로 시작)
                    self.ratingDistribution = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };

                    // 리뷰 데이터가 없는 경우 처리
                    if (!self.review || self.review.length === 0) {
                        // 데이터가 아직 로드되지 않은 초기 상태
                        if (self.review === undefined) {
                            console.log("❌ 리뷰 데이터가 아직 로드되지 않음 (초기 상태)");
                        }
                        // 데이터는 로드되었지만 리뷰가 0개인 경우
                        else {
                            console.log("ℹ️ 리뷰 데이터가 로드되었지만 0개임");
                        }
                        return; // 별점 계산을 진행하지 않고 종료
                    }

                    // 현재 리뷰 데이터를 콘솔에 출력 (디버깅용)
                    // console.log("✅ 현재 리뷰 데이터:", this.review);

                    // 리뷰 목록을 순회하면서 별점 개수 세기
                    self.review.forEach(review => {
                        let score = parseInt(review.reviewScore); // reviewScore를 숫자로 변환
                        if (score >= 1 && score <= 5) {
                            self.ratingDistribution[score]++; // 해당 별점 개수 증가
                        }
                    });

                    // 별점 개수를 백분율(%)로 변환
                    let totalReviews = self.review.length; // 총 리뷰 개수
                    Object.keys(self.ratingDistribution).forEach(key => {
                        let percent = (self.ratingDistribution[key] / totalReviews) * 100;
                        self.ratingDistribution[key] = Math.round(percent); // 소수점 없이 정수로 저장
                    });

                    // 변환된 별점 비율을 콘솔에 출력 (디버깅용)
                    // console.log("✅ 변환된 별점 비율 데이터:", this.ratingDistribution);
                },

                // 문의 내용 가져오기
                fnInquiry() {
                    var self = this;
                    var nparmap = {
                        itemNo: self.itemNo,
                    };

                    $.ajax({
                        url: "/product/getproductQuestion.dox",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result == "success") {
                                self.inquiry = data.ProductQuestion;
                                self.QuestionCount = data.QuestionCount;
                                console.log(data);
                            } else {
                                console.log("실패")
                            }
                        }
                    });
                },



                // 문의 내역 표시 여부
                changeInquiry(iqNo) {
                    var self = this;
                    self.answer = self.answer === iqNo ? null : iqNo;
                },

                // 사용자 ID 마스킹 (예: Ex1234 -> Ex1****)
                maskUserId(userId) {
                    return userId.substring(0, 3) + "****";
                },

                // 문의 사항 작성 팝업 열기
                openInquiryPopup() {
                    var self = this;
                    self.isPopupOpen = true;
                },

                // 문의 사항 작성 팝업 닫기
                closePopup() {
                    var self = this;
                    self.isPopupOpen = false;
                    self.iqContents = ""; // 입력 초기화
                    self.iqTitle = "";
                },

                // 문의 내용 글자수 제한
                limitText() {
                    var self = this;
                    if (self.iqContents.length > 250) {
                        self.iqContents = self.iqContents.substring(0, 250);
                    }
                    if (self.iqTitle.length > 50) {
                        self.iqTitle = self.iqTitle.substring(0, 50);
                    }
                },

                // 문의 내용 등록하기
                fnAddInquiry() {
                    var self = this;

                    if (!self.userId) {
                        alert("로그인 후 이용바랍니다.");
                        location.href = "/member/login.do";
                        return;
                        // 로그인
                    }

                    if (self.iqContents == "" || self.iqTitle == "") {
                        alert("문의 내용을 입력해주세요.");
                        return;
                        // 내용 입력
                    }


                    var nparmap = {
                        userId: self.userId,
                        itemNo: self.itemNo,
                        iqContents: self.iqContents,
                        iqTitle: self.iqTitle,
                    };

                    console.log("userId:", self.userId);
                    console.log("itemNo:", self.itemNo);
                    console.log("iqContents:", self.iqContents);
                    console.log("iqTitle:", self.iqTitle);

                    $.ajax({
                        url: "/product/addproductQuestion.dox",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result == "success") {
                                console.log(data);
                                alert("문의가 정상적으로 등록되었습니다.");
                                self.fnInquiry();
                                self.closePopup();
                            } else {
                                alert("등록 실패. 다시 시도해주세요.");
                            }
                        }
                    });
                },

                // 수량 조절 메소드(버튼 동작)
                fnquantity: function (action) {
                    var self = this;
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

                    if (!self.userId) {
                        alert("로그인 후 이용가능합니다.");
                        return;
                    }
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

                // 장바구니로 이동
                goToCart() {
                    window.location.href = '/cart.do';
                },

                // 쇼핑 계속하기
                closeCartPopup() {
                    var self = this;
                    self.showCartPopup = false;
                },

                // 가격 타입 변혼(콤마 추가)
                formatPrice(value) {
                    return value ? parseInt(value).toLocaleString() : "0";
                },

                // 구매하기로 이동
                fnPay(itemNo, quantity) {
                    var self = this;
                    console.log("itemNo:", itemNo);
                    console.log("quantity:", String(quantity));
                    pageChange("/pay.do", { itemNo: itemNo, quantity: String(quantity) });
                },

                // 이미지 교체
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

                // 선택한 탭으로 변경 (상품정보, 상품리뷰, 상품문의, 교환/환불)
                changeTab(tab) {
                    var self = this;
                    self.selectedTab = tab;
                },


                // 좋아요 표시
                fnLike(itemNo) {
                    var self = this;

                    if (!self.userId) {
                        // 로그인 페이지로 리디렉션
                        alert("로그인 후 이용가능합니다.");
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
                        url: "/product/likeToggle.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result == "a") {  // 좋아요 추가
                                if (!self.likedItems.has(itemNo)) {
                                    self.likedItems.add(itemNo);  // 좋아요 추가
                                    self.likeAction = 'add';
                                    self.showLikePopup = true;
                                    setTimeout(() => {
                                        self.showLikePopup = false;
                                    }, 2000);
                                }
                            } else if (data.result == "c") {  // 좋아요 취소
                                if (self.likedItems.has(itemNo)) {
                                    self.likedItems.delete(itemNo);  // 좋아요 취소
                                    self.likeAction = 'remove';
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

                // 좋아요 여부 확인
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
                                self.likedItemsLoaded = true; // 불러왔다는 표시
                                self.fngetInfo(); // 여기서 호출!
                            }
                        }
                    });
                },

                formatRecommendPrice(value) {
                    if (!value) return '0';
                    return parseInt(value).toLocaleString();
                }


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
                self.fnInquiry();

                // 초기화
                self.showLikePopup = false;
            }
        });
        app.mount('#app');
    </script>
    ​