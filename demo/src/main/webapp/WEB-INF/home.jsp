<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MealPick - 밀키트 쇼핑몰</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .logo {
            font-size: 24px;
            font-weight: bold;
        }
        .nav {
            display: flex;
            gap: 20px;
        }
        .slider {
            position: relative;
            width: 100%;
            max-width: 1000px;
            margin: auto;
            overflow: hidden;
        }
        .slides {
            display: flex;
            transition: transform 0.5s ease-in-out;
        }
        .slide {
            min-width: 100%;
            transition: opacity 1s;
        }
        .slide img {
            width: 100%;
            height: auto;
            display: block;
        }
        .prev, .next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.5);
            color: white;
            border: none;
            padding: 10px;
            cursor: pointer;
            font-size: 20px;
        }
        .prev {
            left: 10px;
        }
        .next {
            right: 10px;
        }
        .floating-icon {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 60px;
            height: 60px;
            background: #4CAF50;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease-in-out;
        }
        .floating-icon:hover {
            transform: scale(1.1);
        }
        .floating-icon img {
            width: 40px;
            height: 40px;
        }
    </style>
</head>
<body>

    <header class="header">
        <div class="logo">MEALPICK</div>
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
            <div class="slide"><img src="image1.jpg" alt="슬라이드 이미지 1"></div>
            <div class="slide"><img src="image2.jpg" alt="슬라이드 이미지 2"></div>
            <div class="slide"><img src="image3.jpg" alt="슬라이드 이미지 3"></div>
        </div>
        <button class="prev" onclick="moveSlide(-1)">&#10094;</button>
        <button class="next" onclick="moveSlide(1)">&#10095;</button>
    </div>

    <div class="floating-icon">
        <img src="icon.png" alt="아이콘">
    </div>

    <script>
        let slideIndex = 0;
        const slides = document.querySelector(".slides");
        const totalSlides = document.querySelectorAll(".slide").length;

        function moveSlide(n) {
            slideIndex += n;
            if (slideIndex >= totalSlides) slideIndex = 0;
            if (slideIndex < 0) slideIndex = totalSlides - 1;
            updateSlide();
        }

        function updateSlide() {
            slides.style.transform = `translateX(${-slideIndex * 100}%)`;
        }

        function autoSlide() {
            moveSlide(1);
        }

        setInterval(autoSlide, 3000);
    </script>

</body>
</html>
