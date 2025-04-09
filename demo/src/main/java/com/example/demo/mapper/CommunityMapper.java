package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Comment;
import com.example.demo.model.Group;
import com.example.demo.model.GroupInfo;
import com.example.demo.model.GroupUser;
import com.example.demo.model.Notification;
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
	
	

	void updateMemberJoin(HashMap<String, Object> map);

	void deleteMemberReject(HashMap<String, Object> map);

	void updateGroupStatus(HashMap<String, Object> map);

	Group selectGroupChat(HashMap<String, Object> map);

	void deleteMember(HashMap<String, Object> map);

	List<Group> selectGroupsToNotify(); // 27일 지난 그룹 조회
	List<GroupUser> selectGroupMembersByGroupId(String groupId); // 그룹 멤버 조회
	void insertGroupDeleteNotification(HashMap<String, Object> notiMap); // 알림 등록

	List<Notification> selectUserNotifications(HashMap<String, Object> map);
	
	int checkDuplicateNotification(HashMap<String, Object> map);

	void deleteGroupPost(HashMap<String, Object> map);

	void updateGroupPost(HashMap<String, Object> map);

	Group groupEditView(HashMap<String, Object> paramMap);

	List<Comment> selectCommentList(HashMap<String, Object> map);

	int selectComment(HashMap<String, Object> map);

	void insertComment(HashMap<String, Object> map);

	void insertRecomment(HashMap<String, Object> map);

	List<Comment> selectRecommentList(HashMap<String, Object> map);

	void updateGroupStatusActive(HashMap<String, Object> map);

}
