package com.example.demo.mapper;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Product;

@Mapper
public interface ProductMapper {

	List<Product> SelectProduct(HashMap<String, Object> map);

	int CountProduct(HashMap<String, Object> map);

	Product SelectProductInfo(HashMap<String, Object> map);

	int SelectProductCount(HashMap<String, Object> map);

}
