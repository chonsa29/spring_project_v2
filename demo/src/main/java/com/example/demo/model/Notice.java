package com.example.demo.model;

import lombok.Data;

@Data
public class Notice {
	
	private String noticeNo;
	private String noticeTitle;
	private String noticeContents;
	private String noticeDate;
	private String noticeCategory;
	private int viewCnt;
	private String prevNoticeNo;
	private String prevTitle;
	private String nextNoticeNo;
	private String nextTitle;

}
