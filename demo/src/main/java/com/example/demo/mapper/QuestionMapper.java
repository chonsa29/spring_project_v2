package com.example.demo.mapper;


import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Question;

@Mapper
public interface QuestionMapper {

	List<Question> qnaInquire(HashMap<String, Object> map);

	int selectQna(HashMap<String, Object> map);

	void qnaInsert(HashMap<String, Object> map);

	Question qnaSelect(HashMap<String, Object> map);

}
