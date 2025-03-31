<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>"></script>
    <link rel="stylesheet" href="/css/inquire-css/inquire-edit-style.css">
    <script src="/js/pageChange.js"></script>
	<title>문의 수정</title>
</head>
<style>
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h2 class="inquire">문의게시판</h2>
            <!-- 제목 컨테이너 -->
            <div class="title-container">
                <img src="/images/profile.png" class="profile-img" alt="프로필">
                <input class="post-title" v-model="info.qsTitle">
            </div>

            <!-- 작성자 정보 -->
            <div class="post-meta">
                <span class="post-user">{{ info.userId }}</span> ·
                <span class="post-date">{{ info.cdatetime }}</span> ·
                조회 {{ info.viewCnt }}
            </div>

            <!-- 본문 내용 -->
            <div class="post-content">
                <input class="post-content" v-model="info.qsContents">
            </div>

            <!-- 버튼들 -->
            <div class="button-group-container">
                <div v-if="sessionId == info.userId || sessionStatus == 'A'" class="button-group">
                    <button class="edit-btn" @click="fnEdit">저장</button>
                </div>
                <button class="buttonGoBack" @click="goBack">목록으로</button>
            </div>
	</div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                qsNo : "${map.qsNo}",
                info : {},
                sessionStatus: "${sessionStatus}",
            };
        },
        methods: {
            fnInquire(){
				var self = this;
				var nparmap = {
                    qsNo : self.qsNo,
                    option : "UPDATE"
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
            fnEdit() {
                var self = this;
				var nparmap = self.info;
				$.ajax({
					url:"/inquire/edit.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        if(data.result == "success") {
							alert("수정되었습니다!");
                            location.href="/inquire.do?tab=qna";
						} else {
                            alert("수정 실패")
                        }
					}
				});
            },
            goBack() {
                location.href = "/inquire.do?tab=qna";
            },
        },
        mounted() {
            var self = this;
            self.fnInquire();
        }
    });
    app.mount('#app');
</script>
​