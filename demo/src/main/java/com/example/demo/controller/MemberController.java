package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.CommunityService;
import com.example.demo.dao.MemberService;
import com.example.demo.model.Member;
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
	
	@RequestMapping("/member/findPwd.do")
	public String findPwd(Model model) throws Exception {

		return "/member/findPwd";
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
}