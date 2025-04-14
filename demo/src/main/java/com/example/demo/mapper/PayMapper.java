package com.example.demo.mapper;


import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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

	List<Product> selectAllProducts();

//	void paymentSell(
//		    @Param("userId") String userId,
//		    @Param("price") int price,
//		    @Param("orderDate") Date orderDate,
//		    @Param("card") String card,
//		    @Param("userName") String userName,
//		    @Param("zipCode") String zipCode,
//		    @Param("address") String address,
//		    @Param("phone") String phone,
//		    @Param("pNo") int pNo,
//		    @Param("request") String request,
//		    @Param("itemNo") int itemNo
//		);

	void deleteCartItems(int cartKey);

	void insertOrderDetail(Map<String, Object> detailMap);

	void deleteOrderedCart(HashMap<String, Object> map);

}
