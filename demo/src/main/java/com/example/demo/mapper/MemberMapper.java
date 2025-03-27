package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Member;

@Mapper
public interface MemberMapper {

	Member selectMember(HashMap<String, Object> map);

	Member loginMember(HashMap<String, Object> map);

	int addMember(HashMap<String, Object> map);

    List<Map<String, Object>> selectMemberList(Map<String, Object> params);
    
    Map<String, Object> selectMemberDetail(String memberId);
    
    List<Map<String, Object>> selectMemberOrderHistory(String memberId);
    
    int updateMember(Map<String, Object> params);
    
    int updateMemberStatus(Map<String, Object> params);
}
