package com.example.demo.mapper;


import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface QuestionMapper {

	void faqInquire(HashMap<String, Object> map);

}
