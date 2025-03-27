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
        <h2 class="inquire">문의게시판</h2>
            <!-- 제목 & 프로필 컨테이너 -->
            <div class="title-container">
                <img src="/images/profile.png" class="profile-img" alt="프로필">
                <div class="post-title">{{ info.qsTitle }}</div>
            </div>

            <!-- 작성자 정보 -->
            <div class="post-meta">
                <span class="post-user">{{ info.userId }}</span> ·
                <span class="post-date">{{ info.cdatetime }}</span> ·
                조회 {{ info.viewCnt }}
            </div>

            <!-- 본문 내용 -->
            <div class="post-content" v-html="info.qsContents"></div>

            <!-- 버튼들 -->
            <div class="button-group-container">
                <div v-if="sessionId == info.userId || sessionStatus == 'A'" class="button-group">
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
                location.href = "/inquire.do?tab=qna";
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
                            location.href="/inquire.do?tab=qna";
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