package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.PayService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class PayController {
	
	@Autowired
	PayService payService;
	
	@RequestMapping("/pay.do") 
    public String noticeEdit(HttpServletRequest request,Model model, 
    		@RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
        return "/cart/pay";
    }
	
	@RequestMapping(value = "/pay.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String pay(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = payService.payProduct(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String payment(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = payService.paymentProduct(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String product(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = payService.payProductInfo(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String member(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = payService.payMemberInfo(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/delivery.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String delivery(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = payService.payDeliveryInfo(map);
		
		return new Gson().toJson(resultMap);
	}
}
