<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <!-- 카카오 주소검색 API -->
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <a href="javascript:kakaoLogin();"><img src=../img/kakao.png></a>
    <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

    <script>
        window.Kakao.init("1e578d25bde3efa2ad35b138518feb97");

        function kakaoLogin(){
            window.Kakao.Auth.login({
                scope:'profile',
                success: function(authObj){
                    console.log(authObj);
                    window.Kakao.API.request({
                        url:'/v2/user/me',
                        success: res =>{
                            const kakao_account = res.kakao_account;
                            console.log(kakao_account);
                        }
                    });
                }
            });
        }
    </script>    
</body>
</html>