package com.example.demo.model;

import lombok.Data;

@Data
public class Question {
	
	private String qsNo;
	private String userId;
	private String qsTitle;
	private String qsContents;
	private String qsStatus;
	private String itemNo;
	private String cdatetime;
	private String viewCnt;
	private String qsCategory;

}
