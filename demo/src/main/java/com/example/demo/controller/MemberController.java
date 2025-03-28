package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.MemberService;
import com.example.demo.model.Member;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {
	@Autowired
	MemberService memberService;	
	
    @Autowired
    HttpSession session;
    
	@RequestMapping("/member/login.do") 
    public String login(Model model) throws Exception{
		return "/member/login"; 
    }
	
	
	@RequestMapping("/member/join.do") 
    public String join(Model model) throws Exception{	

        return "/member/join"; 
    }
	
	@RequestMapping("/member/term.do") 
    public String term(Model model) throws Exception{

        return "/member/term"; 
    }
	@RequestMapping("/member/mypage.do") 
    public String mypage(Model model) throws Exception{
        return "/member/mypage"; 
    }
	
	@RequestMapping("/member/admin.do") 
    public String admin(Model model) throws Exception{

        return "/member/admin-page"; 
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
	
	 @RequestMapping(value = "/member/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public String login(@RequestParam HashMap<String, Object> map) throws Exception {
	        HashMap<String, Object> resultMap = memberService.findMember(map);
	        if ("success".equals(resultMap.get("result"))) {
	            Member member = (Member) resultMap.get("member");
	            session.setAttribute("sessionId", member.getUserId());
	            session.setAttribute("sessionName", member.getUserName());
	            session.setAttribute("sessionStatus", member.getStatus());
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
	    public List<Map<String, Object>> getMemberList(
	            @RequestParam Map<String, Object> params) {
	        return memberService.getMemberList(params);
	    }

	    @RequestMapping(value = "/member/detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public Map<String, Object> getMemberDetail(
	            @RequestParam("memberId") String memberId) {
	        return memberService.getMemberDetail(memberId);
	    }

	    @RequestMapping(value = "/member/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public Map<String, Object> updateMember(
	            @RequestParam Map<String, Object> params) {
	        return memberService.updateMember(params);
	    }

	    @RequestMapping(value = "/member/updateStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public Map<String, Object> updateMemberStatus(
	            @RequestParam Map<String, Object> params) {
	        return memberService.updateMemberStatus(params);
	    }	
	    
	    @RequestMapping(value = "/member/myPage/info/{userId}.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public ResponseEntity<Member> getMemberInfo(@PathVariable String userId) {
	        Member memberInfo = memberService.getMemberInfo(userId);
	        return ResponseEntity.ok(memberInfo);
	    }
	    
	    @RequestMapping(value = "/member/myPage/grade/{userId}.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public ResponseEntity<Member> getMemberGradeInfo(@PathVariable String userId) {
	        Member gradeInfo = memberService.getMemberGradeInfo(userId);
	        return ResponseEntity.ok(gradeInfo);
	    }
	    
	    @RequestMapping(value = "/member/myPage/orders/{userId}.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public ResponseEntity<Member> getRecentOrderInfo(@PathVariable String userId) {
	        Member orderInfo = memberService.getRecentOrderInfo(userId);
	        return ResponseEntity.ok(orderInfo);
	    }
	    
	    @RequestMapping(value = "/member/myPage/wishList/{userId}.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public ResponseEntity<Member> getWishListInfo(@PathVariable String userId) {
	        Member wishInfo = memberService.getWishListInfo(userId);
	        return ResponseEntity.ok(wishInfo);
	    }
}