package com.example.demo.dao;

import org.springframework.stereotype.Service;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.service.DefaultMessageService;
import net.nurigo.sdk.message.model.Message;

@Service
public class SmsService {

	   private final DefaultMessageService messageService;

	    public SmsService() {
	    	 try {
    	        this.messageService = NurigoApp.INSTANCE.initialize(
    	            "NCSUUI8RLSD5AEOQ",
    	            "H38T2Q6TJX4IDWWYSOSU2CCKU56T9PMR",
    	            "https://api.coolsms.co.kr"
    	        );
    	    } catch (Exception e) {
    	        e.printStackTrace();
    	        throw new RuntimeException("SMS 초기화 실패");
    	    }
	    }

	    public void sendSms(String to, String code) {
	        Message message = new Message();
	        message.setFrom("01020908432");  // 발신자 번호 (승인된 번호여야 함)
	        message.setTo(to);               // 수신자 번호
	        message.setText("[본인인증] 인증번호: " + code);


	        try {
	            messageService.send(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }



}