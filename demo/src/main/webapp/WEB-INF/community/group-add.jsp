<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    <% String groupId = request.getParameter("groupId"); %>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h1 class="recipe-input">그룹 구하기</h1>

        <!-- 제목 입력 -->
        <div class="input-group">
            <input v-model="title" id="title" placeholder="제목">
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
                contents: "",
                sessionId: "${sessionId}",
                groupId: "<%= groupId %>" // JSP에서 가져온 값 저장
            };
        },
        methods: {
            fnSave() {
                var self = this;
                if (self.title === "" || self.contents === "") {
                    alert("모든 값을 입력해 주세요.");
                    return;
                }

                var quill = Quill.find(document.getElementById('editor')); // Quill 인스턴스 가져오기
                var quillContentHtml = quill.root.innerHTML; // HTML 형식으로 변환

                var nparmap = {
                    title: self.title,
                    contents: quillContentHtml,
                    userId: self.sessionId,
                    groupId: self.groupId
                };

                $.ajax({
                    url: "/group/add.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                        alert("게시글이 등록되었습니다.");
                        location.href = "/commu-main.do?tab=group";
                    },
                    error: function (xhr, status, error) {
                        console.error("AJAX 요청 실패:", status, error);
                        alert("등록에 실패했습니다.");
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

            quill.on('text-change', function () {
                self.contents = JSON.stringify(quill.getContents());  // Delta 형식 저장
            });

            self.quill = quill;  // 나중에 접근할 수 있도록 저장

            console.log(self.groupId);
        }
    });

    app.mount('#app');
</script>
