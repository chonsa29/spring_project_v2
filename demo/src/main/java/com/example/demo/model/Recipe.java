package com.example.demo.model;

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
    private String cdatetime;
    private int likes;
    private String postCategory;
    private boolean isLiked;
    
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

}
