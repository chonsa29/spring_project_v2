package com.example.demo.model;

import java.util.List;

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
    private String orderCount;
    private String zipCode;
    private String sale;
    private String leaderId;
    private String joinDate;
    private String gradeName;
    private String groupName;
    private int notiId;
    private String groupStatus;
    private String monthSpent;
    private Integer groupDiscountRate; 
    private String groupRole;
    private List<Member> groupMembers; 
}
