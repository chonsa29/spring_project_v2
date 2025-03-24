<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>회원가입</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.prod.js"></script>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Noto Sans KR', sans-serif;
                background: linear-gradient(135deg, #eee, #eee);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .signup-container {
                background: white;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
                width: 400px;
                text-align: center;
            }

            .signup-container h2 {
                margin-bottom: 20px;
                font-weight: 600;
                color: #333;
            }

            .input-box {
                text-align: left;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
            }

            .input-box input,
            .input-box select {
                flex: 1;
                padding: 10px;
                border: 2px solid #ccc;
                border-radius: 8px;
                outline: none;
                font-size: 16px;
            }

            .input-box button {
                margin-left: 10px;
                padding: 10px 15px;
                border: none;
                background: #007bff;
                color: white;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                white-space: nowrap;
            }

            .input-box button:hover {
                background: #0056b3;
            }

            .message {
                font-size: 12px;
                margin-top: 5px;
            }

            .message.error {
                color: red;
            }

            .message.success {
                color: blue;
            }

            .signup-container button {
                width: 100%;
                padding: 12px;
                background: #28a745;
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 18px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 20px;
            }

            .signup-container button:disabled {
                background: #ccc;
                cursor: not-allowed;
            }
        </style>
    </head>

    <body>
        <div id="app" class="signup-container">
            <h2>회원가입</h2>

            <div class="input-box">
                <input type="text" v-model="username" @input="checkUsername" placeholder="아이디" required>
            </div>
            <p class="message"
                :class="{'error': usernameMessage === '중복된 아이디 입니다.', 'success': usernameMessage === '사용 가능합니다.'}">{{
                usernameMessage }}</p>

            <div class="input-box">
                <input type="email" v-model="email" placeholder="이메일 주소" required>
            </div>

            <div class="input-box">
                <input type="password" v-model="password" @input="validatePassword" placeholder="비밀번호 (10~20자)"
                    required>
            </div>
            <p class="message error" v-if="passwordMessage">{{ passwordMessage }}</p>

            <div class="input-box">
                <input type="password" v-model="confirmPassword" @input="validatePassword" placeholder="비밀번호 확인"
                    required>
            </div>
            <p class="message error" v-if="confirmPasswordMessage">{{ confirmPasswordMessage }}</p>

            <div class="input-box">
                <input type="text" v-model="name" placeholder="이름" required>
            </div>

            <div class="input-box">
                <select v-model="gender" required>
                    <option value="" disabled>성별</option>
                    <option value="남성">남성</option>
                    <option value="여성">여성</option>
                </select>
            </div>

            <div class="input-box">
                <input type="text" v-model="address" placeholder="주소" required>
                <button @click="findAddress">주소 찾기</button>
            </div>

            <div class="input-box">
                <input type="text" v-model="detailedAddress" placeholder="상세주소" required>
            </div>

            <div class="input-box">
                <input type="date" v-model="birth" required>
            </div>

            <div class="input-box">
                <input type="text" v-model="phone" placeholder="휴대폰 번호" required>
                <button @click="sendVerificationCode">본인 인증</button>
            </div>

            <button :disabled="!canProceedStep2" @click="registerUser">가입하기</button>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        username: '',
                        email: '',
                        password: '',
                        confirmPassword: '',
                        name: '',
                        gender: '',
                        address: '',
                        detailedAddress: '',
                        birth: '',
                        phone: '',
                        usernameMessage: '',
                        passwordMessage: '',
                        confirmPasswordMessage: ''
                    };
                },
                methods: {
                    checkUsername() {
                        const usernameRegex = /^[a-zA-Z0-9]{6,}$/;
                        if (this.username.length < 6) {
                            this.usernameMessage = '아이디는 6자 이상이어야 합니다.';
                        } else if (!usernameRegex.test(this.username)) {
                            this.usernameMessage = '아이디는 영문과 숫자만 가능합니다.';
                        } else {
                            $.post('/check-username', { username: this.username }, (response) => {
                                this.usernameMessage = response.exists ? '중복된 아이디 입니다.' : '사용 가능합니다.';
                            });
                        }
                    },
                    validatePassword() {
                        const passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[\W_]).{10,20}$/;
                        this.passwordMessage = passwordRegex.test(this.password) ? '' : '비밀번호는 10~20자이며, 문자, 숫자, 특수문자를 포함해야 합니다.';
                        this.confirmPasswordMessage = this.password === this.confirmPassword ? '' : '비밀번호가 일치하지 않습니다.';
                    },
                    sendVerificationCode() {
                        // 본인 인증 코드 API 호출
                        alert('본인 인증 코드가 전송되었습니다!');
                    },
                    findAddress() {
                        const self = this; // Vue 인스턴스를 참조
                        new daum.Postcode({
                            oncomplete: function (data) {
                                self.address = data.roadAddress; // this를 self로 바인딩
                            }
                        }).open();
                    },
                registerUser() {
                        $.post('/signup', {
                            username: this.username,
                            email: this.email,
                            password: this.password,
                            name: this.name,
                            gender: this.gender,
                            address: this.address,
                            detailedAddress: this.detailedAddress,
                            birth: this.birth,
                            phone: this.phone
                        }, (response) => {
                            alert(response.message);
                        });
                    }
                },
                computed: {
                    canProceedStep2() {
                        return this.usernameMessage === '사용 가능합니다.' &&
                            this.passwordMessage === '' &&
                            this.confirmPasswordMessage === '' &&
                            this.password === this.confirmPassword &&
                            this.email &&
                            this.name &&
                            this.gender &&
                            this.address &&
                            this.detailedAddress &&
                            this.birth &&
                            this.phone;
                    }
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>