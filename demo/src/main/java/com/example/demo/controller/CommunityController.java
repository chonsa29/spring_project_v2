package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.CommunityService;
import com.google.gson.Gson;

@Controller
public class CommunityController {
	@Autowired
	CommunityService communityService;
	
	@RequestMapping("/commu-main.do")
	public String home(Model model) throws Exception{
        return "/community/commu-main"; 
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
}
