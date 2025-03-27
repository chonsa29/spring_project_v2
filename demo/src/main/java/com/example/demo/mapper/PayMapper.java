package com.example.demo.mapper;


import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PayMapper {

	void paySell(HashMap<String, Object> map);

}
