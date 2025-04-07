<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/uicons-regular-straight/css/uicons-regular-straight.css">
        <script src="/js/pageChange.js"></script>
        <title>MealPick - 밀키트 쇼핑몰</title>
    </head>

    <body>
        <div id="appHeader">
            <header class="header">
                <div class="logo-container">
                    <a href="/home.do">
                        <div class="logo-contents">
                            <div class="logo">
                                <img src="/img/icon.png" alt="MealPick 로고">
                            </div>
                            <div class="logo2">
                                <img src="/img/MEALPICK.png" alt="MealPick 로고">
                            </div>
                        </div>
                    </a>
                    <!-- nav를 logo-container 내부에 포함 -->
                    <nav class="nav">
                        <a href="/home.do">MAIN</a>
                        <a href="/product.do">PRODUCT</a>
                        <a href="/brand.do">BRAND</a>
                        <a href="/commu-main.do">COMMUNITY</a>
                        <a href="/inquire.do">HELP</a>
                    </nav>

                    <div class="right-container">
                        <div class="login-container">
                            <a href="/member/admin.do" v-if="sessionStatus=='A'">ADMIN</a>
                            <a href="/member/mypage.do" v-if="sessionStatus=='C'">MYPAGE</a>
                            <a href="/member/login.do" v-if="!sessionStatus">LOGIN</a>
                            <a href="/home.do" v-else @click="fnLogout">LOGOUT</a>
                            <a  href="javascript:;" @click="fnCart(sessionId)">CART</a>
                            <div class="button-container" v-if="sessionStatus=='C'">
                                <button class="chat-btn" @click="openChatRoom">
                                    <i class="fi fi-rs-comments" style="font-size: 20px; margin-top: 5px; color: #0DA043;"></i>
                                </button>
                            </div>

                            <!-- 모달 팝업창 -->
                            <div class="custom-modal" v-if="showModal">
                                <div class="custom-modal-content">
                                    <p>{{ modalMessage }}</p>
                                    <button @click="closeModal">확인</button>
                                </div>
                            </div>

                        </div>
                        <div class="search-container">
                            <a href="#"><span class="material-symbols-outlined">
                                search
                            </span></a>
                            <input type="text" placeholder="Search">
                        </div>
                    </div>
                </div>
            </header>

            <!-- 채팅 아이콘 -->
            <div class="floating-icon" @click="toggleChat">
                <img src="/img/icon.png" alt="아이콘">
            </div>

            <!-- AI 채팅창 (v-if 적용) -->
            <div v-if="isChatOpen" class="chat-modal">
                <div class="chat-header">
                    <span>AI 문의</span>
                    <button class="close-btn" @click="toggleChat">✖</button>
                </div>
                <div class="chat-body" id="chatBody">
                    <p class="bot-message">안녕하세요! 무엇을 도와드릴까요?</p>
                </div>
                <div class="chat-footer">
                    <textarea type="text" v-model="userMessage" ref="messageInput"
                    placeholder="문의사항을 입력해 주세요" @keypress.enter="sendMessage"></textarea>
                    <button @click="sendMessage">전송</button>
                </div>
            </div>

        </div>
    </body>

    </html>

    <script>
        window.addEventListener("scroll", function () {
            const header = document.querySelector(".header");
            if (window.scrollY > 50) {
                header.classList.add("shrink"); // 스크롤 내리면 shrink 클래스 추가
            } else {
                header.classList.remove("shrink"); // 맨 위로 올라가면 원래 크기로 복귀
            }
        });


        const appHeader = Vue.createApp({
            data() {
                return {
                    sessionStatus : "${sessionStatus}",
                    sessionId : "${sessionId}",
                    isChatOpen: false, // 채팅창 상태
                    userMessage: "", // 사용자 입력 메시지
                    info : {},
                    showModal: false,
                    modalMessage: "",
                    notificationSent: '<%= String.valueOf(session.getAttribute("notificationSent")) %>',
                    messageFlg : "${messageFlg}"
                };
            },
            computed: {
                memberStatus() {
                    const member = this.members.find(m => m.userId === this.sessionId);
                    return member ? member.status : null;
                }
            },
            methods: {
                fnLogout(){
                    var self = this;
                    var nparmap = {
                    };
                    $.ajax({
                        url:"/member/logout.dox",
                        dataType:"json",	
                        type : "GET", 
                        data : nparmap,
                        success : function(data) { 
                            alert("로그아웃 되었습니다!");
                        }
                        
                    });
                },
                fnCart : function(userId) {
                    pageChange("/cart.do", {userId : userId});
                },
                toggleChat() {
                    this.isChatOpen = !this.isChatOpen; // 채팅창 열기/닫기
                },
                sendMessage(event) {
                    if (this.userMessage.trim() === "") return;

                    const chatBody = document.getElementById("chatBody");

                    // 사용자 메시지 추가
                    const userMessageEl = document.createElement("p");
                    userMessageEl.classList.add("user-message");
                    userMessageEl.textContent = this.userMessage;
                    chatBody.appendChild(userMessageEl);
                    chatBody.scrollTop = chatBody.scrollHeight;

                    const messageToSend = this.userMessage; // 보낼 메시지 저장
                    this.userMessage = ""; // 입력창 초기화

                    // Gemini 응답 대기 메시지
                    const botMessageEl = document.createElement("p");
                    botMessageEl.classList.add("bot-message");
                    botMessageEl.textContent = "질문을 분석 중입니다...";
                    chatBody.appendChild(botMessageEl);
                    chatBody.scrollTop = chatBody.scrollHeight;

                    // AJAX 요청
                    $.ajax({
                        url: "/gemini/chat",  // 여기를 너의 백엔드 컨트롤러 URL로 수정해
                        type: "POST",
                        data: JSON.stringify({ message: messageToSend }),
                        contentType: "application/json",
                        dataType: "json",
                        success: function (response) {
                            // 기존 로딩 메시지 삭제
                            chatBody.removeChild(botMessageEl);

                            const reply = response.reply || "답변을 불러오지 못했습니다.";
                            const newBotMessageEl = document.createElement("p");
                            newBotMessageEl.classList.add("bot-message");
                            newBotMessageEl.textContent = reply;
                            chatBody.appendChild(newBotMessageEl);
                            chatBody.scrollTop = chatBody.scrollHeight;
                        },
                        error: function () {
                            chatBody.removeChild(botMessageEl);

                            const errorMsg = document.createElement("p");
                            errorMsg.classList.add("bot-message");
                            errorMsg.textContent = "죄송합니다. AI 응답을 가져오는 데 실패했습니다.";
                            chatBody.appendChild(errorMsg);
                            chatBody.scrollTop = chatBody.scrollHeight;
                        }
                    });
                },

                resizeTextarea() {
                    this.$nextTick(() => {
                        const textarea = this.$refs.messageTextarea;
                        textarea.style.height = "auto"; // 높이 초기화
                        textarea.style.height = textarea.scrollHeight + "px"; // 내용에 맞게 높이 조정
                    });
                },

                fnGroup : function() {
                    let self = this;
                    var nparmap = {
                        userId : self.sessionId
                    };
                    $.ajax({
                        url: "/group/groupChat.dox",
                        type: "POST",
                        dataType: "json",
                        data: nparmap,
                        success: function(data) {
                            self.info = data.info;
                        },
                        error: function(xhr, status, error) {
                            console.error("AJAX 오류:", error);
                            alert("서버와의 통신 중 오류가 발생했습니다.");
                        }
                    });
                },
                showPopup(message) {
                    this.modalMessage = message;
                    this.showModal = true;
                },
                closeModal() {
                    this.showModal = false;
                },
                // 그룹 채팅
                openChatRoom() {
                    const self = this;

                    // 그룹 정보 조회 후 상태 확인
                    self.fnGroup(); // 최신 정보 조회
                    setTimeout(() => {
                        const groupInfo = self.info;

                        if (!groupInfo || !groupInfo.groupId) {
                            self.showPopup("그룹에 가입하세요!");
                            return;
                        }

                        if (groupInfo.status === "PENDING") {
                            self.showPopup("그룹 승인 요청을 기다리는 중입니다.");
                            return;
                        }

                        if (groupInfo.status === "ACTIVE") {
                            window.open(
                                "/chatting/chatRoom?groupId=" + groupInfo.groupId,
                                "ChatRoom",
                                "width=400,height=600,left=650,top=100"
                            );
                        } else {
                            self.showPopup("유효하지 않은 그룹 상태입니다.");
                        }
                    }, 300); // 비동기 요청에 약간의 시간 대기
                },
                fetchDeleteNotification() {
                    const self = this;
                    if (!self.sessionId) return;

                    const nparmap = {
                        userId: self.sessionId
                    };

                    $.ajax({
                        url: "/notification/getUserNotifications.dox",
                        type: "POST",
                        dataType: "json",
                        data: nparmap,
                        success: function(data) {
                            if (data.status === "success" && data.notifications.length > 0) {
                                const recentNoti = data.notifications[0]; // 최신 알림 하나
                                self.showPopup(recentNoti.message);
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error("삭제 알림 조회 실패:", error);
                        }
                    });
                },
                
            },
            mounted() {
                
                console.log(this.sessionStatus);
                console.log(this.sessionId);

                console.log("알림 상태:", this.notificationSent);
                if (this.messageFlg == "true" || this.messageFlg == "") {
                    this.fetchDeleteNotification();
                }

                const floatingIcon = document.querySelector(".floating-icon img");
                if (floatingIcon && floatingIcon.parentElement) { // 요소가 있는지 확인
                    floatingIcon.parentElement.addEventListener("mouseover", function () {
                        floatingIcon.src = "/img/icon2.png"; // hover 상태 이미지 경로
                    });

                    floatingIcon.parentElement.addEventListener("mouseout", function () {
                        floatingIcon.src = "/img/icon.png"; // 기본 상태 이미지 경로
                    });
                }
                
            },
        });

        appHeader.mount('#appHeader');
    </script>