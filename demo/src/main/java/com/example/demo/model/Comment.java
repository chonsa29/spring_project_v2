package com.example.demo.model;

import lombok.Data;

@Data
public class Comment {
	
	private String commentId;
	private String postId;
	private String userId;
	private String contents;
	private String cdateTime;
	private String nickname;
	
}
