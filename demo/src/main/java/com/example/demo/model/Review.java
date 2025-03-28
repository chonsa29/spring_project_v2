package com.example.demo.model;

import lombok.Data;

@Data
public class Review {

	private String reviewNo;
	private String orderKey;
	private String itemNo;
	private String userId;
	private String userName;
	private String reviewTitle;
	private String reviewScore;
	private String cDatetime;
	private String reviewContents;
	
}
