package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Question;
import com.example.demo.model.Recipe;

@Mapper
public interface CommunityMapper {

	List<Recipe> selectRecipetList(HashMap<String, Object> map);

	int selectRecipe(HashMap<String, Object> map);

	Recipe selectRecipeView(HashMap<String, Object> map);

	void updateCnt(HashMap<String, Object> map);

	void insertRecipe(HashMap<String, Object> map);

	void insertCommuFile(HashMap<String, Object> map);

	String selectSavedContents(Object postId);

}
