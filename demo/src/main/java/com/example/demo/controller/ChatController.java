package com.example.demo.controller;

import java.util.List;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import com.example.demo.dao.ChatService;
import com.example.demo.model.ChatMessage;

@Controller
@RequestMapping("/chatting")
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;

    public ChatController(SimpMessagingTemplate messagingTemplate, ChatService chatService) {
        this.messagingTemplate = messagingTemplate;
        this.chatService = chatService;
    }

    @GetMapping("/chatRoom")
    public String openChatRoom(@RequestParam("groupId") String groupId, Model model) {
    	List<ChatMessage> chatHistory = chatService.getChatHistory(groupId);
        model.addAttribute("groupId", groupId);
        model.addAttribute("chatHistory", chatHistory);
        return "chatting/chatRoom"; // ViewResolver가 WEB-INF 내부의 JSP를 찾게 됨
    }

    @MessageMapping("/chat.sendMessage") // 클라이언트에서 /app/chat.sendMessage로 보낸 메시지를 처리
    public void sendMessage(@Payload ChatMessage chatMessage) {
    	// 메시지 저장
        chatService.saveMessage(chatMessage);

        // 채팅방에 메시지 전송
        String destination = "/topic/groupChat/" + chatMessage.getGroupId();
        messagingTemplate.convertAndSend(destination, chatMessage);
    }
    
    @GetMapping("/chatHistory")
    @ResponseBody
    public List<ChatMessage> getChatHistory(@RequestParam("groupId") String groupId) {
        return chatService.getChatHistory(groupId);
    }
    
    @GetMapping("/joinStatus")
    @ResponseBody
    public boolean checkJoinStatus(@RequestParam("groupId") String groupId, @RequestParam("userId") String userId) {
        return chatService.hasUserJoined(groupId, userId);
    }
}
