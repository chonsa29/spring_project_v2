package com.example.demo.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Member;

@Mapper
public interface MemberMapper {

	Member selectMember(HashMap<String, Object> map);

	Member loginMember(HashMap<String, Object> map);

	int addMember(HashMap<String, Object> map);


}
