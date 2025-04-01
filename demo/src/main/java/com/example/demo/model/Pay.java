package com.example.demo.model;

import lombok.Data;

@Data
public class Pay {

	private String itemNo;
    private String itemName;
    private int price;
    private String itemCount;
    private String filePath;

    // 주문자 정보
    private String userId;
    private String ordererName;
    private String ordererPhone;
    private String address;
    private String point;

    // 쿠폰 정보
    private String couponName;
    private String discountAmount;

    // 주문 요약
    private String pNo;
    private int pPrice;
    private String pWay;
    private String pDate;
    private String pUid;

    // 배송비
    private int deliveryFee;
	
}
