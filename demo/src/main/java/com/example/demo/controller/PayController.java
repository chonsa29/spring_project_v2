package com.example.demo.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.PayService;
import com.example.demo.model.Product;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class PayController {
	
	@Autowired
	PayService payService;
	
	@RequestMapping("/pay.do") 
    public String pay(HttpServletRequest request,Model model, 
    		@RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
        return "/cart/pay";
    }
	
	@RequestMapping("/paySuccess.do") 
    public String paySuccess(HttpServletRequest request,Model model, 
    		@RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
        return "/cart/paySuccess";
    }
	
	@RequestMapping("/recommendedProducts.do")
	@ResponseBody
	public List<Product> getRecommendedProducts() {
	    List<Product> allProducts = payService.getAll(); // 전체 상품 불러오기
	    Collections.shuffle(allProducts); // 랜덤 섞기
	    return allProducts.stream().limit(5).collect(Collectors.toList()); // 5개만
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
	public String payment(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
	    
	    Gson gson = new Gson();

	    if (map.get("orderItems") != null) {
	        String orderItemsJson = map.get("orderItems").toString();
	        session.setAttribute("orderItems", orderItemsJson);
	    }
	    
	    session.setAttribute("discountAmount", map.getOrDefault("discountAmount", "0"));
	    session.setAttribute("usedPoint", map.getOrDefault("usedPoint", "0"));
	    session.setAttribute("shippingFee", map.getOrDefault("shippingFee", "3000"));

	    // 여기!! 세션도 함께 전달
	    HashMap<String, Object> resultMap = payService.paymentProduct(map, session);

	    return gson.toJson(resultMap);
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
	
}
