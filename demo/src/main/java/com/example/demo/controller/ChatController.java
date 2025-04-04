package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import com.example.demo.dao.ChatService;
import com.example.demo.dao.CommunityService;
import com.example.demo.model.ChatMessage;
import com.example.demo.model.Group;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;


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
    	String groupName = chatService.getGroupName(groupId);
    	
        model.addAttribute("groupId", groupId);
        model.addAttribute("groupName", groupName);
        model.addAttribute("chatHistory", chatHistory);
        return "chatting/chatRoom"; // ViewResolver가 WEB-INF 내부의 JSP를 찾게 됨
    }

    @MessageMapping("/chat.sendMessage") // 클라이언트에서 /app/chat.sendMessage로 보낸 메시지를 처리
    public void sendMessage(@Payload ChatMessage chatMessage) {
    	// 만약 JOIN 메시지라면 중복 여부 먼저 체크
        if ("JOIN".equals(chatMessage.getMessageType())) {
            boolean alreadyJoined = chatService.hasUserJoined(chatMessage.getGroupId(), chatMessage.getSender());
            System.out.println("이미 입장 여부: " + alreadyJoined);
            
            if (alreadyJoined) {
                System.out.println("이미 입장한 유저의 JOIN 메시지입니다. 저장 및 전송 생략.");
                return; // 더 이상 진행하지 않음
            }
        }

        // 메시지 저장
        chatService.saveMessage(chatMessage);

        // 채팅방에 메시지 전송
        String destination = "/topic/groupChat/" + chatMessage.getGroupId();
        messagingTemplate.convertAndSend(destination, chatMessage);
        
        System.out.println("📩 서버에서 받은 메시지: " + chatMessage);
    }
    
    @GetMapping("/chatHistory")
    @ResponseBody
    public List<ChatMessage> getChatHistory(@RequestParam("groupId") String groupId) {
        return chatService.getChatHistory(groupId);
    }
    
    @GetMapping("/joinStatus")
    @ResponseBody
    public boolean checkJoinStatus(@RequestParam("groupId") String groupId, @RequestParam("userId") String userId) {
    	System.out.println(userId);
    	if (userId == null || userId.isEmpty()) {
            System.out.println("❌ userId가 비어 있음! groupId: " + groupId);
            return false;
        }

        boolean hasJoined = chatService.hasUserJoined(groupId, userId);
        System.out.println("✅ [" + userId + "]의 그룹 [" + groupId + "] 참여 여부: " + hasJoined);
        return hasJoined;
    }
    
    @RequestMapping(value = "/chat/nickname.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String nickname(Model model, @RequestParam HashMap<String, Object> map) throws Exception {			
    	System.out.println("📌 닉네임 API 호출됨!");
        System.out.println("📌 요청 파라미터: " + map);
    	
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();
    	
		resultMap = chatService.nickname(map);
		
		System.out.println("📌 응답 데이터: " + resultMap);
		
		return new Gson().toJson(resultMap);
	}
    
    @RequestMapping(value = "/chat/leave.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String leave(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	System.out.println("💡 클라이언트에서 받은 값: " + map);
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();
    	
		resultMap = chatService.leave(map);
		
		return new Gson().toJson(resultMap);
	}
   
}
