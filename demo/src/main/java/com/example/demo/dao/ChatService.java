package com.example.demo.dao;

import com.example.demo.mapper.ChatMessageMapper;
import com.example.demo.model.ChatMessage;
import org.springframework.stereotype.Service;
import java.util.List;

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

}
