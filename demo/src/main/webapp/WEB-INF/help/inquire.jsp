<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<link rel="stylesheet" href="/css/inquire-style.css">
	<title>문의 페이지</title>
</head>
<body>
	<jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
		<!-- 탭 메뉴 -->
		<nav class="tab-menu">
			<div class="tab-item" :class="{ active: activeTab === 'faq' }" @click="showSection('faq')">자주 묻는 질문</div>
			<div class="tab-separator">|</div>
			<div class="tab-item" :class="{ active: activeTab === 'qna' }" @click="showSection('qna')">Q & A</div>
			<div class="tab-separator">|</div>
			<div class="tab-item" :class="{ active: activeTab === 'notice' }" @click="showSection('notice')">공지사항</div>
		</nav>

		<!-- 자주 묻는 질문 -->
		<section id="faq" class="tab-content" v-show="activeTab === 'faq'">
			<h2>자주 묻는 질문</h2>
			<div class="faq-list">
				<div v-for="faq in faqList" :key="faq.id" class="faq-item" @click="toggleFaq(faq)">
					<div class="faq-question">Q. {{ faq.question }}</div>
					<div class="faq-answer" v-show="faq.open">A. {{ faq.answer }}</div>
				</div>
			</div>
		</section>

		<!-- Q&A -->
		<section id="qna" class="tab-content" v-show="activeTab === 'qna'">
			<h2>문의게시판</h2>
			<div class="search-bar">
				<select v-model="selectedCategory">
					<option value="">제목</option>
					<option value="상품">상품</option>
					<option value="배송">배송</option>
				</select>
				<input type="text" v-model="searchKeyword" placeholder="검색어를 입력하세요">
				<button @click="searchQuestions">검색</button>
			</div>
			<table class="inquiry-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>내용</th>
						<th>날짜</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="inquiry in inquiryList" :key="inquiry.id">
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</section>

		<!-- 공지사항 -->
		<section id="notice" class="tab-content" v-show="activeTab === 'notice'">
			<h2>공지사항</h2>
			<p>현재 등록된 공지사항이 없습니다.</p>
		</section>
	</div>
	<jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>

<script>
const app = Vue.createApp({
    data() {
        return {
            activeTab: 'faq', // 기본으로 '자주 묻는 질문' 탭 활성화
            faqList: [],
            selectedCategory: '',
            searchKeyword: '',
            inquiryList: [],
        };
    },
    methods: {
        // 탭 변경
        showSection(tab) {
            this.activeTab = tab;
        },

        // FAQ 데이터 불러오기
        loadFaqList() {
            $.ajax({
                url: "/faqList",
                type: "GET",
                dataType: "json",
                success: (response) => {
                    this.faqList = response.map(faq => ({ ...faq, open: false }));
                },
                error: () => {
                    console.error("FAQ 데이터를 불러오는 데 실패했습니다.");
                },
            });
        },

        // FAQ 질문 클릭 시 답변 토글
        toggleFaq(faq) {
            faq.open = !faq.open;
        },

        // 문의 검색 기능 (추후 API 연동 필요)
        searchQuestions() {
            console.log("검색: ", this.searchKeyword);
            // API 연동 필요
        }
    },
    mounted() {
        this.loadFaqList();
    }
});
app.mount('#app');
</script>
