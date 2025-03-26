<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/inquire-css/inquire-add-style.css">
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
	<title>문의게시판</title>
</head>
<style>
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
	<div id="app">
        <h1 class="inquire-input">문의게시판</h1>
        <h2 class="inquire-write">글쓰기</h2>
        <div class="input-group">
            <input v-model="title" id="title" placeholder="제목">
        </div>
        <div class="input-group">
            <div class="editor" contenteditable="true" id="editor"></div>
        </div>
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
                title : "",
                contents : "",
                sessionId : "${sessionId}",
            };
        },
        methods: {
            fnSave(){
                var self = this;
                if(self.title == "" || self.contents == "") {
                    alert("문의 내용을 입력해주세요");
                    return;
                }
				var nparmap = {
                    qsTitle : self.title,
                    qsContents : self.contents,
                    userId : self.sessionId
				};
				$.ajax({
					url:"/inquire/add.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        alert("문의가 등록되었습니다.");
                        location.href="/inquire.do";
					},
                    error: function(xhr, status, error) {
                        console.error("AJAX 요청 실패:", status, error);  // AJAX 요청 실패 확인
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
                        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                        ['link', 'image'],
                        ['clean'],
                        [{'color' : []}, {'background' : []}]
                    ]
                }
            });

            // 에디터 내용이 변경될 때마다 Vue 데이터를 업데이트
            quill.on('text-change', function() {
                self.contents = quill.root.innerHTML;
            });
        }
    });
    app.mount('#app');
</script>
​