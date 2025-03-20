<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/css/style.css">
    <title>MealPick - 밀키트 쇼핑몰</title>
    <style>
    </style>
</head>
<body>

    <header class="header">
        <div class="logo">
            <img src="/img/icon.png" alt="MealPick 로고">
        </div>
        <div class="logo2">
            <img src="/img/MEALPICK.png" alt="MealPick 로고">
        </div>
        <nav class="nav">
            <a href="#">MENU1</a>
            <a href="#">MENU2</a>
            <a href="#">BRAND</a>
            <a href="#">PRODUCT</a>
            <a href="#">GRADE</a>
        </nav>
    </header>

    <div class="slider">
        <div class="slides">
            <div class="slide"><img src="/img/main1.jpg" alt="슬라이드 이미지 1"></div>
            <div class="slide"><img src="/img/main2.jpg" alt="슬라이드 이미지 2"></div>
            <div class="slide"><img src="/img/main3.jpg" alt="슬라이드 이미지 3"></div>
        </div>
        <button class="prev" onclick="moveSlide(-1)">&#10094;</button>
        <button class="next" onclick="moveSlide(1)">&#10095;</button>
    </div>

    <div class="product-section">
        <h2 class="product-title">PRODUCT(슬라이드 기능 구현)</h2>
        <div class="product-container">
            <div class="product-box">상품 1</div>
            <div class="product-box">상품 2</div>
            <div class="product-box">상품 3</div>
            <div class="product-box">상품 4</div>
            <div class="product-box">상품 5</div>
        </div>
    </div>

    <div class="plan-section">
        <div class="plan-card">
            <h3>비회원</h3>
            <ul>
                <li>✅ 혜택</li>
                <li>✅ 혜택</li>
            </ul>
            <p class="price">0 원</p>
            <button class="btn green">현재 선택</button>
        </div>
        <div class="plan-card">
            <h3>플랜1</h3>
            <ul>
                <li>✅ 혜택</li>
                <li>✅ 혜택</li>
                <li>✅ 혜택</li>
            </ul>
            <p class="price">15,000 원</p>
            <button class="btn blue">구입하기</button>
        </div>
        <div class="plan-card">
            <h3>플랜2</h3>
            <ul>
                <li>✅ 혜택</li>
                <li>✅ 혜택</li>
                <li>✅ 혜택</li>
                <li>✅ 혜택</li>
            </ul>
            <p class="price">30,000 원</p>
            <button class="btn orange">구입하기</button>
        </div>
    </div>

    <div class="floating-icon">
        <img src="/img/icon.png" alt="아이콘">
    </div>

</body>
</html>
<script>

    document.addEventListener("DOMContentLoaded", function() {
        const icon = document.querySelector(".floating-icon img");

        icon.style.width = "60px";  // 아이콘 크기 유지
        icon.style.height = "40px";

        icon.addEventListener("mouseover", function() {
            icon.src = "/img/icon2.png"; // hover 시 변경
        });

        icon.addEventListener("mouseout", function() {
            icon.src = "/img/icon.png"; // 원래 아이콘 복구
        });
    });

    let currentIndex = 0;

    function moveSlide(step) {
        const slides = document.querySelector(".slides");
        const totalSlides = document.querySelectorAll(".slide").length;

        currentIndex += step;

        if (currentIndex < 0) {
            currentIndex = totalSlides - 1; // 마지막 슬라이드로 이동
        } else if (currentIndex >= totalSlides) {
            currentIndex = 0; // 첫 번째 슬라이드로 이동
        }

        const offset = -currentIndex * 100 + "%";
        slides.style.transform = "translateX(" + offset + ")";
    }
</script>
