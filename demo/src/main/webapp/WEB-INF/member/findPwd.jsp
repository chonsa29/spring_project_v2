<template>
    <div class="find-container">
      <h2>비밀번호 찾기</h2>
      <input type="text" v-model="userId" placeholder="아이디 입력" />
      <input type="email" v-model="email" placeholder="이메일 입력" />
      <button @click="findPassword">임시 비밀번호 발송</button>
      <p class="message" :class="{ success: success, error: !success }" v-if="message">
        {{ message }}
      </p>
    </div>
  </template>

  <script>
  // jQuery 사용 전제: index.html이나 main.js에서 CDN으로 불러왔거나 npm으로 설치한 상태여야 함
  export default {
    name: 'FindPassword',
    data() {
      return {
        userId: '',
        email: '',
        message: '',
        success: false,
      };
    },
    methods: {
      findPassword() {
        if (!this.userId || !this.email) {
          this.message = '아이디와 이메일을 모두 입력해주세요.';
          this.success = false;
          return;
        }
  
        $.ajax({
          url: '/member/find-password',
          method: 'POST',
          data: {
            userId: this.userId,
            email: this.email
          },
          success: (res) => {
            this.message = res.message;
            this.success = res.success;
          },
          error: () => {
            this.message = '오류가 발생했습니다.';
            this.success = false;
          }
        });
      }
    }
  };
  </script>

  <style scoped>
  .find-container {
    font-family: 'Noto Sans KR', sans-serif;
    background: white;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    width: 400px;
    margin: 100px auto;
  }
  
  h2 {
    margin-bottom: 20px;
    text-align: center;
  }
  
  input {
    width: 100%;
    padding: 10px;
    margin-bottom: 12px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 6px;
  }
  
  button {
    width: 100%;
    padding: 12px;
    font-size: 16px;
    background: #5cb85c;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
  }
  
  button:hover {
    background: #4cae4c;
  }
  
  .message {
    margin-top: 10px;
    font-size: 13px;
  }
  
  .success {
    color: green;
  }
  
  .error {
    color: red;
  }
  </style>
