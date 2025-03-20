package com.example.demo.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.DeliveryMapper;

@Service
public class DeliveryService {
	@Autowired
	DeliveryMapper deliveryMapper;
}
