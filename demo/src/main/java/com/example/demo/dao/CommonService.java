package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.CommonMapper;
import com.example.demo.model.Cart;
import com.example.demo.model.Product;

@Service
public class CommonService {
	
	@Autowired
	CommonMapper commonMapper;

	public HashMap<String, Object> getNewProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Product> list =  commonMapper.selectNewProductList(map);
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getBestProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Product> list =  commonMapper.selectBestProductList(map);
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {    
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> getMonthlyProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Product> list =  commonMapper.selectMonthlyProductList(map);
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {    
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

}
