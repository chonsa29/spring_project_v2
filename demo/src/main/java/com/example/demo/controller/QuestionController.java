package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.QuestionService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class QuestionController {
	
	@Autowired
	QuestionService questionService;
	
	@RequestMapping("/inquire.do")
	public String help(Model model) throws Exception{
        return "/help/inquire";
    }
	
	@RequestMapping("/inquire/add.do")
	public String add(Model model) throws Exception{
        return "/help/inquire-add";
    }
	
	@RequestMapping("/inquire/view.do") 
    public String view(HttpServletRequest request,Model model, 
    		@RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
        return "/help/inquire-view";
    }
	
	@RequestMapping("/inquire/edit.do") 
    public String edit(HttpServletRequest request,Model model, 
    		@RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
        return "/help/inquire-edit";
    }
	
	@RequestMapping(value = "/inquire/qna.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String faq(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = questionService.questionQna(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquire/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = questionService.questionAdd(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquire/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String view(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = questionService.questionView(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquire/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String edit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = questionService.questionEdit(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/inquire/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String remove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
				
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = questionService.questionRemove(map);
		
		return new Gson().toJson(resultMap);
	}
}
