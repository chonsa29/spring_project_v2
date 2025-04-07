<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그룹 채팅방</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <link rel="stylesheet" href="/css/chatting/chat.css">
</head>
<body>
    <div id="chat-app">
        <div class="chat-container">
            <h2>{{ groupName }}</h2>
            <button class="out" @click="leaveChatRoom">채팅방 나가기</button>
            <div class="chat-box" ref="chatBox">
                <!-- 기존 채팅 기록 출력 -->
                <!-- 입장/퇴장 메시지 전용 div 추가 -->
                <div v-for="msg in messages" :key="msg.id">
                    <!-- ✅ 입장/퇴장 메시지는 chat-info 클래스를 적용 -->
                    <div v-if="msg.messageType === 'JOIN' || msg.messageType === 'LEAVE'" class="chat-info"
                        :class="{
                            'join-message': msg.messageType === 'JOIN',
                            'leave-message': msg.messageType === 'LEAVE'
                        }">
                        {{ msg.content }}
                    </div>
                
                    
                    <!-- ✅ 일반 채팅 메시지 -->
                    <div v-else class="message-wrapper" 
                        :class="{ 'my-message-wrapper': msg.sender === userId }">
                        <!-- 닉네임을 따로 표시 -->
                        <div v-if="msg.sender !== userId" class="sender-name">
                            {{ getNickname(msg.sender) ?? '알 수 없음' }}
                        </div>
                        
                        <div class="chat-message"
                            :class="{
                                'my-message': msg.sender === userId,
                                'other-message': msg.sender !== userId
                            }">
                            <div class="message-bubble">
                                {{ msg.content }}
                            </div>
                        </div>
                    </div>
                </div>
                

            </div>
            <div class="chat-input">
                <input type="text" v-model="newMessage" @keyup.enter="sendMessage" placeholder="메시지를 입력하세요..." />
                <button @click="sendMessage">보내기</button>
            </div>
        </div>
    </div>

    <script>
        const socket = new SockJS('/ws');
        const stompClient = Stomp.over(socket);
        stompClient.reconnect_delay = 5000;

        const groupId = new URLSearchParams(window.location.search).get("groupId");
        const userId = "${sessionId}"; // ✅ 세션에서 유저 ID 가져오기
        const groupName = "${groupName}";
        console.log("그룹 네임: ", groupName);

        const app = Vue.createApp({
            data() {
                return {
                    messages: [],  // 채팅 메시지 배열
                    newMessage: "", // 입력할 메시지
                    userId: userId, // 현재 사용자 ID
                    hasJoined: false, // 입장메시지
                    groupName: groupName,
                    members : []
                };
            },
            methods: {
                sendMessage() {
                    if (this.newMessage.trim() !== "") {
                        const chatMessage = {
                            sender: this.userId,
                            content: this.newMessage,
                            groupId: groupId,
                            messageType: "CHAT"
                        };
                        stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(chatMessage));
                        this.newMessage = "";
                    }
                },
                leaveChatRoom() {
                    console.log("🚀 leaveChatRoom() 실행됨!");

                    const nickname = this.getNickname(this.userId);
                    console.log("this.userId:", this.userId);

                    stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                        sender: this.userId,
                        content: nickname + "님이 퇴장하셨습니다.",
                        groupId: groupId,
                        messageType: "LEAVE"
                    }));

                    console.log("📡 AJAX 요청 전송 시도...");

                    $.ajax({
                        url: "/chatting/chat/leave.dox",
                        type: "POST",
                        data: { 
                            userId: this.userId, 
                            groupId: groupId 
                        },
                        beforeSend: function() {
                            console.log("📡 AJAX 요청 보냄 ✅");
                        },
                        success: function(data) {
                            window.close();
                        },
                        error: function(xhr, status, error) {
                            console.error("❌ 퇴장 요청 실패:", status, error);
                            alert("퇴장 요청 실패!");
                        }
                    });

                
                },
                sendJoinMessage() { // 입장 메시지
                    let self = this;
                    const nickname = this.getNickname(self.userId);
                    stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                        sender: this.userId,
                        content: nickname + "님이 입장하셨습니다.",
                        groupId: groupId,
                        messageType: "JOIN"
                    }));
                },
                scrollToBottom() { //자동 스크롤
                    this.$nextTick(() => {
                        const chatBox = this.$refs.chatBox;
                        if (chatBox) {
                            chatBox.scrollTop = chatBox.scrollHeight;
                        }
                    });
                },
                fnGroup(){
                    var self = this;
                    var nparmap = {
                        groupId : groupId,
                    };
                    console.log("📌 닉네임 요청 파라미터:", nparmap);
                    $.ajax({
                        url:"/chatting/chat/nickname.dox",
                        dataType:"json",	
                        type : "POST", 
                        data : nparmap,
                        success : function(data) {
                            console.log("📌 서버 응답 데이터:", data); // 응답 데이터 확인
                            self.members = data.members;
                            
                            console.log("📌 members 업데이트됨:", self.members);
                        }
                    });
                },
                getNickname(userId) {
                    // 📌 userId에 해당하는 닉네임 찾기
                    const member = this.members.find(member => member.userId === userId);
                    return member ? member.nickname : userId; // 닉네임이 없으면 userId 반환
                }
            },
            mounted() {
                stompClient.connect({}, () => {
                    stompClient.subscribe("/topic/groupChat/" + groupId, (message) => {
                        const receivedMessage = JSON.parse(message.body);

                        console.log("📩 수신된 메시지:", receivedMessage);
                        
                        // messages가 배열인지 확인 후 push 실행
                        if (!Array.isArray(this.messages)) {
                            this.messages = [];
                        }
                        this.messages.push(receivedMessage);
                        this.scrollToBottom(); // ✅ 메시지 추가될 때 스크롤 내리기
                    });

                    const userId = this.userId; 
                    // ✅ 입장 여부 확인 후 JOIN 메시지 전송
                    fetch(`/chatting/joinStatus?groupId=${groupId}&userId=` + userId)
                        .then(res => res.json())
                        .then(joined => {
                            console.log("✅ joinStatus API 응답:", joined);
                            if (!joined) {
                                this.sendJoinMessage();
                            }
                        })
                        .catch(error => console.error("❌ joinStatus API 호출 오류:", error));
                    

                    // ✅ 기존 채팅 기록 불러오기
                    fetch("/chatting/chatHistory?groupId=" + groupId)
                        .then(response => response.json())
                        .then(data => {
                            console.log("✅ 서버에서 받아온 채팅 기록:", data); // 응답 확인
                            if (Array.isArray(data)) {
                                this.messages = data;
                            } else {
                                this.messages = []; // 만약 데이터가 배열이 아니라면 빈 배열 할당
                            }
                            this.scrollToBottom(); // ✅ 메시지 추가될 때 스크롤 내리기

                        })
                        .catch(error => console.error("❌ 채팅 기록 로드 실패:", error));

                });

                this.fnGroup();
            }
        });

        app.mount("#chat-app");

    </script>
</body>
</html>
