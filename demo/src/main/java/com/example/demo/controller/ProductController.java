package com.example.demo.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.common.Common;
import com.example.demo.dao.ProductService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class ProductController {
	@Autowired
	ProductService productService;
	
	@RequestMapping("/product.do")
	public String productList(Model model) throws Exception{
        return "/product/product-list"; 
    }

	
	@RequestMapping("/product/info.do") 
	public String View(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/product/product-info";
	}
	
	// 상품 목록 가져오기
	@RequestMapping(value = "/product/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	
	public String productList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = productService.productList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상품 상세정보 가져오기
	@RequestMapping(value = "/product/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	
	public String productInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = productService.productInfo(map);
		return new Gson().toJson(resultMap);
	}
	
	//상품 추가
	@RequestMapping(value = "/product/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.productAdd(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/product/fileUpload.dox")
	public String result(@RequestParam("file1") List<MultipartFile> files, @RequestParam("itemNo") int itemNo,
			HttpServletRequest request, HttpServletResponse response, Model model) {

		String url = null;
		String path = "c:\\img";
		boolean thumbFlg = true;	
		try {
			for (MultipartFile multi : files) {
				// String uploadpath = request.getServletContext().getRealPath(path);
				String uploadpath = path;
				String originFilename = multi.getOriginalFilename();
				String extName = originFilename.substring(originFilename.lastIndexOf("."), originFilename.length());
				long size = multi.getSize();
				String saveFileName = Common.genSaveFileName(extName);

				System.out.println("uploadpath : " + uploadpath);
				System.out.println("originFilename : " + originFilename);
				System.out.println("extensionName : " + extName);
				System.out.println("size : " + size);
				System.out.println("saveFileName : " + saveFileName);
				String path2 = System.getProperty("user.dir");
				System.out.println("Working Directory = " + path2 + "\\src\\webapp\\img");
				if (!multi.isEmpty()) {
					File file = new File(path2 + "\\src\\main\\webapp\\img", saveFileName);
					multi.transferTo(file);

					HashMap<String, Object> map = new HashMap<String, Object>();
					map.put("filename", saveFileName);
					map.put("path", "../img/" + saveFileName);
//					map.put("originFilename", originFilename);
//					map.put("extName", extName); // 확장자
//					map.put("size", size);
					map.put("itemNo", itemNo);
					String thumbNail = thumbFlg ? "Y" : "N";
					map.put("thumbNail", thumbNail);
					// insert 쿼리 실행
					productService.addProductFile(map);
					thumbFlg = false;


				}
			}

			return "redirect:/member/admin.do";
		} catch (Exception e) {
			System.out.println(e);
		}
		return "redirect:/member/admin.do";
	}
}
