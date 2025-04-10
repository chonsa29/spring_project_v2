package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dao.EmailService;

@RestController
@RequestMapping("/email")
public class EmailController {

    @Autowired
    private EmailService emailService;

    private final Map<String, String> emailCodeMap = new ConcurrentHashMap<>();

    @PostMapping("/send-code")
    public ResponseEntity<?> sendEmailCode(@RequestParam String email) {
        String code = emailService.generateCode();
        emailService.sendVerificationEmail(email, code);
        emailCodeMap.put(email, code);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/verify-code")
    public Map<String, Object> verifyCode(@RequestParam String email, @RequestParam String code) {
        boolean verified = code.equals(emailCodeMap.get(email));
        Map<String, Object> result = new HashMap<>();
        result.put("verified", verified);
        return result;
    }
}