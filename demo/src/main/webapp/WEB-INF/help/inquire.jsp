<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<link rel="stylesheet" href="/css/inquire-style.css">
	<title>첫번째 페이지</title>
</head>
<style>
</style>
<body>
	<jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
		<section class="inquiry-container">
			<div class="search-box">
				<select id="category">
					<option value="all">전체</option>
					<option value="product">제품</option>
					<option value="order">주문</option>
				</select>
				<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요">
				<button onclick="searchInquiry()">검색</button>
			</div>
			
			<table class="inquiry-table">
				<thead>
					<tr>
						<th>이름</th>
						<th>제목</th>
						<th>내용</th>
						<th>날짜</th>
					</tr>
				</thead>
				<tbody id="inquiryList">
					<!-- AJAX로 데이터 로드 -->
				</tbody>
			</table>
		</section>
		<jsp:include page="/WEB-INF/common/footer.jsp" />
	</div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {

            };
        },
        methods: {
            fnLogin(){
				var self = this;
				var nparmap = {
				};
				$.ajax({
					url:"/inquire.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
					}
				});
            }
        },
        mounted() {
            var self = this;
        }
    });
    app.mount('#app');
</script>
​