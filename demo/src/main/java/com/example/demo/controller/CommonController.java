package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.CommonService;
import com.google.gson.Gson;

@Controller
public class CommonController {
	
	@Autowired
	CommonService commonService;
	
	@RequestMapping("/home.do")
	public String home(Model model) throws Exception{
        return "/home"; 
    }
	
	@RequestMapping("/brand.do")
	public String brand(Model model) throws Exception{
        return "/brand"; 
    }
	
	@RequestMapping(value = "/main/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String newProductList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.getNewProductList(map);
		return new Gson().toJson(resultMap);
	}

}
