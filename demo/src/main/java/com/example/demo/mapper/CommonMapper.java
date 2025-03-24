package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Cart;

@Mapper
public interface CommonMapper {

	List<Cart> selectNewProductList(HashMap<String, Object> map);

}
