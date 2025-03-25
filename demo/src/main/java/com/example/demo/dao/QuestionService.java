package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.QuestionMapper;
import com.example.demo.model.Question;

@Service
public class QuestionService {
	
	@Autowired
	QuestionMapper questionMapper;

	public HashMap<String, Object> questionQna(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Question> inquiryList = questionMapper.qnaInquire(map);
			int count = questionMapper.selectQna(map);
			resultMap.put("count", count);
			resultMap.put("inquiryList", inquiryList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

	public HashMap<String, Object> questionAdd(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			questionMapper.qnaInsert(map);
			System.out.println("key =>" + map.get("qsNo"));
			resultMap.put("qsNo", map.get("qsNo"));
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

	public HashMap<String, Object> questionView(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Question info = questionMapper.qnaSelect(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
}
