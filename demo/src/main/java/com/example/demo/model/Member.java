package com.example.demo.model;

import lombok.Data;

@Data
public class Member {

	private String userId ;
	private String password ;
	private String name ;
	private String email ;
	private String phone ;
	private String address ;
	private String memberTier ;
	private String deleted ;
	private String createdAt ;
	private String userName;
	private String status;
	private String nickName;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}
