package com.example.demo.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class Comment {
	
	private String commentId;
	private String postId;
	private String userId;
	private String contents;
	private String cdateTime;
	private String nickname;
	
	private String parentId;
	private List<Comment> replies = new ArrayList<Comment>();
	
	
}
