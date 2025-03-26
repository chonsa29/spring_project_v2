<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/inquire-css/inquire-view-style.css">
    <script src="/js/pageChange.js"></script>
	<title>상세보기</title>
</head>
<style>
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h1 class="inquire-view">문의 상세보기</h1>
        <div class="detail-container">
            <div>{{ info.userId }}</div>
            <div>
                <span>{{ info.cdatetime }}</span>
                <span>{{ info.viewCnt }}</span>
                <span>{{ info.qsStatus }}</span>
            </div>
            <div><span>제목:</span>{{ info.qsTitle }}</div>
            <div>내용:<span v-html="info.qsContents"></span></div>
            <div><span>상품 번호:</span>{{ info.itemNo }}</div>
        </div>
        <div v-if="sessionId == info.userId || sessionStatus == 'A'">
            <button @click="fnEdit">수정</button>
            <button @click="fnRemove">삭제</button>
        </div>
        <div class="button-container">
            <button @click="goBack">목록으로 돌아가기</button>
        </div>
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                qsNo : "${map.qsNo}",
                info : {},
                sessionId: "${sessionId}",
                sessionStatus: "${sessionStatus}",
            };
        },
        methods: {
            fnInquire(){
				var self = this;
				var nparmap = {
                    qsNo : self.qsNo,
                    option: "SELECT"
				};
				$.ajax({
					url:"/inquire/view.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        self.info = data.info;
					}
				});
            },
            goBack() {
                location.href = "/inquire.do";
            },
            fnEdit(qsNo) {
                pageChange("/inquire/edit.do", { qsNo: this.qsNo });
            },
            fnRemove: function () {
                var self = this;
                var nparmap = {
                    qsNo: self.qsNo
                };
                $.ajax({
                    url: "/inquire/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        if(data.result == "success") {
							alert("삭제되었습니다!");
                            location.href="/inquire.do";
						} else {
                            alert("삭제 실패")
                        }
                    }
                });
            },
        },
        mounted() {
            var self = this;
            self.fnInquire();
        }
    });
    app.mount('#app');
</script>
​</body>