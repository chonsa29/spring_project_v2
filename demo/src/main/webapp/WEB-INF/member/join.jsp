<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .signup-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 350px;
            text-align: center;
        }
        .signup-container h2 {
            margin-bottom: 20px;
        }
        .signup-container input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .signup-container button {
            width: 100%;
            padding: 10px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .signup-container button:hover {
            background: #218838;
        }
        .message {
            color: red;
            font-size: 12px;
        }
        .available {
            color: green;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div id="app" class="signup-container">
        <h2>회원가입</h2>
        <input type="text" v-model="username" @input="checkUsername" placeholder="아이디" required>
        <div v-if="usernameMessage" :class="usernameAvailable ? 'available' : 'message'">{{ usernameMessage }}</div>

        <input type="email" v-model="email" placeholder="이메일" required>
        <input type="password" v-model="password" placeholder="비밀번호" required>
        <input type="password" v-model="confirmPassword" placeholder="비밀번호 확인" required>
        
        <button :disabled="isButtonDisabled">회원가입</button>
    </div>

    <script>
        new Vue({
            el: '#app',
            data() {
                return {
                    username: '',
                    email: '',
                    password: '',
                    confirmPassword: '',
                    usernameMessage: '',
                    usernameAvailable: false
                };
            },
            methods: {
                checkUsername() {
                    const existingUsernames = ['user1', 'user2', 'user3']; // 예시: 이미 존재하는 아이디들
                    if (this.username.length > 0) {
                        if (existingUsernames.includes(this.username)) {
                            this.usernameMessage = '중복입니다';
                            this.usernameAvailable = false;
                        } else {
                            this.usernameMessage = '사용 가능한 아이디입니다';
                            this.usernameAvailable = true;
                        }
                    } else {
                        this.usernameMessage = '';
                        this.usernameAvailable = false;
                    }
                }
            },
            computed: {
                isButtonDisabled() {
                    return !(this.usernameAvailable && this.password && this.password === this.confirmPassword && this.email);
                }
            }
        });
    </script>
</body>
</html>
