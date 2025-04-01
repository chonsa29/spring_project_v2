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
        <h2 class="recipe">그룹 구해요</h2>
            <!-- 제목 & 프로필 컨테이너 -->
            <div class="title-container">
                <img src="/img/포챠코4.jpg" class="profile-img" alt="프로필">
                <div class="post-title">{{ info.title }}</div>
            </div>

            <!-- 작성자 정보 -->
            <div class="post-meta">
                <span class="post-user">{{ info.userId }}</span> ·
                <span class="post-date">{{ info.cdatetime }}</span> ·
                조회 {{ info.viewCnt }}
            </div>

            <!-- 그룹 정보 컨테이너 -->
            <div class="recipe-info-container">
                <div class="info-item">
                    <span class="info-title">현재 신청자</span>
                    <span>1/3</span>
                </div>
                <div class="button-container" v-if="sessionId == info.userId || sessionStatus == 'A'">
                    <button class="edit-btn" @click="fnMemberView">신청자 보기</button>
                </div>
                <!-- 신청자 보기 버튼 클릭 시 팝업 -->
                <div v-if="isPopupVisible" class="popup-overlay">
                    <div class="popup">
                        <h3>신청자 목록</h3>
                        <ul>
                            <li v-for="member in members" :key="member.id">
                                <span>{{ member.userId }}</span>
                
                                <!-- 리더(방장)일 경우: 수락/거절 버튼 -->
                                <span v-if="sessionId === leaderId">
                                    <button class="accept-btn" @click="fnAccept(member.id)">수락</button>
                                    <button class="reject-btn" @click="fnReject(member.id)">거절</button>
                                </span>
                
                                <!-- 신청한 멤버일 경우: 참가 상태 + 취소 버튼 -->
                                <span v-else-if="sessionId === member.id">
                                    <span> ({{ member.status }}) </span>
                                    <button class="cancel-btn" @click="fnCancel">취소</button>
                                </span>
                            </li>
                        </ul>
                        <button class="close-btn" @click="closePopup">닫기</button>
                    </div>
                </div>
                

                <div class="button-container" v-if="sessionId != info.userId">
                    <button class="edit-btn" @click="fnMember">신청하기</button>
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
                isPopupVisible: false, // 팝업 표시 여부
                members: []
            };
        },
        methods: {
            fnGroup(){
				var self = this;
				var nparmap = {
                    postId : self.postId,
                    userId: self.sessionId,
                    option: "SELECT"
				};
				$.ajax({
					url:"/group/view.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        self.info = data.info;
                        console.log('Post ID:', self.postId);
					}
				});
            },
            fnMemberView() {
                var self = this;
                var nparmap = {
                    postId: self.postId
                };
                $.ajax({
                    url: "/group/members.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        if (data.result === "success") {
                            self.members = data.members;
                            self.isPopupVisible = true; 

                            // Vue가 DOM 업데이트 후 실행되도록 보장
                            self.$nextTick(() => {
                                const popup = document.querySelector('.popup-overlay');
                                if (popup) {
                                    popup.classList.add('show'); // 팝업 활성화
                                }
                            });
                        } else {
                            alert("신청자 정보를 불러오지 못했습니다.");
                        }
                    }
                });
            },
            closePopup() {
                const popup = document.querySelector('.popup-overlay');
                if (popup) {
                    popup.classList.remove('show'); // 팝업 숨김
                }
            },
            goBack() {
                location.href = "/commu-main.do?tab=qna";
            },
            fnEdit(postId) {
                pageChange("/recipe/edit.do", { postId : this.postId });
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
        },
        mounted() {
            var self = this;
            self.fnGroup();
            
        }
    });
    app.mount('#app');
</script>
​</body>