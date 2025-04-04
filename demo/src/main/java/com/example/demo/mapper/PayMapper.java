package com.example.demo.mapper;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Delivery;
import com.example.demo.model.Member;
import com.example.demo.model.Pay;
import com.example.demo.model.Product;

@Mapper
public interface PayMapper {
	
	List<Pay> paySell(HashMap<String, Object> map);

	void paymentSell(HashMap<String, Object> map);

	Product payProductInfo(HashMap<String, Object> map);

	Member payMemberInfo(HashMap<String, Object> map);

	void upsertOrderCount(HashMap<String, Object> map);

}
