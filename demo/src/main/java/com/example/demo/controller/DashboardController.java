package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
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
import com.example.demo.model.Reply;

@RestController
@RequestMapping(value = "/admin/dashboard", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
public class DashboardController {

	@Autowired
	private DashboardService dashboardService;

	@RequestMapping(value = "/inquiryList.dox", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> getInquiryList(@RequestParam(defaultValue = "all") String type,
			@RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int size) {

		Map<String, Object> result = new HashMap<>();
		try {
			Map<String, Object> params = new HashMap<>();
			params.put("type", type);
			params.put("offset", (page - 1) * size);
			params.put("limit", size);

			System.out.println(params);
			// 문의 타입별 분기 처리
			if ("product".equals(type)) {
				result.put("list", dashboardService.selectProductInquiryList(params));
				result.put("total", dashboardService.selectProductInquiryCount(params));
			} else {
				result.put("list", dashboardService.selectInquiryList2(params));
				result.put("total", dashboardService.selectInquiryCount(params));
			}

			result.put("result", "success");
		} catch (Exception e) {
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
	}

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

	@PostMapping("/toggleProductStatus.dox")
	@ResponseBody
	public Map<String, Object> toggleProductStatus(@RequestParam int itemNo, @RequestParam String currentStatus) {

		Map<String, Object> result = new HashMap<>();
		try {
			String newStatus = "Y".equals(currentStatus) ? "N" : "Y";
			dashboardService.updateProductStatus(itemNo, newStatus);
			result.put("result", "success");
			result.put("newStatus", newStatus);
		} catch (Exception e) {
			result.put("result", "fail");
			result.put("message", e.getMessage());
		}
		return result;
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
	public List<Question> getDashboardInquiries(@RequestParam(defaultValue = "all") String status) {

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

	// 배송 목록 조회
	@GetMapping("/delivery/list")
	public Map<String, Object> getDeliveryList(@RequestParam(required = false) String searchType,
			@RequestParam(required = false) String searchKeyword, @RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "10") int size) {

		Map<String, Object> result = dashboardService.getDeliveryList(searchType, searchKeyword, page, size);

		// 안전한 로깅 방식으로 변경
		List<?> list = (List<?>) result.get("list");
		System.out.println("Total count: " + result.get("total"));
		System.out.println("List size: " + list.size());

		if (!list.isEmpty()) {
			System.out.println("First item: " + list.get(0));
		} else {
			System.out.println("List is empty");
		}

		return result;
	}

	@GetMapping("/delivery/detail/{deliveryNo}")
	public ResponseEntity<Map<String, Object>> getDeliveryDetail(@PathVariable int deliveryNo) {

		Map<String, Object> deliveryDetail = dashboardService.getDeliveryDetail(deliveryNo);

		if (deliveryDetail == null || deliveryDetail.isEmpty()) {
			return ResponseEntity.notFound().build();
		}

		return ResponseEntity.ok(deliveryDetail);
	}

	// 배송 상태 업데이트
	@PostMapping("/delivery/updateStatus")
	public ResponseEntity<?> updateDeliveryStatus(@RequestParam int deliveryNo, @RequestParam String status) {

		dashboardService.updateDeliveryStatus(deliveryNo, status);
		return ResponseEntity.ok().build();
	}

	// 운송장 번호 등록/수정
	@PostMapping("/delivery/updateTracking")
	public ResponseEntity<?> updateTrackingNumber(@RequestParam int deliveryNo, @RequestParam String trackingNumber) {

		dashboardService.updateTrackingNumber(deliveryNo, trackingNumber);
		return ResponseEntity.ok().build();
	}

	@GetMapping("/inquiry/replies")
	public ResponseEntity<List<Reply>> getReplies2(@RequestParam("qsNo") int qsNo) {
		// 답변 목록을 조회하는 서비스 메소드 호출
		List<Reply> replies = dashboardService.getReplies2(qsNo);

		if (replies != null && !replies.isEmpty()) {
			return ResponseEntity.ok(replies);
		} else {
			return ResponseEntity.status(HttpStatus.SC_NOT_FOUND).body(null); // 답변이 없으면 404
		}
	}

	// 답변 등록 (일반 문의/상품 문의 통합)
	@PostMapping("/inquiry/reply")
	public ResponseEntity<?> addInquiryReply(@RequestBody QuestionReply reply, 
	                                       @RequestHeader(value = "X-Admin-Id", required = false) String adminId) {
	    if (adminId != null) {
	        reply.setAdminId(adminId);
	    }
	    dashboardService.addReply(reply);
	    return ResponseEntity.ok().build();
	}

	// 답변 수정
	@PutMapping("/reply/{replyNo}")
	public ResponseEntity<?> updateReply(@PathVariable int replyNo, 
	                                    @RequestBody QuestionReply reply,
	                                    @RequestHeader(value = "X-Admin-Id", required = false) String adminId) {
	    reply.setReplyNo(replyNo);
	    if (adminId != null) {
	        reply.setAdminId(adminId);
	    }
	    dashboardService.updateReply(reply);
	    return ResponseEntity.ok().build();
	}

	// 답변 삭제
	@DeleteMapping("/reply/{replyNo}")	
	public ResponseEntity<?> deleteReply(@PathVariable int replyNo) {
	    dashboardService.deleteReply(replyNo);
	    return ResponseEntity.ok().build();
	}
}