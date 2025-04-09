package com.example.demo;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.demo.dao.CommunityService;


@Component
public class GroupScheduler {

	@Autowired
    private CommunityService communityService;

    // 매일 오전 9시에 실행 (그룹 삭제 3일 전 알림 전송)
    @Scheduled(cron = "0 0 9 * * ?")
    public void scheduleDeleteNotification() {
        System.out.println("[스케줄러 실행] 그룹 삭제 알림 전송 시작...");
        HashMap<String, Object> dummyMap = new HashMap<>();
        communityService.sendDeleteNotification(dummyMap);
        System.out.println("[스케줄러 완료] 알림 전송 완료");
    }
    
    @Scheduled(cron = "0 0 3 * * ?") // 매일 새벽 3시에 실행
    public void deleteExpiredGroups() {
    	communityService.deleteExpiredGroups(); // 1개월 지난 그룹 삭제
    }
}
