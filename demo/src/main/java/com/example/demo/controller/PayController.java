package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.dao.PayService;

@Controller
public class PayController {
	
	@Autowired
	PayService payService;
	
	@RequestMapping("/pay.do")
	public String home(Model model) throws Exception{
        return "/cart/pay";
    }
}
