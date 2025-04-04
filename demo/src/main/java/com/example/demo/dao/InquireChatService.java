package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class InquireChatService {
	
	@Value("${GEMINI_URL}")
    private String geminiUrl;

    @Value("${GEMINI_KEY}")
    private String geminiKey;

    public String getGeminiResponse(String userInput) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            
            String prompt = "고객이 제품에 불만이 있을 때, 너무 길지 않고 핵심만 간단하고 친절하게 답변해줘. "
                    + "마크다운 기호 없이 평문으로만 작성해.\n\n"
                    + "고객 질문: " + userInput;

            // 요청 바디 구성
            Map<String, Object> content = new HashMap<>();
            content.put("parts", List.of(Map.of("text", prompt)));

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("contents", List.of(content));

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            // ✅ 키를 쿼리 파라미터로 붙이기
            String fullUrl = geminiUrl + "?key=" + geminiKey;

            ResponseEntity<Map> response = restTemplate.postForEntity(fullUrl, entity, Map.class);

            // 응답 처리
            Map responseBody = response.getBody();
            if (responseBody != null && responseBody.containsKey("candidates")) {
                Map candidate = ((List<Map>) responseBody.get("candidates")).get(0);
                Map contentMap = (Map) candidate.get("content");
                List<Map> parts = (List<Map>) contentMap.get("parts");
                String text = (String) parts.get(0).get("text");

                // 마크다운 기호 제거
                text = text.replaceAll("\\*\\*", "")  // 굵게
                           .replaceAll("\\*", "")    // 기울임
                           .replaceAll("`", "");     // 코드블럭

                return text;
            } else {
                return "AI 응답을 불러올 수 없습니다.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "오류가 발생했습니다: " + e.getMessage();
        }
    }

}
