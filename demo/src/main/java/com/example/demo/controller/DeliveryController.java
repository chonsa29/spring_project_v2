package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.example.demo.dao.DeliveryService;

@Controller
public class DeliveryController {
	@Autowired
	DeliveryService deliveryService;
}
