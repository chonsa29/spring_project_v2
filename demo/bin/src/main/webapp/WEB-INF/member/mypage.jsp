<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="/css/member-css/mypage.css">
        <title>MEALPICK - 마이페이지</title>
        <style>
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">
            <!-- 로딩 표시 -->
            <div v-if="isLoading" class="loading-overlay"
                style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.1); z-index: 1000; display: flex; justify-content: center; align-items: center;">
                <div class="loading-spinner"></div>
            </div>

            <!-- 에러 메시지 -->
            <div v-if="error" class="error-message"
                style="background: #ffebee; color: #c62828; padding: 15px; margin: 10px; border-radius: 4px; text-align: center;">
                {{ error }}
                <button @click="error = null"
                    style="margin-left: 10px; background: none; border: none; color: #c62828; cursor: pointer;">×</button>
            </div>

            <!-- 마이페이지 메인 컨테이너 -->
            <div class="my-page-container">
                <!-- 사이드바 네비게이션 -->
                <aside class="my-page-sidebar">
                    <h3>마이페이지 메뉴</h3>
                    <ul>
                        <li>
                            <a href="#" @click.prevent="changeTab('profile')"
                                :class="{active: currentTab === 'profile'}">
                                <i class="fas fa-user"></i> 회원정보
                            </a>
                        </li>
                        <li>
                            <a href="#" @click.prevent="changeTab('orders')" :class="{active: currentTab === 'orders'}">
                                <i class="fas fa-shopping-bag"></i> 주문내역
                            </a>
                        </li>
                        <li>
                            <a href="#" @click.prevent="changeTab('wishlist')"
                                :class="{active: currentTab === 'wishlist'}">
                                <i class="fas fa-heart"></i> 찜한상품
                            </a>
                        </li>
                        <li>
                            <a href="#" @click.prevent="changeTab('coupons')"
                                :class="{active: currentTab === 'coupons'}">
                                <i class="fas fa-ticket-alt"></i> 쿠폰함
                            </a>
                        </li>
                        <li>
                            <a href="#" @click.prevent="changeTab('inquiries')"
                                :class="{active: currentTab === 'inquiries'}">
                                <i class="fas fa-comment"></i> 문의내역
                            </a>
                        </li>
                        <li>
                            <a href="#" @click.prevent="changeTab('grade')" :class="{active: currentTab === 'grade'}">
                                <i class="fas fa-crown"></i> 등급/그룹
                            </a>
                        </li>
                    </ul>

                    <h3>회원 정보</h3>
                    <ul>
                        <li><i class="fas fa-id-card"></i> ID: {{ memberInfo.userId }}</li>
                        <li><i class="fas fa-user"></i> NAME: {{ memberInfo.userName }}</li>
                        <li><i class="fas fa-coins"></i> POINT: {{ memberInfo.point }} P</li>
                        <li v-if="memberInfo.groupName">
                            <i class="fas fa-users"></i> GROUP: {{ memberInfo.groupName }}
                            <span v-if="memberInfo.leaderId === memberInfo.userId" class="group-badge">리더</span>
                        </li>
                    </ul>
                </aside>

                <!-- 메인 콘텐츠 영역 (탭별로 전환) -->
                <main class="my-page-content">
                    <!-- 회원정보 탭 -->
                    <div v-if="currentTab === 'profile'">
                        <h2 class="section-title">회원 정보</h2>

                        <div class="content-card">
                            <h3 class="card-title">기본 정보</h3>
                            <div class="info-row">
                                <span class="info-label">이름</span>
                                <span class="info-value">{{ memberInfo.userName }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">닉네임</span>
                                <span class="info-value">{{ memberInfo.nickname || '없음' }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">생년월일</span>
                                <span class="info-value">{{ memberInfo.birth }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">성별</span>
                                <span class="info-value">
                                    {{ memberInfo.gender === 'M' ? '남성' : memberInfo.gender === 'F' ? '여성' :
                                    memberInfo.gender }}
                                </span>
                            </div>
                        </div>

                        <div class="content-card">
                            <h3 class="card-title">연락처 정보</h3>
                            <div class="info-row">
                                <span class="info-label">전화번호</span>
                                <span class="info-value">{{ memberInfo.phone }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">이메일</span>
                                <span class="info-value">{{ memberInfo.email }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">주소</span>
                                <span class="info-value">{{ memberInfo.address }}</span>
                            </div>
                        </div>

                        <div class="content-card">
                            <h3 class="card-title">기타 정보</h3>
                            <div class="info-row">
                                <span class="info-label">회원등급</span>
                                <span class="info-value">
                                    <span class="grade-badge">{{ memberInfo.gradeName }}</span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">소속 그룹</span>
                                <span class="info-value">{{ memberInfo.groupName || '없음' }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">보유 포인트</span>
                                <span class="info-value point-value">{{ memberInfo.point }} P</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">알러지 정보</span>
                                <span class="info-value">{{ memberInfo.allergy || '없음' }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">가입일자</span>
                                <span class="info-value">{{ memberInfo.regDate }}</span>
                            </div>
                        </div>

                        <!-- 추가된 그룹 정보 카드 -->
                        <div class="content-card" v-if="memberInfo.groupName">
                            <h3 class="card-title">소속 그룹 상세 정보</h3>
                            <div class="info-row">
                                <span class="info-label">그룹명</span>
                                <span class="info-value">{{ memberInfo.groupName }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">그룹 리더</span>
                                <span class="info-value">
                                    {{ memberInfo.leaderId }}
                                    <span v-if="memberInfo.leaderId === memberInfo.userId" class="group-badge"></span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">가입일</span>
                                <span class="info-value">{{ formatDate(memberInfo.joinDate) }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">그룹 내 역할</span>
                                <span class="info-value">{{ memberInfo.groupRole || '일반 멤버' }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">그룹 상태</span>
                                <span class="info-value">{{ memberInfo.groupStatus === 'ACTIVE' ? '활성' : '비활성' }}</span>
                            </div>
                        </div>
                    </div>

                    <!-- 주문내역 탭 (전체 수정 버전) -->
                    <div v-if="currentTab === 'orders'">
                        <h2 class="section-title">주문 내역 ({{ orderTotalCount }})</h2>

                        <div class="sort-options">
                            <select v-model="orderSort" @change="loadOrderList">
                                <option value="date_desc">최신순</option>
                                <option value="date_asc">오래된순</option>
                                <option value="price_desc">높은금액순</option>
                                <option value="price_asc">낮은금액순</option>
                            </select>
                        </div>

                        <div v-if="orders.length === 0" class="empty-message">
                            주문 내역이 없습니다.
                        </div>

                        <div v-for="order in orders" :key="order.orderKey" class="content-card">
                            <div class="info-row">
                                <span class="info-label">주문 번호</span>
                                <span class="info-value">
                                    {{ order.orderKey }}
                                    <i class="fas fa-search action-btn" @click="viewOrderDetail(order.orderKey)"></i>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">상태</span>
                                <span class="info-value">{{ getOrderStatusText(order.orderStatus) }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">주문일자</span>
                                <span class="info-value">{{ order.orderDate }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">총 금액</span>
                                <span class="info-value">{{ formatNumber(order.totalPrice) }}원</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">상품 수</span>
                                <span class="info-value">{{ order.itemCount }}개</span>
                            </div>
                        </div>

                        <div class="pagination">
                            <a v-for="page in orderPages" @click="changeOrderPage(page)"
                                :class="{active: currentOrderPage === page}">
                                {{ page }}
                            </a>
                        </div>
                    </div>

                    <!-- 등급/그룹 탭 (기존 코드 + 그룹 정보 추가) -->
                    <div v-if="currentTab === 'grade'">
                        <h2 class="section-title">등급 및 그룹 정보</h2>

                        <div class="content-card">
                            <h3 class="card-title">회원 등급</h3>
                            <div class="info-row">
                                <span class="info-label">현재 등급</span>
                                <span class="info-value">
                                    <span class="grade-badge">{{ memberInfo.gradeName }}</span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">다음 등급</span>
                                <span class="info-value">VIP (2,000P 달성 시)</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">남은 포인트</span>
                                <span class="info-value">{{ memberInfo.remainPoint }}P</span>
                            </div>
                        </div>

                        <div class="content-card" v-if="memberInfo.groupName">
                            <h3 class="card-title">소속 그룹</h3>
                            <div class="info-row">
                                <span class="info-label">그룹명</span>
                                <span class="info-value">{{ memberInfo.groupName }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">리더</span>
                                <span class="info-value">{{ memberInfo.leaderId }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">가입 일자</span>
                                <span class="info-value">{{ formatDate(memberInfo.joinDate) }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">그룹 혜택</span>
                                <span class="info-value">5% 추가 할인, 무료 배송</span>
                            </div>
                        </div>
                    </div>

                    <!-- 찜한상품 탭 (전체 수정 버전) -->
                    <div v-if="currentTab === 'wishlist'">
                        <h2 class="section-title">찜한 상품 ({{ wishTotalCount }})</h2>

                        <div class="sort-options">
                            <select v-model="wishSort" @change="loadWishList">
                                <option value="date_desc">최신순</option>
                                <option value="date_asc">오래된순</option>
                                <option value="price_desc">높은가격순</option>
                                <option value="price_asc">낮은가격순</option>
                            </select>
                        </div>

                        <div v-if="wishList.length === 0" class="empty-message">
                            찜한 상품이 없습니다.
                        </div>

                        <div v-for="wish in wishList" :key="wish.wishKey" class="content-card">
                            <div class="info-row">
                                <span class="info-label">상품명</span>
                                <span class="info-value">
                                    {{ wish.recentWishProduct }}
                                    <i class="fas fa-search action-btn" @click="viewProductDetail(wish.itemNo)"></i>
                                    <i class="fas fa-trash action-btn delete" @click="deleteWishItem(wish.wishKey)"></i>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">가격</span>
                                <span class="info-value">{{ formatNumber(wish.price) }}원</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">찜한 날짜</span>
                                <span class="info-value">{{ wish.addDate }}</span>
                            </div>
                        </div>

                        <div class="pagination">
                            <a v-for="page in wishPages" @click="changeWishPage(page)"
                                :class="{active: currentWishPage === page}">
                                {{ page }}
                            </a>
                        </div>
                    </div>

                    <!-- 쿠폰함 탭 -->
                    <div v-if="currentTab === 'coupons'">
                        <h2 class="section-title">보유 쿠폰</h2>
                        <div class="content-card" v-for="coupon in coupons" :key="coupon.couponNo">
                            <div class="info-row">
                                <span class="info-label">쿠폰명</span>
                                <span class="info-value">{{ coupon.couponName }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">할인율</span>
                                <span class="info-value">{{ coupon.discountAmount }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">유효기간</span>
                                <span class="info-value">{{coupon.expireDate}}</span>
                            </div>
                        </div>
                        <div v-if="coupons.length === 0" class="empty-message">
                            보유한 쿠폰이 없습니다.
                        </div>
                    </div>

                    <!-- 문의내역 탭 -->
                    <div v-if="currentTab === 'inquiries'">
                        <h2 class="section-title">문의 내역</h2>
                        <div class="content-card" v-for="inquiry in inquiries" :key="inquiry.qsNo">
                            <div class="info-row">
                                <span class="info-label">제목</span>
                                <span class="info-value">{{ inquiry.qsTitle }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">상태</span>
                                <span class="info-value">{{ inquiry.qsStatus }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">등록일</span>
                                <span class="info-value">{{inquiry.cDateTime}}</span>
                            </div>
                        </div>
                        <div v-if="inquiries.length === 0" class="empty-message">
                            문의 내역이 없습니다.
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <jsp:include page="/WEB-INF/common/footer.jsp" />

    </body>

    </html>
    <script>

        const app = Vue.createApp({
            data() {
                return {
                    currentTab: 'profile',
                    memberInfo: {},
                    coupons: [],
                    inquiries: [],
                    isLoading: false,
                    error: null,
                    sessionStatus: "${sessionStatus}",
                    userId: '${sessionId}',
                    // 주문 내역 관련
                    orders: [],
                    orderTotalCount: 0,
                    currentOrderPage: 1,
                    orderPageSize: 5,
                    orderSort: 'date_desc',
                    orderPages: [],

                    // 찜 목록 관련
                    wishList: [],
                    wishTotalCount: 0,
                    currentWishPage: 1,
                    wishPageSize: 5,
                    wishSort: 'date_desc',
                    wishPages: [],
                    // 추가된 그룹 필드
                    groupId: '',
                    groupName: '',
                    leaderId: '',
                    joinDate: '',
                    groupRole: '',
                    groupStatus: ''
                };
            },
            methods: {
                changeTab(tabName) {
                    this.currentTab = tabName;
                    window.location.hash = tabName;

                    if (tabName === 'orders' && this.orders.length === 0) {
                        this.loadOrderList();
                    } else if (tabName === 'wishlist' && this.wishList.length === 0) {
                        this.loadWishList();
                    } else if (tabName === 'profile') {
                        this.loadMemberInfo();
                    } else if (tabName === 'coupons') {
                        this.loadCoupons();
                    } else if (tabName === 'inquiries') {
                        this.loadInquiries();
                    } else if (tabName === 'grade') {
                        this.loadGradeInfo();
                    }
                },

                formatDate(date) {
                    if (!date) return '';
                    const d = new Date(date);
                    return d.toLocaleDateString();
                },

                formatNumber(num) {
                    return num?.toLocaleString() || '0';
                },

                showLoading() {
                    this.isLoading = true;
                },

                hideLoading() {
                    this.isLoading = false;
                },

                showError(message) {
                    this.error = message;
                    setTimeout(() => this.error = null, 3000);
                },

                // 회원정보 로드 (기존 코드 유지)
                loadMemberInfo() {
                    var self = this;
                    var nparmap = { userId: self.userId };
                    $.ajax({
                        url: "/member/myPage/info.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            self.memberInfo = { ...self.memberInfo, ...data.member };
                            self.setGradeAndGroupNames();
                        },
                        error: function (error) {
                            console.error("회원 정보 로딩 실패:", error);
                        }
                    });
                },

                loadGroupInfo() {
                    var self = this;
                    $.ajax({
                        url: "/member/myPage/groupInfo.dox",
                        dataType: "json",
                        type: "POST",
                        data: { userId: this.userId },
                        success: function (data) {
                            console.log(data);
                            if (data.groupInfo) {
                                self.memberInfo.groupId = data.groupInfo.groupId;
                                self.memberInfo.groupName = data.groupInfo.groupName;
                                self.memberInfo.leaderId = data.groupInfo.leaderId;
                                self.memberInfo.joinDate = data.groupInfo.joinDate;
                                self.memberInfo.groupRole = data.groupInfo.groupRole;
                                self.memberInfo.groupStatus = data.groupInfo.groupStatus;
                            }
                        },
                        error: function (error) {
                            console.error("그룹 정보 로딩 실패:", error);
                        }
                    });
                },

                // 주문 내역 관련 메서드
                loadOrderList() {
                    this.showLoading();

                    const self = this;
                    const nparmap = {
                        userId: this.userId,
                        page: this.currentOrderPage,
                        pageSize: this.orderPageSize,
                        sort: this.orderSort
                    };

                    $.ajax({
                        url: "/member/myPage/orderList.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            self.orders = data.orders || [];
                            self.orderTotalCount = data.totalCount || 0;
                            self.calculateOrderPages();
                        },
                        error: function (error) {
                            self.showError('주문 내역을 불러오는 중 오류가 발생했습니다.');
                            console.error(error);
                        },
                        complete: function () {
                            self.hideLoading();
                        }
                    });
                },

                calculateOrderPages() {
                    const totalPages = Math.ceil(this.orderTotalCount / this.orderPageSize);
                    this.orderPages = Array.from({ length: totalPages }, (_, i) => i + 1);
                },

                changeOrderPage(page) {
                    this.currentOrderPage = page;
                    this.loadOrderList();
                },

                getOrderStatusText(status) {
                    const statusMap = {
                        'PAY_COMPLETE': '결제완료',
                        'PREPARING': '상품준비중',
                        'DELIVERING': '배송중',
                        'DELIVERED': '배송완료',
                        'CANCELED': '취소됨'
                    };
                    return statusMap[status] || status;
                },

                viewOrderDetail(orderKey) {
                    window.location.href = '/order/detail.do?orderKey=' + orderKey;
                },

                // 찜 목록 관련 메서드
                loadWishList() {
                    this.showLoading();

                    const self = this;
                    const nparmap = {
                        userId: this.userId,
                        page: this.currentWishPage,
                        pageSize: this.wishPageSize,
                        sort: this.wishSort
                    };

                    $.ajax({
                        url: "/member/myPage/wishListAll.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            self.wishList = data.wishList || [];
                            self.wishTotalCount = data.totalCount || 0;
                            self.calculateWishPages();
                        },
                        error: function (error) {
                            self.showError('찜 목록을 불러오는 중 오류가 발생했습니다.');
                            console.error(error);
                        },
                        complete: function () {
                            self.hideLoading();
                        }
                    });
                },

                calculateWishPages() {
                    const totalPages = Math.ceil(this.wishTotalCount / this.wishPageSize);
                    this.wishPages = Array.from({ length: totalPages }, (_, i) => i + 1);
                },

                changeWishPage(page) {
                    this.currentWishPage = page;
                    this.loadWishList();
                },

                viewProductDetail(itemNo) {
                    window.location.href = '/product/detail.do?itemNo=' + itemNo;
                },

                deleteWishItem(wishKey) {
                    if (!confirm('정말 삭제하시겠습니까?')) return;

                    this.showLoading();

                    const self = this;
                    const nparmap = {
                        wishKey: wishKey,
                        userId: this.userId
                    };

                    $.ajax({
                        url: "/member/myPage/deleteWish.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result === 'success') {
                                console.log(data);
                                self.showError('삭제되었습니다.');
                                self.loadWishList();
                            } else {
                                self.showError('삭제 실패: ' + (data.message || ''));
                            }
                        },
                        error: function (error) {
                            self.showError('삭제 중 오류가 발생했습니다.');
                            console.error(error);
                        },
                        complete: function () {
                            self.hideLoading();
                        }
                    });
                },

                setGradeAndGroupNames() {
                    var self = this;
                    // 등급명 설정
                    if (self.memberInfo.grade) {
                        switch (self.memberInfo.grade) {
                            case 1: self.memberInfo.gradeName = "라이트픽"; break;
                            case 2: self.memberInfo.gradeName = "굿픽"; break;
                            case 3: self.memberInfo.gradeName = "탑픽"; break;
                            case 4: self.memberInfo.gradeName = "VVIPICK"; break;
                            default: self.memberInfo.gradeName = "뉴픽";
                        }
                    }

                    // 다음 등급까지 남은 포인트 계산
                    if (self.memberInfo.grade && self.memberInfo.point) {
                        var requiredPoint = 0;
                        switch (self.memberInfo.grade) {
                            case 1: requiredPoint = 2000; break;
                            case 2: requiredPoint = 5000; break;
                            default: requiredPoint = 0;
                        }
                        self.memberInfo.remainPoint = Math.max(0, requiredPoint - self.memberInfo.point);
                    }
                },

                loadGradeInfo() {
                    var self = this;
                    self.isLoading = true;
                    var nparmap = { userId: self.userId };
                    $.ajax({
                        url: "/member/myPage/grade.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.member) {
                                self.memberInfo.remainPoint = data.member.remainPoint;
                            }
                        },
                        error: function (error) {
                            console.error('등급 정보 로딩 실패:', error);
                        },
                        complete: function () {
                            self.isLoading = false;
                        }
                    });
                },
                // 쿠폰함 조회
                loadCoupons() {
                    var self = this;
                    self.isLoading = true;
                    $.ajax({
                        url: "/member/myPage/coupons.dox",
                        dataType: "json",
                        type: "POST",
                        data: { userId: self.userId },
                        success: function (data) {
                            console.log(data);
                            self.coupons = data.coupons || [];
                        },
                        error: function (error) {
                            console.error('쿠폰 조회 실패:', error);
                        },
                        complete: function () {
                            self.isLoading = false;
                        }
                    });
                },

                // 문의내역 조회
                loadInquiries() {
                    var self = this;
                    self.isLoading = true;
                    $.ajax({
                        url: "/member/myPage/inquiries.dox",
                        dataType: "json",
                        type: "POST",
                        data: { userId: self.userId },
                        success: function (data) {
                            console.log(data);
                            self.inquiries = data.inquiries || [];
                        },
                        error: function (error) {
                            console.error('문의내역 조회 실패:', error);
                        },
                        complete: function () {
                            self.isLoading = false;
                        }
                    });
                },
            },
            mounted() {
                // URL 해시로부터 탭 정보 읽기
                if (window.location.hash) {
                    const tabFromHash = window.location.hash.substring(1);
                    if (['profile', 'orders', 'wishlist', 'coupons', 'inquiries', 'grade'].includes(tabFromHash)) {
                        this.currentTab = tabFromHash;
                    }
                }

                // 초기 데이터 로딩
                this.loadMemberInfo();
                this.loadCoupons();
                this.loadInquiries();
                this.loadGradeInfo();
                this.loadGroupInfo();
            }
        });

        app.mount('#app');
    </script>