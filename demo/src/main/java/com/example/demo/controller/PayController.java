package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.example.demo.dao.PayService;

@Controller
public class PayController {
	
	@Autowired
	PayService payService;
	
	
}
