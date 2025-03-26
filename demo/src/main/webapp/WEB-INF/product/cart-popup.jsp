<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="popup-overlay" id="popup-overlay"></div>
<div class="popup-container" id="popup-container">
    <p>장바구니에 상품이 담겼습니다!</p>
    <div class="button-container">
        <button id="goToCart">장바구니로 이동</button>
        <button id="continueShopping">쇼핑 계속하기</button>
    </div>    
</div>

<style>
    .popup-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 999;
    }
    .popup-container {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: white;
        padding: 45px;
        border: 1px solid #ccc;
        z-index: 1000;
        text-align: center;
        width: 600px;
        height: 200px;
    }
    .popup-container button {
        background-color: #4CAF50;
        margin: 10px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        width: 50%; /* 버튼 크기 조정 가능 */
        height: 25px;
        padding: 10px;
        padding-bottom: 30px;
        margin-top: 30px;
    }
    .popup-container button:hover{
        background-color: #45a049;
    }

    .button-container {
        display: flex;
        justify-content: center; /* 가로로 버튼을 정렬 */
        gap: 10px; /* 버튼 사이 간격 조정 */
        margin-top: 20px;
    }
</style>

<script>
    function openPopup() {
        document.getElementById('popup-overlay').style.display = 'block';
        document.getElementById('popup-container').style.display = 'block';
    }

    function closePopup() {
        document.getElementById('popup-overlay').style.display = 'none';
        document.getElementById('popup-container').style.display = 'none';
    }

    // 이벤트 핸들러 연결
    document.getElementById('goToCart').addEventListener('click', function() {
        alert('장바구니 페이지로 이동합니다.');
        closePopup();
    });
    document.getElementById('continueShopping').addEventListener('click', closePopup);
    document.getElementById('popup-overlay').addEventListener('click', closePopup);
</script>
