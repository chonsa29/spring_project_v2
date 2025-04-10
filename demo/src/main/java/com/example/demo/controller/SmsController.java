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

import com.example.demo.dao.SmsService;

@RestController
@RequestMapping("/sms")
public class SmsController {

    private final SmsService smsService;
    private final Map<String, String> smsCodeMap = new ConcurrentHashMap<>();

    @Autowired
    public SmsController(SmsService smsService) {
        this.smsService = smsService;
    }

    @PostMapping("/send")
    public ResponseEntity<?> sendCode(@RequestParam String phoneNum) {
        String code = String.valueOf((int)(Math.random() * 900000) + 100000);
        smsService.sendSms(phoneNum, code);
        smsCodeMap.put(phoneNum, code);
        return ResponseEntity.ok("인증번호 전송 완료");
    }

    @PostMapping("/verify")
    public Map<String, Object> verifyCode(@RequestParam String phoneNum, @RequestParam String code) {
        boolean result = code.equals(smsCodeMap.get(phoneNum));
        Map<String, Object> map = new HashMap<>();
        map.put("verified", result);
        return map;
    }
}
