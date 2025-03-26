<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<link rel="stylesheet" href="/css/inquire-css/inquire-style.css">
	<script src="/js/pageChange.js"></script>
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
		<section id="faq" class="tab-content" v-if="activeTab === 'faq'">
			<h2>자주 묻는 질문</h2>
			<div class="faq-list">
				<div v-for="faq in faqList" :key="faq.id" class="faq-item" @click="toggleFaq(faq)">
					<div class="faq-question">{{ faq.question }}</div>
					<div v-if="faq.open" class="faq-answer">{{ faq.answer }}</div>
				</div>
			</div>
		</section>

		<!-- Q&A -->
		<section id="qna" class="tab-content" v-show="activeTab === 'qna'">
			<h2>문의게시판</h2>
			<div class="search-bar">
				<select v-model="searchOption">
					<option value="all">:: 전체 ::</option>
					<option value="title">제목</option>
					<option value="contents">내용</option>
				</select>
				<input type="text" v-model="searchKeyword" placeholder="검색어를 입력하세요">
				<button @click="inquireList">검색</button>
			</div>
			<table class="inquiry-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>내용</th>
						<th>날짜</th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="inquiry in inquiryList" :key="inquiry.userId">
						<td @click="fnView(inquiry.qsNo)">{{ inquiry.qsNo }}</td>
						<td @click="fnView(inquiry.qsNo)">{{ inquiry.qsTitle }}</td>
						<td @click="fnView(inquiry.qsNo)"><span v-html="inquiry.qsContents"></span></td>
						<td>{{ inquiry.cdatetime }}</td>
						<td class="gray-text">{{ inquiry.viewCnt }}</td>
						<td>
							<button :class="getStatusClass(inquiry.qsStatus)">
								{{ getStatusText(inquiry.qsStatus) }}
							</button>
						</td>
					</tr>
				</tbody>
			</table>
				 <!-- 페이징 -->
				 <div class="pagination">
					<a v-if="page !=1" id="index" href="javascript:;"
					@click="fnPageMove('prev')"> < </a>
					<a href="javascript:;" v-for="num in index" @click="fnPage(num)" :class="{active: page === num}">
						{{num}}
					</a>
					<a v-if="page!=index" id="index" href="javascript:;"
						@click="fnPageMove('next')"> >
					</a>
				</div>
				<div class="writing">
				    <button @click="fnWriting">글쓰기</button>
				</div>
		</section>

		<!-- 공지사항 -->
		<section id="notice" class="tab-content" v-show="activeTab === 'notice'">
			<h2>공지사항</h2>
			<div class="search-bar">
				<select v-model="selectedCategory">
					<option value="">제목</option>
					<option value="">상품</option>
					<option value="">배송</option>
				</select>
				<input type="text" v-model="searchKeyword" placeholder="검색어를 입력하세요">
				<button @click="searchNotice">검색</button>
			</div>
			<table class="notice-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>내용</th>
						<th>날짜</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="notice in noticeList" :key="notice.id">
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</section>
	</div>
	<jsp:include page="/WEB-INF/common/footer.jsp" />
</html>
<script>
const app = Vue.createApp({
    data() {
        return {
            activeTab: 'faq', // 기본으로 '자주 묻는 질문' 탭 활성화
            searchOption: "all",
            searchKeyword: '',
            inquiryList: [],
			sessionStatus: "${sessionStatus}",
			pageSize: 5,
			index: 0,
			page: 1,
			faqList: [
				{ id: 1, question: '배송 기간은 얼마나 걸리나요?', answer: '보통 2~3일 소요됩니다.', open: false },
				{ id: 2, question: '교환/환불은 어떻게 하나요?', answer: '고객센터를 통해 요청 가능합니다.', open: false },
				{ id: 3, question: '회원 탈퇴는 어디서 하나요?', answer: '마이페이지에서 탈퇴 가능합니다.', open: false }
            ]
        };
    },
    methods: {
        // 탭 변경
        showSection(tab) {
            this.activeTab = tab;
        },

        inquireList() {
			var self = this;
			var nparmap = {
				searchKeyword: self.searchKeyword,
				searchOption: self.searchOption,
				pageSize: self.pageSize,
				page: (self.page - 1) * self.pageSize
			};
            $.ajax({
                url: "/inquire/qna.dox",
                type: "POST",
                dataType: "json",
				data : nparmap,
                success : function(data) { 
					console.log(data);
					self.inquiryList = data.inquiryList
					self.index = Math.ceil(data.count / self.pageSize);
                }
            });
        },

		fnPage: function (num) {
			let self = this;
			self.page = num;
			self.inquireList();
		},
		
		fnPageMove: function (direction) {
			let self = this;
			let next = document.querySelector(".next");
			let prev = document.querySelector(".prev");
			if (direction == "next") {
				self.page++;
			} else {
				self.page--;
			}
			self.inquireList();
		},

        // FAQ 질문 클릭 시 답변 토글
        toggleFaq(faq) {
			faq.open = !faq.open;
        },

		fnWriting() {
			location.href = "/inquire/add.do";
		},

		fnView(qsNo) {
			pageChange("/inquire/view.do", { qsNo : qsNo });
		},

		getStatusClass(status) {
			console.log("qsStatus 값:", status);
			if (status == 0) return 'status-gray';      // 확인 중 (회색)
			if (status == 1) return 'status-lightgreen'; // 처리 중 (연두색)
			if (status == 2) return 'status-green';     // 처리 완료 (초록색)
			return 'status-gray'; // 기본값
		},
		getStatusText(status) {
			if (status == 0) return '확인 중';
			if (status == 1) return '처리 중';
			if (status == 2) return '처리 완료';
			return '';
		}

    },
    mounted() {
		
		// URL에서 'tab' 파라미터 가져오기
		const urlParams = new URLSearchParams(window.location.search);
		const tabParam = urlParams.get('tab');

		// 'tab' 파라미터 값이 있으면 해당 탭을 활성화
		if (tabParam && ['faq', 'qna', 'notice'].includes(tabParam)) {
			this.activeTab = tabParam;
		}

        this.inquireList();
    }
});
app.mount('#app');
</script>
</body>
