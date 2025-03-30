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

		if (member != null) { // member != null : 값이 있다는 뜻
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
		if (member != null) {
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
		if (member != null) {
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

		if (num != 0) {
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		return resultMap;

	}

	public HashMap<String, Object> getMemberList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		List<Member> member = memberMapper.selectMemberList(map);
		resultMap.put("member", member);
		if (map.containsKey("searchType") && map.containsKey("searchValue")) {
			resultMap.put("searchType", map.get("searchType"));
			resultMap.put("searchValue", map.get("searchValue"));
		}

		if (map.containsKey("status")) {
			resultMap.put("status", map.get("status"));
		}

		return resultMap;
	}

	public HashMap<String, Object> getMemberInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Member member = memberMapper.selectMemberInfo(map);
		if (member != null) {
			resultMap.put("member", member);
			setGradeAndGroupNames(member);
			calculateRemainPoint(member);
		}
		return resultMap;
	}

	public HashMap<String, Object> getMemberDetail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("member", memberMapper.selectMemberDetail(map));
		resultMap.put("orderHistory", memberMapper.selectMemberOrderHistory(map));
		return resultMap;
	}

	public HashMap<String, Object> updateMember(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int affectedRows = memberMapper.updateMember(map);
		resultMap.put("success", affectedRows > 0);
		return resultMap;
	}

	public HashMap<String, Object> updateMemberStatus(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int affectedRows = memberMapper.updateMemberStatus(map);
		resultMap.put("success", affectedRows > 0);
		return resultMap;
	}

	public HashMap<String, Object> getMemberGradeInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Member member = memberMapper.selectMemberGradeInfo(map);
		if (member != null) {
			setGradeAndGroupNames(member);
			calculateRemainPoint(member);
			resultMap.put("member", member);
		}
		return resultMap;
	}

	public HashMap<String, Object> getRecentOrderInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Member orderInfo = memberMapper.selectRecentOrderInfo(map);
		resultMap.put("orderInfo", orderInfo);
		return resultMap;
	}

	public HashMap<String, Object> getWishListInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Member wishInfo = memberMapper.selectWishListInfo(map);
		resultMap.put("wishInfo", wishInfo);
		return resultMap;
	}

	// 등급명과 그룹명 설정
	private void setGradeAndGroupNames(Member member) {
		if (member == null)
			return;

		// 등급명 설정 (1: 일반, 2: VIP, 3: VVIP)
		if (member.getGrade() != null) {
			switch (member.getGrade()) {
			case 1:
				member.setGradeName("라이트픽");
				break;
			case 2:
				member.setGradeName("굿픽");
				break;
			case 3:
				member.setGradeName("탑픽");
				break;
			case 4:
				member.setGradeName("VVIPICK");
				break;
			default:
				member.setGradeName("뉴픽");
			}
		}

		// 그룹명 설정 (1: 일반, 2: 프리미엄)
		if (member.getGroupId() != null) {
			switch (member.getGroupId()) {
			case 1:
				member.setGroupName("일반 그룹");
				break;
			case 2:
				member.setGroupName("프리미엄 그룹");
				break;
			default:
				member.setGroupName("기본 그룹");
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
		case 1:
			requiredPoint = 2000;
			break; // 일반->VIP
		case 2:
			requiredPoint = 5000;
			break; // VIP->VVIP
		default:
			requiredPoint = 0;
		}

		member.setRemainPoint(Math.max(0, requiredPoint - member.getPoint()));
	}
	
    public HashMap<String, Object> getCouponList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        List<HashMap<String, Object>> coupons = memberMapper.selectCouponList(map);
        resultMap.put("coupons", coupons);
        return resultMap;
    }

    public HashMap<String, Object> getInquiryList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        List<HashMap<String, Object>> inquiries = memberMapper.selectInquiryList(map);
        resultMap.put("inquiries", inquiries);
        return resultMap;
    }
}
