package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.DashboardMapper;
import com.example.demo.model.Question;
import com.example.demo.model.QuestionReply;
import com.example.demo.model.Reply;

import jakarta.transaction.Transactional;

@Service
public class DashboardService {

	@Autowired
	private DashboardMapper dashboardMapper;

	public int getTodayOrderCount() {
		return dashboardMapper.selectTodayOrderCount();
	}

	public int getTodayCancelRequestCount() {
		return dashboardMapper.selectTodayCancelRequestCount();
	}

	public int getTodayDeliveryCount() {
		return dashboardMapper.selectTodayDeliveryCount();
	}

	public int getPendingInquiryCount() {
		return dashboardMapper.selectPendingInquiryCount();
	}

	public List<Map<String, Object>> getWeeklySales() {
		return dashboardMapper.selectWeeklySales();
	}

	public List<Map<String, Object>> getRecentOrders() {
		return dashboardMapper.selectRecentOrders();
	}

	public List<Map<String, Object>> getTopProducts() {
		return dashboardMapper.selectTopProducts();
	}

	public Map<String, Object> getPostList(String keyword, String boardType, int page) {
		Map<String, Object> params = new HashMap<>();
		params.put("keyword", keyword);
		params.put("boardType", boardType);
		params.put("offset", (page - 1) * 10);
		params.put("limit", 10);

		Map<String, Object> result = new HashMap<>();
		result.put("data", dashboardMapper.selectRecipeList(params));
		result.put("total", dashboardMapper.selectRecipeCount(params));
		return result;
	}

	public void deleteRecipe(int postId) {
		dashboardMapper.deleteRecipe(postId);
	}

	// 문의 목록 조회
	public List<Question> getInquiries(String status) {
		Map<String, Object> params = new HashMap<>();
		if (!"all".equals(status)) {
			params.put("status", status.equals("pending") ? "1" : "0"); // "pending" → "0", "completed" → "1"
		}
		System.out.println(params);
		return dashboardMapper.selectInquiryList(params);
	}

	// 답변 등록 + 상태 변경
	@Transactional
	public void addReply(QuestionReply reply) {
		// 필수 필드 검증 추가
		if (reply.getAdminId() == null || reply.getAdminId().isEmpty()) {
			throw new IllegalArgumentException("관리자 ID는 필수입니다.");
		}
		dashboardMapper.insertReply(reply);
		dashboardMapper.updateInquiryStatus(reply.getQsNo(), "1"); // 상태를 '1'(완료)로 업데이트
	}

	// 답변 목록 조회
	public List<QuestionReply> getReplies(int qsNo) {
		return dashboardMapper.selectRepliesByQsNo(qsNo);
	}

	// 답변 삭제 + 상태 롤백
	@Transactional
	public void deleteReply(int replyNo, int qsNo) {
		dashboardMapper.deleteReply(replyNo);
		// 답변이 더 이상 없으면 상태 변경
		if (dashboardMapper.selectRepliesByQsNo(qsNo).isEmpty()) {
			dashboardMapper.updateInquiryStatus(qsNo, "1");
		}
	}

	public Map<String, Object> getDeliveryDetail(int deliveryNo) {
		Map<String, Object> params = new HashMap<>();
		params.put("deliveryNo", deliveryNo);

		return dashboardMapper.selectDeliveryDetail(params);
	}

	public Map<String, Object> getDeliveryList(String searchType, String searchKeyword, int page, int size) {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		params.put("offset", (page - 1) * size);
		params.put("limit", size);

		System.out.println("Executing with params: " + params);

		List<Map<String, Object>> list = dashboardMapper.selectDeliveryList(params);
		int total = dashboardMapper.selectDeliveryCount(params);

		System.out.println("Query returned " + list.size() + " items");
		System.out.println("Total count from DB: " + total);

		return Map.of("list", list, "total", total);
	}

	public void updateDeliveryStatus(int deliveryNo, String status) {
		dashboardMapper.updateDeliveryStatus(deliveryNo, status);
	}

	public void updateTrackingNumber(int deliveryNo, String trackingNumber) {
		dashboardMapper.updateTrackingNumber(deliveryNo, trackingNumber);
	}

	@Transactional
	public void updateProductStatus(int itemNo, String status) {
		Map<String, Object> params = new HashMap<>();
		params.put("itemNo", itemNo);
		params.put("status", status);
		dashboardMapper.updateProductStatus(params);
	}

	public List<Map<String, Object>> selectProductInquiryList(Map<String, Object> params) {
		return dashboardMapper.selectProductInquiryList(params);
	}

	public int selectProductInquiryCount(Map<String, Object> params) {
		return dashboardMapper.selectProductInquiryCount(params);
	}

	public List<Map<String, Object>> selectInquiryList2(Map<String, Object> params) {
		return dashboardMapper.selectInquiryList2(params);
	}

	public int selectInquiryCount(Map<String, Object> params) {
		return dashboardMapper.selectInquiryCount(params);
	}

	// 상품 문의 답변 추가
	@Transactional
	public void addProductInquiryReply(QuestionReply reply) {
		dashboardMapper.insertProductInquiryReply(reply);
		dashboardMapper.updateProductInquiryStatus(reply.getQsNo(), "1");
	}

	// 답변 수정
	@Transactional
	public void updateReply(QuestionReply reply) {
		dashboardMapper.updateReply(reply);
	}

	// 상품 문의 상세 조회 추가
	public Map<String, Object> getProductInquiryDetail(int iqNo) {
		return dashboardMapper.selectProductInquiryDetail(iqNo);
	}

	public List<Reply> getReplies(int qsNo, String type) {
		// `qsNo`와 `type`에 맞는 답변 목록을 가져오는 Mapper 호출
		return dashboardMapper.selectReplies(qsNo, type);
	}
}