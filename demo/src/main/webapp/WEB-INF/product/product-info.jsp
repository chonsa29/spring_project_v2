<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <title>첫번째 페이지</title>
    </head>
    <style>
        #imgbox {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            max-width: 800px;
        }

        #product-box {
            width: 500px;
            height: 500px;
            margin-left: 15vw;
            margin-bottom: 10px;
            background-color: #eee;
        }

        .subimg {
            width: 100px;
            height: 100px;
            background-color: #aaa;
            display: block;
        }

        #rootname {
            text-align: left;
            color: #bbb;
            margin-left: 15vw;
            margin-bottom: 20px;
        }
    </style>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div id="rootname">
                <div>HOME>PRODUCT>PRODUCTTYPE</div>
            </div>
            <div id="imgbox">
                <div id="product-box">

                </div>
                <div class="subimg">

                </div>
                <div class="subimg">

                </div>
                <div class="subimg">
                    
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
                    userId: "",
                    pwd: ""
                };
            },
            methods: {
                fnLogin() {
                    var self = this;
                    var nparmap = {
                    };
                    $.ajax({
                        url: "login.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
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
    ​