<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" 
		integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" 
		crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>Gemini 챗봇</title>
</head>
<style>
	.container {
		width: 50%;
		margin: 20px auto;
		text-align: center;
	}
	textarea {
		width: 100%;
		height: 100px;
		margin-bottom: 10px;
	}
	button {
		padding: 10px 20px;
		background-color: #007bff;
		color: white;
		border: none;
		cursor: pointer;
	}
	.result {
		margin-top: 20px;
		padding: 10px;
		border: 1px solid #ccc;
	}
</style>
<body>
	<div id="app" class="container">
		<h2>챗봇</h2>
		<textarea v-model="userInput" placeholder="메시지를 입력하세요..."></textarea>
		<br>
		<button @click="sendMessage">전송</button>
		<div class="result" v-if="message">
			<h3>응답:</h3>
			<p>{{ message }}</p>
		</div>
	</div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                userInput: "", // 사용자 입력
                message: ""    // 응답 메시지
            };
        },
        methods: {
            sendMessage() {
                var self = this;
				let nparmap = {
					input: self.userInput
				}
                $.ajax({
                    url: "/gemini/chat",
                    type: "GET",
                    data: nparmap, // 입력값 전달
                    success: function(response) {
                        self.message = response;
                    },
                    error: function(xhr) {
                        self.message = "오류 발생: " + xhr.responseText;
                    }
                });
            }
        }
    });
    app.mount('#app');
</script>