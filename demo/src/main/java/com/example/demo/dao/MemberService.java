package com.example.demo.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.MemberMapper;
import com.example.demo.model.Member;

@Service
public class MemberService {
	@Autowired
	MemberMapper memberMapper;

	public HashMap<String, Object> searchMember(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Member member = memberMapper.selectMember(map);
		
		int count = member != null ? 1 : 0 ;
		resultMap.put("count", count);
//		int count = 0;
//		if(member != null) {
//			count = 1;
//		} else {
//			count = 0;
//		}
		
		return resultMap;
	}
}
