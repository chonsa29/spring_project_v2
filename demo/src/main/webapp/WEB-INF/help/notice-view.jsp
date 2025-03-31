<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>"></script>
    <link rel="stylesheet" href="/css/inquire-css/notice-view-style.css">
    <script src="/js/pageChange.js"></script>
	<title>상세보기</title>
</head>
<style>
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h2 class="notice">공지사항</h2>
            <!-- 제목 -->
            <div class="title-container">
                <div class="post-title">{{ info.noticeTitle }}</div>
            </div>

            <div class="post-meta">
                <span class="post-date">{{ info.noticeDate }}</span> ·
                조회 {{ info.viewCnt }}
            </div>

            <!-- 본문 내용 -->
            <div class="post-content"><span v-html="info.noticeContents"></span></div>

            <!-- 버튼들 -->
            <div class="button-group-container">
                <div v-if="sessionStatus == 'A'" class="button-group">
                    <button class="edit-btn" @click="fnEdit">수정</button>
                    <button class="delete-btn" @click="fnRemove">삭제</button>
                </div>
                <button class="buttonGoBack" @click="goBack">목록으로</button>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                noticeNo : "${map.noticeNo}",
                info : {},
                sessionStatus: "${sessionStatus}",
            };
        },
        methods: {
            fnNotice(){
				var self = this;
				var nparmap = {
                    noticeNo : self.noticeNo,
                    option: "SELECT"
				};
				$.ajax({
					url:"/notice/view.dox",
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
                location.href = "/inquire.do?tab=notice";
            },
            fnEdit(noticeNo) {
                pageChange("/notice/edit.do", { noticeNo: this.noticeNo });
            },
            fnRemove: function () {
                var self = this;
                var nparmap = {
                    noticeNo: self.noticeNo
                };
                $.ajax({
                    url: "/notice/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        if(data.result == "success") {
							alert("삭제되었습니다!");
                            location.href="/inquire.do?tab=notice";
						} else {
                            alert("삭제 실패")
                        }
                    }
                });
            },
        },
        mounted() {
            var self = this;
            self.fnNotice();
        }
    });
    app.mount('#app');
</script>
​</body>