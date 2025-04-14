<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 상세 내역</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .order-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
        }
        .order-header {
            border-bottom: 2px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .delivery-card, .payment-card {
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .item-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
        }
        .review-btn {
            min-width: 100px;
        }
        .status-badge {
            font-size: 0.9em;
            padding: 5px 10px;
            border-radius: 15px;
        }
    </style>
</head>
<body>
    <div class="container order-container">
        <div class="order-header">
            <h2>주문 상세 정보</h2>
            <p class="text-muted">주문번호: ${order.orderKey}</p>
        </div>

        <!-- 주문 요약 -->
        <div class="row mb-4">
            <div class="col-md-6">
                <h5>주문 정보</h5>
                <p><strong>주문일자:</strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy.MM.dd HH:mm"/></p>
                <p><strong>주문상태:</strong> 
                    <span class="status-badge 
                        ${order.status == 'COMPLETED' ? 'bg-success' : 
                         order.status == 'CANCELED' ? 'bg-secondary' : 'bg-primary'} text-white">
                        ${order.status == 'COMPLETED' ? '주문완료' : 
                         order.status == 'CANCELED' ? '주문취소' : '처리중'}
                    </span>
                </p>
            </div>
            <div class="col-md-6">
                <h5>결제 정보</h5>
                <p><strong>총 결제금액:</strong> <fmt:formatNumber value="${order.totalPrice}"/>원</p>
                <p><strong>결제방법:</strong> ${order.paymentMethod}</p>
            </div>
        </div>

        <!-- 배송 정보 -->
        <div class="delivery-card">
            <h4>배송 정보</h4>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>수령인:</strong> ${delivery.recipientName}</p>
                    <p><strong>연락처:</strong> ${delivery.recipientPhone}</p>
                </div>
                <div class="col-md-6">
                    <p><strong>배송지:</strong> ${delivery.shippingAddress}</p>
                    <p><strong>송장번호:</strong> 
                        <a href="#" onclick="trackDelivery('${delivery.trackingNumber}')">
                            ${delivery.trackingNumber}
                        </a>
                    </p>
                </div>
            </div>
            <div class="mt-3">
                <div class="progress">
                    <div class="progress-bar 
                        ${delivery.status == 'DELIVERED' ? 'bg-success' : 
                         delivery.status == 'SHIPPED' ? 'bg-info' : 'bg-warning'}" 
                        role="progressbar" 
                        style="width: 
                        ${delivery.status == 'DELIVERED' ? '100%' : 
                         delivery.status == 'SHIPPED' ? '70%' : '30%'}">
                        ${delivery.status == 'DELIVERED' ? '배송완료' : 
                         delivery.status == 'SHIPPED' ? '배송중' : '상품준비중'}
                    </div>
                </div>
                <small class="text-muted">
                    <fmt:formatDate value="${delivery.estimatedArrival}" pattern="yyyy.MM.dd"/> 예상 도착
                </small>
            </div>
        </div>

        <!-- 주문 상품 목록 -->
        <h4 class="mt-4">주문 상품</h4>
        <table class="table">
            <thead>
                <tr>
                    <th>상품정보</th>
                    <th>수량</th>
                    <th>금액</th>
                    <th>리뷰</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${items}" var="item">
                    <tr>
                        <td>
                            <div class="d-flex">
                                <img src="${item.thumbnailImg}" class="item-img me-3">
                                <div>
                                    <p class="mb-1">${item.itemName}</p>
                                    <small class="text-muted">상품번호: ${item.itemNo}</small>
                                </div>
                            </div>
                        </td>
                        <td>${item.quantity}개</td>
                        <td><fmt:formatNumber value="${item.price * item.quantity}"/>원</td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status != 'COMPLETED'}">
                                    <button class="btn btn-sm btn-secondary review-btn" disabled>
                                        주문 완료 후 작성
                                    </button>
                                </c:when>
                                <c:when test="${item.reviewWritten}">
                                    <button class="btn btn-sm btn-success review-btn" disabled>
                                        작성 완료
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="/review/write/${item.itemNo}/${order.orderKey}" 
                                       class="btn btn-sm btn-primary review-btn">
                                        리뷰 작성
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="d-flex justify-content-between mt-4">
            <a href="/member/mypage.do?tab=orders" class="btn btn-outline-secondary">
                주문목록으로
            </a>
            <c:if test="${order.status == 'PROCESSING'}">
                <button class="btn btn-danger" onclick="cancelOrder('${order.orderKey}')">
                    주문 취소
                </button>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function trackDelivery(trackingNumber) {
            window.open(`https://tracker.delivery/#/${trackingNumber}`, '_blank');
        }

        function cancelOrder(orderKey) {
            if (confirm('정말 주문을 취소하시겠습니까?')) {
                fetch('/order/cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ orderKey: orderKey })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('주문이 취소되었습니다.');
                        location.reload();
                    } else {
                        alert('주문 취소 실패: ' + data.message);
                    }
                });
            }
        }
    </script>
</body>
</html>