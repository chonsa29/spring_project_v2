package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Cart;

@Mapper
public interface CartMapper {

	List<Cart> selectCartList(HashMap<String, Object> map);

	void updateCount(HashMap<String, Object> map);

	void insertCart(HashMap<String, Object> map);
	
	// 기존 장바구니에 해당 상품이 있는지 확인하는 메서드 추가
	HashMap<String, Object> checkCart(HashMap<String, Object> map);

	// 기존 상품이 있으면 수량을 증가하는 메서드 추가
	void updateCartQuantity(HashMap<String, Object> map);

	void deleteCart(HashMap<String, Object> map);

	void deleteCartList(HashMap<String, Object> map);

}
