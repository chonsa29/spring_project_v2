<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
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

            <!-- 관리자 답변 -->
            <div v-if="reply && reply.replyContents" class="admin-reply">
                <h3>관리자 답변</h3>
                <div class="reply-content" v-html="reply.replyContents"></div>
            </div>

            <!-- 관리자 답변 작성 -->
            <div v-if="sessionStatus == 'A'" class="admin-reply-form">
                <h3>관리자 답변 작성</h3>
                <div class="reply-container">
                    <textarea class="replyform" v-model="replyContents" @keyup.enter="fnSaveReply" placeholder="답변을 입력하세요."></textarea>
                    <div class="button-container">
                        <button @click="fnSaveReply">답변 저장</button>
                    </div>
                </div>
            </div>

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
                reply : {},
                sessionId: "${sessionId}",
                sessionStatus: "${sessionStatus}",
                adminReplyText: "",
                replyContents: ""
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
                        self.reply = data.reply;
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
            fnSaveReply() {
                var self = this;
                var nparmap = {
                    qsNo: self.qsNo,
                    replyContents: self.replyContents,
                    adminId: self.sessionId,
                    userId: self.sessionId
                };
                $.ajax({
                    url: "/inquire/replySave.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        if (data.result == "success") {
                            self.fnInquire();
                            self.replyContents = "";
                        } else {
                            alert("답변 저장 실패");
                        }
                    }
                });
            }
        },
        mounted() {
            var self = this;
            self.fnInquire();
        }
    });
    app.mount('#app');
</script>
​</body>