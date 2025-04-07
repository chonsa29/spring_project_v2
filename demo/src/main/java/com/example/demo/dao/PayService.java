package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.PayMapper;
import com.example.demo.model.Delivery;
import com.example.demo.model.Member;
import com.example.demo.model.Pay;
import com.example.demo.model.Product;

import jakarta.servlet.http.HttpSession;

@Service
public class PayService {
	
	@Autowired
	PayMapper payMapper;
	
	public HashMap<String, Object> payProduct(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Pay> payList = payMapper.paySell(map);
			resultMap.put("payList", payList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

	public HashMap<String, Object> paymentProduct(HashMap<String, Object> map, HttpSession session) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			payMapper.paymentSell(map);
			
		    if (map.get("orderItems") != null) {
	            session.setAttribute("orderItems", map.get("orderItems"));
	        }
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

	public HashMap<String, Object> payProductInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Product productInfo = payMapper.payProductInfo(map);
			resultMap.put("productInfo", productInfo);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

	public HashMap<String, Object> payMemberInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Member memberInfo = payMapper.payMemberInfo(map);
			
            String discountAmountStr = memberInfo.getDiscountAmount(); 

            double discountRate = 0.0;
            if (discountAmountStr != null && discountAmountStr.endsWith("%")) {
                discountRate = Double.parseDouble(discountAmountStr.replace("%", "")) / 100.0;
            }

			resultMap.put("memberInfo", memberInfo);
			resultMap.put("discountRate", discountRate);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

}
