package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.example.demo.dao.QuestionService;

@Controller
public class QuestionController {
	@Autowired
	QuestionService questionService;
}
