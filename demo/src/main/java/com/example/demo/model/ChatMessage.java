package com.example.demo.model;

import java.time.LocalDateTime;

public class ChatMessage {
	private String sender;  // 유저 아이디
    private String content; // 메시지 내용
    private MessageType messageType; // 메시지 타입 (CHAT, JOIN, LEAVE)
    private String groupId; // 그룹 ID
    private LocalDateTime createdAt; // 메시지 생성 시간

    public enum MessageType {
        CHAT, JOIN, LEAVE
    }

    // 기본 생성자
    public ChatMessage() {}

    public ChatMessage(String sender, String content, MessageType messageType, String groupId) {
        this.sender = sender;
        this.content = content;
        this.messageType = messageType;
        this.groupId = groupId;
        this.createdAt = LocalDateTime.now();
    }

    // Getter & Setter
    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public MessageType getMessageType() {
        return messageType;
    }

    public void setType(MessageType messageType) {
        this.messageType = messageType;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    
    
}
