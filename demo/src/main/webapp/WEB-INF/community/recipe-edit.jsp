<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link rel="stylesheet" href="/css/commu-css/recipe-add.css">
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.7/quill.min.js"></script>
    <title>커뮤니티</title>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />

    <%
        // savedContents 값 가져오기
        String savedContents = (String) request.getAttribute("savedContents");
        if (savedContents == null) savedContents = ""; // null 방지
    %>

    <!-- JSON 데이터를 스크립트 변수로 변환 -->
    <script>
       var savedContents = '<%= savedContents.replace("'", "\\'").replace("\"", "\\\"") %>';
    </script>

    <div id="app" data-post-id="${map.postId}">
        <h1 class="inquire-input">레시피 공유</h1>
        <h2 class="inquire-write">수정하기</h2>

        <!-- 제목 입력 -->
        <div class="input-group">
            <input v-model="info.title" id="title" placeholder="제목">
        </div>

        <!-- 요리 정보 입력 -->
        <div class="recipe-info">
            <div class="info-item">
                <label for="cookingTime">요리 시간 (분):</label>
                <input type="number" id="cookingTime" v-model="info.cookingTime" min="1">
            </div>
            <div class="info-item">
                <label for="servings">몇 인분:</label>
                <input type="number" id="servings" v-model="info.servings" min="1">
            </div>
            <div class="info-item">
                <label>난이도:</label>
                <div class="star-rating">
                    <span v-for="n in 5" :key="n" @click="setDifficulty(n)" :class="{ 'selected': n <= info.difficulty }">
                        ★
                    </span>
                </div>
            </div>
        </div>

        <!-- 간략한 요리 설명 -->
        <div class="input-group">
            <textarea v-model="info.instructions" id="instructions" placeholder="간략한 요리 설명을 입력하세요"></textarea>
        </div>

        <!-- 본문 에디터 -->
        <div class="input-group">
            <div class="editor" contenteditable="true" id="editor"></div>
        </div>

        <!-- 작성 버튼 -->
        <div class="writing">
            <button @click="fnSave">작성</button>
        </div>        
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                postId: "", // 초기화
                info: {
                    title: "", // title 초기화
                    cookingTime: "", // cookingTime 초기화
                    servings: "", // servings 초기화
                    difficulty: 1, // 난이도
                    instructions: "", // instructions 초기화
                }, // 레시피 정보
                // title: "",
                // cookingTime: "",
                // servings: "",
                // difficulty: 1,
                // instructions: "",
                contents: "",
                sessionId: "${sessionId}", // 사용자 세션 ID
                quill: null // Quill 인스턴스
            };
        },
        methods: {
            setDifficulty(level) {
                this.info.difficulty = level;  // 난이도 변경
            },
            fnRecipe() {
                var self = this;
                var nparmap = {
                    postId: self.postId,
                    option: "SELECT"
                };
                $.ajax({
                    url: "/recipe/editView.dox",
                    dataType: "json",   
                    type: "POST", 
                    data: nparmap,
                    success: function(data) { 
                        console.log(data);
                        self.info = data.info;
                        self.info.difficulty = data.info.difficulty || 1; // 기본값 1 설정

                        // Quill 데이터 적용
                        if (self.contents && self.quill) {
                            self.quill.clipboard.dangerouslyPasteHTML(self.contents);
                            console.log("Editor Content Loaded from AJAX!");
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("데이터 로드 실패:", error);
                    }
                });
            },
            fnSave() {
                var self = this;

                // 필수 값 체크
    console.log('Title:', self.info.title);
    console.log('Cooking Time:', self.info.cookingTime);
    console.log('Servings:', self.info.servings);
    console.log('instructions:', self.info.instructions);
    console.log('Quill Content:', self.quill.root.innerHTML);

                if (self.info.title === "" || self.info.contents === "" || self.info.cookingTime === "" || self.info.servings === "" || self.info.instructions === "") {
                    alert("모든 값을 입력해 주세요.");
                    return;
                }

                var quillContentHtml = self.quill.root.innerHTML; // Quill 내용 가져오기

                var nparmap = {
                    title: self.info.title,
                    cookingTime: self.info.cookingTime,
                    servings: self.info.servings,
                    difficulty: self.info.difficulty,
                    instructions: self.info.instructions,
                    contents: quillContentHtml,
                    userId: self.sessionId
                };


                $.ajax({
                    url: "/recipe/edit.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                        alert("수정되었습니다.");
                        location.href = "/commu-main.do?tab=recipe";
                    },
                    error: function (xhr, status, error) {
                        console.error("AJAX 요청 실패:", status, error);
                        alert("수정에 실패했습니다.");
                    }
                });
            }
        },
        mounted() {
            var self = this;

            // HTML 데이터 가져오기
            const appElement = document.getElementById('app');
            this.postId = appElement.getAttribute('data-post-id');

            self.fnRecipe(); // 레시피 정보 로드

            // Quill 에디터 초기화
            var quill = new Quill('#editor', {
                theme: 'snow',
                modules: {
                    toolbar: [
                        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                        ['bold', 'italic', 'underline'],
                        [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                        ['link', 'image'],
                        ['clean'],
                        [{ 'color': [] }, { 'background': [] }]
                    ]
                }
            });

            self.quill = quill; // Quill 인스턴스 저장

            if (savedContents) {
                try {
                    savedContents = savedContents.replace(/&quot;/g, '"').replace(/&lt;/g, '<').replace(/&gt;/g, '>');
                    quill.clipboard.dangerouslyPasteHTML(savedContents);
                    self.contents = savedContents;  // Vue 데이터에 Quill 내용을 설정
                    console.log("Editor Content Loaded from JSP!");
                } catch (e) {
                    console.error("HTML 데이터 로드 실패:", e);
                }
            }
        }
    });

    app.mount('#app');
</script>
