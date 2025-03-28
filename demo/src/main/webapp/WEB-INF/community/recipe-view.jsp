<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/commu-css/recipe-view.css">
    <script src="/js/pageChange.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

	<title>상세보기</title>
</head>
<style>
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h2 class="recipe">레시피 공유</h2>
            <!-- 제목 & 프로필 컨테이너 -->
            <div class="title-container">
                <img src="/img/포챠코4.jpg" class="profile-img" alt="프로필">
                <div class="post-title">{{ info.title }}</div>
            </div>

            <!-- 작성자 정보 -->
            <div class="post-meta">
                <span class="post-user">{{ info.userId }}</span> ·
                <span class="post-date">{{ info.cdatetime }}</span> ·
                조회 {{ info.cnt }} · 
                <!-- 좋아요 버튼 -->
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" 
                    id="like-btn-{{ info.postId }}" @click="fnLike" class="like"
                    :class="{ 'liked': info.isLiked }" :fill="info.isLiked ? 'red' : 'gray'">
                    <path d="M47.6 300.4L228.3 469.1c7.5 7 17.4 10.9 27.7 10.9s20.2-3.9 27.7-10.9L464.4 
                    300.4c30.4-28.3 47.6-68 47.6-109.5v-5.8c0-69.9-50.5-129.5-119.4-141C347 36.5 300.6 
                    51.4 268 84L256 96 244 84c-32.6-32.6-79-47.5-124.6-39.9C50.5 55.6 0 115.2 0 
                    185.1v5.8c0 41.5 17.2 81.2 47.6 109.5z"/>
                </svg>

                <!-- 좋아요 숫자 -->
                <span v-show="info.likes !== null">{{ info.likes }}</span>
            </div>

            <!-- 요리 정보 컨테이너 -->
            <div class="recipe-info-container">
                <div class="info-item">
                    <span class="info-title">요리 시간:</span>
                    <span>{{ info.cookingTime }}</span>
                </div>
                <div class="info-item">
                    <span class="info-title">인분:</span>
                    <span>{{ info.servings }}</span>
                </div>
                <div class="info-item">
                    <span class="info-title">난이도:</span>
                    <span class="difficulty-stars">
                        <i v-for="star in 5" :key="star"
                           :class="star <= info.difficulty ? 'fas fa-star star-filled' : 'far fa-star star-empty'">
                        </i>
                    </span>
                    
                </div>
                <div class="info-item">
                    <span class="info-title">설명:</span>
                    <span>{{ info.instructions }}</span>
                </div>
            </div>


            <!-- 본문 내용 -->
            <div class="post-content" v-html="info.contents"></div>

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
                postId : "${map.postId}",
                info : {},
                sessionId: "${sessionId}",
                sessionStatus: "${sessionStatus}",
            };
        },
        methods: {
            fnRecipe(){
				var self = this;
				var nparmap = {
                    postId : self.postId,
                    userId: self.sessionId,
                    option: "SELECT"
				};
				$.ajax({
					url:"/recipe/view.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        self.info = data.info;
                        console.log('Post ID:', self.postId);

                        // 좋아요 상태를 제대로 받아오지 못했을 경우 기본값 설정
                    if (self.info.isLiked === undefined) {
                        self.info.isLiked = false;
                    }

					}
				});
            },
            goBack() {
                location.href = "/commu-main.do?tab=qna";
            },
            fnEdit(postId) {
                pageChange("/recipe/edit.do", { postId : this.postId });
            },
            fnLike() {
                var self = this;

                // 서버로 좋아요 요청
                $.ajax({
                    url: "/recipe/like.dox",
                    type: "POST",
                    data: {
                        postId: self.postId,
                        userId: self.sessionId // 로그인한 유저 ID
                    },
                    success: function(response) {
                        let jsonResponse = typeof response === "string" ? JSON.parse(response) : response;
                        console.log("서버 응답:", jsonResponse); // ✅ 응답 확인

                        if (jsonResponse.result === "success") {
                            self.info.isLiked = jsonResponse.isLiked;
                            self.info.likes = jsonResponse.likes;

                            // 좋아요 상태와 숫자 업데이트
                            let likeButton = $("#like-btn-" + self.postId);
                            let likeCount = $("#like-count-" + self.postId);

                            // 좋아요 버튼 색 변경
                            if (jsonResponse.isLiked) {
                                likeButton.addClass("liked");
                            } else {
                                likeButton.removeClass("liked");
                            }

                            // 좋아요 개수 업데이트
                            likeCount.text(jsonResponse.likes);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Failed to toggle like:", error);
                    }
                });
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
            self.fnRecipe();
            
        }
    });
    app.mount('#app');
</script>
​</body>