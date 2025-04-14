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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
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
                        <li>
                            <a href="#" @click.prevent="openWithdrawModal" class="text-danger">
                                <i class="fas fa-user-slash"></i> 회원 탈퇴
                            </a>
                        </li>
                    </ul>
                </aside>

                <!-- 메인 콘텐츠 영역 (탭별로 전환) -->
                <main class="my-page-content">
                    <!-- 회원정보 탭 -->
                    <div v-if="currentTab === 'profile'">
                        <h2 class="section-title">회원 정보</h2>
                        <!-- 정보 수정 버튼 -->
                        <div v-if="currentTab === 'profile'" class="text-end mt-3">
                            <button class="btn btn-outline-primary" @click="openEditModal">
                                <i class="fas fa-edit me-2"></i>정보 수정
                            </button>
                        </div>
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
                                <span class="info-label">회원 등급</span>
                                <span class="info-value">
                                    <span class="grade-badge" :data-grade="memberInfo.gradeName"
                                        v-if="memberInfo.gradeName">
                                        {{ memberInfo.gradeName }}
                                    </span>
                                    <span v-else>등급 정보 없음</span>
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
                                <span class="info-value">{{ formatDate(memberInfo.regDate) }}</span>
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
                                <span class="info-value">{{ formatNumber(order.price) }}원</span>
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

                        <div class="content-card" v-if="currentTab === 'grade'">
                            <h3 class="card-title">회원 등급</h3>
                            <div class="info-row">
                                <span class="info-label">현재 등급</span>
                                <span class="info-value">
                                    <span class="grade-badge" :data-grade="memberInfo.gradeName">
                                        {{ memberInfo.gradeName }}
                                    </span>
                                    ({{ formatNumber(memberInfo.monthSpent) }}원 사용)
                                </span>
                            </div>
                            <div class="info-row" v-if="memberInfo.grade < 5">
                                <span class="info-label">다음 등급</span>
                                <span class="info-value">
                                    {{ getNextGradeName(memberInfo.grade) }}
                                    ({{ formatNumber(memberInfo.remainPoint) }}원 더 사용 시)
                                </span>
                            </div>
                        </div>

                        <div class="content-card" v-if="memberInfo.groupName">
                            <h3 class="card-title">소속 그룹</h3>
                            <div class="info-row">
                                <span class="info-label">그룹명</span>
                                <span class="info-value">{{ memberInfo.groupName }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">나의 역할</span>
                                <span class="info-value">
                                    {{ memberInfo.groupRole === 'LEADER' ? '리더' : '멤버' }}

                            </div>
                            <div class="info-row">
                                <span class="info-label">리더</span>
                                <span class="info-value">{{ memberInfo.leaderId }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">그룹 멤버</span>
                                <div class="member-list">
                                    <div v-for="member in memberInfo.groupMembers" :key="member.userId"
                                        class="member-item" :class="{ leader: member.groupRole === 'LEADER' }">
                                        {{ member.userName }} ({{ member.userId }})
                                        <span class="role-badge">
                                            {{ member.groupRole === 'LEADER' ? '리더' : '멤버' }}
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="info-row">
                                <span class="info-label">가입 일자</span>
                                <span class="info-value">{{ formatDate(memberInfo.joinDate) }}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">그룹 혜택</span>
                                <span class="info-value">
                                    <span class="discount-badge">{{ memberInfo.groupDiscountRate }}% 추가 할인</span>
                                    <small v-if="memberInfo.gradeName">({{ memberInfo.gradeName }} 등급 적용)</small>
                                </span>
                            </div>
                        </div>

                        <div v-else>
                            <h4>현재 소속된 그룹이 없습니다. <br>그룹 가입시 더 많은 혜택을 받으실 수 있습니다.</h4>
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

                    <!-- 문의내역 탭 부분 수정 -->
                    <div v-if="currentTab === 'inquiries'">
                        <h2 class="section-title">문의 내역</h2>
                        <div class="content-card" v-for="inquiry in inquiries" :key="inquiry.qsNo">
                            <div class="info-row">
                                <span class="info-label">제목</span>
                                <span class="info-value">
                                    <a href="#" @click.prevent="viewInquiryDetail(inquiry.qsNo)" class="inquiry-title">
                                        {{ inquiry.qsTitle }}
                                    </a>
                                    <i class="fas fa-search action-btn" @click="viewInquiryDetail(inquiry.qsNo)"></i>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">상태</span>
                                <span class="info-value" :class="{
                'text-warning': inquiry.qsStatus === '확인중',
                'text-primary': inquiry.qsStatus === '처리중',
                'text-success': inquiry.qsStatus === '처리완료'
            }">
                                    {{ inquiry.qsStatus }}
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">등록일</span>
                                <span class="info-value">{{ inquiry.cDateTime }}</span>
                            </div>
                        </div>
                        <div v-if="inquiries.length === 0" class="empty-message">
                            문의 내역이 없습니다.
                        </div>
                    </div>
                </main>
            </div>
            <!--정보 수정-->
            <div class="modal fade" id="editMemberModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">회원정보 수정</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="editForm">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">이름</label>
                                        <input type="text" class="form-control" :value="memberInfo.userName"
                                            v-model="memberInfo.userName" disabled>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">닉네임</label>
                                        <input type="text" class="form-control" v-model="editData.nickname" required>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">전화번호</label>
                                        <input type="tel" class="form-control" v-model="editData.phone"
                                            placeholder="010-1234-5678" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">이메일</label>
                                        <input type="email" class="form-control" v-model="editData.email" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">주소</label>
                                    <div class="input-group">
                                        <!-- 주소를 한 번에 입력할 수 있도록 설정 -->
                                        <input type="text" class="form-control" v-model="editData.address"
                                            id="memberAddress" readonly>
                                        <button class="btn btn-outline-secondary" type="button"
                                            @click="searchAddress">주소 검색</button>
                                    </div>
                                    <!-- 상세주소 입력 필드 -->
                                    <input type="text" class="form-control mt-2" v-model="editData.addressDetail"
                                        placeholder="상세주소">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">새 비밀번호 (변경시만 입력)</label>
                                    <input type="password" class="form-control" v-model="editData.newPassword">
                                    <small class="text-muted">8자 이상, 영문+숫자 조합</small>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                            <button type="button" class="btn btn-primary" @click="updateMemberInfo">저장하기</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 주문 상세 모달 -->
            <div class="modal-overlay" v-if="showOrderModal" @click.self="closeOrderModal">
                <div class="modal-content">
                    <button class="modal-close" @click="closeOrderModal">×</button>

                    <h3>주문 상세 정보</h3>
                    <div class="info-row">
                        <span class="info-label">주문 번호</span>
                        <span class="info-value">{{ selectedOrder.orderKey }}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">주문일자</span>
                        <span class="info-value">{{ selectedOrder.orderDate }}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">배송 상태</span>
                        <span class="info-value">{{ getOrderStatusText(selectedOrder.orderStatus) }}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">총 금액</span>
                        <span class="info-value">{{ formatNumber(selectedOrder.totalPrice) }}원</span>
                    </div>

                    <!-- 리뷰 작성 폼 -->
                    <div class="review-section" v-if="selectedOrder.orderStatus === 'DELIVERED'">
                        <h4>리뷰 작성</h4>
                        <div v-for="item in selectedOrder.items" :key="item.itemId" class="item-review-block">
                            <div class="info-row">
                                <span class="info-label">{{ item.productName }}</span>
                            </div>
                            <textarea v-model="item.reviewContent" placeholder="리뷰를 작성해 주세요."></textarea>
                            <button @click="submitReview(item)">리뷰 등록</button>
                        </div>
                    </div>
                </div>
            </div>





            <!-- 모달 추가 -->
            <div class="modal fade" id="withdrawModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title">회원 탈퇴</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p>정말 탈퇴하시겠습니까? 모든 정보가 삭제됩니다.</p>
                            <a href="/member/withdraw.do" class="btn btn-danger">탈퇴 페이지 이동</a>
                        </div>
                    </div>
                </div>
            </div>

            <div id="addressSearchContainer" style="display:none;"></div>
            <jsp:include page="/WEB-INF/common/footer.jsp" />
            <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                    currentTab: 'orders',
                    orderSort: 'date_desc',
                    orderTotalCount: 0,
                    currentOrderPage: 1,
                    orderPages: [],
                    showOrderModal: false,
                    selectedOrder: null, // 선택된 주문 저장

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
                    groupStatus: '',
                    monthSpent: '',
                    editData: {
                        nickname: '1234',
                        phone: '1234',
                        email: '1234',
                        address: '1234',
                        newPassword: '1234'
                    },
                    editModal: null // 모달 인스턴스 저장용
                };
            },
            methods: {
                async submitReview(item) {
                    if (!item.reviewContent || item.reviewContent.trim() === '') {
                        alert('리뷰 내용을 입력해 주세요.');
                        return;
                    }

                    try {
                        const response = await $.ajax({
                            url: '/review/write.do',
                            method: 'POST',
                            data: {
                                orderKey: this.selectedOrder.orderKey,
                                itemId: item.itemId,
                                content: item.reviewContent
                            }
                        });

                        if (response.success) {
                            alert('리뷰가 등록되었습니다.');
                            item.reviewContent = ''; // 초기화
                        } else {
                            alert('리뷰 등록에 실패했습니다.');
                        }
                    } catch (error) {
                        console.error('리뷰 등록 오류:', error);
                        alert('리뷰 등록 중 오류가 발생했습니다.');
                    }
                },
                viewOrderDetail(orderKey) {
                    const order = this.orders.find(o => o.orderKey === orderKey);
                    if (order) {
                        this.selectedOrder = order;
                        this.showOrderModal = true;
                    }
                },
                closeOrderModal() {
                    console.log('모달 닫기 호출됨');
                    this.showOrderModal = false;
                    this.selectedOrder = null;
                },
                openWithdrawModal() {
                    new bootstrap.Modal(document.getElementById('withdrawModal')).show();
                },

                getNextGradeName(currentGrade) {
                    const gradeMap = {
                        1: '라이트픽',
                        2: '굿픽',
                        3: '탑픽',
                        4: 'VVIPICK',
                        5: '최고 등급'
                    };
                    return gradeMap[currentGrade + 1] || '';
                },
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
                    }
                },

                formatDate(date) {
                    if (!date) return '';
                    const d = new Date(date);
                    return d.toLocaleDateString();
                },

                formatNumber(num) {
                    if (typeof num === 'number') {
                        return num.toLocaleString();
                    }
                    const parsed = parseFloat(num);
                    return isNaN(parsed) ? '0' : parsed.toLocaleString();
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
                // loadMemberInfo() 수정
                loadMemberInfo() {
                    const self = this;
                    this.isLoading = true;

                    // 1. 회원 기본 정보 로드
                    $.ajax({
                        url: "/member/myPage/info.dox",
                        type: "POST",
                        data: { userId: this.userId, groupId: this.groupId },
                        success: function (memberData) {
                            if (memberData.member) {
                                // 2. 등급 계산
                                const spent = parseInt(memberData.member.monthSpent || 0);
                                const gradeInfo = self.calculateGrade(spent);

                                // 3. 그룹 정보 로드
                                $.ajax({
                                    url: "/member/myPage/groupInfo.dox",
                                    type: "POST",
                                    data: { userId: self.userId, groupId: self.groupId },
                                    success: function (groupData) {
                                        if (typeof groupData === 'string') {
                                            groupData = JSON.parse(groupData);
                                        }

                                        // 그룹 정보 로드 후 memberInfo를 업데이트
                                        const groupInfo = groupData.groupInfo;
                                        const groupMembers = groupData.groupMembers || [];

                                        self.memberInfo = {
                                            ...memberData.member,
                                            ...gradeInfo,
                                            groupId: groupInfo.groupId,
                                            groupName: groupInfo.groupName,
                                            leaderId: groupInfo.leaderId,
                                            joinDate: groupInfo.joinDate,
                                            groupStatus: groupInfo.groupStatus,
                                            groupRole: groupInfo.groupRole || 'MEMBER',
                                            groupMembers: groupMembers
                                        };

                                        // memberInfo가 업데이트된 후에 loadEditForm 호출
                                        self.loadEditForm();
                                    },
                                    error: function (error) {
                                        console.error("그룹 정보 로드 실패:", error);
                                    }
                                });
                            }
                        },
                        error: function (error) {
                            console.error("회원 정보 로드 실패:", error);
                        },
                        complete: function () {
                            self.isLoading = false;
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
                        'P': '상품준비중',
                        'D': '배송중',
                        'F': '배송완료',
                        'C': '취소됨'
                    };
                    return statusMap[status] || status;
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
                    window.location.href = '/product/info.do?itemNo=' + itemNo;
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

                calculateGrade(spent) {
                    let grade, gradeName, remainPoint;

                    if (spent >= 200000) {
                        grade = 5; gradeName = "VVIPICK"; remainPoint = 0;
                    } else if (spent >= 100000) {
                        grade = 4; gradeName = "탑픽"; remainPoint = 200000 - spent;
                    } else if (spent >= 50000) {
                        grade = 3; gradeName = "굿픽"; remainPoint = 100000 - spent;
                    } else if (spent >= 10000) {
                        grade = 2; gradeName = "라이트픽"; remainPoint = 50000 - spent;
                    } else {
                        grade = 1; gradeName = "뉴픽"; remainPoint = 10000 - spent;
                    }

                    return {
                        grade: grade,
                        gradeName: gradeName,
                        remainPoint: Math.max(0, remainPoint)
                    };
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
                            // 상태 값을 텍스트로 변환
                            if (data.inquiries) {
                                self.inquiries = data.inquiries.map(inquiry => {
                                    let statusText = '확인중'; // 기본값
                                    if (inquiry.qsStatus === '1') {
                                        statusText = '처리중';
                                    } else if (inquiry.qsStatus === '2') {
                                        statusText = '처리완료';
                                    }
                                    return {
                                        ...inquiry,
                                        qsStatus: statusText
                                    };
                                });
                            } else {
                                self.inquiries = [];
                            }
                        },
                        error: function (error) {
                            console.error('문의내역 조회 실패:', error);
                        },
                        complete: function () {
                            self.isLoading = false;
                        }
                    });
                },
                viewInquiryDetail(qsNo) {
                    window.location.href = '/inquire/view.do?qsNo=' + qsNo;
                },
                // 모달 열기
                openEditModal() {

                    // 모달을 먼저 열고 데이터 로드
                    this.editModal.show();

                    this.loadMemberInfo(() => {
                        this.loadEditForm();

                        // Vue가 DOM 업데이트를 완료한 후 강제 리렌더링
                        this.$nextTick(() => {
                            this.$forceUpdate();
                        });
                    });
                },

                // 폼 데이터 로드
                loadEditForm() {
                    // editData 객체를 완전히 새로 생성
                    console.log(this.memberInfo);
                    this.editData = {
                        userName: this.memberInfo.userName || '',
                        nickname: this.memberInfo.nickname || '',
                        phone: this.memberInfo.phone || '',
                        email: this.memberInfo.email || '',
                        address: this.memberInfo.address || '',
                        addressDetail: this.memberInfo.addressDetail || '',
                        newPassword: ''
                    };
                },

                // 정보 업데이트 (jQuery AJAX)
                updateMemberInfo() {
                    if (!this.validateForm()) return;

                    const self = this;
                    const nparmap = {
                        userId: this.userId,
                        ...this.editData
                    };

                    $.ajax({
                        url: "/member/updateInfo.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        beforeSend: function () {
                            self.isLoading = true;
                        },
                        success: function (data) {
                            if (data.result === 'success') {
                                self.editModal.hide();
                                Swal.fire('성공!', '정보가 수정되었습니다', 'success');
                                self.loadMemberInfo();
                            } else {
                                Swal.fire('오류', data.message || '수정 실패', 'error');
                            }
                        },
                        error: function (xhr) {
                            Swal.fire('오류', '서버 오류가 발생했습니다', 'error');
                        },
                        complete: function () {
                            self.isLoading = false;
                        }
                    });
                },

                // 폼 유효성 검사
                validateForm() {
                    if (!this.editData.phone.match(/^01[0-9]-[0-9]{3,4}-[0-9]{4}$/)) {
                        Swal.fire('오류', '전화번호 형식이 올바르지 않습니다', 'error');
                        return false;
                    }
                    if (this.editData.newPassword && this.editData.newPassword.length < 8) {
                        Swal.fire('오류', '비밀번호는 8자 이상이어야 합니다', 'error');
                        return false;
                    }
                    return true;
                },
                searchAddress() {
                    new daum.Postcode({
                        oncomplete: (data) => {
                            let fullAddr = '';
                            let extraAddr = '';

                            if (data.userSelectedType === 'R') {
                                fullAddr = data.roadAddress;
                                if (data.bname !== '') {
                                    extraAddr += data.bname;
                                }
                                if (data.buildingName !== '') {
                                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                                }
                                fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
                            } else {
                                fullAddr = data.jibunAddress;
                            }

                            this.editData.address = fullAddr;  // 주소 입력란에 반영
                            document.getElementById('memberAddress').focus();  // 입력란에 포커스
                        },
                        width: '100%',
                        height: '100%'
                    }).open();  // 팝업 방식으로 주소 찾기
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

                this.editModal = new bootstrap.Modal(document.getElementById('editMemberModal'));
                this.loadMemberInfo();
                this.loadCoupons();
                this.loadInquiries();

            }
        });

        app.mount('#app');
    </script>