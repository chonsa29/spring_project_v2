<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>

        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/main.css">
        <link rel="stylesheet" href="/css/member-css/mypage.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />

        <title>MealPick - 밀키트 쇼핑몰</title>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">
            <div class="mypage-container">
                <div>
                    <div class="profile-card">
                        <div class="profile-icon">👤</div>
                        <h2>{{ user.username }}</h2>
                        <p>{{ user.email }}</p>
                        <button @click="logout">로그아웃</button>
                        <button @click="openSupport">고객센터</button>
                    </div>
                    <div class="menu-list">
                        <ul>
                            <li @click="selectMenu('profile')">프로필</li>
                            <li @click="selectMenu('level')">등급</li>
                            <li @click="selectMenu('group')">그룹 확인</li>
                            <li @click="selectMenu('orders')">주문 내역</li>
                            <li @click="withdraw">회원 탈퇴</li>
                        </ul>
                    </div>
                </div>
                <div class="profile-details">
                    <h3>{{ menuTitle }}</h3>
                    <p v-if="selectedMenu === 'profile'"><strong>ID:</strong> {{ user.id }}</p>
                    <p v-if="selectedMenu === 'profile'"><strong>NAME:</strong> {{ user.name }}</p>
                    <p v-if="selectedMenu === 'profile'"><strong>USERNAME:</strong> {{ user.username }}</p>
                    <p v-if="selectedMenu === 'profile'"><strong>PASSWORD:</strong> ************</p>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </body>

    </html>
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    user: {
                        id: "user123",
                        name: "홍길동",
                        username: "USERNAME",
                        email: "username@gmail.com",
                    },
                    selectedMenu: 'profile',
                    menuTitles: {
                        profile: '프로필',
                        level: '등급',
                        group: '그룹 확인',
                        orders: '주문 내역'
                    }
                };
            },
            computed: {
                menuTitle() {
                    return this.menuTitles[this.selectedMenu] || '프로필';
                }
            },
            methods: {
                selectMenu(menu) {
                    this.selectedMenu = menu;
                },
                logout() {
                    alert("로그아웃 되었습니다.");
                },
                openSupport() {
                    alert("고객센터 페이지로 이동합니다.");
                },
                withdraw() {
                    if (confirm("정말로 회원 탈퇴하시겠습니까?")) {
                        alert("회원 탈퇴가 완료되었습니다.");
                    }
                }
            }
        });
        app.mount('#app');
    </script>