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
            <h2>그룹 채팅방</h2>
            <button @click="leaveChatRoom">채팅방 나가기</button>
            <div class="chat-box">
                <!-- ✅ 기존 채팅 기록 출력 -->
                <div v-for="msg in messages" class="chat-message" 
                     :class="{'join-message': msg.messageType === 'JOIN', 'leave-message': msg.messageType === 'LEAVE'}">
                     <strong v-if="msg.messageType === 'CHAT'">{{ msg.sender ?? '알 수 없음' }}</strong>
                    <span>{{ msg.content }}</span>
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

        const app = Vue.createApp({
            data() {
                return {
                    messages: [],  // 채팅 메시지 배열
                    newMessage: "", // 입력할 메시지
                    userId: userId // 현재 사용자 ID
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
                    // ✅ 퇴장 메시지 전송
                    stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                        sender: this.userId,
                        content: this.userId + "님이 퇴장하셨습니다.",
                        groupId: groupId,
                        type: "LEAVE"
                    }));

                    // ✅ 페이지 이동 (메인 화면으로 이동)
                    window.location.href = "/main";  // 원하는 경로로 수정
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
                    });

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
                        })
                        .catch(error => console.error("❌ 채팅 기록 로드 실패:", error));

                    // ✅ 입장 메시지 전송
                    stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                        sender: this.userId,
                        content: this.userId + "님이 입장하셨습니다.",
                        groupId: groupId,
                        messageType: "JOIN"
                    }));
                });
            }
        });

        app.mount("#chat-app");

    </script>
</body>
</html>
