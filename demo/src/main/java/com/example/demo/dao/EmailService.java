package com.example.demo.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public String generateCode() {
        return String.valueOf((int)((Math.random() * 900000) + 100000)); // 6자리 숫자
    }

    public void sendVerificationEmail(String toEmail, String code) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("[회원가입] 이메일 인증 코드 안내");
        message.setText("인증 코드는 " + code + " 입니다.\n입력창에 정확히 입력해주세요.");
        mailSender.send(message);
    }
}





