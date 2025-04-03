package com.example.demo.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.common.Common;
import com.example.demo.dao.CommunityService;
import com.example.demo.model.Recipe;
import com.google.gson.Gson;

@Controller
public class CommunityController {
	@Autowired
	CommunityService communityService;
	
	// 커뮤니티 메인
	@RequestMapping("/commu-main.do")
	public String main(Model model) throws Exception{
        return "/community/commu-main"; 
    }
	
	// 레시피 자세히 보기
	@RequestMapping("/recipe/view.do")
	public String recipeView(HttpServletRequest request,Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
        return "/community/recipe-view"; 
    }
	
	// 레시피 추가
	@RequestMapping("/recipe/add.do")
	public String recipeAdd(Model model) throws Exception{
        return "/community/recipe-add"; 
    }
	
	// 레시피 수정 페이지
	@RequestMapping("/recipe/edit.do")
	public String recipeEdit(HttpServletRequest request,Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		// POST_ID 기반으로 데이터 조회
	    Recipe recipe = communityService.getRecipeById(map.get("postId"));
	    
	    // JSP에 전달할 데이터 설정
	    model.addAttribute("map", map);
	    model.addAttribute("recipe", recipe); // 조회된 데이터
	    model.addAttribute("savedContents", recipe.getContents()); // HTML 콘텐츠
	    

	    return "/community/recipe-edit"; // JSP 경로
    }
	
	// 레시피 리스트
	@RequestMapping(value = "/commu/recipe.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String recipeList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = communityService.getRecipeList(map);
		System.out.println(resultMap);
		return new Gson().toJson(resultMap);
	}
	
	// 레시피 게시글 상세보기
	@RequestMapping(value = "/recipe/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String view(Model model, @RequestParam HashMap<String, Object> map) throws Exception {			
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String postId = (String) map.get("postId");
	    String userId = (String) map.get("userId");  // 로그인한 유저 ID
		
		resultMap = communityService.recipeView(map);
		return new Gson().toJson(resultMap);
	}
	
	// 레시피 게시글 수정 화면 페이지
	@RequestMapping(value = "/recipe/editView.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {			
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = communityService.recipeEditView(map);
		
		return new Gson().toJson(resultMap);
	}
	
	// 레시피 게시글 추가
	@RequestMapping(value = "/recipe/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String recipeAdd(@RequestParam HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 서비스 호출하여 레시피 추가 처리
	        resultMap = communityService.addRecipe(map);

	        // 성공 메시지 추가
	        resultMap.put("status", "success");
	        resultMap.put("message", "레시피가 성공적으로 등록되었습니다.");
	    } catch (Exception e) {
	        // 예외 발생 시 오류 메시지 반환
	        resultMap.put("status", "error");
	        resultMap.put("message", "레시피 등록 중 오류가 발생했습니다.");
	        resultMap.put("error", e.getMessage());
	    }

	    // JSON 변환 후 반환
	    return new Gson().toJson(resultMap);
	}
	
	// 게시글 수정
	@RequestMapping(value = "/recipe/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String recipeEdit(@RequestBody HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 서비스 호출하여 레시피 추가 처리
	        resultMap = communityService.editRecipe(map);

	        // 성공 메시지 추가
	        resultMap.put("status", "success");
	        resultMap.put("message", "레시피가 성공적으로 등록되었습니다.");
	    } catch (Exception e) {
	        // 예외 발생 시 오류 메시지 반환
	        resultMap.put("status", "error");
	        resultMap.put("message", "레시피 등록 중 오류가 발생했습니다.");
	        resultMap.put("error", e.getMessage());
	    }

	    // JSON 변환 후 반환
	    return new Gson().toJson(resultMap);
	}
	
	// 좋아요 기능
	@RequestMapping(value = "/recipe/like.dox", method = RequestMethod.POST)
	@ResponseBody
	public String likeRecipe(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    String postId = (String) map.get("postId");
	    String userId = (String) map.get("userId");
	    
	    System.out.println("postId: " + postId + ", userId: " + userId);

	    try {
	        // 좋아요 상태 변경
	        boolean isLiked = communityService.toggleLike(postId, userId);
	        int updatedLikes = communityService.getLikes(postId); // 좋아요 수 가져오기

	        resultMap.put("result", "success");
	        resultMap.put("isLiked", isLiked); // 좋아요 상태 (true: 좋아요 추가, false: 좋아요 취소)
	        resultMap.put("likes", updatedLikes); // 좋아요 총 개수
	        System.out.println("isLiked: " + isLiked + ", likes: " + updatedLikes); // 로그 추가
	        System.out.println("서버 응답 JSON: " + new Gson().toJson(resultMap));
	    } catch (Exception e) {
	        System.out.println("Error toggling like: " + e.getMessage());
	        resultMap.put("result", "fail");
	    }

	    return new Gson().toJson(resultMap);
	}
	
	// 레시피 삭제
	@RequestMapping(value = "/recipe/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String recipeRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = communityService.removeRecipe(map);
		return new Gson().toJson(resultMap);
	}
	
	// // 그룹 부분 // //
	
	// 그룹 리스트
	@RequestMapping(value = "/commu/group.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String groupList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = communityService.getGroupList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	// 그룹 페이지 자세히 보기
	@RequestMapping("/group/view.do")
	public String groupView(HttpServletRequest request,Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
        return "/community/group-view"; 
    }
	
	// 그룹 게시글 쓰기
	@RequestMapping("/group/add.do")
	public String groupAdd(Model model) throws Exception{
        return "/community/group-add"; 
    }
	
	// 그룹 게시글 상세보기
	@RequestMapping(value = "/group/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String groupView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {			
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = communityService.groupView(map);
		return new Gson().toJson(resultMap);
	}
	
	// 그룹 신청자 보기
	@RequestMapping(value = "/group/members.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String groupMembers(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = communityService.getGroupMembers(map);
		
		return new Gson().toJson(resultMap);
	}
	
	// 그룹 참가 확인
	@RequestMapping(value = "/group/memberCheck.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String groupMemberChek(Model model, @RequestParam HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    
	    try {
	        resultMap = communityService.groupMemberCheck(map); // 멤버 목록 조회
	        resultMap.put("status", "success"); // 성공 상태 추가
	    } catch (Exception e) {
	        resultMap.put("status", "error");
	        resultMap.put("message", "그룹 멤버 정보를 불러오는 중 오류가 발생했습니다.");
	        e.printStackTrace();
	    }
	    
	    return new Gson().toJson(resultMap);
	}
	
	
	// 그룹 신청
	@RequestMapping(value = "/group/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String groupJoin(@RequestParam HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 서비스 호출하여 레시피 추가 처리
	        resultMap = communityService.joinGroup(map);

	        // 성공 메시지 추가
	        resultMap.put("status", "success");
	        resultMap.put("message", "신청이 성공적으로 등록되었습니다.");
	    } catch (Exception e) {
	        // 예외 발생 시 오류 메시지 반환
	        resultMap.put("status", "error");
	        resultMap.put("message", "신청 중 오류가 발생했습니다.");
	        resultMap.put("error", e.getMessage());
	    }

	    // JSON 변환 후 반환
	    return new Gson().toJson(resultMap);
	}
	
	// 그룹 글쓰기
	@RequestMapping(value = "/group/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String groupAdd(@RequestParam HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 서비스 호출하여 레시피 추가 처리
	        resultMap = communityService.addGroup(map);

	        // 성공 메시지 추가
	        resultMap.put("status", "success");
	        resultMap.put("message", "게시글이 성공적으로 등록되었습니다.");
	    } catch (Exception e) {
	        // 예외 발생 시 오류 메시지 반환
	        resultMap.put("status", "error");
	        resultMap.put("message", "게시글 등록 중 오류가 발생했습니다.");
	        resultMap.put("error", e.getMessage());
	    }

	    // JSON 변환 후 반환
	    return new Gson().toJson(resultMap);
	}
	
	// 그룹 만들기
	@RequestMapping(value = "/group/create.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String groupCreate(@RequestParam HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 서비스 호출하여 레시피 추가 처리
	        resultMap = communityService.createGroup(map);

	        // 성공 메시지 추가
	        resultMap.put("status", "success");
	        resultMap.put("message", "그룹이 성공적으로 등록되었습니다.");
	    } catch (Exception e) {
	        // 예외 발생 시 오류 메시지 반환
	        resultMap.put("status", "error");
	        resultMap.put("message", "그룹 등록 중 오류가 발생했습니다.");
	        resultMap.put("error", e.getMessage());
	    }

	    // JSON 변환 후 반환
	    return new Gson().toJson(resultMap);
	}
	
	// 멤버 수락하기
	@RequestMapping(value = "/group/accept.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String acceptMember(@RequestBody HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 서비스 호출하여 레시피 추가 처리
	        resultMap = communityService.acceptMember(map);

	        // 성공 메시지 추가
	        resultMap.put("status", "success");
	        resultMap.put("message", "멤버가 성공적으로 수락되었습니다.");
	    } catch (Exception e) {
	        // 예외 발생 시 오류 메시지 반환
	        resultMap.put("status", "error");
	        resultMap.put("message", "멤버 수락 중 오류가 발생했습니다.");
	        resultMap.put("error", e.getMessage());
	    }
	    return new Gson().toJson(resultMap);
	}
	
	// 멤버 거절하기(삭제, 거절)
	@RequestMapping(value = "/group/reject.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rejectMember(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = communityService.rejectMember(map);
		return new Gson().toJson(resultMap);
	}
	
	// 그룹 마감
	@RequestMapping(value = "/group/close.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String closeGroup(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = communityService.closeGroup(map);
		return new Gson().toJson(resultMap);
	}

}
