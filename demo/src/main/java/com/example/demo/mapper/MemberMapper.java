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

    List<Member> selectMemberList(Map<String, Object> map);
    
    Member selectMemberInfo(HashMap<String, Object> map);
    
    Member selectMemberDetail(HashMap<String, Object> map);
    
    List<HashMap<String, Object>> selectMemberOrderHistory(HashMap<String, Object> map);
        
    int updateMember(HashMap<String, Object> map);
        
    int updateMemberStatus(HashMap<String, Object> map);

    Member selectMemberGradeInfo(HashMap<String, Object> map);
        
    Member selectRecentOrderInfo(HashMap<String, Object> map);
        
    Member selectWishListInfo(HashMap<String, Object> map);

    List<HashMap<String, Object>> selectCouponList(HashMap<String, Object> map);
    
    List<HashMap<String, Object>> selectInquiryList(HashMap<String, Object> map);
}
