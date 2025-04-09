package com.example.demo.mapper;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Question;

@Mapper
public interface QuestionMapper {

	List<Question> qnaInquire(HashMap<String, Object> map);

	int selectQna(HashMap<String, Object> map);

	void qnaInsert(HashMap<String, Object> map);

	Question qnaSelect(HashMap<String, Object> map);

	void qnaUpdate(HashMap<String, Object> map);

	void qnaDelete(HashMap<String, Object> map);

	void updateCnt(HashMap<String, Object> map);

	int qnaStatusUpdate(HashMap<String, Object> map);

	void qnaSaveReply(HashMap<String, Object> map);

}
