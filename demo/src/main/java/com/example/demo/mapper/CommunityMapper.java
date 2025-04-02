package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Group;
import com.example.demo.model.GroupInfo;
import com.example.demo.model.GroupUser;
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

	int checkLike(String postId, String userId);

	void deleteLike(String postId, String userId);

	void insertLike(String postId, String userId);

	int selectLikes(String postId);

	void deleteRecipe(HashMap<String, Object> map);

	Recipe recipeEditView(HashMap<String, Object> paramMap);

	void updateRecipe(Recipe recipe);

	List<Group> selectGroupList(HashMap<String, Object> map);

	int selectGroup(HashMap<String, Object> map);

	Group selectGroupView(HashMap<String, Object> map);

	void updateGroupCnt(HashMap<String, Object> map);

	List<GroupUser> selectMembers(HashMap<String, Object> map);

	String groupMemberCkeck(HashMap<String, Object> map);

	void insertGroupJoin(HashMap<String, Object> map);

	String groupLeaderCkeck(HashMap<String, Object> map);

	void insertGroupPost(HashMap<String, Object> map);

	void insertGroup(HashMap<String, Object> map);

	void updatePostId(HashMap<String, Object> map);

	GroupInfo selectGroupId(HashMap<String, Object> map);

	int selectLastPostId(HashMap<String, Object> map);

	void insertGroupMember(HashMap<String, Object> map);

}
