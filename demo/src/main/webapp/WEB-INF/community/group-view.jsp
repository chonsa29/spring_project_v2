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
                    <span>{{ members.length }}/3</span>
                </div>

                <!-- sessionId가 members 배열에 포함되어 있으면 신청자 보기 버튼 -->
                <div class="button-container" v-if="isMember">
                    <button class="edit-btn" @click="fnMemberView">신청자 보기</button>
                </div>

                <!-- 신청자 보기 팝업 -->
                <div v-if="isPopupVisible" class="popup-overlay">
                    <div class="popup">
                        <h3>신청자 목록</h3>
                        <ul>
                            <li v-for="member in members" :key="member.id">
                                <span>{{ member.userId }}</span>

                                <!-- 리더 표시 -->
                                <span v-if="member.userId === member.leaderId" class="leader-label">리더</span>
                            
                                    <template v-else>
                                        <!-- 리더(방장)일 경우 -->
                                        <template v-if="sessionId === member.leaderId">
                                            <div class="button-group">
                                                <button v-if="member.status === 'ACTIVE'" class="accept-btn" disabled>수락 완료</button>
                                                <button v-if="member.status === 'ACTIVE'" class="reject-btn" @click="removeMember(member.userId)">삭제</button>
                                                <button v-if="member.status === 'PENDING'" class="accept-btn2" @click="acceptMember(member.userId)">수락</button>
                                                <button v-if="member.status === 'PENDING'" class="reject-btn" @click="rejectMember(member.userId)">거절</button>
                                            </div>
                                        </template>

                                        <!-- 멤버(신청자)일 경우 -->
                                        <template v-else-if="sessionId === member.userId">
                                            <div class="button-group">
                                                <button v-if="member.status === 'ACTIVE'" class="accept-btn" disabled>수락 완료</button>
                                                <button v-if="member.status === 'ACTIVE'" class="cancel-btn" @click="cancelApplication(member.userId)">취소</button>
                                                <button v-if="member.status === 'PENDING'" class="pending-btn" disabled>수락 대기</button>
                                                <button v-if="member.status === 'PENDING'" class="cancel-btn" @click="cancelApplication(member.userId)">취소</button>
                                            </div>
                                        </template>
                                    </template>
                           
                            </li>
                        </ul>

                        <!-- 리더일 때만 마감 버튼을 팝업 하단에 추가 -->
                        <div v-if="isLeader" class="button-group">
                            <button class="end-btn">마감하기</button>
                        
                        <button class="close-btn" @click="closePopup">닫기</button></div>
                    </div>
                </div>

                <!-- sessionId가 members 배열에 없으면 신청하기 버튼 -->
                <div class="button-container" v-if="!isMember">
                    <button class="edit-btn" @click="fnMemberJoin">신청하기</button>
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
                members: [],
                isMember: false, // sessionId가 members 배열에 포함되었는지 여부
                isLeader: false, // 현재 사용자가 리더인지 여부
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
                        self.members = data.members;
                        self.checkIfMember(); // sessionId가 members에 포함되었는지 확인
                        self.checkIfLeader(); // 리더인지 확인
					}
				});
            },
            // sessionId가 members 배열에 포함되었는지 확인
            checkIfMember() {
                this.isMember = this.members.some(member => member.userId === this.sessionId);
            },
            // 현재 사용자가 리더인지 확인
            checkIfLeader() {
                this.isLeader = this.members.some(member => member.userId === this.sessionId && member.userId === member.leaderId);
            },
            // 게시글에 포함된 사람들 리스트 함수
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
                location.href = "/commu-main.do?tab=group";
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

            // 가입 신청
            fnMemberJoin: function () {
                var self = this;
                var nparmap = {
                    userId : self.sessionId
                };
                $.ajax({
                    url: "/group/join.dox",
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
            }
        },
        mounted() {
            var self = this;
            self.fnGroup();

            console.log('members:', this.members);
            
        }
    });
    app.mount('#app');
</script>
​</body>