<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/commu-css/recipe-add.css">
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.7/quill.min.js"></script>
	<title>커뮤니티</title>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h1 class="inquire-input">레시피 공유</h1>
        <h2 class="inquire-write">글쓰기</h2>

        <!-- 제목 입력 -->
        <div class="input-group">
            <input v-model="title" id="title" placeholder="제목">
        </div>

        <!-- 요리 정보 입력 -->
        <div class="recipe-info">
            <div class="info-item">
                <label for="cookingTime">요리 시간 (분):</label>
                <input type="number" id="cookingTime" v-model="cookingTime" min="1">
            </div>
            <div class="info-item">
                <label for="servings">몇 인분:</label>
                <input type="number" id="servings" v-model="servings" min="1">
            </div>
            <div class="info-item">
                <label>난이도:</label>
                <div class="star-rating">
                    <span v-for="n in 5" :key="n" 
                        @click="setDifficulty(n)" 
                        :class="{ 'selected': n <= difficulty }">
                        ★
                    </span>
                </div>
            </div>
        </div>

        <!-- 간략한 요리 설명 -->
        <div class="input-group">
            <textarea v-model="description" id="description" placeholder="간략한 요리 설명을 입력하세요"></textarea>
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
                title: "",
                cookingTime: "",
                servings: "",
                difficulty: 1,
                description: "",
                contents: "",
                sessionId: "${sessionId}",
            };
        },
        methods: {
            setDifficulty(level) {
                this.difficulty = level;  // 난이도 변경
            },
            fnSave() {
                var self = this;
                if (self.title === "" || self.contents === "" || self.cookingTime === "" || self.servings === "" || self.description === "") {
                    alert("모든 값을 입력해 주세요.");
                    return;
                }

                var nparmap = {
                    title: self.title,
                    cookingTime: self.cookingTime,
                    servings: self.servings,
                    difficulty: self.difficulty,
                    instructions: self.description,
                    contents: self.contents,
                    userId: self.sessionId
                };

                $.ajax({
                    url: "/recipe/add.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                        alert("등록되었습니다.");
                        location.href = "/commu-main.do?tab=recipe";
                    },
                    error: function (xhr, status, error) {
                        console.error("AJAX 요청 실패:", status, error);
                        alert("문의 등록에 실패했습니다.");
                    }
                });
            }
        },
        mounted() {
            var self = this;
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

             // MutationObserver를 사용하여 Quill 에디터의 내용 변경 감지
            const observer = new MutationObserver(() => {
                self.contents = quill.root.innerHTML;
            });

            observer.observe(document.querySelector('.ql-editor'), {
                childList: true,     // 자식 요소 추가/제거 감지
                subtree: true,       // 하위 요소까지 감지
                characterData: true  // 텍스트 변경 감지
            });

            // 기존의 `DOMNodeInserted` 이벤트를 사용하는 코드가 있으면 제거
            $(document).off('DOMNodeInserted');
        }
    });

    app.mount('#app');
</script>
