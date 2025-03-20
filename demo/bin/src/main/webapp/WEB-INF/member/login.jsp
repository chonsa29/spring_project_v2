<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 페이지</title>
    <style>
        /* 배경 설정 */ 
        body {
            background: url("../img/main1.jpg") no-repeat center center/cover;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
        }

        /* 로그인 박스 */
        .login-container {
            width: 600px;
            background: rgba(255, 255, 255, 0.2);
            padding: 50px;
            border:1.5px solid white;
            border-radius: 20px;
            backdrop-filter: blur(10px);
            text-align:center;
        }

        /* 입력 필드 */
        .login-input {
            width: 70%;
            padding: 12px;
            margin: 10px 0;
            border: 1.5px solid white;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.346);
            font-size: 16px; 
            outline: none;
        }
        .login-input::placeholder{
            color:white;
        }

        /* 체크박스 */
        .checkbox-container {
            text-align:left;
            width:70%;
            margin-left:15%;
            margin-top:10px;
            margin-bottom:30px;
            font-size: 14px;
            color: white;
        }
        
        [type="checkbox"]{
           accent-color:white;
        }

        /* 버튼 */
        .login-btn {
            width: 50%;
            padding: 12px;
            margin-top: 70px;
            background-color: #71cf87;
            border:1.5px solid white;
            border-radius: 25px;
            color: white;
            font-size: 18px;
            cursor: pointer;
        }

        .login-btn:hover {
            background-color: #218838;
        }

        /* 하단 링크 */
        .bottom-links {
            margin-top: 10px;
            font-size: 14px;
            color: white;
        }

        .bottom-links a {
            color: white;
            text-decoration: none;
            margin: 0 5px;
        }

        .bottom-links a:hover {
            text-decoration: underline;
        }

        /* 어두운 오버레이 */
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
            /* 투명한 검은색 */
            z-index: 1;
        }

        /* 로그인 박스가 오버레이 위에 표시되도록 */
        .login-container {
            position: relative;
            z-index: 2;
        }
        .logo{
            margin-bottom:50px;
            margin-top:30px;
            color:#aaa;
        }
        .arrow{
            color:white;
            font-size:30px;
            display:flex;
        }
        .arrow a{
            text-decoration:none;
            color:white;
        }
    </style>
</head>

<body>
    <div class="overlay"></div> <!-- 어두운 배경 -->
    <div class="login-container">
        <div class="arrow">
            <a href="#"><</a>
        </div>
        <h2 style="color: white;">Login</h2>
        <input type="text" placeholder="아이디 입력" class="login-input">
        <input type="password" placeholder="비밀번호 입력" class="login-input">
        <div class="checkbox-container">
            <label><input type="checkbox"> 아이디 저장</label>
        </div>
        <div class="bottom-links">
            <a href="#">회원가입 </a> 
            <a href="#">다른 계정 로그인 </a> 
            <a href="#">비밀번호 찾기</a>
        </div>
        <button class="login-btn">로그인</button>
        <div class="logo">
            @MEALPICK
        </div>
    </div>
</body>

</html>