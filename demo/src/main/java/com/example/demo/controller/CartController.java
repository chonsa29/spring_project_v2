package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.CartService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

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
	
	// 장바구니 추가
	@RequestMapping(value = "/cart/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String countAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = cartService.addCart(map);
		return new Gson().toJson(resultMap);
	}
	
	// 삭제
	@RequestMapping(value = "/cart/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String countRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = cartService.removeCart(map);
		return new Gson().toJson(resultMap);
	}
	
	// 여러 상품 삭제
	@RequestMapping(value = "/cart/remove-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeSelectedItems(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String json = map.get("selectList").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>(){});
		
		map.put("list", list);
		
		System.out.println(map);
		
		
		resultMap = cartService.removeSelectedItems(map);
		return new Gson().toJson(resultMap);
	}


}
