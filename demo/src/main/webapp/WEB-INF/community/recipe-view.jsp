<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
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
                <span class="post-user">{{ info.nickname }}</span> ·
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
                    <span>{{ info.cookingTime }}분</span>
                </div>
                <div class="info-item">
                    <span class="info-title">양:</span>
                    <span>{{ info.servings }}인분</span>
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

            <!-- 댓글 영역 -->
            <div class="comment-section">
                <h3>댓글</h3>

                <!-- 댓글 작성 영역 -->
                <div class="comment-form">
                    <textarea v-model="contents" @keyup.enter="addComment" placeholder="댓글을 입력하세요."></textarea>
                    <button @click="addComment">등록</button>
                </div>

                <!-- 댓글 리스트 -->
                <div class="comment-list" v-if="commentList.length > 0">
                    <template v-for="(comment, index) in commentList" :key="index">
                    <!-- 댓글 -->
                    <div class="comment-item">
                        <div class="comment-header">
                        <span class="comment-user">{{ comment.nickname }}</span>
                        <span class="comment-date">{{ comment.cdateTime }}</span>
                        </div>
                    
                        <!-- 수정 중일 때 -->
                        <div v-if="editIndex === comment.commentId" class="comment-body">
                            <textarea v-model="editContent"></textarea>
                        </div>
                        <!-- 일반 출력 -->
                        <div v-else class="comment-body">
                            {{ comment.contents }}
                        </div>
                    
                        <!-- 버튼 영역도 수정 모드에 따라 다르게 -->
                        <div class="comment-actions">
                        <!-- 수정 중이면 저장/취소 -->
                        <template v-if="editIndex === comment.commentId">
                            <i class="fas fa-check" @click="saveEdit(comment.commentId)" title="저장">저장</i>
                            <i class="fas fa-times" @click="cancelEdit" title="취소">취소</i>
                        </template>
                        <!-- 일반 상태 -->
                        <template v-else>
                            <template v-if="comment.userId === sessionId || sessionStatus == 'A'">
                                <i class="fas fa-edit" @click="editComment(comment)" title="수정"></i>
                                <i class="fas fa-trash-alt" @click="deleteComment(comment)" title="삭제"></i>
                            </template>
                            <i class="fas fa-reply" @click="toggleReply(comment.commentId)" title="답글">답글</i>
                        </template>
                        </div>
                    </div>
  
                
                    <!-- 대댓글 입력창 -->
                    <div v-if="replyIndex === comment.commentId" class="reply-box">
                        <textarea v-model="replyContent" @keyup.enter="addReply(comment.commentId)" placeholder="답글을 입력하세요"></textarea>
                        <button @click="addReply(comment.commentId)">등록</button>
                    </div>
                
                    <!-- 대댓글 리스트 -->
                    <div class="replies" v-if="comment.replies && comment.replies.length > 0">
                        <div class="reply-item" v-for="reply in comment.replies" :key="reply.commentId">
                        <!-- 대댓글 내용 박스 -->
                        <div class="reply-content">
                            <div class="comment-header">
                                <span class="comment-user">{{ reply.nickname }}</span>
                                <span class="comment-date">{{ reply.cdateTime }}</span>
                            </div>

                            <!-- 대댓글 수정 중 -->
                            <div v-if="editIndex === reply.commentId" class="comment-body">
                                <textarea v-model="editContent"></textarea>
                            </div>

                            <!-- 일반 출력 -->
                            <div v-else class="comment-body">
                                {{ reply.contents }}
                            </div>

                            <div class="comment-actions">
                                <template v-if="editIndex === reply.commentId">
                                  <i class="fas fa-check" @click="saveEdit(reply.commentId)" title="저장">저장</i>
                                  <i class="fas fa-times" @click="cancelEdit" title="취소">취소</i>
                                </template>
                                <template v-else>
                                  <template v-if="reply.userId === sessionId || sessionStatus == 'A'">
                                    <i class="fas fa-edit" @click="editComment(reply)" title="수정"></i>
                                    <i class="fas fa-trash-alt" @click="deleteComment(reply)" title="삭제"></i>
                                  </template>
                                </template>
                              </div>

                            
                        </div>
                    </div>
                    </template>
                </div>
  
                  
                  
                <div v-else class="no-comments">댓글이 없습니다.</div>
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
                commentList: [],
                contents: "",
                replyIndex: null,
                replyContent: '',
                editIndex: null,         // 현재 수정 중인 댓글 ID
                editContent: "",         // 수정 중인 내용

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
                location.href = "/commu-main.do?tab=recipe";
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
                    postId: self.postId
                };
                $.ajax({
                    url: "/recipe/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        if(data.result == "success") {
							alert("삭제되었습니다!");
                            location.href="/commu-main.do?tab=recipe";
						} else {
                            alert("삭제 실패")
                        }
                    }
                });
            },
            // 댓글 목록 불러오기
            loadComments() {
                var self = this;
                $.ajax({
                    url: "/recipe/comments.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        postId: self.postId
                    },
                    success: function (res) {
                        self.commentList = res.commentList || [];
                    }
                });
            },

            // 댓글 등록
            addComment() {
                var self = this;

                if (!self.contents.trim()) {
                    alert("댓글을 입력해주세요.");
                    return;
                }

                var nparmap = {
                    postId: self.postId,
                    userId: self.sessionId,
                    contents: self.contents
                };

                $.ajax({
                    url: "/recipe/commentAdd.dox",
                    type: "POST",
                    dataType: "json",
                    data: nparmap,
                    success: function (res) {
                        if (res.result === "success") {
                            self.contents = "";
                            self.loadComments(); // 새로고침
                        } else {
                            alert("댓글 등록 실패");
                        }
                    }
                });
            },
            // 수정 버튼 클릭
            editComment(comment) {
                this.editIndex = comment.commentId;
                this.editContent = comment.contents;

                this.$nextTick(() => {
                    const textarea = document.querySelector(`#comment-${comment.id} textarea`);
                    if (textarea) textarea.focus();
                });
            },
            cancelEdit() {
                this.editIndex = null;
                this.editContent = "";
            },
            saveEdit(commentId) {
                let self = this;
                var nparmap = {
                    commentId: commentId,
                    contents: self.editContent
                };

                $.ajax({
                    url: "/recipe/commentEdit.dox",
                    type: "POST",
                    dataType: "json",
                    data: nparmap,
                    success: (res) => {
                        if (res.result === "success") {
                            alert("수정되었습니다!");
                            self.editIndex = null;         // ✅ 수정 모드 초기화
                            self.editContent = "";         // ✅ 수정 내용 초기화
                            self.loadComments();
                        } else {
                            alert("수정 실패");
                        }
                    }
                });
            },
            // 삭제
            deleteComment(comment) {
                if (confirm("댓글을 삭제하시겠습니까?")) {
                    $.ajax({
                        url: "/recipe/commentDelete.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            commentId: comment.commentId
                        },
                        success: (res) => {
                            if (res.result === "success") {
                                alert("삭제되었습니다!");
                                this.loadComments();
                            } else {
                                alert("삭제 실패");
                            }
                        }
                    });
                }
            },
            // 대댓글 토글
            toggleReply(index) {
                console.log("Toggle reply for index:", index);
                if (this.replyIndex === index) {
                this.replyIndex = null; // 다시 누르면 닫힘
                } else {
                this.replyIndex = index;
                }
            },
            // 대댓글 등록
            addReply(commentId) {
                if (!this.replyContent.trim()) {
                    alert("답글을 입력하세요");
                    return;
                }

                $.ajax({
                    url: "/recipe/recommentAdd.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        postId: this.postId,
                        commentId: commentId,
                        userId: this.sessionId,
                        contents: this.replyContent
                    },
                    success: (res) => {
                        if (res.result === "success") {
                            this.replyIndex = null;
                            this.replyContent = "";
                            this.loadComments();
                        } else {
                            alert("답글 등록 실패");
                        }
                    }
                });
            }
        },
        mounted() {
            var self = this;
            self.fnRecipe();
            self.loadComments();
            
        }
    });
    app.mount('#app');
</script>
​</body>