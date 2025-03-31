package com.example.demo.model;

import java.util.Date;

import lombok.Data;

@Data
public class Member {

	private String userId;
    private Integer groupId;
    private String password;
    private String userName;
    private String address;
    private String email;
    private String birth;
    private String gender;
    private String phone;
    private String status;
    private String nickname;
    private Integer grade;
    private String allergy;
    private Integer point;
    private String regDate;
    private Integer remainPoint;
    private String recentOrderKey;
    private String orderStatus;
    private String orderDate;
    private String recentWishProduct;
    private String wishCount;
    private String couponNo;
    private String isUsed;
    private String couponName;
    private String expireDate;
    private String discountAmount;
    private String qsNo;
    private String qsTitle;
    private String qsContents;
    private String cDateTime;
    private String qsStatus;
    
    // 추가 필드 (DB에는 없지만 화면에 표시하기 위해 사용)
    private String gradeName;
    private String groupName;

}
