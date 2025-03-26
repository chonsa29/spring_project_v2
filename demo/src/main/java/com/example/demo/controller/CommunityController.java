package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.dao.CommunityService;

@Controller
public class CommunityController {
	@Autowired
	CommunityService communityService;
	
	@RequestMapping("/commu-main.do")
	public String home(Model model) throws Exception{
        return "/community/commu-main"; 
    }
}
