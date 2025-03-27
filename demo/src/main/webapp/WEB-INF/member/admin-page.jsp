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
                                <canvas id="salesChart" height="300"></canvas>
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
                                                <tr v-for="order in recentOrders" :key="order.orderId">
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
                            <p>주문 관리 관련 콘텐츠</p>
                        </div>

                        <!-- 회원 관리 -->
                        <div v-if="currentSection === 'member-management'" class="section">
                            <h3>회원 관리</h3>
                            <p>회원 관리 관련 콘텐츠</p>
                        </div>
                    </div>
                </div>
            </div>
        </body>

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
                        users: []
                    };
                },
                methods: {
                    showSection(section) {
                        this.currentSection = section;
                        if (section === 'dashboard') {
                            this.loadDashboardData();
                        } else if (section === 'product-management') {
                            this.itemList();
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
                                this.renderSalesChart();
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
                                    borderWidth: 2,
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

                    // 기존 상품 관리 메서드들 유지
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