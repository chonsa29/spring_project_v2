package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dao.DashboardService;
import com.example.demo.model.Question;
import com.example.demo.model.QuestionReply;

@RestController
@RequestMapping(value = "/admin/dashboard", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
public class DashboardController {

	@Autowired
	private DashboardService dashboardService;

	@PostMapping("/todayStats.dox")
	@ResponseBody
	public Map<String, Object> getTodayStats() {
		Map<String, Object> result = new HashMap<>();
		result.put("todayOrders", dashboardService.getTodayOrderCount());
		result.put("todayCancelRequests", dashboardService.getTodayCancelRequestCount());
		result.put("todayDeliveries", dashboardService.getTodayDeliveryCount());
		result.put("pendingInquiries", dashboardService.getPendingInquiryCount());
		return result;
	}

	@PostMapping("/weeklySales.dox")
	@ResponseBody
	public List<Map<String, Object>> getWeeklySales() {
		return dashboardService.getWeeklySales();
	}

	@PostMapping("/recentOrders.dox")
	@ResponseBody
	public List<Map<String, Object>> getRecentOrders() {
		return dashboardService.getRecentOrders();
	}

	@PostMapping("/topProducts.dox")
	@ResponseBody
	public List<Map<String, Object>> getTopProducts() {
		return dashboardService.getTopProducts();
	}

	// 게시판 목록 조회 (GET /admin/boards)
	@GetMapping("/boards")
	public Map<String, Object> getPosts(@RequestParam(required = false) String keyword,
			@RequestParam(required = false) String boardType, @RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "10") int size) {

		Map<String, Object> params = new HashMap<>();
		params.put("keyword", keyword);
		params.put("boardType", boardType);
		params.put("offset", (page - 1) * size);
		params.put("limit", size); // size → limit으로 변환

		return dashboardService.getPostList(keyword, boardType, page);
	}

	// 게시글 삭제 (DELETE /admin/boards/{id})
	@DeleteMapping("/boards/{id}")
	public ResponseEntity<?> deleteBoard(@PathVariable int id) {
		dashboardService.deleteRecipe(id);
		return ResponseEntity.ok().build();
	}

	// 문의 목록 조회
    @GetMapping("/inquiries") // GET /admin/dashboard/inquiries
    public List<Question> getDashboardInquiries(
            @RequestParam(defaultValue = "all") String status) {
  
        return dashboardService.getInquiries(status);
    }

	// 답변 등록
	@PostMapping("/inquiries/{qsNo}/reply")
	public void addReply(@PathVariable int qsNo, @RequestBody QuestionReply reply,
			@RequestHeader("X-Admin-Id") String adminId) {
		reply.setQsNo(qsNo);
		reply.setAdminId(adminId); // 헤더에서 관리자 ID 추출
		dashboardService.addReply(reply);
	}

	// 답변 목록 조회
	@GetMapping("/{qsNo}/replies")
	public List<QuestionReply> getReplies(@PathVariable int qsNo) {
		return dashboardService.getReplies(qsNo);
	}

	// 답변 삭제
	@DeleteMapping("/replies/{replyNo}")
	public void deleteReply(@PathVariable int replyNo, @RequestParam int qsNo) {
		dashboardService.deleteReply(replyNo, qsNo);
	}
	
	   // 배송 목록 조회
    @GetMapping("/delivery/list")
    public Map<String, Object> getDeliveryList(
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String searchKeyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        return dashboardService.getDeliveryList(searchType, searchKeyword, page, size);
    }

    // 배송 상태 업데이트
    @PostMapping("/delivery/updateStatus")
    public ResponseEntity<?> updateDeliveryStatus(
            @RequestParam int deliveryNo,
            @RequestParam String status) {
        
        dashboardService.updateDeliveryStatus(deliveryNo, status);
        return ResponseEntity.ok().build();
    }

    // 운송장 번호 등록/수정
    @PostMapping("/delivery/updateTracking")
    public ResponseEntity<?> updateTrackingNumber(
            @RequestParam int deliveryNo,
            @RequestParam String trackingNumber) {
        
        dashboardService.updateTrackingNumber(deliveryNo, trackingNumber);
        return ResponseEntity.ok().build();
    }
}