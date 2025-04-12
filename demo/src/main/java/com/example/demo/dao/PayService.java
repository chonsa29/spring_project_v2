package com.example.demo.dao;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.PayMapper;
import com.example.demo.model.Delivery;
import com.example.demo.model.Member;
import com.example.demo.model.Pay;
import com.example.demo.model.Product;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

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
 
 	        if (map.get("discountAmount") != null) {
 	            session.setAttribute("discountAmount", map.get("discountAmount"));
 	        } else {
 	            session.setAttribute("discountAmount", "0");
 	        }
 
 	        if (map.get("usedPoint") != null) {
 	            session.setAttribute("usedPoint", map.get("usedPoint"));
 	        } else {
 	            session.setAttribute("usedPoint", "0");
 	        }
 
 	        if (map.get("shippingFee") != null) {
 	            session.setAttribute("shippingFee", map.get("shippingFee"));
 	        } else {
 	            session.setAttribute("shippingFee", "3000");
 	        }
 
 	        resultMap.put("result", "success");
 	    } catch (Exception e) {
 	        System.out.println(e.getMessage());
 	        resultMap.put("result", "fail");
 	    }
 
 	    return resultMap;
 	}

//	public HashMap<String, Object> paymentProduct(HashMap<String, Object> map, HttpSession session) {
//	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
//	    try {
//	    	String userId = (String) map.get("userId");
//	        String card = (String) map.getOrDefault("card", "");
//	        String userName = (String) map.get("userName");
//	        String zipCode = (String) map.get("zipCode");
//	        String address = (String) map.get("address");
//	        String phone = (String) map.get("phone");
//	        String request = (String) map.getOrDefault("request", "");
//	        java.sql.Date orderDate = new java.sql.Date(new java.util.Date().getTime());
//
//	        // cartList 존재 여부 체크
//	        Object cartListObj = map.get("cartList");
//	        if (cartListObj != null) {
//	            List<HashMap<String, Object>> cartList;
//
//	            // 문자열로 들어온 경우 파싱
//	            if (cartListObj instanceof String) {
//	                ObjectMapper mapper = new ObjectMapper();
//	                cartList = mapper.readValue(
//                        (String) cartListObj,
//                        new TypeReference<List<HashMap<String, Object>>>() {}
//                    );
//	            } else {
//	                cartList = (List<HashMap<String, Object>>) cartListObj;
//	            }
//
//	            for (HashMap<String, Object> cartItem : cartList) {
//	                int cartKey = Integer.parseInt(cartItem.get("cartKey").toString());
//	                int price = Integer.parseInt(cartItem.get("price").toString());
//	                int orderCount = Integer.parseInt(cartItem.get("orderCount").toString());
//	                int itemNo = Integer.parseInt(cartItem.get("itemNo").toString());
//	                int pNo = Integer.parseInt(cartItem.get("pNo").toString());
//
//	                payMapper.paymentSell(userId, price, orderDate, card, userName,
//	                        zipCode, address, phone, pNo, request, itemNo);
//
//	                payMapper.deleteCartItems(cartKey);
//	            }
//
//	        } else {
//	            // 2. 단일 상품 결제인 경우
//	            int cartKey = Integer.parseInt(map.getOrDefault("cartKey", "0").toString());
//	            int price = Integer.parseInt(map.getOrDefault("price", "0").toString());
//	            int orderCount = Integer.parseInt(map.getOrDefault("orderCount", "1").toString());
//	            int itemNo = Integer.parseInt(map.getOrDefault("itemNo", "0").toString());
//	            int pNo = Integer.parseInt(map.getOrDefault("pNo", "0").toString());
//
//	            // 주문 저장
//	            payMapper.paymentSell(userId, price, orderDate, card, userName,
//	                    zipCode, address, phone, pNo, request, itemNo);
//	            
//	            if (cartKey > 0) {
//	                payMapper.deleteCartItems(cartKey);
//	            }
//	        }
//	        
//	        session.setAttribute("discountAmount", map.get("discountAmount"));
//	        session.setAttribute("usedPoint", map.get("usedPoint"));
//	        session.setAttribute("shippingFee", map.get("shippingFee"));
//	        session.setAttribute("gradeDiscount", map.get("gradeDiscount"));
//
//	        resultMap.put("result", "success");
//	    } catch (Exception e) {
//	        System.out.println(e.getMessage());
//	        resultMap.put("result", "fail");
//	    }
//
//	    return resultMap;
//	}

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

	public List<Product> getAll() {
		// TODO Auto-generated method stub
		return payMapper.selectAllProducts();
	}

}
