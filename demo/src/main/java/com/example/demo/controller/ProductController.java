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
	public String productList(Model model) throws Exception {
		return "/product/product-list";
	}

	@RequestMapping("/product/info.do")
	public String View(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {
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

	// 상품 목록 가져오기2
	@RequestMapping(value = "/product/list2.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody

	public String productList2(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.productList2(map);
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

	// 리뷰 가져오기
	@RequestMapping(value = "/product/review.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody

	public String productReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.productReview(map);
		return new Gson().toJson(resultMap);
	}

	// 상품 추가
	@RequestMapping(value = "/product/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.productAdd(map);
		return new Gson().toJson(resultMap);
	}

	// 상품 수정
	@RequestMapping(value = "/product/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String update(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.productUpdate(map);
		return new Gson().toJson(resultMap);
	}

	// 파일 업로드
	@RequestMapping("/product/fileUpload.dox")
	public String result(@RequestParam("file1") List<MultipartFile> files, @RequestParam("itemNo") int itemNo,
			@RequestParam(value = "contentImage", required = false) MultipartFile contentImage,
			HttpServletRequest request, HttpServletResponse response, Model model) {

		String path = "c:\\img";
		boolean thumbFlg = true;

		try {
			// 기존 썸네일/추가이미지 업로드
			for (MultipartFile multi : files) {
				String originFilename = multi.getOriginalFilename();
				String extName = originFilename.substring(originFilename.lastIndexOf("."), originFilename.length());
				long size = multi.getSize();
				String saveFileName = Common.genSaveFileName(extName);

				String path2 = System.getProperty("user.dir");
				if (!multi.isEmpty()) {
					File file = new File(path2 + "\\src\\main\\webapp\\img", saveFileName);
					multi.transferTo(file);

					HashMap<String, Object> map = new HashMap<String, Object>();
					map.put("filename", saveFileName);
					map.put("path", "../img/" + saveFileName);
					map.put("itemNo", itemNo);
					map.put("thumbNail", thumbFlg ? "Y" : "N");

					productService.addProductFile(map);
					thumbFlg = false;
				}
			}

			// ✅ 설명용 이미지(contentImage) BLOB 저장
			if (contentImage != null && !contentImage.isEmpty()) {
				byte[] blobData = contentImage.getBytes();

				HashMap<String, Object> blobMap = new HashMap<>();
				blobMap.put("itemNo", itemNo);
				blobMap.put("contentBlob", blobData);

				// BLOB 저장용 service 호출
				productService.saveProductContentImage(blobMap);
			}

			return "redirect:/product.do";
		} catch (Exception e) {
			System.out.println(e);
		}
		return "redirect:/product.do";
	}

	// 상품 수정
	@RequestMapping("/product/fileUpdate.dox")
	public String update(@RequestParam("file1") List<MultipartFile> files,
	                     @RequestParam("itemNo") int itemNo,
	                     @RequestParam("isThumbnail") String isThumbnail,
	                     @RequestParam(value = "contentImage", required = false) MultipartFile contentImage,
	                     HttpServletRequest request, HttpServletResponse response, Model model) {

	    String path = "c:\\img";

	    try {
	        for (MultipartFile multi : files) {
	            String originFilename = multi.getOriginalFilename();
	            String extName = originFilename.substring(originFilename.lastIndexOf("."), originFilename.length());
	            long size = multi.getSize();
	            String saveFileName = Common.genSaveFileName(extName);

	            String path2 = System.getProperty("user.dir");
	            if (!multi.isEmpty()) {
	                File file = new File(path2 + "\\src\\main\\webapp\\img", saveFileName);
	                multi.transferTo(file);

	                HashMap<String, Object> map = new HashMap<>();
	                map.put("filename", saveFileName);
	                map.put("path", "../img/" + saveFileName);
	                map.put("itemNo", itemNo);
	                map.put("thumbNail", isThumbnail);

	                productService.updateProductFile(map);
	            }
	        }

	        // ✅ 설명 이미지 BLOB 업데이트
	        if (contentImage != null && !contentImage.isEmpty()) {
	            byte[] blobData = contentImage.getBytes();

	            HashMap<String, Object> blobMap = new HashMap<>();
	            blobMap.put("itemNo", itemNo);
	            blobMap.put("contentBlob", blobData);
	            
	            System.out.println(blobMap);
	            
	            productService.updateProductContentImage(blobMap);
	        }

	        return "redirect:/member/admin.do";
	    } catch (Exception e) {
	        System.out.println(e);
	    }
	    return "redirect:/member/admin.do";
	}

	@RequestMapping(value = "/product/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String delete(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.productDelete(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/product/deleteImg.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteImg(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.productDeleteImg(map);
		return new Gson().toJson(resultMap);
	}

	// 좋아요 처리
	@RequestMapping(value = "/product/likeToggle.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String likeToggle(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.productlikeToggle(map);
		return new Gson().toJson(resultMap);
	}

	// 좋아요 조회
	@RequestMapping(value = "/product/getLikedItems.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getLikedItems(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.productgetLikedItems(map);
		return new Gson().toJson(resultMap);
	}

	// 상품별 문의 가져오기
	@RequestMapping(value = "/product/getproductQuestion.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getproductQuestion(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.getproductQuestion(map);
		return new Gson().toJson(resultMap);
	}

	// 상품별 문의 추가하기
	@RequestMapping(value = "/product/addproductQuestion.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addproductQuestion(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = productService.addproductQuestion(map);
		return new Gson().toJson(resultMap);
	}

}
