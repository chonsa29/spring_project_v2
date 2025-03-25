package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.CartService;
import com.google.gson.Gson;

@Controller
public class CartController {
	
	@Autowired
	CartService cartService;
	
	@RequestMapping("/cart.do")
	public String cartList(Model model) throws Exception{
        return "/product/cart";
    }
	
	// 장바구니 리스트
	@RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String memberList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = cartService.getCartList(map);
		System.out.println(resultMap);
		return new Gson().toJson(resultMap);
	}
	
	// 수량 변경
	@RequestMapping(value = "/cart/count.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String countEdit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = cartService.editCount(map);
		return new Gson().toJson(resultMap);
	}

}
