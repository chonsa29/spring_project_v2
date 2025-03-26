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

	// 장바구니 리스트
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

	// 장바구니 수량 변경
	public HashMap<String, Object> editCount(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		cartMapper.updateCount(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	// 장바구니 추가
	public HashMap<String, Object> addCart(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        // 1. 장바구니에 해당 상품이 있는지 확인
	        HashMap<String, Object> existingCart = cartMapper.checkCart(map);

	        if (existingCart != null) {
	            // 2. 이미 존재하면 수량 증가
	            cartMapper.updateCartQuantity(map);
	        } else {
	            // 3. 존재하지 않으면 새로 추가
	            cartMapper.insertCart(map);
	        }

	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}

	// 삭제
	public HashMap<String, Object> removeCart(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	       
	            cartMapper.deleteCart(map);

	            resultMap.put("result", "success");
	            
	    } catch (Exception e) {
	    	
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        
	    }
		return resultMap;
	}

	public HashMap<String, Object> removeSelectedItems(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		cartMapper.deleteCartList(map);
		resultMap.put("result", "success");

		return resultMap;
		
	}

}
