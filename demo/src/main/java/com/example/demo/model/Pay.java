package com.example.demo.model;

import lombok.Data;

@Data
public class Pay {

	private String itemNo;
    private String itemName;
    private int price;
    private String filePath;

    // 주문자 정보
    private String userId;
    private String ordererName;
    private String ordererPhone;
    private String address;
    private int point;

    // 쿠폰 정보
    private String couponName;
    private int discountAmount;

    // 주문 요약
    private String pNo;
    private int pPrice;
    private String pWay;

    // 배송비
    private int deliveryFee;
	
}
