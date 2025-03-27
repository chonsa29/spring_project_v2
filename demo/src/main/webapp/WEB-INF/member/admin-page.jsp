<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/member-css/admin-page.css">
        <title>상품 관리</title>
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
                        <div>
                            <h3>오늘 할 일</h3>
                            <p>주문 관리: 3 | 취소 관리: 0 | 발품 관리: 0 | 답변대기 문의: 1</p>
                        </div>
                        <div class="dashboard-grid">
                            <div class="card">방문자 현황</div>
                            <div class="card">매출액</div>
                            <div class="card">문의</div>
                            <div class="card">리뷰</div>
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
                                <input type="file" id="additionalPhotos" @change="handleFileChange('additionalPhotos')"
                                    multiple>

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
                                        <td><a href="javascript:;" @click="fnEdit(item.itemNo)">{{item.itemName}}</a>
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
                    imgList: []
                };
            },
            methods: {
                showSection(section) {
                    this.currentSection = section;
                },
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
                                // 파일이 존재하면 업로드 처리

                                if (self.thumbnail || self.additionalPhotos.length > 0) {
                                    var form = new FormData();
                                    if (self.thumbnail) {
                                        form.append("file1", self.thumbnail); // 썸네일 파일 추가
                                        form.append("isThumbnail","Y");
                                    }
                                    if (self.additionalPhotos.length > 0) {
                                        self.additionalPhotos.forEach((photo, index) => {
                                            form.append("file1", photo); // 추가 사진 파일 추가
                                            form.append("isThumbnail","N");
                                        });
                                    }
                                    form.append("itemNo", data.itemNo); // 상품 아이디
                                    self.upload(form); // 파일 업로드 함수 호출
                                }
                            }
                        });
                    } else {
                        console.log(self.thumbnail);
                        $.ajax({
                            url: "/product/update.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                // 파일이 존재하면 업로드 처리

                                if (self.thumbnail || self.additionalPhotos.length > 0) {
                                    var form = new FormData();
                                    if (self.thumbnail) {
                                        form.append("file1", self.thumbnail); // 썸네일 파일 추가
                                        form.append("isThumbnail","Y");
                                    }
                                    if (self.additionalPhotos.length > 0) {
                                        self.additionalPhotos.forEach((photo, index) => {
                                            form.append("file1", photo); // 추가 사진 파일 추가
                                            form.append("isThumbnail","N");
                                        });
                                    }

                                    console.log(self.thumbnail);
                                    console.log(self.additionalPhotos);
                                    console.log(data.itemNo);
                                    console.log(self.itemNo);
                                    form.append("itemNo", data.itemNo); // 상품 아이디
                                    self.update(form); // 파일 업로드 함수 호출
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
                            // location.reload(); // 페이지 새로고침
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
                    var nparmap = {
                        itemNo: itemNo
                    };
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
                    var nparmap = {
                    };
                    $.ajax({
                        url: "/product/list2.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            self.list = data.list
                        }
                    });
                },
                fnDelete(itemNo) {
                    var self = this;
                    var nparmap = {
                        itemNo: itemNo
                    };
                    $.ajax({
                        url: "/product/delete.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            self.itemList();
                            alert("삭제되었습니다.");
                        }
                    });
                },
                fnDeleteImg(fileName) {
                    var self = this;
                    var nparmap = {
                        fileName: fileName
                    };
                    $.ajax({
                        url: "/product/deleteImg.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            alert("삭제되었습니다.");
                        }
                    });
                }

            },
            mounted() {
                var self = this;
            }
        });
        app.mount('#app');
    </script>