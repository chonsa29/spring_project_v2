package com.example.demo.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.PayMapper;

@Service
public class PayService {
	@Autowired
	PayMapper payMapper;
}
