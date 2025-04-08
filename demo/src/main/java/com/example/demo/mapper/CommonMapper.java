package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Cart;
import com.example.demo.model.Product;

@Mapper
public interface CommonMapper {

	List<Product> selectNewProductList(HashMap<String, Object> map);

	List<Product> selectBestProductList(HashMap<String, Object> map);

	List<Product> selectMonthlyProductList(HashMap<String, Object> map);

}
