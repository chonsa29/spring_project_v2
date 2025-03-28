<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="true" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <link rel="stylesheet" href="/css/member-css/admin-page.css">
            <title>상품 관리</title>
            <style>
            </style>
        </head>

        <body>
            <div id="app">
                <div class="header">
                    <h2>MEALPICK</h2>
                    <a href="/home.do"><button class="button" @click="">나가기</button></a>
                </div>
                <!-- 관리자 페이지 전체 구조 -->
                <div class="admin-container">
                    <!-- 사이드바 -->
                    <div class="sidebar">
                        <h2>관리자 메뉴</h2>
                        <ul>
                            <li><a href="#" @click="showSection('dashboard')">대시보드</a></li>
                            <li><a href="#" @click="showSection('product-management')">상품 관리</a></li>
                            <li><a href="#" @click="showSection('order-management')">주문 관리</a></li>
                            <li><a href="#" @click="showSection('member-management')">회원 관리</a></li>
                        </ul>
                    </div>

                    <!-- 페이지 콘텐츠 영역 -->
                    <div class="content">
                        <!-- 대시보드 -->
                        <div v-if="currentSection === 'dashboard'" class="section">
                            <h3>대시보드</h3>
                            <div class="dashboard-summary">
                                <h4>오늘 할 일</h4>
                                <div class="dashboard-grid">
                                    <div class="stat-card">
                                        <h3>{{ dashboard.todayOrders }}</h3>
                                        <p>신규 주문</p>
                                    </div>
                                    <div class="stat-card">
                                        <h3>{{ dashboard.todayCancelRequests }}</h3>
                                        <p>취소 요청</p>
                                    </div>
                                    <div class="stat-card">
                                        <h3>{{ dashboard.todayDeliveries }}</h3>
                                        <p>배송 관리</p>
                                    </div>
                                    <div class="stat-card">
                                        <h3>{{ dashboard.pendingInquiries }}</h3>
                                        <p>답변 대기 문의</p>
                                    </div>
                                </div>
                            </div>

                            <!-- 매출 차트 -->
                            <div class="card sales-chart-container">
                                <h4>최근 7일 매출 추이</h4>
                                <canvas id="salesChart"></canvas>
                            </div>

                            <div class="dashboard-grid">
                                <!-- 최근 주문 -->
                                <div class="card">
                                    <h4>최근 주문</h4>
                                    <div class="recent-orders">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>주문번호</th>
                                                    <th>회원명</th>
                                                    <th>금액</th>
                                                    <th>상태</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr v-for="order in recentOrders" :key="order.ORDERKEY">
                                                    <td>{{ order.orderKey }}</td>
                                                    <td>{{ order.userId }}</td>
                                                    <td>{{ formatCurrency(order.price) }}</td>
                                                    <td>
                                                        <span class="badge" :class="getStatusClass(order.status)">
                                                            {{ order.orderStatus }}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- 인기 상품 TOP 3 -->
                                <div class="card">
                                    <h4>인기 상품 TOP 3</h4>
                                    <div class="top-products">
                                        <div class="product-card" v-for="(product, index) in topProducts"
                                            :key="product.productId">
                                            <img :src="product.imageUrl || '/images/no-image.png'"
                                                :alt="product.productName">
                                            <div class="product-info">
                                                <h4>#{{ index + 1 }} {{ product.productName }}</h4>
                                                <p>{{ formatCurrency(product.price) }}</p>
                                                <p>판매량: {{ product.totalCount }}개</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 상품 관리 -->
                        <div v-if="currentSection === 'product-management'" class="section">
                            <h3>상품 관리</h3>

                            <!-- 상품 추가/수정 버튼 -->
                            <button @click="showForm('add')" @click="showForm(formType)">상품 추가</button>
                            <button @click="showForm('edit')" @click="showForm(formType)">상품 수정</button>

                            <!-- 상품 추가/수정 폼 -->
                            <div class="product-form">
                                <h4 v-if="formType === 'add'">상품 추가</h4>
                                <h4 v-if="formType === 'edit'">상품 수정</h4>
                                <form @submit.prevent="submitForm" v-if="showProductForm" :key="showProductForm">
                                    <label for="name">상품 이름</label>
                                    <input type="text" id="name" v-model="name" required>

                                    <label for="price">가격</label>
                                    <input type="number" id="price" v-model="price" required>

                                    <label for="quantity">상품 개수</label>
                                    <input type="number" id="quantity" v-model="quantity" required>

                                    <label for="category">카테고리</label>
                                    <input type="text" id="category" v-model="category" required>

                                    <label for="info">정보</label>
                                    <textarea id="info" v-model="info" required></textarea>

                                    <label for="details">알레르기 정보</label>
                                    <textarea id="details" v-model="allergens" required></textarea>

                                    <label for="thumbnail">썸네일 이미지</label>
                                    <div class="product-image" v-if="formType=='edit'">
                                        <img class="product-image" :src="item.filePath" alt="item.itemName" />
                                    </div>
                                    <input type="file" id="thumbnail" @change="handleFileChange('thumbnail')">
                                    <label for="additionalPhotos">추가 이미지</label>
                                    <div class="subimg-container" v-if="formType=='edit' && imgList.length != 0">
                                        <table>
                                            <tr>
                                                <th>추가 이미지</th>
                                                <th>삭제</th>
                                            </tr>
                                            <tr v-for="(img,index) in imgList">
                                                <td><img :src="img.filePath"></td>
                                                <td><button @click="fnDeleteImg(img.fileName)">삭제</button></td>
                                            </tr>
                                        </table>
                                    </div>
                                    <input type="file" id="additionalPhotos"
                                        @change="handleFileChange('additionalPhotos')" multiple>

                                    <button type="submit">저장</button>
                                    <button type="button" @click="cancelForm">취소</button>
                                </form>
                                <div v-if="showTable">
                                    <table>
                                        <tr>
                                            <th>상품 번호</th>
                                            <th>상품 이름</th>
                                            <th>가격</th>
                                            <th>재고</th>
                                            <th>등록일</th>
                                            <th>삭제</th>
                                        </tr>
                                        <tr v-for="item in list">
                                            <td>{{item.itemNo}}</td>
                                            <td><a href="javascript:;"
                                                    @click="fnEdit(item.itemNo)">{{item.itemName}}</a>
                                            </td>
                                            <td>{{item.price}}</td>
                                            <td>{{item.itemCount}}</td>
                                            <td>{{item.rDate}}</td>
                                            <td><button @click="fnDelete(item.itemNo)">삭제</button></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- 주문 관리 -->
                        <div v-if="currentSection === 'order-management'" class="section">
                            <h3>주문 관리</h3>

                            <!-- 검색 필터 -->
                            <div class="card mb-4">
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <label class="form-label">기간 검색</label>
                                            <div class="input-group">
                                                <input type="date" class="form-control" v-model="orderSearch.startDate">
                                                <span class="input-group-text">~</span>
                                                <input type="date" class="form-control" v-model="orderSearch.endDate">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">주문 상태</label>
                                            <select class="form-select" v-model="orderSearch.status">
                                                <option value="">전체</option>
                                                <option value="PENDING">결제대기</option>
                                                <option value="PAID">결제완료</option>
                                                <option value="PREPARING">상품준비중</option>
                                                <option value="SHIPPED">배송중</option>
                                                <option value="DELIVERED">배송완료</option>
                                                <option value="CANCELED">취소</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">검색 조건</label>
                                            <div class="input-group">
                                                <select class="form-select" v-model="orderSearch.searchType"
                                                    style="max-width: 120px;">
                                                    <option value="orderId">주문번호</option>
                                                    <option value="userId">회원ID</option>
                                                    <option value="userName">회원명</option>
                                                </select>
                                                <input type="text" class="form-control"
                                                    v-model="orderSearch.searchValue" @keyup.enter="searchOrders">
                                            </div>
                                        </div>
                                        <div class="col-md-2 d-flex align-items-end">
                                            <button class="btn btn-primary me-2" @click="searchOrders">검색</button>
                                            <button class="btn btn-outline-secondary"
                                                @click="resetOrderSearch">초기화</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 주문 목록 -->
                            <div class="card">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover order-table">
                                            <thead>
                                                <tr>
                                                    <th>주문번호</th>
                                                    <th>주문일시</th>
                                                    <th>회원명(ID)</th>
                                                    <th>결제금액</th>
                                                    <th>결제방법</th>
                                                    <th>주문상태</th>
                                                    <th>관리</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr v-for="order in orderList" :key="order.ORDERID">
                                                    <td>{{ order.ORDERKEY }}</td>
                                                    <td>{{ formatDate(order.ORDERDATE) }}</td>
                                                    <td>{{ order.USERNAME }} ({{ order.USERID }})</td>
                                                    <td>{{ formatCurrency(order.PRICE) }}</td>
                                                    <td>{{ getPaymentMethod(order.PWAY) }}</td>
                                                    <td>
                                                        <span :class="'status-badge ' + getStatusClass(order.status)">
                                                            {{ getStatusText(order.ORDERSTATUS) }}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary"
                                                            @click="showOrderDetail(order.ORDERKEY)">
                                                            상세
                                                        </button>
                                                        <button v-if="order.status !== 'CANCELED'"
                                                            class="btn btn-sm btn-outline-danger ms-1"
                                                            @click="showCancelModal(order.ORDERKEY)">
                                                            취소
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr v-if="orderList.length === 0">
                                                    <td colspan="7" class="text-center">조회된 주문이 없습니다.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- 페이징 -->
                                    <nav v-if="totalPages > 1">
                                        <ul class="pagination">
                                            <li class="page-item" :class="{ disabled: currentPage === 1 }">
                                                <a class="page-link" href="#"
                                                    @click.prevent="changePage(currentPage - 1)">이전</a>
                                            </li>
                                            <li class="page-item" v-for="page in displayedPages" :key="page"
                                                :class="{ active: page === currentPage }">
                                                <a class="page-link" href="#" @click.prevent="changePage(page)">{{ page
                                                    }}</a>
                                            </li>
                                            <li class="page-item" :class="{ disabled: currentPage === totalPages }">
                                                <a class="page-link" href="#"
                                                    @click.prevent="changePage(currentPage + 1)">다음</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                        <!-- 회원 관리 -->
                        <!-- 회원 관리 섹션 -->
                        <div v-if="currentSection === 'member-management'" class="section">
                            <h3>회원 관리</h3>

                            <!-- 검색 필터 -->
                            <div class="card mb-4">
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <label class="form-label">회원 상태</label>
                                            <select class="form-select" v-model="memberSearch.status">
                                                <option value="">전체</option>
                                                <option value="ACTIVE">활성</option>
                                                <option value="DORMANT">휴면</option>
                                                <option value="BANNED">정지</option>
                                                <option value="WITHDRAWN">탈퇴</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">검색 조건</label>
                                            <div class="input-group">
                                                <select class="form-select" v-model="memberSearch.searchType"
                                                    style="max-width: 120px;">
                                                    <option value="memberId">회원ID</option>
                                                    <option value="userName">회원명</option>
                                                    <option value="email">이메일</option>
                                                </select>
                                                <input type="text" class="form-control"
                                                    v-model="memberSearch.searchValue" @keyup.enter="searchMembers">
                                            </div>
                                        </div>
                                        <div class="col-md-2 d-flex align-items-end">
                                            <button class="btn btn-primary me-2" @click="searchMembers">검색</button>
                                            <button class="btn btn-outline-secondary"
                                                @click="resetMemberSearch">초기화</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 회원 목록 -->
                            <div class="card">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>회원ID</th>
                                                    <th>회원명</th>
                                                    <th>이메일</th>
                                                    <th>연락처</th>
                                                    <th>가입일</th>
                                                    <th>주문건수</th>
                                                    <th>상태</th>
                                                    <th>관리</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr v-for="member in memberList" :key="member.memberId">
                                                    <td>{{ member.USERID }}</td>
                                                    <td>{{ member.USERNAME }}</td>
                                                    <td>{{ member.EMAIL }}</td>
                                                    <td>{{ member.PHONE }}</td>
                                                    <td>{{ formatDate(member.CDATE) }}</td>
                                                    <td>{{ member.ORDERCOUNT }}</td>
                                                    <td>
                                                        <span :class="'badge ' + getMemberStatusClass(member.status)">
                                                            {{ getMemberStatusText(member.STATUS) }}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary"
                                                            @click="showMemberDetail(member.USERID)">
                                                            상세
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr v-if="memberList.length === 0">
                                                    <td colspan="8" class="text-center">조회된 회원이 없습니다.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- 페이징 -->
                                    <nav v-if="memberTotalPages > 1">
                                        <ul class="pagination justify-content-center mt-3">
                                            <li class="page-item" :class="{ disabled: memberCurrentPage === 1 }">
                                                <a class="page-link" href="#"
                                                    @click.prevent="changeMemberPage(memberCurrentPage - 1)">이전</a>
                                            </li>
                                            <li class="page-item" v-for="page in memberDisplayedPages" :key="page"
                                                :class="{ active: page === memberCurrentPage }">
                                                <a class="page-link" href="#" @click.prevent="changeMemberPage(page)">{{
                                                    page }}</a>
                                            </li>
                                            <li class="page-item"
                                                :class="{ disabled: memberCurrentPage === memberTotalPages }">
                                                <a class="page-link" href="#"
                                                    @click.prevent="changeMemberPage(memberCurrentPage + 1)">다음</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>

                        <!-- 회원 상세 모달 -->
                        <div class="modal fade" id="memberDetailModal" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">회원 상세 정보 - {{ currentMember?.member?.memberId }}</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body" v-if="currentMember">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <h6>기본 정보</h6>
                                                <table class="table table-bordered">
                                                    <tr>
                                                        <th style="width: 30%">회원ID</th>
                                                        <td>{{ currentMember.member.memberId }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>회원명</th>
                                                        <td>{{ currentMember.member.userName }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>이메일</th>
                                                        <td>{{ currentMember.member.email }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>연락처</th>
                                                        <td>{{ currentMember.member.phone }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>가입일</th>
                                                        <td>{{ formatDateTime(currentMember.member.regDate) }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>최근로그인</th>
                                                        <td>{{ currentMember.member.lastLogin ?
                                                            formatDateTime(currentMember.member.lastLogin) : '-' }}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="col-md-6">
                                                <h6>추가 정보</h6>
                                                <table class="table table-bordered">
                                                    <tr>
                                                        <th style="width: 30%">주소</th>
                                                        <td>
                                                            ({{ currentMember.member.zipcode }})<br>
                                                            {{ currentMember.member.address }}<br>
                                                            {{ currentMember.member.detailAddress }}
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>상태</th>
                                                        <td>
                                                            <select class="form-select"
                                                                v-model="currentMember.member.status">
                                                                <option value="ACTIVE">활성</option>
                                                                <option value="DORMANT">휴면</option>
                                                                <option value="BANNED">정지</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>포인트</th>
                                                        <td>{{ formatCurrency(currentMember.member.point) }}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>

                                        <h6 class="mt-4">최근 주문 내역 (최근 5건)</h6>
                                        <div class="table-responsive">
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th>주문번호</th>
                                                        <th>주문일시</th>
                                                        <th>금액</th>
                                                        <th>상태</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr v-for="order in currentMember.orderHistory"
                                                        :key="order.orderId">
                                                        <td>{{ order.orderId }}</td>
                                                        <td>{{ formatDateTime(order.orderDate) }}</td>
                                                        <td>{{ formatCurrency(order.totalPrice) }}</td>
                                                        <td>{{ getOrderStatusText(order.status) }}</td>
                                                    </tr>
                                                    <tr v-if="currentMember.orderHistory.length === 0">
                                                        <td colspan="4" class="text-center">주문 내역이 없습니다.</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">닫기</button>
                                        <button type="button" class="btn btn-primary" @click="updateMember">저장</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 주문 상세 모달 -->
                        <div class="modal fade" id="orderDetailModal" tabindex="-1" aria-hidden="true"
                            style="display: none;">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">주문 상세 정보 - {{ currentOrder?.order?.ORDERKEY }}</h5>
                                    </div>
                                    <div class="modal-body" v-if="currentOrder">
                                        <div class="row mb-4">
                                            <div class="col-md-6">
                                                <h6>주문 정보</h6>
                                                <table class="table table-bordered">
                                                    <tr>
                                                        <th style="width: 30%">주문번호</th>
                                                        <td>{{ currentOrder.order.ORDERKEY }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>주문일시</th>
                                                        <td>{{ formatDateTime(currentOrder.order.ORDERDATE) }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>주문상태</th>
                                                        <td>
                                                            <span
                                                                :class="'status-badge ' + getStatusClass(currentOrder.order.ORDERSTATUS)">
                                                                {{ getStatusText(currentOrder.order.ORDERSTATUS) }}
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>결제금액</th>
                                                        <td>{{ formatCurrency(currentOrder.order.PRICE) }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>결제방법</th>
                                                        <td>{{ getPaymentMethod(currentOrder.order.PWAY) }}
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="col-md-6">
                                                <h6>회원 정보</h6>
                                                <table class="table table-bordered">
                                                    <tr>
                                                        <th style="width: 30%">회원ID</th>
                                                        <td>{{ currentOrder.order.USERID }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>회원명</th>
                                                        <td>{{ currentOrder.order.USERNAME }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>연락처</th>
                                                        <td>{{ currentOrder.order.PHONE || '-' }}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>이메일</th>
                                                        <td>{{ currentOrder.order.EMAIL || '-' }}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="card mb-4">
                                            <div class="card-body">
                                                <p class="text-muted mt-2" v-if="currentOrder.order.REQUEST">
                                                    <strong>요청사항:</strong> {{ currentOrder.order.REQUEST }}
                                                </p>
                                            </div>
                                        </div>

                                        <h6 class="mb-3">주문 상품</h6>
                                        <div class="table-responsive">
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th>상품 이미지</th>
                                                        <th>상품명</th>
                                                        <th>상품번호</th>
                                                        <th>수량</th>
                                                        <th>단가</th>
                                                        <th>금액</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr v-for="item in currentOrder.items" :key="item.itemNo">
                                                        <td>
                                                            <img :src="item.IMAGEURL" :alt="item.itemName"
                                                                style="width: 60px; height: 60px; object-fit: cover;">
                                                        </td>
                                                        <td>{{ item.ITEMNAME }}</td>
                                                        <td>{{ item.ITEMNO }}</td>
                                                        <td>{{ item.ORDERCOUNT }}개</td>
                                                        <td>{{ formatCurrency(item.PRICE) }}</td>
                                                        <td>{{ formatCurrency(item.ORDERCOUNT * item.PRICE) }}</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="5" class="text-end"><strong>총 결제금액</strong></td>
                                                        <td><strong>{{ formatCurrency(item.ORDERCOUNT *
                                                                item.PRICE)}}</strong></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">닫기</button>
                                        <button v-if="currentOrder?.order?.status !== 'CANCELED'" type="button"
                                            class="btn btn-danger"
                                            @click="showCancelModal(currentOrder.order.ORDERKEY)">
                                            주문 취소
                                        </button>
                                        <button v-if="canUpdateStatus(currentOrder?.order?.status)" type="button"
                                            class="btn btn-primary"
                                            @click="showStatusModal(currentOrder.order.ORDERKEY)">
                                            상태 변경
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 주문 상태 변경 모달 -->
                        <div class="modal fade" id="statusModal" tabindex="-1" aria-hidden="true"
                            style="display: none;">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">주문 상태 변경</h5>
                                    </div>
                                    <div class="modal-body">
                                        <select class="form-select" v-model="selectedStatus">
                                            <option value="PAID">결제완료</option>
                                            <option value="PREPARING">상품준비중</option>
                                            <option value="SHIPPED">배송중</option>
                                            <option value="DELIVERED">배송완료</option>
                                        </select>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">취소</button>
                                        <button type="button" class="btn btn-primary"
                                            @click="updateOrderStatus">변경</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 주문 취소 모달 -->
                        <div class="modal fade" id="cancelModal" tabindex="-1" aria-hidden="true"
                            style="display: none;">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">주문 취소</h5>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label">취소 사유</label>
                                            <textarea class="form-control" v-model="cancelReason" rows="3"></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">닫기</button>
                                        <button type="button" class="btn btn-danger" @click="cancelOrder">취소 처리</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        </html>

        <script>

            const app = Vue.createApp({
                data() {
                    return {
                        currentSection: 'dashboard',
                        // 대시보드 데이터
                        dashboard: {
                            todayOrders: 0,
                            todayCancelRequests: 0,
                            todayDeliveries: 0,
                            pendingInquiries: 0,
                            weeklySales: []
                        },
                        recentOrders: [],
                        topProducts: [],
                        salesChart: null,

                        // 기존 상품 관리 데이터
                        showProductForm: false,
                        showTable: false,
                        formType: '',
                        name: '',
                        price: '',
                        quantity: '',
                        category: '',
                        info: '',
                        allergens: '',
                        thumbnail: null,
                        additionalPhotos: [],
                        list: [],
                        item: {},
                        itemNo: "",
                        imgList: [],
                        users: [],

                        //주문 관리 데이터
                        orderSearch: {
                            startDate: '',
                            endDate: '',
                            status: '',
                            searchType: 'orderId',
                            searchValue: ''
                        },
                        orderList: [],
                        currentOrder: null,
                        currentPage: 1,
                        pageSize: 10,
                        totalCount: 0,
                        selectedOrderId: '',
                        selectedStatus: 'PAID',
                        cancelReason: '',

                        // 회원 관리 관련 데이터
                        memberSearch: {
                            status: '',
                            searchType: 'memberId',
                            searchValue: ''
                        },
                        memberList: [],
                        currentMember: null,
                        memberCurrentPage: 1,
                        memberPageSize: 10,
                        memberTotalCount: 0
                    };
                },
                computed: {
                    totalPages() {
                        return Math.ceil(this.totalCount / this.pageSize);
                    },
                    displayedPages() {
                        const pages = [];
                        const startPage = Math.max(1, this.currentPage - 2);
                        const endPage = Math.min(this.totalPages, startPage + 4);

                        for (let i = startPage; i <= endPage; i++) {
                            pages.push(i);
                        }
                        return pages;
                    },
                    memberTotalPages() {
                        return Math.ceil(this.memberTotalCount / this.memberPageSize);
                    },
                    memberDisplayedPages() {
                        const pages = [];
                        const startPage = Math.max(1, this.memberCurrentPage - 2);
                        const endPage = Math.min(this.memberTotalPages, startPage + 4);

                        for (let i = startPage; i <= endPage; i++) {
                            pages.push(i);
                        }
                        return pages;
                    }
                },
                methods: {
                    // 회원 관리 관련 메서드 추가
                    searchMembers() {
                        const params = {
                            ...this.memberSearch,
                            page: this.memberCurrentPage,
                            size: this.memberPageSize
                        };

                        $.ajax({
                            url: "/member/list.dox",
                            type: "POST",
                            dataType: "json",
                            data: params,
                            success: (response) => {
                                this.memberList = response;
                                // 실제 구현에서는 페이지네이션 정보도 함께 받아야 함
                                // this.memberTotalCount = response.totalCount;
                            }
                        });
                    },

                    resetMemberSearch() {
                        this.memberSearch = {
                            status: '',
                            searchType: 'memberId',
                            searchValue: ''
                        };
                        this.memberCurrentPage = 1;
                        this.searchMembers();
                    },

                    showMemberDetail(memberId) {
                        $.ajax({
                            url: "/member/detail.dox",
                            type: "POST",
                            dataType: "json",
                            data: { memberId: memberId },
                            success: (response) => {
                                this.currentMember = response;
                                const modal = new bootstrap.Modal(document.getElementById('memberDetailModal'));
                                modal.show();
                            }
                        });
                    },

                    updateMember() {
                        $.ajax({
                            url: "/member/update.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                memberId: this.currentMember.member.memberId,
                                status: this.currentMember.member.status
                            },
                            success: (response) => {
                                if (response.success) {
                                    alert("회원 정보가 업데이트되었습니다.");
                                    this.searchMembers();
                                    bootstrap.Modal.getInstance(document.getElementById('memberDetailModal')).hide();
                                }
                            }
                        });
                    },

                    getMemberStatusClass(status) {
                        switch (status) {
                            case 'ACTIVE': return 'bg-success';
                            case 'DORMANT': return 'bg-warning';
                            case 'BANNED': return 'bg-danger';
                            case 'WITHDRAWN': return 'bg-secondary';
                            default: return 'bg-info';
                        }
                    },

                    getMemberStatusText(status) {
                        switch (status) {
                            case 'ACTIVE': return '활성';
                            case 'DORMANT': return '휴면';
                            case 'BANNED': return '정지';
                            case 'WITHDRAWN': return '탈퇴';
                            default: return status;
                        }
                    },

                    changeMemberPage(page) {
                        if (page < 1 || page > this.memberTotalPages) return;
                        this.memberCurrentPage = page;
                        this.searchMembers();
                    },
                    // 주문 관리 관련 메서드 추가
                    searchOrders() {
                        const params = {
                            ...this.orderSearch,
                            page: this.currentPage,
                            size: this.pageSize
                        };

                        $.ajax({
                            url: "/admin/order/list.dox",
                            type: "POST",
                            dataType: "json",
                            data: params,
                            success: (response) => {

                                this.orderList = response;

                                // 실제 구현에서는 페이지네이션 정보도 함께 받아야 함
                                // this.totalCount = response.totalCount;
                            },
                            error: (xhr, status, error) => {
                                console.error("주문 목록 조회 실패:", error);
                            }
                        });
                    },

                    resetOrderSearch() {
                        this.orderSearch = {
                            startDate: '',
                            endDate: '',
                            status: '',
                            searchType: 'orderId',
                            searchValue: ''
                        };
                        this.currentPage = 1;
                        this.searchOrders();
                    },

                    showOrderDetail(orderId) {
                        $.ajax({
                            url: "/admin/order/detail.dox",
                            type: "POST",
                            dataType: "json",
                            data: { orderId: orderId },
                            success: (response) => {
                                this.currentOrder = response;
                                console.log(this.currentOrder);
                                const modal = new bootstrap.Modal(document.getElementById('orderDetailModal'));
                                modal.show();
                            },
                            error: (xhr, status, error) => {
                                console.error("주문 상세 조회 실패:", error);
                            }
                        });
                    },

                    showStatusModal(orderId) {
                        this.selectedOrderId = orderId;
                        const modal = new bootstrap.Modal(document.getElementById('statusModal'));
                        modal.show();
                    },

                    updateOrderStatus() {
                        $.ajax({
                            url: "/admin/order/updateStatus.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                orderId: this.selectedOrderId,
                                status: this.selectedStatus
                            },
                            success: (response) => {
                                if (response.success) {
                                    alert("주문 상태가 변경되었습니다.");
                                    this.searchOrders();
                                    bootstrap.Modal.getInstance(document.getElementById('statusModal')).hide();
                                    bootstrap.Modal.getInstance(document.getElementById('orderDetailModal')).hide();
                                }
                            },
                            error: (xhr, status, error) => {
                                console.error("주문 상태 변경 실패:", error);
                            }
                        });
                    },

                    showCancelModal(orderId) {
                        this.selectedOrderId = orderId;
                        this.cancelReason = '';
                        const modal = new bootstrap.Modal(document.getElementById('cancelModal'));
                        modal.show();
                    },

                    cancelOrder() {
                        if (!this.cancelReason) {
                            alert("취소 사유를 입력해주세요.");
                            return;
                        }

                        console.log(this.selectedOrderId);
                        console.log(this.cancelReason);
                        $.ajax({
                            url: "/admin/order/cancel.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                orderId: this.selectedOrderId,
                                cancelReason: this.cancelReason
                            },
                            success: (response) => {
                                if (response.success) {
                                    alert("주문이 취소되었습니다.");
                                    this.searchOrders();
                                    bootstrap.Modal.getInstance(document.getElementById('cancelModal')).hide();
                                    if (document.getElementById('orderDetailModal')) {
                                        bootstrap.Modal.getInstance(document.getElementById('orderDetailModal')).hide();
                                    }
                                }
                            },
                            error: (xhr, status, error) => {
                                console.error("주문 취소 실패:", error);
                            }
                        });
                    },

                    changePage(page) {
                        if (page < 1 || page > this.totalPages) return;
                        this.currentPage = page;
                        this.searchOrders();
                    },

                    getStatusClass(status) {
                        switch (status) {
                            case 'PENDING': return 'status-pending';
                            case 'PAID': return 'status-processing';
                            case 'PREPARING': return 'status-processing';
                            case 'SHIPPED': return 'status-processing';
                            case 'DELIVERED': return 'status-completed';
                            case 'CANCELED': return 'status-canceled';
                            default: return '';
                        }
                    },

                    getStatusText(status) {
                        switch (status) {
                            case 'PENDING': return '결제대기';
                            case 'PAID': return '결제완료';
                            case 'PREPARING': return '상품준비중';
                            case 'SHIPPED': return '배송중';
                            case 'DELIVERED': return '배송완료';
                            case 'CANCELED': return '취소됨';
                            default: return status;
                        }
                    },

                    getPaymentMethod(method) {
                        switch (method) {
                            case 'CARD': return '카드결제';
                            case 'BANK_TRANSFER': return '무통장입금';
                            case 'MOBILE_PAYMENT': return '휴대폰결제';
                            default: return method;
                        }
                    },

                    canUpdateStatus(status) {
                        return status && !['CANCELED', 'DELIVERED'].includes(status);
                    },

                    formatDate(dateString) {
                        if (!dateString) return '';
                        const date = new Date(dateString);
                        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
                    },

                    formatCurrency(value) {
                        if (!value) return '0원';
                        return new Intl.NumberFormat('ko-KR').format(value) + '원';
                    },
                    showSection(section) {
                        this.currentSection = section;
                        if (section === 'dashboard') {
                            this.loadDashboardData();
                        } else if (section === 'product-management') {
                            this.itemList();
                        }
                    },
                    formatDateTime(dateString) {
                        if (!dateString) return '';
                        const date = new Date(dateString);
                        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
                    },
                    formatCurrency(value) {
                        if (!value) return '0원';
                        return new Intl.NumberFormat('ko-KR').format(value) + '원';
                    },
                    getStatusClass(status) {
                        switch (status) {
                            case 'PENDING': return 'status-pending';
                            case 'PAID': return 'status-processing';
                            case 'PREPARING': return 'status-processing';
                            case 'SHIPPED': return 'status-processing';
                            case 'DELIVERED': return 'status-completed';
                            case 'CANCELED': return 'status-canceled';
                            default: return '';
                        }
                    },
                    getStatusText(status) {
                        switch (status) {
                            case 'PENDING': return '결제대기';
                            case 'PAID': return '결제완료';
                            case 'PREPARING': return '상품준비중';
                            case 'SHIPPED': return '배송중';
                            case 'DELIVERED': return '배송완료';
                            case 'CANCELED': return '취소됨';
                            default: return status;
                        }
                    },
                    getPaymentMethod(method) {
                        switch (method) {
                            case 'CARD': return '카드결제';
                            case 'BANK_TRANSFER': return '무통장입금';
                            case 'MOBILE_PAYMENT': return '휴대폰결제';
                            default: return method;
                        }
                    },
                    // 대시보드 관련 메서드
                    loadDashboardData() {
                        this.fetchTodayStats();
                        this.fetchWeeklySales();
                        this.fetchRecentOrders();
                        this.fetchTopProducts();
                    },

                    fetchTodayStats() {
                        $.ajax({
                            url: "/admin/dashboard/todayStats.dox",
                            dataType: "json",
                            type: "POST",
                            success: (data) => {
                                this.dashboard.todayOrders = data.todayOrders || 0;
                                this.dashboard.todayCancelRequests = data.todayCancelRequests || 0;
                                this.dashboard.todayDeliveries = data.todayDeliveries || 0;
                                this.dashboard.pendingInquiries = data.pendingInquiries || 0;
                            }
                        });
                    },

                    fetchWeeklySales() {
                        $.ajax({
                            url: "/admin/dashboard/weeklySales.dox",
                            dataType: "json",
                            type: "POST",
                            success: (data) => {
                                this.dashboard.weeklySales = data;
                                this.renderSalesChart(data);
                            }
                        });
                    },

                    fetchRecentOrders() {
                        $.ajax({
                            url: "/admin/dashboard/recentOrders.dox",
                            dataType: "json",
                            type: "POST",
                            success: (data) => {
                                this.recentOrders = data;
                            }
                        });
                    },

                    fetchTopProducts() {
                        $.ajax({
                            url: "/admin/dashboard/topProducts.dox",
                            dataType: "json",
                            type: "POST",
                            success: (data) => {
                                this.topProducts = data;
                            }
                        });
                    },

                    renderSalesChart(data) {
                        // 차트가 이미 존재하면 제거
                        console.log(data);
                        if (this.salesChart) {
                            this.salesChart.destroy();
                        }

                        const ctx = document.getElementById('salesChart').getContext('2d');
                        this.salesChart = new Chart(ctx, {
                            type: 'line',
                            data: {
                                labels: data.map(item => item.date),
                                datasets: [{
                                    label: '일별 매출액',
                                    data: data.map(item => item.sales),
                                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                                    borderColor: 'rgba(54, 162, 235, 1)',
                                    borderWidth: 3,
                                    tension: 0.4
                                }]
                            },
                            options: {
                                responsive: true,
                                scales: {
                                    y: {
                                        beginAtZero: true
                                    }
                                }
                            }
                        });
                    },

                    formatCurrency(value) {
                        return new Intl.NumberFormat('ko-KR', { style: 'currency', currency: 'KRW' }).format(value);
                    },

                    getStatusClass(status) {
                        switch (status) {
                            case '결제완료': return 'badge-warning';
                            case '배송중': return 'badge-info';
                            case '배송완료': return 'badge-success';
                            default: return 'badge-info';
                        }
                    },

                    //상품 관리 메서드
                    showForm(type) {
                        var self = this;
                        this.formType = type;
                        if (type == 'add') {
                            this.showProductForm = true;
                            this.showTable = false;
                            self.name = "";
                            self.price = "";
                            self.quantity = "";
                            self.category = "";
                            self.info = "";
                            self.allergens = "";
                            self.itemNo = "",
                                self.item = {};
                            thumbnail = null;
                        } else {
                            this.showProductForm = false;
                            this.showTable = true;
                            self.itemList();
                        }
                    },
                    handleFileChange(field) {
                        const fileInput = document.getElementById(field);
                        const files = fileInput.files;
                        if (field === 'thumbnail') {
                            this.thumbnail = files[0];
                        } else if (field === 'additionalPhotos') {
                            this.additionalPhotos = Array.from(files);
                        }
                    },
                    submitForm() {
                        var self = this;
                        var nparmap = {
                            itemNo: self.itemNo,
                            name: self.name,
                            price: self.price,
                            quantity: self.quantity,
                            category: self.category,
                            info: self.info,
                            allergens: self.allergens,
                        };
                        if (self.item.itemNo == null) {
                            $.ajax({
                                url: "/product/add.dox",
                                dataType: "json",
                                type: "POST",
                                data: nparmap,
                                success: function (data) {
                                    if (self.thumbnail || self.additionalPhotos.length > 0) {
                                        var form = new FormData();
                                        if (self.thumbnail) {
                                            form.append("file1", self.thumbnail);
                                            form.append("isThumbnail", "Y");
                                        }
                                        if (self.additionalPhotos.length > 0) {
                                            self.additionalPhotos.forEach((photo, index) => {
                                                form.append("file1", photo);
                                                form.append("isThumbnail", "N");
                                            });
                                        }
                                        form.append("itemNo", data.itemNo);
                                        self.upload(form);
                                    }
                                }
                            });
                        } else {
                            $.ajax({
                                url: "/product/update.dox",
                                dataType: "json",
                                type: "POST",
                                data: nparmap,
                                success: function (data) {
                                    if (self.thumbnail || self.additionalPhotos.length > 0) {
                                        var form = new FormData();
                                        if (self.thumbnail) {
                                            form.append("file1", self.thumbnail);
                                            form.append("isThumbnail", "Y");
                                        }
                                        if (self.additionalPhotos.length > 0) {
                                            self.additionalPhotos.forEach((photo, index) => {
                                                form.append("file1", photo);
                                                form.append("isThumbnail", "N");
                                            });
                                        }
                                        form.append("itemNo", data.itemNo);
                                        self.update(form);
                                    }
                                }
                            });
                        }
                        this.showProductForm = false;
                    },
                    upload(form) {
                        var self = this;
                        $.ajax({
                            url: "/product/fileUpload.dox",
                            type: "POST",
                            processData: false,
                            contentType: false,
                            data: form,
                            success: function (response) {
                                alert("저장되었습니다!");
                                location.href = "/product.do";
                                self.showProductForm = false;
                            }
                        });
                    },
                    update(form) {
                        var self = this;
                        $.ajax({
                            url: "/product/fileUpdate.dox",
                            type: "POST",
                            processData: false,
                            contentType: false,
                            data: form,
                            success: function (response) {
                                alert("수정되었습니다!");
                                location.reload();
                            }
                        });
                    },
                    cancelForm() {
                        this.showProductForm = false;
                        if (this.formType == 'edit') {
                            this.showTable = true;
                        }
                    },
                    fnEdit(itemNo) {
                        var self = this;
                        var nparmap = { itemNo: itemNo };
                        $.ajax({
                            url: "/product/info.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                self.item = data.info;
                                self.name = self.item.itemName;
                                self.price = self.item.price;
                                self.quantity = self.item.itemCount;
                                self.category = self.item.category;
                                self.info = self.item.itemInfo;
                                self.allergens = self.item.allergens;
                                self.imgList = data.imgList;
                                self.itemNo = self.item.itemNo;
                                self.showProductForm = true;
                                self.showTable = false;
                            }
                        });
                    },
                    itemList() {
                        var self = this;
                        $.ajax({
                            url: "/product/list2.dox",
                            dataType: "json",
                            type: "POST",
                            success: function (data) {
                                self.list = data.list
                            }
                        });
                    },
                    fnDelete(itemNo) {
                        var self = this;
                        var nparmap = { itemNo: itemNo };
                        $.ajax({
                            url: "/product/delete.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                self.itemList();
                                alert("삭제되었습니다.");
                            }
                        });
                    },
                    fnDeleteImg(fileName) {
                        var self = this;
                        var nparmap = { fileName: fileName };
                        $.ajax({
                            url: "/product/deleteImg.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                alert("삭제되었습니다.");
                            }
                        });
                    }
                },
                mounted() {
                    this.loadDashboardData();
                }
            });
            app.mount('#app');
        </script>