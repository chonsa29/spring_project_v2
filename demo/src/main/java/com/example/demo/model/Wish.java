package com.example.demo.model;

import lombok.Data;

@Data
public class Wish {	
	private String wishKey;
	private String userId;
	private String itemNo;
	private String addDate;
	private String price;
    private String recentWishProduct;
}
