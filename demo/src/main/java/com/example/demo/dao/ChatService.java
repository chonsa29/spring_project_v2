package com.example.demo.dao;

import com.example.demo.mapper.ChatMessageMapper;
import com.example.demo.model.ChatMessage;
import com.example.demo.model.Group;
import com.example.demo.model.GroupUser;

import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Optional;

@Service
public class ChatService {
    private final ChatMessageMapper chatMessageMapper;

    public ChatService(ChatMessageMapper chatMessageMapper) {
        this.chatMessageMapper = chatMessageMapper;
    }

    public void saveMessage(ChatMessage message) {
        chatMessageMapper.saveMessage(message);
    }

    public List<ChatMessage> getChatHistory(String groupId) {
    	List<ChatMessage> chatMessages = chatMessageMapper.findMessagesByGroupId(groupId);
        return chatMessages;
    }
    
    // 방에 입장한 적 있는지
    public boolean hasUserJoined(String groupId, String userId) {
        return chatMessageMapper.countUserJoinMessages(groupId, userId) > 0;
    }

    public String getGroupName(String groupId) {
        return chatMessageMapper.getGroupNameById(groupId);
    }

	public HashMap<String, Object> nickname(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Group> members =  chatMessageMapper.selectMembers(map);
			System.out.println("📌 members 데이터 확인: " + members);
			
			
			resultMap.put("members", members); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

	// join 상태 삭제
	public HashMap<String, Object> leave(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			chatMessageMapper.deleteJoin(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

}
