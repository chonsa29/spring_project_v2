package com.example.demo.model;

import lombok.Data;

@Data
public class Cart {
	
	private String cartKey;
	private String userId;
	private String itemNo;
	private String cartCount;
	private String itemName;
	private String price;
	private String filePath;

}
