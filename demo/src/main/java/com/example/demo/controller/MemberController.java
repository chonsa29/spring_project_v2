package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.CommunityService;
import com.example.demo.dao.MemberService;
import com.example.demo.model.Delivery;
import com.example.demo.model.Member;
import com.example.demo.model.Review2;
import com.example.demo.model.ReviewDTO;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;



@Controller
public class MemberController {
	@Autowired
	MemberService memberService;

	@Autowired
	CommunityService communityService;

	@Autowired
	HttpSession session;

	// GET 요청 처리 추가
	@GetMapping("/member/withdraw.do")
	public String withdrawPage(Model model) {
		return "/member/withdraw"; // 탈퇴 페이지 뷰 반환
	}

	@RequestMapping("/member/login.do")
	public String login(Model model) throws Exception {
		return "/member/login";
	}

	@RequestMapping("/member/join.do")
	public String join(Model model) throws Exception {

		return "/member/join";
	}

	@RequestMapping("/member/term.do")
	public String term(Model model) throws Exception {

		return "/member/term";
	}

	@RequestMapping("/member/mypage.do")
	public String mypage(Model model) throws Exception {
		return "/member/mypage";
	}

	@RequestMapping("/member/admin.do")
	public String admin(Model model) throws Exception {

		return "/member/admin-page";
	}
	
	@RequestMapping("/member/repwd.do")

	public String repwd(Model model) throws Exception {

		return "/member/find-password";

	}

	@RequestMapping(value = "/member/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = memberService.searchMember(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/get.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String get(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.getMember(map);
		return new Gson().toJson(resultMap);
	}

	@CrossOrigin(origins = "http://localhost:8080", allowCredentials = "true")
	@RequestMapping(value = "/member/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = memberService.findMember(map);
		if ("success".equals(resultMap.get("result"))) {
			Member member = (Member) resultMap.get("member");
			session.setAttribute("sessionId", member.getUserId());
			session.setAttribute("sessionName", member.getUserName());
			session.setAttribute("sessionStatus", member.getStatus());
			session.setAttribute("messageFlg", true);

			// 로그 찍어보자
			System.out.println("세션 ID: " + session.getId());
			System.out.println("세션에 notificationSent 있음? -> " + session.getAttribute("notificationSent"));

			// 로그인 성공 + 세션 당 한 번만 알림 전송
			communityService.sendDeleteNotification(new HashMap<>());
			session.setAttribute("notificationSent", true);
			resultMap.put("notificationSent", true); // 프론트로 알림 전송 사실을 알려줌

		}
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/logout.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String logout() {
		session.invalidate();
		HashMap<String, Object> resultMap = new HashMap<>();
		resultMap.put("result", "logout");
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String join(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.joinMember(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String list(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.getMemberList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/myPage/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMember(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = memberService.getMemberInfo(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/myPage/grade.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMemberGrade(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = memberService.getMemberGradeInfo(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMemberDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = memberService.getMemberDetail(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateMember(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = memberService.updateMember(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/updateStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateMemberStatus(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = memberService.updateMemberStatus(map);
		return new Gson().toJson(resultMap);
	}

	// 주문 목록 (페이징+정렬)
	@RequestMapping(value = "/member/myPage/orderList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getOrderList(@RequestParam HashMap<String, Object> map) {
		map.put("sort", map.get("sort")); // date_desc, price_asc 등
		return new Gson().toJson(memberService.getOrderList(map));
	}

	// 찜 목록 (페이징+정렬)
	@RequestMapping(value = "/member/myPage/wishListAll.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getWishListAll(@RequestParam HashMap<String, Object> map) {
		map.put("sort", map.get("sort"));
		return new Gson().toJson(memberService.getWishList(map));
	}

	// 찜 삭제
	@RequestMapping(value = "/member/myPage/deleteWish.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteWishItem(@RequestParam HashMap<String, Object> map) {
		return new Gson().toJson(memberService.deleteWishItem(map));
	}

	// 쿠폰함 조회
	@RequestMapping(value = "/member/myPage/coupons.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCoupons(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = memberService.getCouponList(map);
		return new Gson().toJson(resultMap);
	}

	// 문의내역 조회
	@RequestMapping(value = "/member/myPage/inquiries.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInquiries(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = memberService.getInquiryList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/myPage/groupInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMemberGroupInfo(Model model, @RequestParam HashMap<String, Object> map) {
		return new Gson().toJson(memberService.getMemberGroupInfo(map));
	}

	@RequestMapping(value = "/member/updateInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateMemberInfo(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = memberService.updateMemberInfo(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/member/withdraw.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String withdrawMember(@RequestParam HashMap<String, Object> map, HttpSession session) {

		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 1. 비밀번호 확인
			boolean isValid = memberService.checkPassword(map);
			if (!isValid) {
				resultMap.put("result", "fail");
				resultMap.put("message", "비밀번호가 일치하지 않습니다.");
				return new Gson().toJson(resultMap);
			}

			// 2. 탈퇴 처리 (소프트 삭제 방식)
			int result = memberService.withdrawMember(map);

			if (result > 0) {
				// 3. 세션 무효화
				session.invalidate();
				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "탈퇴 처리 중 오류가 발생했습니다.");
			}
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", "시스템 오류: " + e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}

	@PostMapping("/member/myPage/orderDeliveryInfo.dox")
	@ResponseBody
	public Map<String, Object> getDeliveryInfo(@RequestParam int orderKey) {
		Map<String, Object> result = new HashMap<>();
		Delivery delivery = memberService.getDeliveryByOrderKey(orderKey); // 예시 메서드
		result.put("delivery", delivery);
		return result;
	}

	@PostMapping("/review/write.do")
	@ResponseBody
	public Map<String, Object> writeReview(@RequestParam int orderKey,
	                                       @RequestParam int itemNo,
	                                       @RequestParam String userid,
	                                       @RequestParam String reviewTitle,
	                                       @RequestParam int reviewScore,
	                                       @RequestParam String reviewContents) {
	    Map<String, Object> result = new HashMap<>();

	    ReviewDTO review = new ReviewDTO();
	    review.setOrderKey(orderKey);
	    review.setItemNo(itemNo);
	    review.setUserid(userid);
	    review.setReviewTitle(reviewTitle);
	    review.setReviewScore(reviewScore);
	    review.setReviewContents(reviewContents);

	    int check = memberService.checkReviewExists(orderKey, itemNo);
	    if (check > 0) {
	        result.put("success", false);
	        result.put("message", "이미 리뷰가 작성되었습니다.");
	        return result;
	    }

	    int inserted = memberService.insertReview(review);
	    result.put("success", inserted > 0);
	    return result;
	}
	
	@PostMapping("/review/update.do")
	@ResponseBody
	public Map<String, Object> updateReview(@RequestParam int orderKey,
	                                        @RequestParam int itemNo,
	                                        @RequestParam String content,
	                                        @RequestParam int score,
	                                        HttpSession session) {
	    String userId = (String) session.getAttribute("userId");
	    Review2 review = new Review2();
	    review.setOrderKey(orderKey);
	    review.setItemNo(itemNo);
	    review.setUserId(userId);
	    review.setReviewContents(content);
	    review.setReviewScore(score);

	    boolean success = memberService.updateReview(review);
	    return Map.of("success", success);
	}

	@PostMapping("/review/delete.do")
	@ResponseBody
	public Map<String, Object> deleteReview(@RequestParam int orderKey,
	                                        @RequestParam int itemNo,
	                                        HttpSession session) {
	    String userId = (String) session.getAttribute("userId");
	    boolean success = memberService.deleteReview(userId, orderKey, itemNo);
	    return Map.of("success", success);
	}

	@PostMapping("/review/exist.do")
	@ResponseBody
	public Map<String, Object> reviewExists(@RequestParam int orderKey,
	                                        @RequestParam int itemNo,
	                                        HttpSession session) {
	    String userId = (String) session.getAttribute("userId");
	    boolean exists = memberService.reviewExists(userId, orderKey, itemNo);
	    return Map.of("exists", exists);
	}
	
	@RequestMapping(value = "/member/insertReview.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String insertReview(@RequestParam HashMap<String, Object> map) {
		System.out.println("======= 리뷰 등록 전 파라미터 =======");
		for (String key : map.keySet()) {
		    System.out.println(key + " : " + map.get(key));
		}

	    if (map.get("orderKey") != null && !map.get("orderKey").toString().isEmpty()) {
	        map.put("orderKey", Integer.parseInt(map.get("orderKey").toString()));
	    }
	    if (map.get("itemNo") != null && !map.get("itemNo").toString().isEmpty()) {
	        map.put("itemNo", Integer.parseInt(map.get("itemNo").toString()));
	    }
	    if (map.get("reviewScore") != null && !map.get("reviewScore").toString().isEmpty()) {
	        map.put("reviewScore", Integer.parseInt(map.get("reviewScore").toString()));
	    }


	    int result = memberService.insertReview(map);
	    HashMap<String, Object> res = new HashMap<>();
	    res.put("result", result > 0 ? "success" : "fail");
	    return new Gson().toJson(res);
	}


	
	@RequestMapping(value = "/member/orderDetailItems.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getOrderDetailItems(@RequestParam HashMap<String, Object> map) {
	    List<HashMap<String, Object>> items = memberService.getOrderDetailItems(map);
	    HashMap<String, Object> res = new HashMap<>();
	    res.put("items", items);
	    return new Gson().toJson(res);
	}

}