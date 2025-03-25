package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.CartMapper;
import com.example.demo.model.Cart;

@Service
public class CartService {
	
	@Autowired
	CartMapper cartMapper;

	public HashMap<String, Object> getCartList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Cart> list =  cartMapper.selectCartList(map);
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> editCount(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		cartMapper.updateCount(map);
		resultMap.put("result", "success");
		return resultMap;
	}

}
