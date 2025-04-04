package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.model.InquireChatMessage;
import com.example.demo.dao.InquireChatService;


@RestController
@RequestMapping("/gemini")
public class InquireChatController {

	@Autowired
    private InquireChatService inquireChatService;
	
	public InquireChatController(InquireChatService inquireChatService) {
        this.inquireChatService = inquireChatService;
    }

    @PostMapping("/chat")
    public Map<String, Object> chat(@RequestBody InquireChatMessage inquireChatMessage) {
        String reply = inquireChatService.getGeminiResponse(inquireChatMessage.getMessage());

        Map<String, Object> result = new HashMap<>();
        result.put("reply", reply);
        return result;
    }

}
