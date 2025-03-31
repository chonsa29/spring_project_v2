package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.CommunityMapper;
import com.example.demo.model.Question;
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

	// 레시피 게시글 상세보기
	public HashMap<String, Object> recipeView(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			
			String postId = (String) map.get("postId");  // map에서 postId 추출
	        String userId = (String) map.get("userId");  // map에서 userId 추출
			
			if(map.get("option").equals("SELECT")) {
				communityMapper.updateCnt(map);
			}
			Recipe info = communityMapper.selectRecipeView(map);
			
			// 해당 유저가 좋아요를 눌렀는지 여부 확인
		    int likeCount = communityMapper.checkLike(postId, userId);  // 유저의 좋아요 상태 확인
		    info.setIsLiked(likeCount > 0);  // 유저가 좋아요를 눌렀으면 true, 아니면 false
		    
		    // 총 좋아요 개수 가져오기
		    int totalLikes = communityMapper.selectLikes(postId);
		    info.setLikes(totalLikes);  // 좋아요 개수 설정
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

	// 레시피 게시글 추가
	public HashMap<String, Object> addRecipe(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.insertRecipe(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}

	public void addCommuFile(HashMap<String, Object> map) {
		communityMapper.insertCommuFile(map);
		
	}
	
	// 게시글 수정
	public Recipe getRecipeById(Object postId) {
	    try {
	        HashMap<String, Object> paramMap = new HashMap<>();
	        paramMap.put("postId", postId);
	        return communityMapper.recipeEditView(paramMap);
	    } catch (Exception e) {
	        System.out.println("Error fetching recipe: " + e.getMessage());
	        throw e;
	    }
	}
	
	public HashMap<String, Object> recipeEditView(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Recipe info = communityMapper.recipeEditView(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> recipeEdit(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			if(map.get("option").equals("SELECT")) {
				communityMapper.updateCnt(map);
			}
			Recipe info = communityMapper.selectRecipeView(map);
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
	
	// 좋아요 기능
	public boolean toggleLike(String postId, String userId) throws Exception {
	    try {
	    	int count = communityMapper.checkLike(postId, userId);
	    	System.out.println("현재 좋아요 상태 count: " + count);
	        if (count > 0) {
	            // 좋아요를 이미 눌렀으므로 취소
	            communityMapper.deleteLike(postId, userId);
	            return false;
	        } else {
	            // 좋아요 추가
	            communityMapper.insertLike(postId, userId);
	            return true;
	        }
	    } catch (Exception e) {
	        throw e;
	    }
	}

	public int getLikes(String postId) throws Exception {
	    return communityMapper.selectLikes(postId);
	}

	public HashMap<String, Object> removeRecipe(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			communityMapper.deleteRecipe(map);

	        resultMap.put("result", "success");
	            
	    } catch (Exception e) {
	    	
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        
	    }
		return resultMap;
	}

	// 레시피 수정
	public HashMap<String, Object> editRecipe(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    // map에서 Recipe 객체 추출
	    Recipe recipe = (Recipe) map.get("recipe");

	    try {
	        communityMapper.updateRecipe(recipe);  // Recipe 객체를 넘기도록 수정
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	




}
