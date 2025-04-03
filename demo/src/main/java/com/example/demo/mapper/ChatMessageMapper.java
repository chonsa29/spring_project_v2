package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.ChatMessage;

@Mapper
public interface ChatMessageMapper {
	
    void saveMessage(ChatMessage message);
    
    List<ChatMessage> findMessagesByGroupId(@Param("groupId") String groupId);

	int countUserJoinMessages(String groupId, String userId);
}

