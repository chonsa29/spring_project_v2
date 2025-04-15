package com.example.demo.model;

import java.util.Date;

import lombok.Data;

@Data
public class ReviewDTO {
    private int reviewNo;
    private int orderKey;
    private int itemNo;
    private String userid;
    private String reviewTitle;
    private int reviewScore;
    private Date cdatetime;
    private String reviewContents;
}
