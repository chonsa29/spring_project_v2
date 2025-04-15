package com.example.demo.model;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Reply {
	private int replyNo;
	private String replyContents;
	private String adminId;
	private LocalDateTime createdAt;

}
