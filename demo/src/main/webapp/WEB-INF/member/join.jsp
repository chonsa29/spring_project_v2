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
                .message {
        color: red; /* ❌ 오류 메시지는 붉은색 */
        font-size: 12px;
    }
    .available {
        color: blue; /* ✅ 사용 가능 메시지는 파란색 */
        font-size: 12px;
    }
            
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
                width: 400px;
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
                margin-top: 10px;
            }
            .signup-container button:disabled {
                background: #ccc;
                cursor: not-allowed;
            }
            .signup-container button:hover {
                background: #218838;
            }
            .checkbox-group {
                text-align: left;
                margin-bottom: 10px;
            }
            .step-indicator {
                margin-bottom: 20px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div id="app" class="signup-container">
            <h2>회원가입</h2>
         
    
          
    
            <!-- STEP 2: 회원 정보 입력 -->
            <div >
                <input type="text" v-model="username" @input="checkUsername" placeholder="아이디" required>
                <div v-if="usernameMessage" :class="usernameAvailable ? 'available' : 'message'">{{ usernameMessage }}</div>
    
                <input type="email" v-model="email" placeholder="[선택] 이메일주소 (비밀번호 찾기 등 본인 확인용)" required>
    
                <input type="password" v-model="password" @input="validatePassword" placeholder="비밀번호 (10~20자)" required maxlength="20">
                <div v-if="passwordMessage" class="message">{{ passwordMessage }}</div>
    
                <input type="password" v-model="confirmPassword" @input="validatePassword" placeholder="비밀번호 확인" required maxlength="20">
                <div v-if="confirmPasswordMessage" class="message">{{ confirmPasswordMessage }}</div>
    
                <button @click="prevStep">이전</button>
                <button :disabled="!canProceedStep2" @click="nextStep">다음</button>
            </div>
    
    
        <script>
            new Vue({
                el: '#app',
                data() {
                    return {
                        step: 1,
                        agreeTerms: false,
                        agreePrivacy: false,
                        agreeMarketing: false,
                        username: '',
                        email: '',
                        password: '',
                        confirmPassword: '',
                        usernameMessage: '',
                        usernameAvailable: false,
                        passwordMessage: '',
                        confirmPasswordMessage: ''
                    };
                },
                computed: {
                    stepText() {
                        return this.step === 1 ? '1단계: 약관 동의' :
                               this.step === 2 ? '2단계: 회원 정보 입력' :
                               '3단계: 가입 완료';
                    },
                    canProceedStep1() {
                        return this.agreeTerms && this.agreePrivacy;
                    },
                    canProceedStep2() {
                        return this.usernameAvailable && this.password.length >= 10 && this.password.length <= 20 &&
                               this.passwordMessage === '' && this.confirmPasswordMessage === '' &&
                               this.password === this.confirmPassword && this.email;
                    }
                },
                methods: {
                    nextStep() {
                        if (this.step < 3) this.step++;
                    },
                    prevStep() {
                        if (this.step > 1) this.step--;
                    },
                    restart() {
                        this.step = 1;
                        this.username = '';
                        this.email = '';
                        this.password = '';
                        this.confirmPassword = '';
                        this.usernameMessage = '';
                        this.usernameAvailable = false;
                        this.passwordMessage = '';
                        this.confirmPasswordMessage = '';
                    },
                    checkUsername() {
                        const usernameRegex = /^[a-zA-Z0-9]{6,}$/;
                        if (this.username.length > 0) {
                            if (!usernameRegex.test(this.username)) {
                                this.usernameMessage = '아이디는 6자 이상, 영어와 숫자만 가능합니다';
                                this.usernameAvailable = false;
                            } else {
                                this.usernameMessage = '사용 가능한 아이디입니다';
                                this.usernameAvailable = true;
                            }
                        } else {
                            this.usernameMessage = '';
                            this.usernameAvailable = false;
                        }
                    },
                    validatePassword() {
                        const passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[\W_]).{10,20}$/;
    
                        if (this.password.length > 20) {
                            this.password = this.password.slice(0, 20);
                        }
                        if (this.confirmPassword.length > 20) {
                            this.confirmPassword = this.confirmPassword.slice(0, 20);
                        }
    
                        if (this.password.length > 0) {
                            if (!passwordRegex.test(this.password)) {
                                this.passwordMessage = '비밀번호는 10~20자이며, 영문, 숫자, 특수문자를 포함해야 합니다.';
                            } else {
                                this.passwordMessage = '';
                            }
                        } else {
                            this.passwordMessage = '';
                        }
    
                        if (this.confirmPassword.length > 0) {
                            if (this.password !== this.confirmPassword) {
                                this.confirmPasswordMessage = '비밀번호가 일치하지 않습니다.';
                            } else {
                                this.confirmPasswordMessage = '';
                            }
                        } else {
                            this.confirmPasswordMessage = '';
                        }
                    }
                }
            });
        </script>
    </body>
    </html>
    