package com.example.demo.mapper;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Pay;

@Mapper
public interface PayMapper {
	
	List<Pay> paySell(HashMap<String, Object> map);

	void paymentSell(HashMap<String, Object> map);

}
