package com.example.demo.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	
	@RequestMapping("/recipe/edit.do")
	public String recipeEdit(HttpServletRequest request,Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		// POST_ID 기반으로 데이터 조회
	    Recipe recipe = communityService.getRecipeById(map.get("postId"));
	    
	    System.out.println("Contents from DB: " + recipe.getContents());
	    
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
		resultMap = communityService.recipeView(map);
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

	
}
