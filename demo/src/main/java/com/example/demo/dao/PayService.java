package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.PayMapper;
import com.example.demo.model.Pay;

@Service
public class PayService {
	@Autowired
	PayMapper payMapper;
	
	public HashMap<String, Object> payProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Pay info = payMapper.paySell(map);
			System.out.println("paySell() 조회 결과: " + info);
			System.out.println("map 데이터: " + map);
			System.out.println("paySell() 조회 시 itemNo 값: " + map.get("itemNo"));
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
