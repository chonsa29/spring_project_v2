<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<link rel="stylesheet" href="/css/commu-css/commu-main.css">
	<link rel="stylesheet" href="/css/commu-css/group-add.css">
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
						<th>날짜</th>
						<th>조회수</th>
						<th>좋아요</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="item in rList">
						<td>{{ item.postId }}</td>
						<td @click="fnRecipeView(item.postId)">{{ item.title }} <span style="color: #0DA043;">({{ item.commentCount }})</span></td>
						<td>{{ item.cdatetime.substring(0, 10) }}</td>
						<td class="gray-text">{{ item.cnt }}</td>
						<td class="gray-text">{{ item.likes }}</td>
					</tr>
				</tbody>
			</table>
			<!-- 레시피 페이징 -->
			<div class="pagination">
				<a v-if="page != 1" id="index" href="javascript:;" @click="fnRecipePageMove('prev')"> < </a>
				<a href="javascript:;" v-for="num in index" @click="fnRecipePage(num)" :class="{active: page === num}">{{ num }}</a>
				<a v-if="page != index" id="index" href="javascript:;" @click="fnRecipePageMove('next')"> > </a>
			</div>
				<div class="writing">
				    <button @click="fnAddRecipe">글쓰기</button>
				</div>
		</section>

		<!-- group -->
		<section id="group" class="tab-content" v-show="activeTab === 'group'">
			<h2>구하면 등급 UP 그룹 구합니다</h2>
			<div class="search-bar">
				<select v-model="searchOption">
					<option value="all">:: 전체 ::</option>
					<option value="title">제목</option>
					<option value="contents">내용</option>
				</select>
				<input type="text" v-model="searchKeyword" @keyup.enter="fnGroupList" placeholder="검색어를 입력하세요">
				<button @click="fnGroupList">검색</button>
			</div>
			<table class="recipe-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>날짜</th>
						<th>조회수</th>
						<th>모집 상태</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="item in gList">
						<td>{{ item.postId }}</td>
						<td @click="fnGroupView(item.postId)">{{ item.title }}</td>
						<td>{{ item.cdatetime.substring(0, 10) }}</td>
						<td class="gray-text">{{ item.viewCnt }}</td>
						<td class="gray-text">
							<!-- 모집 상태 버튼 -->
							<button v-if="item.status === 'PENDING'" class="status-btn open">모집 중</button>
							<button v-if="item.status === 'CLOSE'" class="status-btn closed">마감</button>
						</td>
					</tr>
				</tbody>
			</table>
			<!-- 그룹 페이징 -->
			<div class="pagination">
				<a v-if="groupPage != 1" id="index" href="javascript:;" @click="fnGroupPageMove('prev')"> < </a>
				<a href="javascript:;" v-for="num in groupIndex" @click="fnGroupPage(num)" :class="{ active: groupPage === num }">{{ num }}</a>
				<a v-if="groupPage != groupIndex" id="index" href="javascript:;" @click="fnGroupPageMove('next')"> > </a>
			</div>
				
				<div class="writing">
				    <button v-if="isLeader" @click="fnAddGroupPost">글쓰기</button>
    				<button v-else @click="fnAddGroup">그룹 만들기</button>
				</div>
				<!-- 그룹 만들기 팝업 -->
				<div class="popup-overlay" :class="{ show: showGroupPopup }">
					<div class="popup">
						<h3>새 그룹 만들기</h3>
						<input type="text" v-model="groupName" placeholder="그룹 이름을 입력하세요">
						<div class="popup-buttons">
							<button class="create-btn" @click="createGroup">생성</button>
							<button class="close-btn" @click="closeGroupPopup">닫기</button>
						</div>
					</div>
				</div>
		</section>

	</div>
	<jsp:include page="/WEB-INF/common/footer.jsp" />
</html>
</body>
<script>
const app = Vue.createApp({
	data() {
		return {
			activeTab: 'recipe',
			searchOption: "all",
			searchKeyword: '',
			rList: [],
			gList: [],
			sessionStatus: "${sessionStatus}",
			userId : "${sessionId}",

			showGroupPopup: false, // 팝업 여부 추가
            groupName: "", // 그룹명 입력 필드

			pageSize: 5,
			index: 0,
			page: 1,

			groupPage: 1,
			groupIndex: 0,
			groupPageSize: 5,

            isLeader: false, // 현재 사용자가 리더인지 여부
			leaders: [],

			groupId : ""
		};
	},
	methods: {
		// 탭 변경
		showSection(tab) {
			this.activeTab = tab;

			// 탭이 변경될 때 해당 탭의 데이터 불러오기
			if (tab === "recipe") {
				this.fnRecipeList();
			} else if (tab === "group") {
				this.fnGroupList();
			}
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
				data: nparmap,
				success: function(data) { 
					console.log(data);
					self.rList = data.rList;
					self.index = Math.ceil(data.count / self.pageSize);
				}
			});
		},
		
		fnGroupList() {
			let self = this;
			let nparmap = {
				userId: self.userId,
				searchKeyword: self.searchKeyword,
				searchOption: self.searchOption,
				groupPageSize: self.groupPageSize,
				groupPage: (self.groupPage - 1) * self.groupPageSize
			};
			$.ajax({
				url: "/commu/group.dox",
				type: "POST",
				dataType: "json",
				data: nparmap,
				success: function(data) { 
					console.log(data);
					self.gList = data.gList;

					self.groupIndex = Math.ceil(data.count / self.groupPageSize);

					// 리더 찾기
					self.isLeader = data.leaders;
					console.log(self.isLeader);

					// 그룹 아이디 가져오기
					self.group = data.group;
					console.log(self.group.groupId);
				}
			});
		},

		// 레시피 페이지 이동
		fnRecipePageMove(direction) {
			let self = this;
			if (direction === "next") {
				self.page++;
			} else if (direction === "prev") {
				self.page--;
			}
			self.fnRecipeList();
		},

		// 그룹 페이지 이동
		fnGroupPageMove(direction) {
			let self = this;
			if (direction === "next") {
				self.groupPage++;
			} else if (direction === "prev") {
				self.groupPage--;
			}
			self.fnGroupList();
		},

		// 레시피 페이지 이동
        fnRecipePage(num) {
            let self = this;
            self.page = num;
            self.fnRecipeList();
        },

        // 그룹 페이지 이동
        fnGroupPage(num) {
            let self = this;
            self.groupPage = num;
            self.fnGroupList();
        },

		fnAddRecipe() {
			location.href = "/recipe/add.do";
		},

		fnRecipeView(postId) {
			console.log('Post ID:', postId); 
			pageChange("/recipe/view.do", { postId : postId });
		},
		fnGroupView(postId) {
			console.log('Post ID:', postId); 
			pageChange("/group/view.do", { postId : postId });
		},
		fnAddGroupPost(groupId) {
			location.href = "/group/add.do?groupId=" + this.group.groupId;
		},
		 // 그룹 만들기 버튼 클릭
		 fnAddGroup() {
            let self = this;

            // 1. 현재 탭이 'group'이 아니면 변경 후 종료
            if (self.activeTab !== "group") {
                self.activeTab = "group";
                return;
            }

            // 2. 그룹 가입 여부 체크 (일단 바로 팝업 띄우기 테스트)
            console.log("그룹 상태 체크 시작");
            $.ajax({
                url: "/group/memberCheck.dox",
                type: "POST",
                dataType: "json",
                data: { userId: self.userId }, // 사용자 ID 전달
                success: function(response) {
                    console.log("서버 응답:", response); //  응답 확인

                    if (response.status === "success") {
                        if (response.groupStatus === "joined") {
                            alert("이미 그룹에 참가 중이십니다.");
                            
                        } else {
                            self.showGroupPopup = true; // 팝업 띄우기
                            console.log("팝업 활성화:", self.showGroupPopup);
                        }
                    } else {
                        alert(response.message || "사용자 그룹 상태를 확인할 수 없습니다.");
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX 오류:", error);
                    alert("서버와의 통신 중 오류가 발생했습니다.");
                }
            });
        },

        // 그룹 생성하기
        createGroup() {
            if (!this.groupName.trim()) {
                alert("그룹 이름을 입력하세요.");
                return;
            }

            let self = this;
            $.ajax({
                url: "/group/create.dox",
                type: "POST",
                dataType: "json",
                data: { 
					userId: self.userId,
					groupName: self.groupName,
				},
                success: function(response) {
                    if (response.status === "success") {
                        alert("그룹이 성공적으로 생성되었습니다!");
                        self.showGroupPopup = false;
                        self.groupName = '';
                        self.fnGroupList(); // 그룹 목록 다시 불러오기
                    } else {
                        alert(response.message || "그룹 생성에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("서버 오류가 발생했습니다. 다시 시도해주세요.");
                }
            });
        },

        // 팝업 닫기
        closeGroupPopup() {
            this.showGroupPopup = false;
            this.newGroupName = '';
        },

	},
	mounted() {
		// URL에서 'tab' 파라미터 가져오기
		const urlParams = new URLSearchParams(window.location.search);
		const tabParam = urlParams.get('tab');

		// 'tab' 파라미터 값이 있으면 해당 탭을 활성화
		if (tabParam && ['recipe', 'group'].includes(tabParam)) {
			this.activeTab = tabParam;
		}

		if (this.activeTab === 'group') {
			this.fnGroupList();  // 그룹 리스트 불러오기
		} else {
			this.fnRecipeList(); // 레시피 리스트 불러오기
		}

	}
});
app.mount('#app');
</script>
	
