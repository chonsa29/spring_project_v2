<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/commu-css/recipe-add.css">
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.7/quill.min.js"></script>
    <title>커뮤니티</title>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />

    <%
        String savedContents = (String) request.getAttribute("savedContents");
        if (savedContents == null) savedContents = "";
    %>

    <!-- JSON 데이터를 스크립트 변수로 변환 -->
    <script>
       var savedContents = '<%= savedContents.replace("'", "\\'").replace("\"", "\\\"") %>';
    </script>

    <div id="app" data-post-id="${map.postId}">
        <h1 class="inquire-input">그룹 구해요</h1>
        

        <!-- 제목 입력 -->
        <div class="input-group">
            <input v-model="info.title" id="title" placeholder="제목">
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
                info: {},
                sessionId: "${sessionId}", // 사용자 세션 ID
                quill: null, // Quill 인스턴스
                contents: "",
                members : []
            };
        },
        methods: {
            fnGroupPost() {
                var self = this;
				var nparmap = {
                    postId : self.postId,
                    userId: self.sessionId,
                    option: "SELECT"
				};
				$.ajax({
					url:"/group/view.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) {
						console.log(data);
                        self.info = data.info;
                        self.members = data.members;
					}
				});
            },
            fnSave() {
                var self = this;

                if (self.info.title === "" || self.info.contents === "") {
                    alert("모든 값을 입력해 주세요.");
                    return;
                }

                var quillContentHtml = self.quill.root.innerHTML; // Quill 내용 가져오기

                var nparmap = {
                    title: self.info.title,
                    contents: quillContentHtml,
                    postId : self.postId
                };
                $.ajax({
                    url: "/group/edit.dox",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json",  // JSON 형식 명시
                    data: JSON.stringify(nparmap),  // JSON 문자열로 변환
                    success: function (data) {
                        console.log(data);
                        alert("수정되었습니다.");
                        pageChange("/group/view.do", { postId : self.postId });
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

            self.fnGroupPost(); // 레시피 정보 로드

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
