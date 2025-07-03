package com.example.demo.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.MemberMapper;
import com.example.demo.model.Delivery;
import com.example.demo.model.Member;
import com.example.demo.model.Review2;
import com.example.demo.model.ReviewDTO;

import jakarta.servlet.http.HttpSession;

@Service
public class MemberService {
	@Autowired
	MemberMapper memberMapper;

	@Autowired
	HttpSession session;

	private final PasswordEncoder passwordEncoder;

	@Autowired
	public MemberService(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

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

	public HashMap<String, Object> getMemberGroupInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		// 그룹 기본 정보 조회
		Member groupInfo = memberMapper.selectMemberGroupInfo(map);
		resultMap.put("groupInfo", groupInfo);

		// 그룹 멤버 목록 조회 (groupId가 있을 경우에만)
		if (groupInfo != null && groupInfo.getGroupId() != null) {
			map.put("groupId", groupInfo.getGroupId()); // 멤버 조회용 groupId 설정
			List<Member> members = memberMapper.selectGroupMembers(map);
			resultMap.put("groupMembers", members);
		}

		return resultMap;
	}

	// 기존 getMemberInfo 메서드 수정
	public HashMap<String, Object> getMemberInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		Member member = memberMapper.selectMemberInfo(map);

		// 그룹 정보 추가 로드
		Member groupInfo = memberMapper.selectMemberGroupInfo(map);
		if (groupInfo != null) {
			member.setGroupId(groupInfo.getGroupId());
			member.setGroupName(groupInfo.getGroupName());
			member.setLeaderId(groupInfo.getLeaderId());
			member.setJoinDate(groupInfo.getJoinDate());
			member.setGroupStatus(groupInfo.getGroupStatus());
			member.setMonthSpent(groupInfo.getMonthSpent());
		}
		if (member != null && member.getMonthSpent() != null) {
			int spent = Integer.parseInt(member.getMonthSpent());
			calculateGrade(member, spent); // 등급 계산 메서드 호출
		}
		if (member != null) {
			// 등급별 할인율 계산 추가
			int discountRate = calculateDiscountRate(member.getGrade());
			member.setGroupDiscountRate(discountRate);
		}
		resultMap.put("member", member);
		return resultMap;
	}

	private int calculateDiscountRate(Integer grade) {
		if (grade == null)
			return 3; // 기본값

		switch (grade) {
		case 1:
			return 3; // 뉴픽: 3%
		case 2:
			return 4; // 라이트픽: 4%
		case 3:
			return 5; // 굿픽: 5%
		case 4:
			return 6; // 탑픽: 6%
		case 5:
			return 7; // VVIPICK: 7%
		default:
			return 3;
		}
	}

	private void calculateGrade(Member member, int spent) {
		if (spent >= 200000) {
			member.setGrade(5);
			member.setGradeName("VVIPICK");
		} else if (spent >= 100000) {
			member.setGrade(4);
			member.setGradeName("탑픽");
		} else if (spent >= 50000) {
			member.setGrade(3);
			member.setGradeName("굿픽");
		} else if (spent >= 10000) {
			member.setGrade(2);
			member.setGradeName("라이트픽");
		} else {
			member.setGrade(1);
			member.setGradeName("뉴픽");
		}
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

	// 주문 목록 조회
	public HashMap<String, Object> getOrderList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int page = map.get("page") != null ? Integer.parseInt(map.get("page").toString()) : 1;
		int pageSize = map.get("pageSize") != null ? Integer.parseInt(map.get("pageSize").toString()) : 10;

		map.put("offset", (page - 1) * pageSize);

		result.put("orders", memberMapper.selectOrderList(map));
		result.put("totalCount", memberMapper.selectOrderCount(map));

		return result;
	}

	// 찜 목록 조회
	public HashMap<String, Object> getWishList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int page = Integer.parseInt(map.get("page").toString());
		int pageSize = Integer.parseInt(map.get("pageSize").toString());
		map.put("offset", (page - 1) * pageSize);

		result.put("wishList", memberMapper.selectWishList(map));
		result.put("totalCount", memberMapper.selectWishCount(map));
		return result;
	}

	// 찜 삭제
	public HashMap<String, Object> deleteWishItem(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		try {
			int affected = memberMapper.deleteWishItem(map);
			result.put("result", affected > 0 ? "success" : "fail");
		} catch (Exception e) {
			result.put("result", "error");
			result.put("message", e.getMessage());
		}
		return result;
	}

	
	   public boolean changePassword(String email, String password) {

	        return memberMapper.updatePassword(email, password) > 0;

	    }


	
	
	
	
	// 등급명과 그룹명 설정
	private void setGradeAndGroupNames(Member member) {
		if (member == null)
			return;
		
		

		// monthSpent 기반 등급 설정
		if (member.getMonthSpent() != null) {
			int spent = Integer.parseInt(member.getMonthSpent());

			if (spent >= 200000) {
				member.setGrade(5);
				member.setGradeName("VVIPICK");
			} else if (spent >= 100000) {
				member.setGrade(4);
				member.setGradeName("탑픽");
			} else if (spent >= 50000) {
				member.setGrade(3);
				member.setGradeName("굿픽");
			} else if (spent >= 10000) {
				member.setGrade(2);
				member.setGradeName("라이트픽");
			} else {
				member.setGrade(1);
				member.setGradeName("뉴픽");
			}
		}

		// 그룹명 설정 (기존 로직 유지)
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
		if (member == null || member.getGrade() == null || member.getMonthSpent() == null) {
			if (member != null) {
				member.setRemainPoint(0);
			}
			return;
		}

		int currentSpent = Integer.parseInt(member.getMonthSpent());
		int nextGradeRequirement;

		switch (member.getGrade()) {
		case 1: // 뉴픽 → 라이트픽
			nextGradeRequirement = 10000;
			break;
		case 2: // 라이트픽 → 굿픽
			nextGradeRequirement = 50000;
			break;
		case 3: // 굿픽 → 탑픽
			nextGradeRequirement = 100000;
			break;
		case 4: // 탑픽 → VVIPICK
			nextGradeRequirement = 200000;
			break;
		default: // VVIPICK 이상
			nextGradeRequirement = 0;
		}

		member.setRemainPoint(Math.max(0, nextGradeRequirement - currentSpent));
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

	public HashMap<String, Object> updateMemberInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 비밀번호 변경 여부 확인
			if (map.containsKey("newPassword") && !map.get("newPassword").toString().isEmpty()) {
				map.put("password", map.get("newPassword"));
			}

			int affectedRows = memberMapper.updateMemberInfo(map);
			if (affectedRows > 0) {
				resultMap.put("result", "success");
				// 세션 정보 갱신 (선택적)
				Member updatedMember = memberMapper.selectMember(map);
				session.setAttribute("sessionName", updatedMember.getUserName());
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "변경된 내용이 없습니다.");
			}
		} catch (Exception e) {
			resultMap.put("result", "error");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public boolean checkPassword(HashMap<String, Object> map) {
		String inputPw = (String) map.get("password");
		String dbPw = memberMapper.selectPassword(map);
		System.out.println(inputPw);
		System.out.println(dbPw);
		return inputPw.equals(dbPw);
	}

	public int withdrawMember(HashMap<String, Object> map) {
		// 1. 주문 내역 등 연결 데이터 확인
		int activeOrders = memberMapper.countActiveOrders(map);
		if (activeOrders > 0) {
			throw new RuntimeException("처리 중인 주문이 존재합니다");
		}

		// 2. 소프트 삭제 처리 (실제 삭제 대신 상태 변경)
		map.put("status", "WITHDRAWN");
		map.put("withdrawDate", new Date()); // java.util.Date 사용
		return memberMapper.updateMemberStatus2(map);
	}

	public Delivery getDeliveryByOrderKey(int orderKey) {
		return memberMapper.selectDeliveryByOrderKey(orderKey);
	}

	public int checkReviewExists(int orderKey, int itemId) {
		return memberMapper.selectReviewCount(orderKey, itemId);
	}

	public int insertReview(ReviewDTO review) {
		return memberMapper.insertReview(review);
	}
    public boolean insertReview(Review2 review) {
        return memberMapper.insertReview(review) > 0;
    }

    public boolean updateReview(Review2 review) {
        return memberMapper.updateReview(review) > 0;
    }

    public boolean deleteReview(String userId, int orderKey, int itemNo) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("orderKey", orderKey);
        params.put("itemNo", itemNo);
        return memberMapper.deleteReview(params) > 0;
    }

    public boolean reviewExists(String userId, int orderKey, int itemNo) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("orderKey", orderKey);
        params.put("itemNo", itemNo);
        return memberMapper.reviewExists(params);
    }

    public int insertReview(HashMap<String, Object> map) {
        return memberMapper.insertReview(map);
    }

    public List<HashMap<String, Object>> getOrderDetailItems(HashMap<String, Object> map) {
        return memberMapper.selectOrderDetailItems(map);
    }

}
