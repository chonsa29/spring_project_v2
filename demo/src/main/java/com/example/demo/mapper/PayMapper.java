package com.example.demo.mapper;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Pay;
import com.example.demo.model.PayProduct;

@Mapper
public interface PayMapper {
	
	PayProduct paySell(HashMap<String, Object> map);

	void paymentSell(HashMap<String, Object> map);

}
