<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
        <title>회원가입</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
                font-family: 'Noto Sans KR', sans-serif;
            }

            body {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background: #f6fcf7;
            }

            .signup-container {
                background: white;
                width: 450px;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
            }

            h2 {
                font-size: 20px;
                font-weight: bold;
                margin-bottom: 20px;
            }

            .input-box {
                position: relative;
                margin-bottom: 12px;
            }

            .input-box input,
            .input-box select {
                width: 100%;
                height: 42px;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                box-sizing: border-box;
            }

            .input-box input:focus,
            .input-box select:focus {
                border-color: #5cb85c;
                outline: none;
            }

            .input-box button {
                position: absolute;
                right: 0;
                top: 0;
                height: 42px;
                /* input과 동일한 높이 */
                border: none;
                background: #5cb85c;
                color: white;
                padding: 0 15px;
                font-size: 14px;
                border-radius: 0 6px 6px 0;
                /* 오른쪽만 둥글게 */
                cursor: pointer;
                box-sizing: border-box;
            }

            #register {
                width: 30%;
                display: flex;
                justify-self: center;
                justify-content: center;
                margin-top: 20px;
            }

            #register button {
                color: white;
                padding: 10px 25px;
                background: #5cb85c;
                border: none;
                border-radius: 6px;
            }

            #register button:hover {
                background: #4cae4c;
            }

            .input-box button:hover {
                background: #4cae4c;
            }

            .message {
                font-size: 12px;
                margin-top: 5px;
            }

            .message.success {
                color: blue;
            }

            .message.error {
                color: red;
            }

            .address-container {
                display: flex;
                gap: 5px;
            }

            .address-container input {
                flex: 1;
            }

            .address-container button {
                flex: none;
                padding: 10px 12px;
                white-space: nowrap;
            }

            .signup-button {
                width: 100%;
                background: #5cb85c;
                color: white;
                font-size: 16px;
                padding: 12px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                margin-top: 10px;
            }

            .signup-button:hover {
                background: #4cae4c;
            }
        </style>
    </head>

    <body>
        <div id="app" class="signup-container">
            <h2>회원가입</h2>

            <!-- 아이디 입력 -->
            <div class="input-box">
                <input type="text" v-model="user.userId" placeholder="아이디 (영문 또는 영문+숫자, 6자 이상)" maxlength="20"
                    @input="fnIdCheck">
                <p v-if="idError"
                    :class="{'message': true, 'error': idError !== '사용 가능한 아이디입니다.', 'success': idError === '사용 가능한 아이디입니다.'}">
                    {{ idError }}</p>
            </div>

            <!-- 이메일 인증 추가 -->
            <div class="input-box">
                <input type="email" v-model="user.email" placeholder="이메일 주소">
                <button @click="fnSendEmailCode">인증 코드 전송</button>
            </div>
            <div class="input-box" v-if="emailSent">
                <input type="text" v-model="emailCodeInput" placeholder="인증 코드 입력">
                <button @click="fnVerifyEmailCode">확인</button>
                <p class="message" :class="{'success': emailVerified, 'error': !emailVerified && emailCodeChecked}">
                    {{ emailMessage }}
                </p>
            </div>

            <!-- 비밀번호 -->
            <div class="input-box">
                <input type="password" v-model="user.pwd" placeholder="비밀번호" maxlength="30" @input="fnPwdCheck">
                <p v-if="pwdError" :class="{'message': true, 'error': true}">{{ pwdError }}</p>
            </div>
            <div class="input-box">
                <input type="password" v-model="user.confirmPwd" placeholder="비밀번호 확인" maxlength="30"
                    @input="fnPwdMatch">
                <p v-if="confirmPwdError" :class="{'message': true, 'error': true}">{{ confirmPwdError }}</p>
            </div>

            <!-- 이름, 성별 -->
            <div class="input-box">
                <input type="text" v-model="user.userName" placeholder="이름">
            </div>
            <div class="input-box">
                <select v-model="user.gender">
                    <option value="" disabled>성별</option>
                    <option value="M">남성</option>
                    <option value="F">여성</option>
                </select>
            </div>

            <!-- 주소 -->
            <div class="input-box">
                <div class="address-container">
                    <input type="text" v-model="user.address" placeholder="주소">
                    <button @click="fnSearchAddr">주소검색</button>
                </div>
            </div>
            <div class="input-box">
                <input type="text" v-model="user.detailedAddress" placeholder="상세주소">
            </div>

            <!-- 생년월일 -->
            <div class="input-box">생년월일
                <input type="date" v-model="user.birth">
            </div>

            <!-- 휴대폰 번호 -->
            <div class="input-box">
                <input type="text" v-model="user.phoneNum" @keyup.enter="fnSendSms" placeholder="휴대폰 번호">
                <button @click="fnSendSms">본인 인증</button>
            </div>

            <!-- ✅ SMS 인증 입력창 -->
            <div class="input-box" v-if="smsSent">
                <input type="text" @keyup.enter="fnVerifySms" v-model="smsCodeInput" placeholder="인증 코드 입력">
                <button @click="fnVerifySms">확인</button>
                <p class="message" :class="{'success': smsVerified, 'error': !smsVerified && smsCodeChecked}">
                    {{ smsMessage }}
                </p>
            </div>


            <!-- 가입 버튼 -->
            <div id="register">
                <button @click="fnJoin">가입하기</button>
            </div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        user: {
                            userId: "",
                            email: "",
                            pwd: "",
                            confirmPwd: "",
                            userName: "",
                            gender: "",
                            address: "",
                            emailVer: "N",
                            detailedAddress: "",
                            status: "C",
                            birth: "",
                            phoneNum: "",
                            nickName: ""
                        },
                        idError: "",
                        pwdError: "",
                        confirmPwdError: "",
                        addressError: "",
                        selectedAddress: "",

                        // 이메일 인증 관련 추가
                        emailSent: false,
                        emailCodeInput: "",
                        emailCodeChecked: false,
                        emailVerified: false,
                        emailMessage: "",


                        // ✅ SMS 인증 관련
                        smsSent: false,
                        smsCodeInput: "",
                        smsCodeChecked: false,
                        smsVerified: false,
                        smsMessage: ""
                    };
                },
                methods: {
                    fnIdCheck() {
                        const userId = this.user.userId;
                        const idPattern = /^[a-zA-Z][a-zA-Z0-9]{5,19}$/;

                        if (!userId) {
                            this.idError = "";
                            return;
                        }

                        if (!idPattern.test(userId)) {
                            this.idError = "사용 불가능 합니다.";
                            return;
                        }

                        $.ajax({
                            url: "/member/check.dox",
                            type: "POST",
                            data: { userId },
                            success: (data) => {
                                this.idError = data.result === "check" ? "중복된 아이디입니다." : "사용 가능한 아이디입니다.";
                            }
                        });
                    },
                    fnPwdCheck() {
                        const pwd = this.user.pwd;
                        const pwdPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+={}\[\]:;"'<>,.?/\\|`~])[a-zA-Z0-9!@#$%^&*()_+={}\[\]:;"'<>,.?/\\|`~]{10,}$/;
                        if (!pwd) {
                            this.pwdError = "";
                            return;
                        }
                        if (!pwdPattern.test(pwd)) {
                            this.pwdError = "비밀번호는 영문, 숫자, 특수문자를 포함한 10자 이상이어야 합니다.";
                            return;
                        }
                        this.pwdError = "";
                    },
                    fnPwdMatch() {
                        const confirmPwd = this.user.confirmPwd;
                        if (confirmPwd !== this.user.pwd) {
                            this.confirmPwdError = "비밀번호가 일치하지 않습니다.";
                        } else {
                            this.confirmPwdError = "";
                        }
                    },
                    fnSearchAddr() {
                        const _this = this;
                        new daum.Postcode({
                            oncomplete: function (data) {
                                _this.user.address = data.address;
                                _this.addressError = "";
                            }
                        }).open();
                    },
                    fnSmsAuth() {
                        alert("본인 인증 코드가 전송되었습니다!");
                    },

                    // 이메일 인증 추가
                    fnSendEmailCode() {
                        if (!this.user.email) {
                            alert("이메일을 입력해주세요.");
                            return;
                        }

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
                    fnVerifyEmailCode() {
                        $.ajax({
                            url: "/email/verify-code",
                            type: "POST",
                            data: {
                                email: this.user.email,
                                code: this.emailCodeInput
                            },
                            success: (res) => {
                                if (res.verified) {
                                    this.emailVerified = true;
                                    this.user.emailVer = "Y";
                                    this.emailMessage = "이메일 인증 완료!";
                                } else {
                                    this.emailVerified = false;
                                    this.emailMessage = "인증 코드가 일치하지 않습니다.";
                                }
                                this.emailCodeChecked = true;
                            }
                        });
                    },
                    fnSendSms() {
                        if (!this.user.phoneNum) {
                            alert("휴대폰 번호를 입력해주세요.");
                            return;
                        }

                        $.post("/sms/send", { phoneNum: this.user.phoneNum }, () => {
                            this.smsSent = true;
                            alert("인증번호가 전송되었습니다.");
                        }).fail(() => {
                            alert("문자 전송에 실패했습니다.");
                        });
                    },
                    fnVerifySms() {
                        $.post("/sms/verify", {
                            phoneNum: this.user.phoneNum,
                            code: this.smsCodeInput
                        }, (res) => {
                            this.smsVerified = res.verified;
                            this.smsCodeChecked = true;
                            this.smsMessage = res.verified ? "인증 성공!" : "인증 실패 😢";

                            if (res.verified) {
                                this.user.smsVer = "Y"; // 필요하면 백엔드로도 인증 정보 전달 가능
                            }
                        });
                    },



                    fnJoin() {
                        if (!this.user.userId || !this.user.email || !this.user.pwd || !this.user.confirmPwd ||
                            !this.user.userName || !this.user.gender || !this.user.address || !this.user.phoneNum ||
                            !this.user.birth) {
                            alert("모든 필수 항목을 입력해주세요.");
                            return;
                        }

                        if (this.idError && this.idError !== "사용 가능한 아이디입니다.") {
                            alert("아이디를 올바르게 입력해주세요.");
                            return;
                        }

                        if (this.pwdError || this.confirmPwdError) {
                            alert("비밀번호를 확인해주세요.");
                            return;
                        }

                        if (this.user.emailVer !== "Y") {
                            alert("이메일 인증을 완료해주세요.");
                            return;
                        }

                        if (!this.smsVerified) {
                            alert("휴대폰 인증을 완료해주세요.");
                            return;
                        }


                        var nparmap = { ...this.user };

                        $.ajax({
                            url: "/member/join.dox",
                            type: "POST",
                            dataType: "json",
                            data: nparmap,
                            success: (data) => {
                                if (data.result === "success") {
                                    alert("회원가입이 완료되었습니다.");
                                    location.href="/member/login.do"
                                } else {
                                    alert("회원가입에 실패하였습니다.");
                                }
                            }
                        });
                    }
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>