package com.example.demo.model;

import java.util.Date;

public class Review2 {
	  private int reviewNo;
	    private int orderKey;
	    private int itemNo;
	    private String userId;
	    private String reviewTitle;       // 필요 없으면 제거해도 됨
	    private int reviewScore;
	    private String reviewContents;
	    private Date cdatetime;

	    // Getters and Setters
	    public int getReviewNo() {
	        return reviewNo;
	    }

	    public void setReviewNo(int reviewNo) {
	        this.reviewNo = reviewNo;
	    }

	    public int getOrderKey() {
	        return orderKey;
	    }

	    public void setOrderKey(int orderKey) {
	        this.orderKey = orderKey;
	    }

	    public int getItemNo() {
	        return itemNo;
	    }

	    public void setItemNo(int itemNo) {
	        this.itemNo = itemNo;
	    }

	    public String getUserId() {
	        return userId;
	    }

	    public void setUserId(String userId) {
	        this.userId = userId;
	    }

	    public String getReviewTitle() {
	        return reviewTitle;
	    }

	    public void setReviewTitle(String reviewTitle) {
	        this.reviewTitle = reviewTitle;
	    }

	    public int getReviewScore() {
	        return reviewScore;
	    }

	    public void setReviewScore(int reviewScore) {
	        this.reviewScore = reviewScore;
	    }

	    public String getReviewContents() {
	        return reviewContents;
	    }

	    public void setReviewContents(String reviewContents) {
	        this.reviewContents = reviewContents;
	    }

	    public Date getCdatetime() {
	        return cdatetime;
	    }

	    public void setCdatetime(Date cdatetime) {
	        this.cdatetime = cdatetime;
	    }
}
