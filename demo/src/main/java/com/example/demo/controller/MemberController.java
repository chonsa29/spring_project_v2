package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.dao.MemberService;

@Controller
public class MemberController {
	@Autowired
	MemberService memberService;
	
	@RequestMapping("/member/login.do") 
    public String add(Model model) throws Exception{

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
}
