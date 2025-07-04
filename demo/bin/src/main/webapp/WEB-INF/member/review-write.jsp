<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/star-rating.js@4.3.0/css/star-rating.min.css">
    <style>
        .review-container {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
        }
        .preview-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            margin-right: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .rating-container {
            font-size: 24px;
            margin: 15px 0;
        }
        .star {
            cursor: pointer;
            color: #ddd;
        }
        .star.active {
            color: #ffc107;
        }
    </style>
</head>
<body>
    <div class="container review-container">
        <h2 class="mb-4">리뷰 작성</h2>
        <p class="text-muted">주문번호: ${orderKey} | 상품번호: ${itemNo}</p>
        
        <form action="/review/submit" method="post" enctype="multipart/form-data">
            <input type="hidden" name="orderKey" value="${orderKey}">
            <input type="hidden" name="itemNo" value="${itemNo}">
            
            <!-- 평점 선택 -->
            <div class="mb-4">
                <label class="form-label">상품 평가</label>
                <div class="rating-container">
                    <span class="star" data-value="1">★</span>
                    <span class="star" data-value="2">★</span>
                    <span class="star" data-value="3">★</span>
                    <span class="star" data-value="4">★</span>
                    <span class="star" data-value="5">★</span>
                    <input type="hidden" name="rating" id="rating-value" required>
                </div>
            </div>
            
            <!-- 리뷰 내용 -->
            <div class="mb-4">
                <label for="content" class="form-label">리뷰 내용</label>
                <textarea class="form-control" id="content" name="content" rows="5" 
                          placeholder="상품 사용 후기를 자세히 작성해주세요." required></textarea>
            </div>
            
            <!-- 이미지 업로드 -->
            <div class="mb-4">
                <label for="images" class="form-label">사진 첨부 (최대 3장)</label>
                <input type="file" class="form-control" id="images" name="images" 
                       multiple accept="image/*" onchange="previewImages(this)">
                <div id="image-preview" class="d-flex flex-wrap mt-2"></div>
            </div>
            
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">리뷰 등록</button>
                <a href="/order/detail/${orderKey}" class="btn btn-outline-secondary">취소</a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 별점 선택 기능
        document.querySelectorAll('.star').forEach(star => {
            star.addEventListener('click', function() {
                const value = this.getAttribute('data-value');
                document.getElementById('rating-value').value = value;
                
                document.querySelectorAll('.star').forEach(s => {
                    s.classList.toggle('active', s.getAttribute('data-value') <= value);
                });
            });
        });

        // 이미지 미리보기
        function previewImages(input) {
            const preview = document.getElementById('image-preview');
            preview.innerHTML = '';
            
            if (input.files.length > 3) {
                alert('최대 3장까지 업로드 가능합니다.');
                input.value = '';
                return;
            }
            
            Array.from(input.files).forEach(file => {
                if (!file.type.match('image.*')) {
                    alert('이미지 파일만 업로드 가능합니다.');
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'preview-image';
                    preview.appendChild(img);
                }
                reader.readAsDataURL(file);
            });
        }
    </script>
</body>
</html>