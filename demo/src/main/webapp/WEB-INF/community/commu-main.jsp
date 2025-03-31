<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>"></script>
	<link rel="stylesheet" href="/css/commu-css/commu-main.css">
	<script src="/js/pageChange.js"></script>
	<title>커뮤니티</title>
</head>
<body>
	<jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
		<!-- 탭 메뉴 -->
		<nav class="tab-menu">
			<div class="tab-item" :class="{ active: activeTab === 'recipe' }" @click="showSection('recipe')">나만의 레시피</div>
			<div class="tab-separator">|</div>
			<div class="tab-item" :class="{ active: activeTab === 'group' }" @click="showSection('group')">그룹 구해요</div>
		</nav>

		<!-- 자주 묻는 질문 -->
		<section id="recipe" class="tab-content" v-if="activeTab === 'recipe'">
			<h2>나만의 레시피를 공유합니다</h2>
			<div class="search-bar">
				<select v-model="searchOption">
					<option value="all">:: 전체 ::</option>
					<option value="title">제목</option>
					<option value="contents">내용</option>
				</select>
				<input type="text" v-model="searchKeyword" @keyup.enter="fnRecipeList" placeholder="검색어를 입력하세요">
				<button @click="fnRecipeList">검색</button>
			</div>
			<table class="recipe-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<!-- <th>내용</th> -->
						<th>날짜</th>
						<th>조회수</th>
						<th>좋아요</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="item in rList">
						<td>{{ item.postId }}</td>
						<td @click="fnRecipeView(item.postId)">{{ item.title }}</td>
						<!-- <td @click="fnRecipeView(item.postId)"><span v-html="item.contents"></span></td> -->
						<td>{{ item.cdatetime.substring(0, 10) }}</td>
						<td class="gray-text">{{ item.cnt }}</td>
						<td class="gray-text">{{ item.likes }}</td>
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
				    <button @click="fnAddRecipe">글쓰기</button>
				</div>
		</section>

		<!-- Q&A -->
		<section id="group" class="tab-content" v-show="activeTab === 'group'">
			<h2>구하면 등급 UP 그룹 구합니다</h2>
			<div class="search-bar">
				<select v-model="searchOption">
					<option value="all">:: 전체 ::</option>
					<option value="title">제목</option>
					<option value="contents">내용</option>
				</select>
				<input type="text" v-model="searchKeyword" @keyup.enter="fnRecipeList" placeholder="검색어를 입력하세요">
				<button @click="fnGroupList">검색</button>
			</div>
			<table class="recipe-table">
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

	</div>
	<jsp:include page="/WEB-INF/common/footer.jsp" />
</html>
<script>
const app = Vue.createApp({
    data() {
        return {
            activeTab: 'recipe',
            searchOption: "all",
            searchKeyword: '',
            rList: [],
			sessionStatus: "${sessionStatus}",
			pageSize: 5,
			index: 0,
			page: 1
        };
    },
    methods: {
        // 탭 변경
        showSection(tab) {
            this.activeTab = tab;
        },

        fnRecipeList() {
			var self = this;
			var nparmap = {
				searchKeyword: self.searchKeyword,
				searchOption: self.searchOption,
				pageSize: self.pageSize,
				page: (self.page - 1) * self.pageSize
			};
            $.ajax({
                url: "/commu/recipe.dox",
                type: "POST",
                dataType: "json",
				data : nparmap,
                success : function(data) { 
					console.log(data);
					self.rList = data.rList
					self.index = Math.ceil(data.count / self.pageSize);
                }
            });
        },

		fnPage: function (num) {
			let self = this;
			self.page = num;
			self.fnRecipeList();
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
			self.fnRecipeList();
		},

		fnAddRecipe() {
			location.href = "/recipe/add.do";
		},

		fnRecipeView(postId) {
			console.log('Post ID:', postId); 
			pageChange("/recipe/view.do", { postId : postId });
		}

    },
    mounted() {
		
		// URL에서 'tab' 파라미터 가져오기
		const urlParams = new URLSearchParams(window.location.search);
		const tabParam = urlParams.get('tab');

		// 'tab' 파라미터 값이 있으면 해당 탭을 활성화
		if (tabParam && ['recipe', 'group'].includes(tabParam)) {
			this.activeTab = tabParam;
		}

        this.fnRecipeList();
    }
});
app.mount('#app');
</script>
</body>
