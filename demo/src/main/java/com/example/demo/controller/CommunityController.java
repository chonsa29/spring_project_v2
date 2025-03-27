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
	public String recipeAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = communityService.addRecipe(map);
		return new Gson().toJson(resultMap);
	}
	
	// 파일 업로드
		@RequestMapping("/fileUpload.dox")
		public String result(@RequestParam("file1") List<MultipartFile> files, 
		                     @RequestParam("postId") int boardNo, 
		                     HttpServletRequest request, HttpServletResponse response, 
		                     Model model) {
			String url = null;
		    String path = "c:\\img";

		    try {
		        String uploadpath = path;

		        for (MultipartFile multi : files) {
		            if (!multi.isEmpty()) {
		                String originFilename = multi.getOriginalFilename();
		                String extName = originFilename.substring(originFilename.lastIndexOf("."), originFilename.length());
		                long size = multi.getSize();
		                String saveFileName = Common.genSaveFileName(extName);

		                System.out.println("uploadpath : " + uploadpath);
		                System.out.println("originFilename : " + originFilename);
		                System.out.println("extensionName : " + extName);
		                System.out.println("size : " + size);
		                System.out.println("saveFileName : " + saveFileName);

		                // 현재 디렉토리 경로 가져오기
		                String path2 = System.getProperty("user.dir");
		                System.out.println("Working Directory = " + path2 + "\\src\\webapp\\img");

		                // 파일 저장 경로 설정
		                File saveFile = new File(path2 + "\\src\\main\\webapp\\img", saveFileName);
		                multi.transferTo(saveFile);

		                // 데이터 저장 준비
		                HashMap<String, Object> map = new HashMap<>();
		                map.put("filename", saveFileName);
		                map.put("path", "../img/" + saveFileName);
		                map.put("originFilename", originFilename);
		                map.put("extName", extName);
		                map.put("size", size);
		                map.put("boardNo", boardNo);

		                // 서비스 호출
		                communityService.addCommuFile(map);

		                // 모델에 데이터 추가
		                model.addAttribute("filename", originFilename);
		                model.addAttribute("uploadPath", saveFile.getAbsolutePath());
		            }
		        }
		        return "redirect:board/list.do";
		    } catch (Exception e) {
		        e.printStackTrace();
		        model.addAttribute("errorMessage", "파일 업로드 중 에러가 발생했습니다.");
		        return "errorPage"; // 에러 페이지로 리다이렉트하도록 변경
		    }
		}
}
