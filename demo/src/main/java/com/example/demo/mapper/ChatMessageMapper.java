package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.ChatMessage;
import com.example.demo.model.Group;

@Mapper
public interface ChatMessageMapper {
	
    void saveMessage(ChatMessage message);
    
    List<ChatMessage> findMessagesByGroupId(@Param("groupId") String groupId);

	int countUserJoinMessages(String groupId, String userId);

	String getGroupNameById(@Param("groupId") String groupId);

	List<Group> selectMembers(HashMap<String, Object> map);

	void deleteJoin(HashMap<String, Object> map);
}

