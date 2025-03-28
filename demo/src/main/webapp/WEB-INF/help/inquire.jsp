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
					<div class="faq-question">
						{{ faq.question }}
						<span class="faq-icon" v-if="faq.open">▲</span>
        				<span class="faq-icon" v-else>▼</span>
					</div>
					<div v-if="faq.open" class="faq-answer">{{ faq.answer }}</div>
				</div>
			</div>
		</section>

		<!-- Q&A -->
		<section id="qna" class="tab-content" v-show="activeTab === 'qna'">
			<h2>문의게시판</h2>
			<div class="qna-category">
				<button class="category-btn" :class="{ active: selectedCategory === 'all' }" @click="changeCategory('all')">전체</button>
				<button class="category-btn" :class="{ active: selectedCategory === 'delivery' }" @click="changeCategory('delivery')">배송</button>
				<button class="category-btn" :class="{ active: selectedCategory === 'payment' }" @click="changeCategory('payment')">결제</button>
				<button class="category-btn" :class="{ active: selectedCategory === 'member' }" @click="changeCategory('member')">회원</button>
				<button class="category-btn" :class="{ active: selectedCategory === 'product' }" @click="changeCategory('product')">제품</button>
				<button class="category-btn" :class="{ active: selectedCategory === 'etc' }" @click="changeCategory('etc')">기타</button>
			</div>
			<div class="search-bar">
				<select v-model="searchOption">
					<option value="all">:: 전체 ::</option>
					<option value="title">제목</option>
					<option value="contents">내용</option>
				</select>
				<input type="text" v-model="searchKeyword" placeholder="검색어를 입력하세요" @keyup.enter="inquireList">
				<button @click="inquireList">검색</button>
				<select v-model="pageSize" @change="inquireList">
					<option value="5">5개씩</option>
					<option value="10">10개씩</option>
					<option value="15">15개씩</option>
					<option value="20">20개씩</option>
				</select>
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
						<td v-if="sessionStatus == 'A'">
							<button class="statusChange" :class="getStatusClass(inquiry.qsStatus)" @click="updateStatus(qsNo, qsStatus)">
								{{ getStatusText(inquiry.qsStatus) }}
							</button>
						</td>
						<td v-else>
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
						{{ num }}
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
				<select v-model="noticeSearchOption">
					<option value="nAll">:: 전체 ::</option>
					<option value="nTitle">제목</option>
					<option value="nContents">내용</option>
				</select>
				<input type="text" v-model="noticeSearchKeyword" placeholder="검색어를 입력하세요" @keyup.enter="fnNoticeList">
				<button @click="fnNoticeList">검색</button>
				<select v-model="noticePageSize" @change="fnNoticeList">
					<option value="5">5개씩</option>
					<option value="10">10개씩</option>
					<option value="15">15개씩</option>
					<option value="20">20개씩</option>
				</select>
			</div>
			<table class="notice-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>내용</th>
						<th>날짜</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="notice in noticeList">
						<td @click="fnNoticeView(notice.noticeNo)">{{ notice.noticeNo }}</td>
						<td @click="fnNoticeView(notice.noticeNo)">{{ notice.noticeTitle }}</td>
						<td @click="fnNoticeView(notice.noticeNo)"><span v-html="notice.noticeContents"></span></td>
						<td>{{ notice.noticeDate }}</td>
						<td class="gray-text">{{ notice.viewCnt }}</td>
					</tr>
				</tbody>
			</table>
			<!-- 페이징 -->
			<div class="pagination" v-if="noticeList.length > 0">
				<a v-if="noticePage !=1" id="noticeIndex" href="javascript:;"
				@click="fnNoticePageMove('prev')"> < </a>
				<a href="javascript:;" v-for="number in noticeIndex" @click="fnNoticePage(number)" :class="{active: noticePage === number}">
					{{ number }}
				</a>
				<a v-if="noticePage!=noticeIndex" id="noticeIndex" href="javascript:;"
					@click="fnNoticePageMove('next')"> >
				</a>
			</div>
			<div class="writing" v-if="sessionStatus == 'A'">
				<button @click="fnNoticeWriting">글쓰기</button>
			</div>
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
			noticeSearchOption: "nAll",
            searchKeyword: '',
			noticeSearchKeyword: '',
            inquiryList: [],
			noticeList: [],
			sessionStatus: "${sessionStatus}",
			qsNo : "${map.qsNo}",
			noticeNo : "${map.noticeNo}",
			pageSize: 5,
			index: 0,
			page: 1,
			noticePageSize: 5,
			noticeIndex: 0,
			noticePage: 1,
			faqList: [
				{ id: 1, question: '배송 기간은 얼마나 걸리나요?', answer: '보통 2~3일 소요됩니다.', open: false },
				{ id: 2, question: '교환/환불은 어떻게 하나요?', answer: '고객센터를 통해 요청 가능합니다.', open: false },
				{ id: 3, question: '회원 탈퇴는 어디서 하나요?', answer: '마이페이지에서 탈퇴 가능합니다.', open: false }
            ],
			selectedCategory: 'all'
        };
    },
    methods: {
        // 탭 변경
        showSection(tab) {
            this.activeTab = tab;
        },

		changeCategory(category) {
			this.selectedCategory = category;  // 선택한 카테고리 설정
			this.inquireList(); // 선택된 카테고리에 맞게 Q&A 목록 다시 불러오기
		},

        inquireList() {
			var self = this;
			var nparmap = {
				searchKeyword: self.searchKeyword,
				searchOption: self.searchOption,
				pageSize: self.pageSize,
				page: (self.page - 1) * self.pageSize,
				category: self.selectedCategory
			};
            $.ajax({
                url: "/inquire/qna.dox",
                type: "POST",
                dataType: "json",
				data : nparmap,
                success : function(data) { 
					console.log(data);
					self.inquiryList = data.inquiryList;
					self.index = Math.ceil(data.inquiryCount / self.pageSize);
                },
				error: function () {
					console.error("Q&A 데이터를 불러오는 데 실패했습니다.");
				}
            });
        },

		fnPage: function (num) {
			let self = this;
			self.page = num;
			self.inquireList();
		},

		fnNoticePage: function (number) {
			let self = this;
			self.noticePage = number;
			self.fnNoticeList();
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

		fnNoticePageMove: function (direction) {
			let self = this;
			let next = document.querySelector(".next");
			let prev = document.querySelector(".prev");
			if (direction == "next") {
				self.noticePage++;
			} else {
				self.noticePage--;
			}
			self.fnNoticeList();
		},

        // FAQ 질문 클릭 시 답변 토글
        toggleFaq(faq) {
			faq.open = !faq.open;
        },

		fnWriting() {
			location.href = "/inquire/add.do";
		},

		fnNoticeWriting() {
			location.href = "/notice/add.do";
		},

		fnView(qsNo) {
			pageChange("/inquire/view.do", { qsNo : qsNo });
		},

		fnNoticeView(noticeNo) {
			pageChange("/notice/view.do", { noticeNo : noticeNo });
		},

		getStatusClass(status) {
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
		},

		updateStatus(qsNo, qsStatus) {

			console.log("updateStatus 실행됨!", qsNo, qsStatus); 

			let newStatus

			if (inquiry.qsStatus === 0) {
				newStatus = 1; // 0 → 1 (확인 중 → 처리 중)
			} else if (inquiry.qsStatus === 1) {
				newStatus = 2; // 1 → 2 (처리 중 → 처리 완료)
			} else {
				console.log("⚠ 상태 변경 없음: 이미 처리 완료 상태입니다.");
				return;
			}

			console.log("변경할 상태:", newStatus); // 변경된 값 확인

            // 서버에 변경된 상태 업데이트 요청
			var self = this;
			var nparmap = {
				qsNo: inquiry.qsNo,
				qsStatus: newStatus
			};
            $.ajax({
                url: "/inquire/updateStatus.dox",
                type: "POST",
                dataType: "json",
                data: nparmap,
                success: function (data) {
					console.log(data);
                    if (data.result === "success") {
						inquiry.qsStatus = newStatus; 
                        alert("상태가 변경되었습니다.");
                    } else {
                        alert("상태 변경에 실패했습니다.");
                    }
                },
                error: function () {
                    alert("서버 오류가 발생했습니다.");
                }
            });
        },

		fnNoticeList(noticeNo) {
			let self = this;
			let params = {
				noticeSearchKeyword: self.noticeSearchKeyword,
				noticeSearchOption: self.noticeSearchOption,
				noticePageSize: self.noticePageSize,
				noticePage: (self.noticePage - 1) * self.noticePageSize
			};

			$.ajax({
				url: "/inquire/notice.dox", 
				type: "POST",
				dataType: "json",
				data: params,
				success: function (data) {
					console.log("공지사항 데이터:", data);
					self.noticeList = data.noticeList;
					self.noticeIndex = Math.ceil(data.noticeCount / self.pageSize);
				},
				error: function () {
					console.error("공지사항 데이터를 불러오는 데 실패했습니다.");
				}
			});
    	},

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
		this.fnNoticeList();
    }
});
app.mount('#app');
</script>
</body>
