package com.example.demo.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ChatController {
	@RequestMapping("/chat.do") 
    public String add(Model model) throws Exception{
        return "/chatting/chat"; 
    }
	@RequestMapping("/gemini.do") 
    public String gemini(Model model) throws Exception{
        return "/chatting/gemini"; 
    }
    @MessageMapping("/sendMessage") // 클라이언트에서 "/app/sendMessage"로 요청 시 실행
    @SendTo("/topic/public") // 메시지를 "/topic/public"을 구독하는 모든 사용자에게 전송
    public String sendMessage(String message) {
        System.out.println("Received message: " + message); // 로그 확인
        return message;
    }
}
