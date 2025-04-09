package com.example.demo.model;

import lombok.Data;
import java.util.Date;
@Data
public class Recipe {
	
	private String postId;
    private String instructions;
    private String cookingTime;
    private String servings;
    private String difficulty;
    private String contents;
    private String title;
    private String userId;
    private String cnt;
    private Date cdatetime;
    private int likes;
    private String postCategory;
    private boolean isLiked;
    private int commentCount;
    private String nickname;
    
    // Getter and Setter for Contents
    public String getContents() {
        return contents;
    }

    public void setContents(String contents) {
        this.contents = contents;
    }
    
    public int getLikes() {
        return likes;
    }

    public void setLikes(int totalLikes) {
        this.likes = totalLikes;
    }

    // Getter and Setter for IsLiked
    public boolean isLiked() {
        return isLiked;
    }

    public void setIsLiked(boolean isLiked) {
        this.isLiked = isLiked;
    }

	public String getPostId() {
		return postId;
	}

	public void setPostId(String postId) {
		this.postId = postId;
	}

	public String getInstructions() {
		return instructions;
	}

	public void setInstructions(String instructions) {
		this.instructions = instructions;
	}

	public String getCookingTime() {
		return cookingTime;
	}

	public void setCookingTime(String cookingTime) {
		this.cookingTime = cookingTime;
	}

	public String getServings() {
		return servings;
	}

	public void setServings(String servings) {
		this.servings = servings;
	}

	public String getDifficulty() {
		return difficulty;
	}

	public void setDifficulty(String difficulty) {
		this.difficulty = difficulty;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCnt() {
		return cnt;
	}

	public void setCnt(String cnt) {
		this.cnt = cnt;
	}

	public Date getCdatetime() {
		return cdatetime;
	}

	public void setCdatetime(Date cdatetime) {
		this.cdatetime = cdatetime;
	}

	public String getPostCategory() {
		return postCategory;
	}

	public void setPostCategory(String postCategory) {
		this.postCategory = postCategory;
	}

	public void setLiked(boolean isLiked) {
		this.isLiked = isLiked;
	}
	
	public int getCommentCount() {
	    return commentCount;
	}

	public void setCommentCount(int commentCount) {
	    this.commentCount = commentCount;
	}

    
}
