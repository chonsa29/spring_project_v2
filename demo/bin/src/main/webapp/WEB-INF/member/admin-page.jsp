<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="true" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <link rel="stylesheet" href="/css/member-css/admin-page.css">
            <title>상품 관리</title>
            <style>
                /* 추가적인 인라인 스타일이 필요한 경우 여기에 작성 */
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
                            <li><a href="#" @click="showSection('board-management')">게시판 관리</a></li>
                            <li><a href="#" @click="showSection('inquiry-management')">문의 관리</a></li>
                            <li><a href="#" @click="showSection('delivery-management')">배송 관리</a></li>
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
                                                <tr v-for="order in recentOrders" :key="order.orderKeys">
                                                    <td>
                                                        <a href="javascript:;" @click="showOrderDetail(order.orderKey)">
                                                            {{ order.orderKey }}
                                                        </a>
                                                    </td>
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

                            <!-- 검색 필터 추가 -->
                            <div class="card mb-4" v-if="showTable">
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label">상품명 검색</label>
                                            <input type="text" class="form-control" v-model="productSearch.keyword"
                                                @keyup.enter="searchProducts">
                                        </div>
                                        <!-- <div class="col-md-3">
                                            <label class="form-label">카테고리</label>
                                            <select class="form-select" v-model="productSearch.category">
                                                <option value="">전체 카테고리</option>
                                                <option v-for="cat in categories" :value="cat">{{ cat }}</option>
                                            </select>
                                        </div> -->
                                        <div class="col-md-3">
                                            <label class="form-label">상품 상태</label>
                                            <select class="form-select" v-model="productSearch.status">
                                                <option value="">전체 상태</option>
                                                <option value="Y">판매중</option>
                                                <option value="N">판매중지</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2 d-flex align-items-end">
                                            <button class="btn btn-primary me-2" @click="searchProducts">검색</button>
                                            <button class="btn btn-outline-secondary"
                                                @click="resetProductSearch">초기화</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 상품 추가/수정 버튼 -->
                            <button @click="showForm('add')" class="btn btn-success mb-3">상품 추가</button>
                            <button @click="showForm('edit')" class="btn btn-primary mb-3">상품 수정</button>

                            <!-- 상품 테이블 -->
                            <div v-if="showTable">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>상품 번호</th>
                                            <th>상품 이름</th>
                                            <th>가격</th>
                                            <th>재고</th>
                                            <th>카테고리</th>
                                            <th>상태</th>
                                            <th>등록일</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="item in productList" :key="item.itemNo">
                                            <td>{{ item.itemNo }}</td>
                                            <td>
                                                <a href="javascript:;" @click="fnEdit(item.itemNo)">{{ item.itemName
                                                    }}</a>
                                            </td>
                                            <td>{{ formatCurrency(item.price) }}</td>
                                            <td>{{ item.itemCount }}</td>
                                            <td>{{ item.category }}</td>
                                            <td>
                                                <button @click="toggleProductStatus(item)" :class="[
                                                    'status-toggle-btn',
                                                    {
                                                      'active': item.status === 'Y',
                                                      'inactive': item.status !== 'Y',
                                                      'loading': item.loading
                                                    }
                                                  ]" :disabled="item.loading">
                                                    <span v-if="item.loading">
                                                        <i class="fas fa-spinner fa-pulse"></i> 처리중
                                                    </span>
                                                    <span v-else>
                                                        {{ item.status === 'Y' ? '판매중' : '판매중지' }}
                                                    </span>
                                                </button>
                                            </td>
                                            <td>{{ formatDate(item.rDate) }}</td>
                                            <td>
                                                <button @click="fnDelete(item.itemNo)"
                                                    class="btn btn-sm btn-danger">삭제</button>
                                            </td>
                                        </tr>
                                        <tr v-if="productList.length === 0">
                                            <td colspan="8" class="text-center">조회된 상품이 없습니다.</td>
                                        </tr>
                                    </tbody>
                                </table>

                                <!-- 페이징 추가 -->
                                <nav v-if="productTotalPages > 1">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item" :class="{ disabled: productCurrentPage === 1 }">
                                            <a class="page-link" href="#"
                                                @click.prevent="changeProductPage(productCurrentPage - 1)">이전</a>
                                        </li>
                                        <li class="page-item" v-for="page in productDisplayedPages" :key="page"
                                            :class="{ active: page === productCurrentPage }">
                                            <a class="page-link" href="#" @click.prevent="changeProductPage(page)">{{
                                                page }}</a>
                                        </li>
                                        <li class="page-item"
                                            :class="{ disabled: productCurrentPage === productTotalPages }">
                                            <a class="page-link" href="#"
                                                @click.prevent="changeProductPage(productCurrentPage + 1)">다음</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                            <!-- 상품 추가/수정 폼 -->
                            <div class="product-form">
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
                                    <div class="subimg-container" v-if="imgList && imgList.length > 0">
                                        <table>
                                            <tr>
                                                <th>추가 이미지</th>
                                                <th>삭제</th>
                                            </tr>
                                            <tr v-for="(img,index) in imgList">
                                                <td><img :src="img.filePath"></td>
                                                <td><button type="button" @click="fnDeleteImg(img.fileName)">삭제</button>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <input type="file" id="additionalPhotos"
                                        @change="handleFileChange('additionalPhotos')" multiple>
                                    <!-- 설명 이미지 업로드 필드 -->
                                    <label for="contentImage">설명 이미지</label>
                                    <input type="file" id="contentImage" @change="handleFileChange('contentImage')">


                                    <!-- 설명 이미지 미리보기 -->
                                    <div v-if="contentImagePreview">
                                        <h5>설명 이미지 미리보기</h5>
                                        <img :src="contentImagePreview" alt="설명 이미지"
                                            style="max-width: 100%; height: auto;">
                                    </div>
                                    <button type="submit">저장</button>
                                    <button type="button" @click="cancelForm">취소</button>
                                </form>

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
                                                <option value="P">결제완료</option>
                                                <option value="D">배송중</option>
                                                <option value="F">배송완료</option>
                                                <option value="C">취소</option>
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
                                                    <td>신용카드</td>
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
                        <div v-if="currentSection === 'member-management'" class="section">
                            <h3>회원 관리</h3>

                            <!-- 검색 필터 -->
                            <div class="card mb-4">
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label">검색</label>
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
                        <!-- 게시판 관리 섹션 -->
                        <div v-if="currentSection === 'board-management'" class="section">
                            <h3>게시판 관리</h3>

                            <!-- 검색 필터 -->
                            <div class="card mb-4">
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <input type="text" class="form-control" v-model="boardSearch.keyword"
                                                placeholder="제목/작성자 검색">
                                        </div>
                                        <div class="col-md-3">
                                            <select class="form-select" v-model="boardSearch.boardType">
                                                <option value="">전체 게시판</option>
                                                <option value="recipe">레시피 게시판</option>
                                                <option value="group">그룹 게시판</option>
                                            </select>
                                        </div>
                                        <button class="btn btn-primary col-md-2" @click="searchBoards">검색</button>
                                    </div>
                                </div>
                            </div>

                            <!-- 게시글 테이블 -->
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>제목</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                        <th>조회수</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="board in boardList" :key="board.postId">
                                        <td>{{ board.postId }}</td>
                                        <td>
                                            <a :href="`/recipe/view.do?postId=${board.postId}`"
                                                class="text-decoration-none">
                                                {{ board.title }}
                                            </a>
                                        </td>
                                        <td>{{ board.userId }}</td>
                                        <td>{{ formatDate(board.cdatetime) }}</td>
                                        <td>{{ board.cnt }}</td>
                                        <td>
                                            <button @click="deleteBoard(board.postId)"
                                                class="btn btn-sm btn-danger">삭제</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                            <!-- 페이징 -->
                            <nav v-if="boardTotalPages > 1">
                                <ul class="pagination">
                                    <li v-for="page in boardDisplayedPages" :key="page"
                                        :class="{ active: page === boardCurrentPage }">
                                        <a @click="changeBoardPage(page)">{{ page }}</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>

                        <!--문의 관리-->
                        <div v-if="currentSection === 'inquiry-management'" class="section">
                            <h3>문의 관리</h3>

                            <!-- 상태 필터 탭 -->
                            <div class="inquiry-tabs">
                                <button @click="currentInquiryTab = 'general'"
                                    :class="{ active: currentInquiryTab === 'general' }">
                                    일반 문의
                                </button>
                                <button @click="currentInquiryTab = 'product'"
                                    :class="{ active: currentInquiryTab === 'product' }">
                                    상품 문의
                                </button>
                            </div>

                            <!-- 일반 문의 탭 -->
                            <div v-if="currentInquiryTab === 'general'">
                                <table class="inquiry-table">
                                    <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>작성일</th>
                                            <th>상태</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="inq in generalInquiries" :key="inq.QSNO">
                                            <td>{{ inq.QSNO }}</td>
                                            <td>
                                                <a @click="showInquiryDetail(inq)">{{ inq.QSTITLE }}</a>
                                            </td>
                                            <td>{{ inq.USERID }}</td>
                                            <td>{{ inq.CDATETIME }}</td>
                                            <td>
                                                <span
                                                    :class="'status-badge ' + (inq.qsStatus === '1' ? 'completed' : 'pending')">
                                                    {{ inq.QSSTATUS === '1' ? '답변완료' : '답변대기' }}
                                                </span>
                                            </td>
                                            <td>
                                                <button @click="showInquiryDetail(inq)"
                                                    class="btn btn-sm btn-primary">답변
                                                    관리</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <!-- 상품 문의 탭 -->
                            <div v-else>
                                <table class="inquiry-table">
                                    <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>상품명</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>작성일</th>
                                            <th>상태</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="inq in productInquiries" :key="inq.QSNO">
                                            <td>{{ inq.QSNO }}</td>
                                            <td> <a href="javascript:;" @click="showProductDetail(inq.ITEMNO)">
                                                    {{ inq.ITEMNAME }}
                                                </a></td>
                                            <td>{{ inq.QSTITLE }}</td>
                                            <td>{{ inq.USERID }}</td>
                                            <td>{{ inq.CDATETIME }}</td>
                                            <td>
                                                <span
                                                    :class="'status-badge ' + (inq.qsStatus === '1' ? 'completed' : 'pending')">
                                                    {{ inq.qsStatus === '1' ? '답변완료' : '답변대기' }}
                                                </span>
                                            </td>
                                            <td>
                                                <button @click="showProductInquiryDetail(inq)"
                                                    class="btn btn-sm btn-primary">
                                                    답변 관리
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <!-- 답변 모달 -->
                            <div v-if="showReplyModal" class="custom-modal">
                                <div class="custom-modal-content">
                                    <h3>답변 관리</h3>
                                    <button @click="showReplyModal = false" class="modal-close">X</button>

                                    <!-- 답변 목록 -->
                                    <div v-if="replies.length > 0" class="reply-list">
                                        <div v-for="reply in replies" :key="reply.replyNo" class="reply-item">
                                            <p><strong>내용:</strong> {{ reply.replyContents }}</p>
                                            <p><strong>작성자:</strong> {{ reply.adminId }}</p>
                                            <p><strong>작성일:</strong> 2024-04-11 </p>

                                            <button @click="startEditReply(reply)">수정</button>
                                            <button @click="deleteReply(reply.replyNo)">삭제</button>
                                        </div>
                                    </div>
                                    <div v-else>
                                        <p>등록된 답변이 없습니다.</p>
                                    </div>

                                    <!-- 답변 작성/수정 -->
                                    <div class="reply-form">
                                        <textarea v-model="replyContent" placeholder="답변 내용을 입력하세요"></textarea>
                                        <div>
                                            <button v-if="isEditing" @click="updateReply">답변 수정</button>
                                            <button @click="submitReply(selectedInquiryId)">답변 등록</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--배송관리-->
                        <div v-if="currentSection === 'delivery-management'" class="section">
                            <h3>배송 관리</h3>

                            <!-- 검색 필터 -->
                            <div class="card mb-4">
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <select class="form-select" v-model="deliverySearch.searchType">
                                                <option value="orderKey">주문번호</option>
                                                <option value="trackingNumber">운송장번호</option>
                                                <option value="userName">회원명</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control"
                                                v-model="deliverySearch.searchKeyword" @keyup.enter="searchDeliveries"
                                                placeholder="검색어 입력">
                                        </div>
                                        <div class="col-md-3">
                                            <button class="btn btn-primary me-2" @click="searchDeliveries">검색</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 배송 목록 -->
                            <div class="card">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>배송번호</th>
                                                    <th>주문번호</th>
                                                    <th>회원명</th>
                                                    <th>배송상태</th>
                                                    <th>운송장번호</th>
                                                    <th>배송예정일</th>
                                                    <th>배송비</th>
                                                    <th>관리</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr v-for="delivery in deliveryList" :key="delivery.DELIVERYNO">
                                                    <td>{{ delivery.DELIVERYNO }}</td>
                                                    <td>{{ delivery.ORDERKEY }}</td>
                                                    <td>{{ delivery.USERNAME }}</td>
                                                    <td>
                                                        <select class="form-select form-select-sm"
                                                            v-model="delivery.DELIVERYSTATUS"
                                                            @change="updateDeliveryStatus(delivery.DELIVERYNO, delivery.DELIVERYSTATUS)">
                                                            <option value="P">배송준비중</option>
                                                            <option value="D">배송중</option>
                                                            <option value="S">배송완료</option>
                                                            <option value="C">배송취소</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control form-control-sm"
                                                            v-model="delivery.TRACKINGNUMBER"
                                                            @blur="updateTrackingNumber(delivery.DELIVERYNO, $event.target.value)"
                                                            @keyup.enter="updateTrackingNumber(delivery.DELIVERYNO, $event.target.value)">
                                                    </td>
                                                    <td>{{ delivery.DELIVERYDATE }}</td>
                                                    <td>{{ formatCurrency(delivery.DELIVERYFEE) }}</td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary"
                                                            @click="showDeliveryDetail(delivery.DELIVERYNO)">
                                                            상세보기
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr v-if="deliveryList.length === 0">
                                                    <td colspan="8" class="text-center">조회된 배송 정보가 없습니다.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- 페이징 -->
                                    <nav v-if="deliveryTotalPages > 1">
                                        <ul class="pagination justify-content-center mt-3">
                                            <li class="page-item" :class="{ disabled: deliveryCurrentPage === 1 }">
                                                <a class="page-link" href="#"
                                                    @click.prevent="changeDeliveryPage(deliveryCurrentPage - 1)">이전</a>
                                            </li>
                                            <li class="page-item" v-for="page in deliveryDisplayedPages" :key="page"
                                                :class="{ active: page === deliveryCurrentPage }">
                                                <a class="page-link" href="#"
                                                    @click.prevent="changeDeliveryPage(page)">{{ page }}</a>
                                            </li>
                                            <li class="page-item"
                                                :class="{ disabled: deliveryCurrentPage === deliveryTotalPages }">
                                                <a class="page-link" href="#"
                                                    @click.prevent="changeDeliveryPage(deliveryCurrentPage + 1)">다음</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 모달 영역 -->
                <!-- 회원 상세 모달 -->
                <div class="modal" id="memberDetailModal" tabindex="-1" aria-hidden="true">
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
                                                <td>{{ currentMember.member.userId }}</td>
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
                                                <td>{{ currentMember.member.cDateTime }}</td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>추가 정보</h6>
                                        <table class="table table-bordered">
                                            <tr>
                                                <th style="width: 30%">주소</th>
                                                <td>
                                                    {{ currentMember.member.address }}<br>
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
                                            <tr v-for="order in currentMember.orderHistory" :key="order.orderId">
                                                <td>{{ order.ORDERKEY }}</td>
                                                <td>{{ order.ORDERDATE }}</td>
                                                <td>{{ formatCurrency(order.PRICE) }}</td>
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
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                                <button type="button" class="btn btn-primary" @click="updateMember">저장</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 주문 상세 모달 -->
                <div class="modal" id="orderDetailModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">주문 상세 정보 - {{ currentOrder?.order?.ORDERKEY }}</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
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
                                                <td>신용카드
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
                                                <td><strong>{{ formatCurrency(totalOrderPrice) }}</strong></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                                <button v-if="currentOrder?.order?.status !== 'CANCELED'" type="button"
                                    class="btn btn-danger" @click="showCancelModal(currentOrder.order.ORDERKEY)">
                                    주문 취소
                                </button>
                                <button v-if="canUpdateStatus(currentOrder?.order?.status)" type="button"
                                    class="btn btn-primary" @click="showStatusModal(currentOrder.order.ORDERKEY)">
                                    상태 변경
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 주문 상태 변경 모달 -->
                <div class="modal" id="statusModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">주문 상태 변경</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
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
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                                <button type="button" class="btn btn-primary" @click="updateOrderStatus">변경</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 주문 취소 모달 -->
                <div class="modal" id="cancelModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">주문 취소</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">취소 사유</label>
                                    <textarea class="form-control" v-model="cancelReason" rows="3"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                                <button type="button" class="btn btn-danger" @click="cancelOrder">취소 처리</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 배송 상세 모달 추가 -->
                <div class="modal fade" id="deliveryDetailModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">배송 상세 정보 - {{ currentDelivery.DELIVERYNO }}</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body" v-if="currentDelivery">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>배송 정보</h6>
                                        <table class="table table-bordered">
                                            <tr>
                                                <th>배송번호</th>
                                                <td>{{ currentDelivery.DELIVERYNO }}</td>
                                            </tr>
                                            <tr>
                                                <th>주문번호</th>
                                                <td>{{ currentDelivery.ORDERKEY }}</td>
                                            </tr>
                                            <tr>
                                                <th>배송상태</th>
                                                <td>{{ getDeliveryStatusText(currentDelivery.DELIVERYSTATUS) }}</td>
                                            </tr>
                                            <tr>
                                                <th>운송장번호</th>
                                                <td>{{ currentDelivery.TRACKINGNUMBER || '-' }}</td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>회원 정보</h6>
                                        <table class="table table-bordered">
                                            <tr>
                                                <th>회원명</th>
                                                <td>{{ currentDelivery.USERNAME }}</td>
                                            </tr>
                                            <tr>
                                                <th>연락처</th>
                                                <td>{{ currentDelivery.USERPHONE }}</td>
                                            </tr>
                                            <tr>
                                                <th>이메일</th>
                                                <td>{{ currentDelivery.USEREMAIL }}</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>




            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>

        <script>

            const app = Vue.createApp({
                data() {
                    return {
                        selectedInquiryId : "",
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
                        contentImage: null,
                        contentImagePreview: null,
                        // 상품 검색 및 페이징 관련 데이터
                        productSearch: {
                            keyword: '',
                            category: '',
                            status: '',
                            page: 1,
                            size: 10
                        },
                        productList: [],
                        productCurrentPage: 1,
                        productPageSize: 10,
                        productTotalCount: 0,
                        categories: [], // 카테고리 목록
                        item: {
                            filePath: ''
                        },
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
                        memberTotalCount: 0,

                        // 게시판 관리 데이터
                        boardList: [],
                        boardSearch: {
                            keyword: '',
                            boardType: '',
                            page: 1,
                            size: 10
                        },
                        boardCurrentPage: 1,
                        boardTotalCount: 0,
                        // 문의 관리 데이터
                        generalInquiries: [],
                        inquiryFilter: {
                            status: 'all'
                        },
                        currentInquiryTab: 'general',
                        productInquiries: [],
                        productInquiryPagination: {
                            currentPage: 1,
                            totalItems: 0,
                            itemsPerPage: 10
                        },
                        deliverySearch: {
                            searchType: 'orderKey',
                            searchKeyword: '',
                            page: 1,
                            size: 10
                        },
                        deliveryList: [],
                        deliveryCurrentPage: 1,
                        deliveryPageSize: 10,
                        deliveryTotalCount: 0,
                        currentDelivery: {  // 기본 구조 초기화
                            DELIVERYNO: null,
                            ORDERKEY: null,
                            DELIVERYSTATUS: null,
                            TRACKINGNUMBER: null,
                            USERNAME: null,
                            USERPHONE: null,
                            USEREMAIL: null
                        },
                        deleteContentImage: false,
                        selectedInquiry: null,
                        replies: [], // 여기서 replies를 관리합니다.
                        replyContent: '',
                        isEditing: false,
                        editingReplyId: null,
                        showReplyModal: false,

                    };
                },
                computed: {
                    
                    totalOrderPrice() {
                        return this.currentOrder.items.reduce((sum, item) => {
                            return sum + (item.ORDERCOUNT * item.PRICE);
                        }, 0);
                    },
                    deliveryTotalPages() {
                        return Math.ceil(this.deliveryTotalCount / this.deliveryPageSize);
                    },
                    deliveryDisplayedPages() {
                        const pages = [];
                        const startPage = Math.max(1, this.deliveryCurrentPage - 2);
                        const endPage = Math.min(this.deliveryTotalPages, startPage + 4);

                        for (let i = startPage; i <= endPage; i++) {
                            pages.push(i);
                        }
                        return pages;
                    },
                    // 게시판 페이징 계산
                    boardTotalPages() {
                        return Math.ceil(this.boardTotalCount / this.boardSearch.size);
                    },
                    boardDisplayedPages() {
                        const range = [];
                        for (let i = 1; i <= this.boardTotalPages; i++) {
                            range.push(i);
                        }
                        return range;
                    },
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
                    },
                    productTotalPages() {
                        return Math.ceil(this.productTotalCount / this.productPageSize);
                    },
                    productDisplayedPages() {
                        const pages = [];
                        const startPage = Math.max(1, this.productCurrentPage - 2);
                        const endPage = Math.min(this.productTotalPages, startPage + 4);

                        for (let i = startPage; i <= endPage; i++) {
                            pages.push(i);
                        }
                        return pages;
                    }
                },
                watch: {
                    currentInquiryTab(newVal) {
                        if (newVal === 'product') {
                            this.fetchProductInquiries();
                        } else if (newVal === 'general') {
                            this.fetchInquiries();
                        }
                    }
                },
                methods: {
                    submitReply(QSNO) {
                        alert("등록되었습니다.");
                        const formData = {
                            qsNo : QSNO,
                            replyContents: this.replyContent,
                            adminId: 'admin' // 실제로는 로그인한 관리자 ID 사용
                        };
                        console.log("test ==> ", formData);

                        $.ajax({
                            url: '/admin/dashboard/inquiry/reply',
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify(formData),
                            success: (response) => {
                                alert('답변이 등록되었습니다.');
                                this.replyContent = '';
                                this.fetchReplies(QSNO); // 답변 목록 새로고침
                                
                            },
                            error: (xhr) => {
                                alert('답변 등록에 실패했습니다.');
                                console.error(xhr);
                            }
                        });
                        this.showReplyModal = false;
                    },

                    // 답변 수정 메서드
                    updateReply() {
                        if (!this.replyContent) {
                            alert('답변 내용을 입력해주세요.');
                            return;
                        }

                        const formData = {
                            replyNo: this.editingReplyNo,
                            replyContents: this.replyContent,
                            adminId: 'admin' // 실제로는 로그인한 관리자 ID 사용
                        };

                        $.ajax({
                            url: `/admin/dashboard/reply/${this.editingReplyNo}`,
                            type: 'PUT',
                            contentType: 'application/json',
                            data: JSON.stringify(formData),
                            success: (response) => {
                                alert('답변이 수정되었습니다.');
                                this.cancelEdit();
                                this.fetchReplies(this.selectedInquiry.QSNO);
                            },
                            error: (xhr) => {
                                alert('답변 수정에 실패했습니다.');
                                console.error(xhr);
                            }
                        });
                    },

                    // 답변 삭제 메서드
                    deleteReply(replyNo) {
                        if (!confirm('정말 삭제하시겠습니까?')) return;

                        $.ajax({
                            url: `/admin/dashboard/reply/${replyNo}`,
                            type: 'DELETE',
                            success: (response) => {
                                alert('답변이 삭제되었습니다.');
                                this.fetchReplies(this.selectedInquiry.QSNO);
                            },
                            error: (xhr) => {
                                alert('답변 삭제에 실패했습니다.');
                                console.error(xhr);
                            }
                        });
                    },

                    // 수정 모드 시작
                    startEditReply(reply) {
                        this.editingReplyNo = reply.replyNo;
                        this.replyContent = reply.replyContents;
                        this.isEditing = true;
                    },

                    // 수정 취소
                    cancelEdit() {
                        this.editingReplyNo = null;
                        this.replyContent = '';
                        this.isEditing = false;
                    },
                    // 일반 문의 상세 보기
                    showInquiryDetail(inq) {
                        this.selectedInquiryId = inq.QSNO;
                        const QSNO = parseInt(inq.QSNO);

                        if (isNaN(QSNO)) {
                            console.error("QSNO is not a number:", inq.QSNO);
                            return;
                        }
                        this.selectedInquiry = { QSNO: QSNO };
                        this.fetchReplies(QSNO);
                        this.showReplyModal = true;
                        console.log("모달 열기 상태:", this.showReplyModal);
                    },

                    // 상품 문의 상세 보기
                    showProductInquiryDetail(inquiry) {
                        if (!inquiry.QSNO) {
                            console.error("QSNO is missing in inquiry:", inquiry);
                            return;
                        }

                        const QSNO = parseInt(inquiry.QSNO); // 🔥 숫자 변환

                        if (isNaN(QSNO)) {
                            console.error("QSNO is not a number:", inquiry.QSNO);
                            return;
                        }

                        this.selectedInquiry = inquiry;
                        this.fetchReplies(QSNO);
                        this.showReplyModal = true;
                    },

                    // 답변 목록 가져오기
                    fetchReplies(QSNO) {
                        if (isNaN(QSNO)) {
                            console.error("Invalid qsNo:", QSNO);
                            return;
                        }

                        const url = '/admin/dashboard/inquiry/replies';
                        $.ajax({
                            url: url,
                            type: "GET",
                            data: {
                                qsNo: QSNO
                            },
                            success: (response) => {
                                console.log(response);
                                this.replies = response; // 서버에서 받은 답변 데이터를 replies에 할당
                                console.log("Replies:", this.replies); // 로그로 확인
                            },
                        });
                    },
                    // 답변 수정
                    editReply(reply) {
                        this.replyContent = reply.replyContents;
                        this.isEditing = true;
                        this.editingReplyId = reply.replyNo;
                    },
                    fetchProductInquiries() {
                        $.ajax({
                            url: "/admin/dashboard/inquiryList.dox",
                            type: "POST",
                            data: {
                                type: "product",
                                page: this.currentPage,
                                size: this.pageSize
                            },
                            success: (response) => {
                                // 응답 데이터 구조 확인
                                console.log(response);

                                // productInquiries에 직접 할당
                                this.productInquiries = response.list || response.data || response;

                                // 할당 후 데이터 확인
                                console.log("할당 후 productInquiries:", this.productInquiries);
                            }
                        });
                    },
                    showProductDetail(itemNo) {
                        // 상품 상세 보기 구현
                        console.log("상품 조회:", itemNo);
                        window.location.href = '/product/info.do?itemNo=' + itemNo;
                    },
                    toggleProductStatus(item) {
                        if (!confirm(`정말 ${item.status === 'Y' ? '판매중지' : '판매재개'} 하시겠습니까?`)) {
                            return;
                        }

                        $.ajax({
                            url: "/admin/dashboard/toggleProductStatus.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                itemNo: item.itemNo,
                                currentStatus: item.status
                            },
                            success: (response) => {
                                if (response.result === "success") {
                                    item.status = response.newStatus; // 상태값 실시간 업데이트
                                    this.showAlert(
                                        response.newStatus === 'Y' ? '판매 상태가 활성화되었습니다.' : '판매가 중지되었습니다.',
                                        'success'
                                    );
                                } else {
                                    this.showAlert('상태 변경 실패: ' + response.message, 'error');
                                }
                            },
                            error: (xhr) => {
                                this.showAlert('서버 오류: ' + xhr.statusText, 'error');
                            }
                        });
                    },
                    showAlert(message, type) {
                        // SweetAlert2 또는 기존 alert 사용
                        alert(message); // 간단한 알림
                    },
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
                                console.log(response);
                                this.memberList = response.member;
                                console.log(this.memberList);
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
                                console.log(response);
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
                            case 'C': return '회원';
                            case 'A': return '관리자';
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

                        // 날짜가 없으면 파라미터에서 제거
                        if (!params.startDate) delete params.startDate;
                        if (!params.endDate) delete params.endDate;

                        $.ajax({
                            url: "/admin/order/list.dox",
                            type: "POST",
                            dataType: "json",
                            data: params,
                            success: (response) => {
                                this.orderList = response;
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
                            this.fetchProducts();
                        } else if (section === 'board-management') {
                            this.fetchBoards();
                        } else if (section === 'inquiry-management') {
                            this.fetchInquiries(); // 일반 문의 로드
                            this.fetchProductInquiries(); // 상품 문의 로드
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
                    handleFileChange(field) {
                        const fileInput = document.getElementById(field);
                        const files = fileInput.files;

                        if (field === 'thumbnail') {
                            this.thumbnail = files[0];
                        } else if (field === 'additionalPhotos') {
                            this.additionalPhotos = Array.from(files);
                        } else if (field === 'contentImage') {
                            this.contentImage = files[0];

                            // ✅ 미리보기용 URL 생성
                            const reader = new FileReader();
                            reader.onload = (e) => {
                                this.contentImagePreview = e.target.result;
                            };
                            if (this.contentImage) {
                                reader.readAsDataURL(this.contentImage);
                            }
                        }
                    },
                    // 상품 추가 전용 메서드
                    async addProduct() {
                        try {
                            const formData = new FormData();
                            // 숫자 값은 명시적으로 변환
                            formData.append("name", this.name);
                            formData.append("price", parseInt(this.price));
                            formData.append("quantity", parseInt(this.quantity));
                            formData.append("category", this.category);
                            formData.append("info", this.info);
                            formData.append("allergens", this.allergens);

                            // 파일 추가
                            if (this.thumbnail) {
                                formData.append("thumbnail", this.thumbnail);
                            }

                            if (this.additionalPhotos && this.additionalPhotos.length > 0) {
                                this.additionalPhotos.forEach(file => {
                                    formData.append("additionalPhotos", file);
                                });
                            }

                            if (this.contentImage) {
                                formData.append("contentImage", this.contentImage);
                            }

                            const response = await $.ajax({
                                url: "/product/addWithFiles.dox",
                                type: "POST",
                                data: formData,
                                processData: false,
                                contentType: false,
                                dataType: "json"
                            });

                            if (response.result === "success") {
                                alert("상품이 추가되었습니다.");
                                this.showProductForm = false;
                                this.fetchProducts();
                            } else {
                                alert("상품 추가 실패: " + response.message);
                            }
                        } catch (error) {
                            console.error("상품 추가 실패:", error);
                            alert("상품 추가 중 오류가 발생했습니다.");
                        }
                    },

                    // 상품 수정 전용 메서드
                    async updateProduct() {
                        try {
                            const formData = new FormData();
                            formData.append("itemNo", this.itemNo);
                            formData.append("name", this.name);
                            formData.append("price", this.price);
                            formData.append("quantity", this.quantity);
                            formData.append("category", this.category);
                            formData.append("info", this.info);
                            formData.append("allergens", this.allergens);

                            // 파일 추가 (기존 파일 유지 또는 새 파일 업로드)
                            if (this.thumbnail) {
                                formData.append("thumbnail", this.thumbnail);
                            }

                            if (this.additionalPhotos && this.additionalPhotos.length > 0) {
                                this.additionalPhotos.forEach(file => {
                                    formData.append("additionalPhotos", file);
                                });
                            }

                            if (this.contentImage) {
                                formData.append("contentImage", this.contentImage);
                            }

                            if (this.deleteContentImage) {
                                formData.append("deleteContentImage", "true");
                            }

                            const response = await $.ajax({
                                url: "/product/updateWithFiles.dox",
                                type: "POST",
                                data: formData,
                                processData: false,
                                contentType: false,
                                dataType: "json"
                            });

                            if (response.result === "success") {
                                alert("상품이 수정되었습니다.");
                                this.showProductForm = false;
                                this.fetchProducts();
                            } else {
                                alert("상품 수정 실패: " + response.message);
                            }
                        } catch (error) {
                            console.error("상품 수정 실패:", error);
                            alert("상품 수정 중 오류가 발생했습니다.");
                        }
                    },

                    // 폼 제출 시 추가/수정 구분하여 처리
                    submitForm() {
                        if (this.formType === 'add') {
                            this.addProduct();
                        } else if (this.formType === 'edit') {
                            this.updateProduct();
                        }
                    },

                    // 상품 수정 버튼 클릭 시 처리
                    showForm(type) {
                        this.formType = type;
                        if (type === 'add') {
                            // 추가 모드: 폼 초기화
                            this.showProductForm = true;
                            this.showTable = false;
                            this.resetForm();
                        } else {
                            // 수정 모드: 목록 표시
                            this.showProductForm = false;
                            this.showTable = true;
                            this.fetchProducts();
                        }
                    },

                    // 폼 초기화 메서드
                    resetForm() {
                        this.itemNo = "";
                        this.name = "";
                        this.price = "";
                        this.quantity = "";
                        this.category = "";
                        this.info = "";
                        this.allergens = "";
                        this.item = { filePath: "" };
                        this.thumbnail = null;
                        this.additionalPhotos = [];
                        this.contentImage = null;
                        this.contentImagePreview = null;
                        this.imgList = [];
                        this.deleteContentImage = false;
                    },
                    makeUploadForm(itemNo) {
                        if (!this.thumbnail && this.additionalPhotos.length === 0 && !this.contentImage) {
                            return null;
                        }

                        var form = new FormData();

                        if (this.thumbnail) {
                            form.append("file1", this.thumbnail);
                            form.append("isThumbnail", "Y");
                        } else {
                            // 썸네일이 없을 경우 빈 file1 추가 (해결책)
                            form.append("file1", "");
                        }

                        if (this.additionalPhotos.length > 0) {
                            this.additionalPhotos.forEach((photo, index) => {
                                form.append("file1", photo);
                                form.append("isThumbnail", "N");
                            });
                        }

                        // 설명 이미지 경로를 보내는 부분
                        if (this.contentImage) {
                            form.append("contentImage", this.contentImage); // 설명용 이미지 경로
                        }

                        form.append("itemNo", itemNo);

                        return form;
                    },

                    upload(form) {
                        var self = this;
                        $.ajax({
                            url: '/product/fileUpload.dox',
                            type: 'POST',
                            data: formData,
                            contentType: false,
                            processData: false,
                            success: function (response) {
                                // 파일 업로드 성공
                            },
                            error: function (error) {
                                alert("파일 업로드 실패: " + error.responseJSON.message);
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
                                location.href = "/product.do";
                                self.showProductForm = false;
                            },
                            error: function (xhr, status, error) {
                                console.log("에러 발생: " + error);
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
                                console.log(data);
                                self.item = data.info;
                                self.name = self.item.itemName;
                                self.price = self.item.price;
                                self.quantity = self.item.itemCount;
                                self.category = self.item.category;
                                self.info = self.item.itemInfo;
                                self.allergens = self.item.allergens;

                                // 이미지 리스트 초기화
                                self.imgList = data.imgList || [];

                                // 썸네일 이미지 설정
                                if (data.info.filePath) {
                                    self.item.filePath = data.info.filePath;
                                }

                                self.itemNo = self.item.itemNo;
                                self.showProductForm = true;
                                self.showTable = false;
                                self.formType = 'edit';
                            }
                        });
                    },
                    // 상품 검색
                    searchProducts() {
                        this.productSearch.page = 1;
                        this.productCurrentPage = 1;
                        this.fetchProducts();
                    },
                    // 검색 조건 초기화
                    resetProductSearch() {
                        this.productSearch = {
                            keyword: '',
                            category: '',
                            status: '',
                            page: 1,
                            size: 10
                        };
                        this.fetchProducts();
                    },

                    // 상품 목록 가져오기
                    fetchProducts() {
                        $.ajax({
                            url: "/product/list2.dox",
                            type: "POST",
                            dataType: "json",
                            data: this.productSearch,
                            success: (response) => {
                                console.log(response);
                                this.productList = response.list;
                                this.productTotalCount = response.totalCount;
                                this.categories = response.categories || [];
                            }
                        });
                    },

                    // 페이지 변경
                    changeProductPage(page) {
                        if (page < 1 || page > this.productTotalPages) return;
                        this.productCurrentPage = page;
                        this.productSearch.page = page;
                        this.fetchProducts();
                    },

                    // 날짜 포맷팅
                    formatDate(dateString) {
                        if (!dateString) return '';
                        const date = new Date(dateString);
                        return date.toLocaleDateString('ko-KR') + ' ' + date.toLocaleTimeString('ko-KR', {
                            hour: '2-digit',
                            minute: '2-digit'
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
                                self.fetchProducts();
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
                                // 화면에서만 제거
                                self.imgList = self.imgList.filter(img => img.fileName !== fileName);

                                // 만약 썸네일이 삭제된 경우
                                if (self.item.filePath && self.item.filePath.includes(fileName)) {
                                    self.item.filePath = '';
                                }
                            }
                        });
                    },
                    getOrderStatusText(status) {
                        switch (status) {
                            case 'PAY_COMPLETE': return '결제완료';
                            case 'P': return '상품준비중';
                            case 'D': return '배송중';
                            case 'F': return '배송완료';
                            case 'C': return '취소됨';
                        }
                    },
                    // 게시판 관리
                    async fetchBoards() {
                        try {
                            const response = await $.ajax({
                                url: '/admin/dashboard/boards',
                                method: 'GET',
                                data: this.boardSearch
                            });
                            console.log(response);
                            this.boardList = response.data;
                            this.boardTotalCount = response.totalCount;
                        } catch (error) {
                            console.error('게시판 조회 실패:', error);
                        }
                    },
                    searchBoards() {
                        this.boardCurrentPage = 1;
                        this.fetchBoards();
                    },
                    changeBoardPage(page) {
                        this.boardCurrentPage = page;
                        this.boardSearch.page = page;
                        this.fetchBoards();
                    },
                    async deleteBoard(id) {
                        if (confirm('정말 삭제하시겠습니까?')) {
                            await $.ajax({
                                url: `/admin/dashboard/boards/${id}`,
                                method: 'DELETE'
                            });
                            this.fetchBoards();
                        }
                    },

                    // 문의 관리
                    fetchInquiries() {
                        console.log("일반 문의 조회 시작");
                        $.ajax({
                            url: "/admin/dashboard/inquiryList.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                type: "general",
                                page: this.currentPage,
                                size: this.pageSize
                            },
                            success: (response) => {
                                console.log("API 응답 데이터:", response);
                                this.generalInquiries = response.list || [];
                                console.log("할당 후 generalInquiries:", this.generalInquiries);
                            },
                            error: (xhr, status, error) => {
                                console.error("문의 목록 조회 실패:", error);
                                console.log("상태 코드:", xhr.status);
                                console.log("응답 텍스트:", xhr.responseText);
                            }
                        });
                    },
                    loadReplies(QSNO) {
                        $.ajax({
                            url: `/admin/inquiries/${QSNO}/replies`,
                            type: 'GET',
                            success: function (replies) {
                                $('#reply-list').empty();
                                replies.forEach(reply => {
                                    $('#reply-list').append(`
                    <div class="reply-item">
                        <strong>${reply.adminId}</strong>
                        <p>${reply.replyContents}</p>
                        <small>${formatDate(reply.cdatetime)}</small>
                        <button onclick="deleteReply(${reply.replyNo})"
                                class="btn btn-sm btn-danger">삭제</button>
                    </div>
                `);
                                });
                            }
                        });
                    },
                
                    stripHtml(html) {
                        const tmp = document.createElement("div");
                        tmp.innerHTML = html;
                        return tmp.textContent || tmp.innerText || "";
                    },
                    // 배송 관리 관련 메서드
                    searchDeliveries() {
                        this.deliveryCurrentPage = 1;
                        this.fetchDeliveries();
                    },

                    resetDeliverySearch() {
                        this.deliverySearch = {
                            searchType: 'orderKey',
                            searchKeyword: '',
                            page: 1,
                            size: 10
                        };
                        this.fetchDeliveries();
                    },

                    fetchDeliveries() {
                        const params = {
                            ...this.deliverySearch,
                            page: this.deliveryCurrentPage,
                            size: this.deliveryPageSize
                        };

                        $.ajax({
                            url: "/admin/dashboard/delivery/list",
                            type: "GET",
                            dataType: "json",
                            data: params,
                            success: (response) => {
                                console.log(response);
                                this.deliveryList = response.list;
                                this.deliveryTotalCount = response.total;
                                return {
                                    ...item,
                                    originalTracking: item.trackingNumber // 원래 값 저장
                                };
                            }
                        });
                    },

                    updateDeliveryStatus(deliveryNo, status) {
                        $.ajax({
                            url: "/admin/dashboard/delivery/updateStatus",
                            type: "POST",
                            data: {
                                deliveryNo: deliveryNo,
                                status: status
                            },
                            success: () => {
                                alert("배송 상태가 업데이트되었습니다.");
                            }
                        });
                    },

                    updateTrackingNumber(deliveryNo, trackingNumber) {
                        // 이전 값과 동일하면 API 호출 안 함
                        const delivery = this.deliveryList.find(d => d.deliveryNo === deliveryNo);
                        if (delivery.originalTracking === trackingNumber) {
                            return;
                        }

                        // 유효성 검사
                        if (!trackingNumber || trackingNumber.trim() === '') {
                            alert("운송장 번호를 입력해주세요.");
                            delivery.trackingNumber = delivery.originalTracking; // 원래 값으로 복원
                            return;
                        }

                        $.ajax({
                            url: "/admin/dashboard/delivery/updateTracking",
                            type: "POST",
                            data: {
                                deliveryNo: deliveryNo,
                                trackingNumber: trackingNumber
                            },
                            success: () => {
                                // 성공 시 원래 값 업데이트
                                delivery.originalTracking = trackingNumber;
                                console.log("운송장 번호 업데이트 성공");
                            },
                            error: (xhr) => {
                                console.error("운송장 번호 업데이트 실패:", xhr.responseText);
                                alert("운송장 번호 업데이트에 실패했습니다.");
                                delivery.trackingNumber = delivery.originalTracking; // 실패 시 원래 값으로 복원
                            }
                        });
                    },

                    showDeliveryDetail(deliveryNo) {
                        $.ajax({
                            url: `/admin/dashboard/delivery/detail/${deliveryNo}`,
                            type: "GET",
                            dataType: "json",
                            success: (response) => {
                                console.log("상세 정보 응답:", response);
                                this.currentDelivery = response;
                                console.log(this.currentDelivery);
                                this.showDetailModal(); // 모달 표시 메서드 호출
                            },
                            error: (xhr) => {
                                console.error("상세 정보 조회 실패:", xhr.responseText);
                                alert("배송 상세 정보를 불러오는데 실패했습니다.");
                            }
                        });
                    },
                    showDetailModal() {
                        // Bootstrap 모달 표시
                        this.$nextTick(() => {
                            const modal = new bootstrap.Modal(document.getElementById('deliveryDetailModal'));
                            modal.show();
                        });

                        // 또는 직접 표시 (Bootstrap 없을 경우)
                        // document.getElementById('deliveryDetailModal').style.display = 'block';
                    },
                    changeDeliveryPage(page) {
                        if (page < 1 || page > this.deliveryTotalPages) return;
                        this.deliveryCurrentPage = page;
                        this.deliverySearch.page = page;
                        this.fetchDeliveries();
                    },
                    getDeliveryStatusText(status) {
                        const statusMap = {
                            'P': '배송준비중',
                            'D': '배송중',
                            'S': '배송완료',
                            'C': '배송취소'
                        };
                        return statusMap[status] || status;
                    },
                    
                },
                mounted() {
                    this.loadDashboardData();
                    this.fetchProducts();
                    this.fetchInquiries();
                }
            });
            app.mount('#app');
        </script>