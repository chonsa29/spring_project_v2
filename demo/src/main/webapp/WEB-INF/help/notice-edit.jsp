<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link rel="stylesheet" href="/css/inquire-css/notice-edit-style.css">
    <script src="/js/pageChange.js"></script>
	<title>공지 수정</title>
</head>
<style>
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h2 class="notice">공지사항</h2>
            <!-- 제목 -->
            <div class="title-container">
                <input class="post-title" v-model="info.noticeTitle">
            </div>

            <div class="post-meta">
                <span class="post-date">{{ info.noticeDate }}</span> ·
                조회 {{ info.viewCnt }}
            </div>

            <!-- 본문 내용 -->
            <div class="post-content">
                <input class="post-content" v-model="info.noticeContents">
            </div>

            <!-- 버튼들 -->
            <div class="button-group-container">
                <div>
                    <button class="edit-btn" @click="fnEdit">저장</button>
                </div>
                <div>
                    <button class="buttonGoBack" @click="goBack">목록으로</button>
                </div>
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
                info : {}
            };
        },
        methods: {
            fnNotice(){
				var self = this;
				var nparmap = {
                    noticeNo : self.noticeNo,
                    option : "UPDATE"
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
            fnEdit() {
                var self = this;
				var nparmap = self.info;
				$.ajax({
					url:"/notice/edit.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        if(data.result == "success") {
							alert("수정되었습니다!");
                            location.href="/inquire.do?tab=notice";
						} else {
                            alert("수정 실패")
                        }
					}
				});
            },
            goBack() {
                location.href = "/inquire.do?tab=notice";
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