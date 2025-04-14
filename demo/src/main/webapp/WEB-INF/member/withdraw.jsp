<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 탈퇴</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Vue 3 -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.prod.js"></script>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        .withdraw-container {
            max-width: 500px;
            margin: 50px auto;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #fff;
        }
    </style>
</head>
<body>
<div id="app" class="withdraw-container">
    <h2>회원 탈퇴</h2>

    <div class="alert alert-warning">
        <strong>주의!</strong> 탈퇴 시 모든 정보가 삭제되며 복구가 불가능합니다.
    </div>

    <form @submit.prevent="submitWithdraw">
        <div class="form-group mb-3">
            <label for="password">비밀번호 확인</label>
            <input type="password" id="password" v-model="password" class="form-control" required
                   placeholder="현재 비밀번호 입력">
        </div>

        <div class="form-check mb-3">
            <input type="checkbox" id="confirmCheck" v-model="isConfirmed" class="form-check-input">
            <label for="confirmCheck" class="form-check-label">
                모든 내용을 확인했으며, 탈퇴에 동의합니다.
            </label>
        </div>

        <div v-if="error" class="alert alert-danger">
            {{ error }}
        </div>

        <div class="d-grid gap-2">
            <button type="submit" class="btn btn-danger" :disabled="!isConfirmed || isLoading">
                <span v-if="isLoading" class="spinner-border spinner-border-sm"></span>
                회원 탈퇴
            </button>
            <button type="button" class="btn btn-secondary" @click="cancelWithdraw">
                취소
            </button>
        </div>
    </form>
</div>

<script>
    const app = Vue.createApp({
        data() {
            return {
                userId: '${sessionId}',
                password: '',
                isConfirmed: false,
                isLoading: false,
                error: null
            };
        },
        methods: {
            submitWithdraw() {
                if (!this.isConfirmed) {
                    this.error = "탈퇴 동의 체크박스를 선택해주세요.";
                    return;
                }

                this.isLoading = true;
                this.error = null;

                $.ajax({
                    url: "/member/withdraw.dox",
                    type: "POST",
                    data: {
                        userId: "${sessionId}", // 서버에서 sessionId 값을 제대로 넣어줘야 함
                        password: this.password
                    },
                    success: (data) => {
                        console.log(data);
                        if (data.result === "success") {
                            Swal.fire({
                                title: "탈퇴 완료",
                                text: "그동안 이용해주셔서 감사합니다.",
                                icon: "success"
                            }).then(() => {
                                window.location.href = "/home.do";
                            });
                        } else {
                            this.error = data.message || "탈퇴 처리 중 오류 발생";
                        }
                    },
                    error: () => {
                        this.error = "서버 오류가 발생했습니다.";
                    },
                    complete: () => {
                        this.isLoading = false;
                    }
                });
            },
            cancelWithdraw() {
                window.location.href = "/member/mypage.do";
            }
        },
        mounted(){
            console.log(this.userId);
        }
    }).mount("#app");
</script>
</body>
</html>
