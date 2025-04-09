package com.example.demo.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.CommunityMapper;
import com.example.demo.model.Comment;
import com.example.demo.model.Group;
import com.example.demo.model.GroupInfo;
import com.example.demo.model.GroupUser;
import com.example.demo.model.Notification;
import com.example.demo.model.Question;
import com.example.demo.model.Recipe;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.websocket.Session;

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

	// 레시피 게시글 삭제
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
	    ObjectMapper objectMapper = new ObjectMapper();

	    try {
	        // HashMap -> Recipe 객체 변환
	        Recipe recipe = objectMapper.convertValue(map, Recipe.class);

	        communityMapper.updateRecipe(recipe);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	
	// 댓글
	public HashMap<String, Object> getCommentList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// 1. 댓글 + 대댓글을 한 번에 불러옴
	        List<Comment> flatList = communityMapper.selectCommentList(map);

	        // 2. commentId 기준으로 매핑
	        Map<String, Comment> commentMap = new HashMap<>();
	        List<Comment> commentList = new ArrayList<Comment>();

	        for (Comment comment : flatList) {
	            commentMap.put(comment.getCommentId(), comment);
	        }

	        // 3. parentId를 기준으로 계층화
	        for (Comment comment : flatList) {
	            String parentId = comment.getParentId();
	            if (parentId == null) {
	                commentList.add(comment); // 일반 댓글
	            } else {
	                Comment parent = commentMap.get(parentId);
	                if (parent != null) {
	                    parent.getReplies().add(comment); // 대댓글 추가
	                }
	            }
	        }
	        
			resultMap.put("commentList", commentList); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	// 댓글 추가
	public HashMap<String, Object> addComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.insertComment(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}
	
	// 댓글 수정
	public HashMap<String, Object> editComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.updateComment(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}
	
	// 댓글 삭제
	public HashMap<String, Object> deleteComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.deleteComment(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}
	
	// 대댓글 추가
	public HashMap<String, Object> addRecomment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.insertRecomment(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}
	
	// // 그룹 부분 // //
	
	// 그룹 리스트
	public HashMap<String, Object> getGroupList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Group> gList =  communityMapper.selectGroupList(map);
			int count = communityMapper.selectGroup(map);
			
			// 사용자의 리더 상태 확인
	        String leaders = communityMapper.groupLeaderCkeck(map);	
	      
	        if (leaders != null) {
	        	resultMap.put("leaders", true);  // 이미 그룹에 속해 있음
	            
	        } else {
	        	resultMap.put("leaders", false);  // 그룹에 속하지 않음
	        }
	        
	        GroupInfo group = communityMapper.selectGroupId(map);
	        
	        if (group != null) {
	        	resultMap.put("group", group);
	        } else {
	        	resultMap.put("group", "");
	        }
			
			resultMap.put("count", count);
			resultMap.put("gList", gList); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	// 게시글 자세히 보기
	public HashMap<String, Object> groupView(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			
			if(map.get("option").equals("SELECT")) {
				communityMapper.updateGroupCnt(map);
			}
			
			Group info = communityMapper.selectGroupView(map);
			
			List<GroupUser> members =  communityMapper.selectMembers(map);			
			resultMap.put("members", members); 
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}

	// 그룹 멤버 리스트
	public HashMap<String, Object> getGroupMembers(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<GroupUser> members =  communityMapper.selectMembers(map);			
			resultMap.put("members", members); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	// 그룹 체크
	public HashMap<String, Object> groupMemberCheck(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

        // 사용자의 그룹 상태 조회 (예: 이미 그룹에 속해있는지 확인)
        String groupStatus = communityMapper.groupMemberCkeck(map);	
      
        if (groupStatus != null) {
            result.put("groupStatus", "joined");  // 이미 그룹에 속해 있음
            
        } else {
            result.put("groupStatus", "not_joined");  // 그룹에 속하지 않음
        }

        return result;
    }
	
	
	// 그룹 신청
	public HashMap<String, Object> joinGroup(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.insertGroupJoin(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}

	// 그룹 게시글 작성
	public HashMap<String, Object> addGroup(HashMap<String, Object> map) {
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			// 1. INSERT 실행
	        communityMapper.insertGroupPost(map);

	        // 2. 마지막 POST_ID 가져오기
	        int postId = communityMapper.selectLastPostId(map);
	        map.put("postId", postId); // map에 저장

	        // 3. GROUP_INFO 업데이트
	        communityMapper.updatePostId(map);
	        
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}

	// 그룹 생성
	public HashMap<String, Object> createGroup(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        
			// 1. 그룹 생성
			communityMapper.insertGroup(map);
			
			// 2. GROUP_ID 가져오기
			GroupInfo group = communityMapper.selectGroupId(map);
			String groupId = group.getGroupId();
			System.out.println(groupId);
			
	        map.put("groupId", groupId); // map에 저장
	        
	        // 3. 멤버에 추가
			communityMapper.insertGroupMember(map);
			
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}

	// 멤버 수락하기
	public HashMap<String, Object> acceptMember(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.updateMemberJoin(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}

	// 멤버 거절
	public HashMap<String, Object> rejectMember(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.deleteMemberReject(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}

	// 그룹 마감
	public HashMap<String, Object> closeGroup(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.updateGroupStatus(map); //마감상태
	        communityMapper.deleteMember(map); //PENDING 멤버 삭제
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}
	
	// 그룹 활성화
	public HashMap<String, Object> activeGroup(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
	        communityMapper.updateGroupStatusActive(map); //마감상태
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}

	// 채팅
	public HashMap<String, Object> chatGroup(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			Group info =  communityMapper.selectGroupChat(map);
			
			resultMap.put("info", info);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }
		return resultMap;
	}
	
	// 그룹 삭제 전 알림
	public HashMap<String, Object> sendDeleteNotification(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        List<Group> groupList = communityMapper.selectGroupsToNotify(); // 27일 이상 지난 그룹 조회
	        int totalNotiCount = 0;

	        for (Group group : groupList) {
	            String groupId = group.getGroupId();
	            String groupName = group.getGroupName();
	            int daysLeft = group.getDaysLeft();
	            
	            System.out.println("알림 보낼 그룹 이름: " + group.getGroupName());

	            List<GroupUser> members = communityMapper.selectGroupMembersByGroupId(groupId);

	            for (GroupUser member : members) {
	                HashMap<String, Object> notiMap = new HashMap<>();
	                notiMap.put("userId", member.getUserId());
	                notiMap.put("groupId", groupId);
	                notiMap.put("title", "[알림] " + groupName);
	                notiMap.put("message", "'" + groupName + "' 그룹이 " + daysLeft + "일 후 자동 삭제됩니다.");
	                notiMap.put("type", "DELETE_NOTICE");

	                int duplicateCount = communityMapper.checkDuplicateNotification(notiMap);

	                if (duplicateCount == 0) {
	                    notiMap.put("title", "[알림] " + groupName);
	                    notiMap.put("message", "'" + groupName + "' 그룹이 " + daysLeft + "일 후 자동 삭제됩니다.");

	                    communityMapper.insertGroupDeleteNotification(notiMap);
	                    totalNotiCount++;
	                }
	            }
	        }

	        resultMap.put("notifiedGroups", groupList.size());
	        resultMap.put("totalNotiSent", totalNotiCount);
	        resultMap.put("result", "success");

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("error", e.getMessage());
	    }

	    return resultMap;
	}
	
	public List<Notification> getUserNotifications(HashMap<String, Object> map) {
	    return communityMapper.selectUserNotifications(map);
	}

	public HashMap<String, Object> removeGroupPost(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			communityMapper.deleteGroupPost(map);

	        resultMap.put("result", "success");
	            
	    } catch (Exception e) {
	    	
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        
	    }
		return resultMap;
	}

	// 게시글 수정
	public HashMap<String, Object> editGroupPost(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		communityMapper.updateGroupPost(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	public Group getGroupById(Object postId) {
		try {
	        HashMap<String, Object> paramMap = new HashMap<>();
	        paramMap.put("postId", postId);
	        return communityMapper.groupEditView(paramMap);
	    } catch (Exception e) {
	        System.out.println("Error fetching recipe: " + e.getMessage());
	        throw e;
	    }
	}

	public void deleteExpiredGroups() {
		communityMapper.deleteGroupsOlderThanOneMonth();
		
	}

	

}
