package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.dao.ProductService;

@Controller
public class ProductController {
	@Autowired
	ProductService productService;
	
	@RequestMapping("/product.do")
	public String productList(Model model) throws Exception{
        return "/product/product-list"; 
    }
	
	@RequestMapping("/cart.do")
	public String cartList(Model model) throws Exception{
        return "/product/cart"; 
    }
}
