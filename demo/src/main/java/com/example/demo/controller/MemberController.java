package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.MemberService;
import com.google.gson.Gson;

@Controller
public class MemberController {
	@Autowired
	MemberService memberService;	
	


	
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
	
}