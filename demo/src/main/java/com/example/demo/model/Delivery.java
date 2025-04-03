package com.example.demo.model;

import lombok.Data;

@Data
public class Delivery {
	
	private String deliveryNo;
	private String orderKey;
	private String cartKey;
	private String deliveryStatus;
	private String trackingNumber;
	private String deliveryDate;
	private String deliveryFee;

}
