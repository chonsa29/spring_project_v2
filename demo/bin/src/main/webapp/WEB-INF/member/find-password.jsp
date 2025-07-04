<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>비밀번호 찾기</title>

        <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    </head>
    <style>
        * {
            box-sizing: border-box; /* padding, border 포함한 width 계산 */
        }
    
        body {
            font-family: 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif;
            background-color: #f0fdf4;
            margin: 0;
            padding: 0;
        }
    
        .password-reset-container {
            max-width: 420px;
            margin: 60px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid #d9f2e6;
        }
    
        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #2e7d32;
        }
    
        .form-group {
            margin-bottom: 20px;
        }
    
        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            color: #388e3c;
        }
    
        input[type="email"],
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #b2dfdb;
            border-radius: 8px;
            font-size: 14px;
            background-color: #f9fdfb;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box;
        }
    
        input:focus {
            border-color: #66bb6a;
            outline: none;
            box-shadow: 0 0 0 3px rgba(102, 187, 106, 0.2);
        }
    
        .btn {
            width: 100%;
            padding: 10px;
            font-size: 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s;
            box-sizing: border-box;
        }
    
        .btn-primary {
            background-color: #81c784;
            color: #fff;
        }
    
        .btn-primary:hover {
            background-color: #66bb6a;
        }
    
        .btn-success {
            background-color: #4caf50;
            color: white;
        }
    
        .btn-success:hover {
            background-color: #388e3c;
        }
    
        .password-change-section {
            margin-top: 30px;
            border-top: 1px solid #d0e9d3;
            padding-top: 20px;
        }
    </style>
    <body>
        <div id="app" class="password-reset-container">
            <h2>비밀번호 변경</h2>

            <!-- 이메일 입력 필드 -->
            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" v-model="user.email" class="form-control" placeholder="이메일을 입력해주세요"
                    required>
            </div>

            <div class="form-group">
                <button @click="fnSendEmailCode" class="btn btn-primary">인증코드 전송</button>
            </div>

            <!-- 인증코드 입력 필드 -->
            <div class="form-group" v-if="emailSent">
                <label for="code">인증코드</label>
                <input type="text" id="code" v-model="user.inputCode" class="form-control" placeholder="인증코드를 입력해주세요"
                    required>
            </div>

            <div class="form-group" v-if="emailSent">
                <button @click="fnVerifyCode" class="btn btn-primary">인증코드 확인</button>
            </div>

            <!-- 새 비밀번호 입력 필드 -->
            <div v-if="emailVerified" class="password-change-section">
                <div class="form-group">
                    <label for="newPwd">새 비밀번호</label>
                    <input type="password" id="newPwd" v-model="user.newPwd" class="form-control"
                        placeholder="새 비밀번호를 입력해주세요" required>
                </div>
                <div class="form-group">
                    <label for="confirmPwd">비밀번호 확인</label>
                    <input type="password" id="confirmPwd" v-model="user.confirmPwd" class="form-control"
                        placeholder="비밀번호를 다시 입력해주세요" required>
                </div>
                <div class="form-group">
                    <button @click="fnChangePassword" class="btn btn-success">비밀번호 변경</button>
                </div>
            </div>
        </div>

        <script>
            new Vue({
                el: '#app',
                data: {
                    user: {
                        email: '',
                        inputCode: '',
                        newPwd: '',
                        confirmPwd: ''
                    },
                    emailSent: false,
                    emailVerified: false
                },
                methods: {
                    fnSendEmailCode() {
                        $.ajax({
                            url: "/email/send-code",
                            type: "POST",
                            data: { email: this.user.email },
                            success: () => {
                                this.emailSent = true;
                                alert("인증 코드가 이메일로 전송되었습니다.");
                            },
                            error: () => {
                                alert("이메일 전송에 실패했습니다.");
                            }
                        });
                    },
                    fnVerifyCode() {
                        $.ajax({
                            url: "/email/verify-code-for-reset",
                            type: "POST",
                            data: {
                                email: this.user.email,
                                code: this.user.inputCode
                            },
                            success: (res) => {
                                if (!res.registered) {
                                    alert("회원이 아닙니다.");
                                    this.emailVerified = false;
                                    return;
                                }
        
                                if (res.verified) {
                                    this.emailVerified = true;
                                    alert("이메일 인증에 성공했습니다.");
                                } else {
                                    this.emailVerified = false;
                                    alert("인증 코드가 일치하지 않습니다.");
                                }
                            },
                            error: (err) => {
                                console.error('인증 코드 확인 중 오류:', err);
                                alert('인증 코드 확인 중 오류가 발생했습니다.');
                            }
                        });
                    },
                    fnChangePassword() {
                        if (!this.emailVerified) {
                            alert('이메일 인증을 먼저 진행해주세요.');
                            return;
                        }
        
                        if (this.user.newPwd !== this.user.confirmPwd) {
                            alert('비밀번호가 일치하지 않습니다.');
                            return;
                        }
        
                        // 비밀번호 유효성 검사
                        const pwd = this.user.newPwd;
                        const pwdRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{10,}$/;
        
                        if (!pwdRegex.test(pwd)) {
                            alert('비밀번호는 영문, 숫자, 특수문자를 포함한 10자 이상이어야 합니다.');
                            return;
                        }
        
                        // 서버로 변경 요청
                        axios.post('/member/change-password.dox', {
                            email: this.user.email,
                            password: this.user.newPwd  // password 필드로 변경
                        }).then(response => {
                            if (response.data.result === 'success') {
                                alert('비밀번호가 성공적으로 변경되었습니다.');
                                window.location.href = '/login';
                            } else {
                                alert('비밀번호 변경 실패: ' + response.data.message);
                            }
                        }).catch(error => {
                            console.error('서버 오류:', error.response ? error.response.data : error.message);
                            alert('서버 오류로 인해 비밀번호 변경을 처리할 수 없습니다.');
                        });
                    }
                }
            });
        </script>
        
    </body>

    </html>