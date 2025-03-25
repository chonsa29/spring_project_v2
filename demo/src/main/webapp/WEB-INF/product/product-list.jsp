<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/product-css/product-list.css">
        <script src="/js/pageChange.js"></script>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">
            <div id="rootname">
                <a href="/home.do">HOME</a> > <a href="/product.do">PRODUCT</a>
            </div>
            <div id="name">
                <h2>상품 목록</h2>
            </div>
            <div>
                <input type="text" placeholder="검색하기" id="product-search" v-model="keyword" @keyup.enter="fnProductList">
            </div>
            <div id="product-count">
                <span id="selectproduct">전체개수</span>
                <span>{{productcount}}개</span>
            </div>
            <div class="product-list">
                <div class="product" v-for="item in list">
                    <div class="product-image" @click="fnInfo(item.itemNo)">
                        <img class="product-image" :src="item.filePath" alt="item.itemName" />
                    </div>
                    <div @click="fnInfo(item.itemNo)">
                        <p class="product-info">{{item.itemInfo}}</p>
                        <h4 class="product-name">{{item.itemName}}</h4>
                        <p class="product-discount-style">{{formatPrice(item.price * 10) }}</p>
                        <p class="product-discount">10%</p>
                        <p class="product-price">{{formatPrice(item.price)}}원</p>
                    </div>
                    <div id="reaction-menu">
                        <button class="product-like">❤</button>
                        <button class="product-cart">🛒</button>
                    </div>
                </div>
            </div>
            <div id="indexnum">
                <a v-if="page !=1" id="index" href="javascript:;" class="color-black" @click="fnPageMove('prev')">
                    < </a>
                        <a id="index" href="javascript:;" v-for="num in index" @click="fnPage(num)">
                            <span v-if="page == num">
                                {{num}}
                            </span>
                            <span v-else class="color-black">
                                {{num}}
                            </span>
                        </a>
                        <a v-if="page!=index" id="index" href="javascript:;" class="color-black"
                            @click="fnPageMove('next')"> >
                        </a>
            </div>
        </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </body>

    </html>
    <script>

        const app = Vue.createApp({
            data() {
                return {
                    list: [],
                    pageSize: 9,
                    productcount: 0,
                    index: 0,
                    page: 1,
                    price: 0,
                    keyword : "",
                };
            },
            methods: {
                fnProductList() {
                    var self = this;
                    var nparmap = {
                        keyword : self.keyword,
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize,
                    };
                    $.ajax({
                        url: "/product/list.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            if (data.result == "success") {
                                console.log(data);
                                self.list = data.list;
                                self.productcount = data.count;
                                self.index = Math.ceil(data.count / self.pageSize);
                            } else {
                                console.log("실패");
                            }
                        }
                    });
                },

                fnInfo(itemNo) {
                    pageChange("/product/info.do", { itemNo: itemNo });
                },

                fnPage: function (num) {
                    let self = this;
                    self.page = num;
                    self.fnProductList();
                },

                fnPageMove: function (direction) {
                    let self = this;
                    let next = document.querySelector(".next");
                    let prev = document.querySelector(".prev");
                    if (direction == "next") {
                        self.page++;
                    } else {
                        self.page--;
                    }
                    self.fnProductList();
                },
                formatPrice(value) {
                    return value ? parseInt(value).toLocaleString() : "0";
                }
            },
            mounted() {
                var self = this;
                self.fnProductList();
            }
        });
        app.mount('#app');
    </script>