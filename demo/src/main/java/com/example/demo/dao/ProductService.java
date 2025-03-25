package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ProductMapper;
import com.example.demo.model.Product;

@Service
public class ProductService {
	@Autowired
	ProductMapper productMapper;

	public HashMap<String, Object> productList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Product> list = productMapper.SelectProduct(map);
			int count = productMapper.CountProduct(map);
			resultMap.put("list", list);
			resultMap.put("count", count);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> productInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Product info = productMapper.SelectProductInfo(map);
			int count = productMapper.SelectProductCount(map);
			resultMap.put("info", info);
			resultMap.put("count", count);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> productAdd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int num = productMapper.addProduct(map);
		if (num > 0) {
			resultMap.put("itemNo", map.get("itemNo"));
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public void addProductFile(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		try {
			productMapper.insertProductFile(map);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
		}
	}
}
