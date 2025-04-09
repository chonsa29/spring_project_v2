package com.example.demo.model;

import lombok.Data;

@Data
public class QuestionReply {
	private int replyNo;
    private int qsNo; // 문의 번호(FK)
    private String userId; // 문의 작성자
    private String replyContents; // 답변 내용
    private String adminId; // 답변 관리자 ID
}
