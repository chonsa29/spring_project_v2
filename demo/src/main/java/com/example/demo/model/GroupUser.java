package com.example.demo.model;

import lombok.Data;

@Data
public class GroupUser {
	
	private String groupId;
	private String userId;
	private String joinDate;
	private String status;
	private String role;
	private String groupName;
	private String leaderId;

}
