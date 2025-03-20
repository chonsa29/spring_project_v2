package com.example.demo.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ReviewMapper;

@Service
public class ReviewService {
	@Autowired
	ReviewMapper reviewMapper;
}
