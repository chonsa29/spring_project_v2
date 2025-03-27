package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.CommunityMapper;
import com.example.demo.model.Recipe;

@Service
public class CommunityService {
	@Autowired
	CommunityMapper communityMapper;

	// 레시피 리스트
	public HashMap<String, Object> getRecipeList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Recipe> rList =  communityMapper.selectRecipetList(map);
			int count = communityMapper.selectRecipe(map);
			resultMap.put("count", count);
			resultMap.put("rList", rList); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}
