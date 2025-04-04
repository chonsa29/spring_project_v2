package com.example.demo.model;

import lombok.Data;

@Data
public class Group {
	
	private String postId;
	private String postCategory;
	private String userId;
	private String contents;
	private String cdatetime;
	private String viewCnt;
	private int likes;
	
	private String title;
	private String groupId;
//	private String userId;
	private String joinDate;
	private String status;
	private String role;
	private String groupName;
	private String leaderId;
	
//	private String groupId;
//	private String postId;
//	private String groupName;
//	private String leaderId;
	private String createDate; 
	
	public String nickname;
}
