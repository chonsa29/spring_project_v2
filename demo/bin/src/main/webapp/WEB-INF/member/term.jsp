<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>이용약관 및 개인정보 수집 동의</title>
  <script type="module">
    import { createApp, ref, computed } from 'https://unpkg.com/vue@3/dist/vue.esm-browser.js';

    const App = {
      setup() {
        const isTermsAgreed = ref(false);
        const isPrivacyAgreed = ref(false);
        const isOptionalAgreed = ref(false);

        const isAgreed = computed(() => isTermsAgreed.value && isPrivacyAgreed.value);

        const goNext = () => {
          alert("이용약관 동의 완료! 회원가입을 진행합니다.");
          window.location.href = "/member/join.do";
        };

        return {
          isTermsAgreed,
          isPrivacyAgreed,
          isOptionalAgreed,
          isAgreed,
          goNext
        };
      },
      template: `
        <div class="terms-container">
          <h2>이용약관 및 개인정보 수집 동의</h2>

          <!-- (필수) 밀픽 이용약관 -->
          <h3>[밀픽 이용약관]</h3>
          <div class="terms-content">
            <strong>제1조 (서비스 목적)</strong><br>
            밀픽은 신선한 재료로 만든 밀키트를 판매하는 신선식품 밀키트 업체입니다.<br><br>
            <strong>제2조 (서비스 내용)</strong><br>
            - 신선한 재료 제공<br>
            - 간편한 조리법 지원<br>
            - 빠르고 편리한 서비스 제공<br><br>
            <strong>제3조 (이용 방법)</strong><br>
            고객은 밀픽 웹 페이지에서 제품 및 서비스를 확인하고 주문할 수 있습니다.<br><br>
            <strong>제4조 (기타)</strong><br>
            밀픽은 고객의 편의를 위해 지속적으로 서비스를 개선하고 있습니다.<br>
          </div>

          <div class="checkbox-container">
            <input type="checkbox" id="termsAgree" v-model="isTermsAgreed">
            <label for="termsAgree">(필수) 밀픽 이용약관에 동의합니다.</label>
          </div>

          <!-- 개인정보 수집 -->
          <h3>[개인정보 수집 및 이용]</h3>
          <div class="terms-content">
            <strong>1. 수집하는 개인정보 항목</strong><br>
            - 필수항목: 이름, 이메일 주소, 전화번호, 배송 주소<br>
            - 선택항목: 생년월일, 성별, 결제 정보, 서비스 이용 기록<br><br>
            <strong>2. 개인정보 수집 및 이용 목적</strong><br>
            - 서비스 제공: 신선식품 밀키트 주문 및 배송, 고객 상담<br>
            - 마케팅 및 광고 활용: 이벤트 및 프로모션 정보 제공<br>
            - 서비스 개선: 고객의 사용 패턴 분석, 맞춤형 서비스 제공<br><br>
            <strong>3. 개인정보 보유 및 이용 기간</strong><br>
            - 회원 탈퇴 시까지 보유 및 이용<br>
            - 법령에 따른 보관 의무 (전자상거래법, 상법 등)<br><br>
            <strong>4. 개인정보 보호 담당자</strong><br>
            - 담당자: 김강필<br>
            - 연락처: 010-9595-5959, strongkang4959@naver.com<br>
          </div>

          <div class="checkbox-container">
            <input type="checkbox" id="privacyAgree" v-model="isPrivacyAgreed">
            <label for="privacyAgree">(필수) 개인정보 수집 및 이용에 동의합니다.</label>
          </div>

          <!-- 선택 동의 -->
          <h3>[이벤트·혜택 정보 수신]</h3>
          <div class="terms-content">
            <strong>1. 이용 목적</strong><br>
            - 신규 서비스 안내 및 이벤트 정보 제공<br>
            - 할인 및 프로모션 정보 제공<br><br>
            <strong>2. 수집하는 항목</strong><br>
            - 이메일, 전화번호<br><br>
            <strong>3. 보유 및 이용 기간</strong><br>
            - 회원 탈퇴 시 또는 동의 철회 시까지<br>
          </div>

          <div class="checkbox-container">
            <input type="checkbox" id="optionalAgree" v-model="isOptionalAgreed">
            <label for="optionalAgree">(선택) 이벤트 및 혜택 정보 수신에 동의합니다.</label>
          </div>

          <button class="terms-button" :disabled="!isAgreed" @click="goNext">다음</button>
        </div>
      `
    };

    createApp(App).mount('#app');
  </script>

  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }
    .terms-container {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      width: 800px;
      text-align: left;
      overflow-y: auto;
      max-height: 90vh;
    }
    .terms-container h2 {
      text-align: center;
      margin-bottom: 20px;
    }
    .terms-content {
      border: 1px solid #ccc;
      padding: 10px;
      height: 150px;
      overflow-y: auto;
      background-color: #fdfdfd;
      font-size: 14px;
      line-height: 1.5;
    }
    .checkbox-container {
      margin-top: 10px;
      display: flex;
      align-items: center;
    }
    .checkbox-container input {
      margin-right: 10px;
    }
    .terms-button {
      width: 100%;
      padding: 10px;
      margin-top: 20px;
      background: #28a745;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
    }
    .terms-button:disabled {
      background: #ccc;
      cursor: not-allowed;
    }
  </style>
</head>
<body>
  <div id="app"></div>
</body>
</html>
