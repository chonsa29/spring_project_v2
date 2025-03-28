package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
		
		if(member != null) { // member != null : 값이 있다는 뜻
			resultMap.put("result", "check");
			// result에 check 표시
		} else {
			resultMap.put("result", "none");
			// result에 none 표시
		}
		return resultMap;
	}

	public HashMap<String, Object> getMember(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Member member = memberMapper.selectMember(map);
		if(member != null) {
			resultMap.put("member", member);
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> findMember(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Member member = memberMapper.loginMember(map);
		if(member != null) {
			resultMap.put("member", member);
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> joinMember(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int num = memberMapper.addMember(map);
		
		if(num!=0) {
			resultMap.put("result", "success");
		}else {
			resultMap.put("result", "fail");
		}
		return resultMap;
		
	}
	
	 public List<Map<String, Object>> getMemberList(Map<String, Object> params) {
	        Map<String, Object> searchParams = new HashMap<>();
	        
	        if (params.containsKey("searchType") && params.containsKey("searchValue")) {
	            searchParams.put("searchType", params.get("searchType"));
	            searchParams.put("searchValue", params.get("searchValue"));
	        }
	        
	        if (params.containsKey("status")) {
	            searchParams.put("status", params.get("status"));
	        }
	        
	        return memberMapper.selectMemberList(searchParams);
	    }

	    public Map<String, Object> getMemberDetail(String memberId) {
	        Map<String, Object> result = new HashMap<>();
	        result.put("member", memberMapper.selectMemberDetail(memberId));
	        result.put("orderHistory", memberMapper.selectMemberOrderHistory(memberId));
	        return result;
	    }

	    public Map<String, Object> updateMember(Map<String, Object> params) {
	        Map<String, Object> result = new HashMap<>();
	        int affectedRows = memberMapper.updateMember(params);
	        result.put("success", affectedRows > 0);
	        return result;
	    }

	    public Map<String, Object> updateMemberStatus(Map<String, Object> params) {
	        Map<String, Object> result = new HashMap<>();
	        int affectedRows = memberMapper.updateMemberStatus(params);
	        result.put("success", affectedRows > 0);
	        return result;
	    }
	    
	    public Member getMemberInfo(String userId) {
	        Member member = memberMapper.selectMemberInfo(userId);
	        if (member != null) {
	            setGradeAndGroupNames(member);
	            calculateRemainPoint(member);
	        }
	        return member;
	    }

	    public Member getMemberGradeInfo(String userId) {
	        Member member = memberMapper.selectMemberGradeInfo(userId);
	        if (member != null) {
	            setGradeAndGroupNames(member);
	            calculateRemainPoint(member);
	        }
	        return member;
	    }

	    public Member getRecentOrderInfo(String userId) {
	        return memberMapper.selectRecentOrderInfo(userId);
	    }

	    public Member getWishListInfo(String userId) {
	        return memberMapper.selectWishListInfo(userId);
	    }

	    // 등급명과 그룹명 설정
	    private void setGradeAndGroupNames(Member member) {
	        if (member == null) return;

	        // 등급명 설정 (1: 일반, 2: VIP, 3: VVIP)
	        if (member.getGrade() != null) {
	            switch (member.getGrade()) {
	                case 1: member.setGradeName("일반 회원"); break;
	                case 2: member.setGradeName("VIP 회원"); break;
	                case 3: member.setGradeName("VVIP 회원"); break;
	                default: member.setGradeName("기본 회원");
	            }
	        }

	        // 그룹명 설정 (1: 일반, 2: 프리미엄)
	        if (member.getGroupId() != null) {
	            switch (member.getGroupId()) {
	                case 1: member.setGroupName("일반 그룹"); break;
	                case 2: member.setGroupName("프리미엄 그룹"); break;
	                default: member.setGroupName("기본 그룹");
	            }
	        }
	    }

	    // 다음 등급까지 남은 포인트 계산
	    private void calculateRemainPoint(Member member) {
	        if (member == null || member.getGrade() == null || member.getPoint() == null) {
	            if (member != null) {
	                member.setRemainPoint(0);
	            }
	            return;
	        }

	        int requiredPoint;
	        switch (member.getGrade()) {
	            case 1: requiredPoint = 2000; break; // 일반->VIP
	            case 2: requiredPoint = 5000; break; // VIP->VVIP
	            default: requiredPoint = 0;
	        }

	        member.setRemainPoint(Math.max(0, requiredPoint - member.getPoint()));
	    }
}

