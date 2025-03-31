package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.PayMapper;
import com.example.demo.model.Pay;
import com.example.demo.model.PayProduct;

@Service
public class PayService {
	@Autowired
	PayMapper payMapper;
	
	public HashMap<String, Object> payProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			PayProduct info = payMapper.paySell(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

	public HashMap<String, Object> paymentProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			payMapper.paymentSell(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
}
