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
	
}
