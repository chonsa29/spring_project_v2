package com.example.demo.dao;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ProductMapper;
import com.example.demo.model.Product;
import com.example.demo.model.ProductQuestion;
import com.example.demo.model.Review;
import com.example.demo.model.Wish;

import jakarta.transaction.Transactional;

@Service
public class ProductService {
	@Autowired
	ProductMapper productMapper;

	// 리스트 가져오기
	public HashMap<String, Object> productList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Product> list = productMapper.SelectProduct(map);
			int count = productMapper.CountProduct(map);
			List<Product> category = productMapper.SelectCategory(map);
			resultMap.put("list", list);
			resultMap.put("count", count);
			resultMap.put("category", category);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	// (페이징 제외) 리스트 가져오기
	public HashMap<String, Object> productList2(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Product> list = productMapper.SelectProduct2(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	// 상세정보 가져오기
	public HashMap<String, Object> productInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Product info = productMapper.SelectProductInfo(map);
			// 단일객체
			int count = productMapper.SelectProductCount(map);
			// 재고
			List<Product> imgList = productMapper.SelectProductImgList(map);
			// 이미지 리스트
			List<Product> recommend = productMapper.RecommendProduct(map);
			// 추천 상품 목록 가져오기

			resultMap.put("imgList", imgList);
			resultMap.put("count", count);
			resultMap.put("info", info);
			resultMap.put("recommend", recommend);

			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	// 상품 추가하기
	@Transactional
	public HashMap<String, Object> productAdd(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        // 모든 가능한 숫자 타입 처리
	        Object priceObj = map.get("price");
	        if (priceObj instanceof BigDecimal) {
	            map.put("price", ((BigDecimal)priceObj).intValue());
	        } else if (priceObj instanceof String) {
	            map.put("price", Integer.parseInt((String)priceObj));
	        } else if (priceObj instanceof Integer) {
	            // 이미 Integer면 그대로 사용
	        } else {
	            throw new IllegalArgumentException("가격 형식이 올바르지 않습니다");
	        }

	        // 동일한 방식으로 quantity 처리
	        Object quantityObj = map.get("quantity");
	        if (quantityObj instanceof BigDecimal) {
	            map.put("quantity", ((BigDecimal)quantityObj).intValue());
	        } else if (quantityObj instanceof String) {
	            map.put("quantity", Integer.parseInt((String)quantityObj));
	        } else if (quantityObj instanceof Integer) {
	            // 이미 Integer면 그대로 사용
	        } else {
	            throw new IllegalArgumentException("수량 형식이 올바르지 않습니다");
	        }

	        productMapper.addProduct(map);
	        int itemNo = (int) map.get("itemNo");
	        
	        resultMap.put("result", "success");
	        resultMap.put("itemNo", itemNo);
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "상품 추가 실패: " + e.getMessage());
	        throw new RuntimeException(e); // 트랜잭션 롤백을 위해 예외 전파
	    }
	    return resultMap;
	}
	// 상품의 이미지 추가하기
	public void addProductFile(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		try {
			productMapper.insertProductFile(map);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
		}
	}

	public void updateProductFile(HashMap<String, Object> map) {
		if ("Y".equals(map.get("thumbNail"))) {
			// 썸네일은 UPDATE
			productMapper.updateThumbnail(map);
		} else {
			// 추가 이미지는 무조건 INSERT
			productMapper.insertAdditionalImage(map);
		}
	}

	public HashMap<String, Object> productDelete(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			productMapper.deleteProduct(map);
			productMapper.deleteProductImages(map);

			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	public void saveProductContentImage(HashMap<String, Object> map) throws Exception {
		// PRODUCT 테이블의 ITEM_CONTENTS 컬럼 업데이트
		productMapper.updateProductContentImage(map);
	}

	public void updateProductContentImage(HashMap<String, Object> map) throws Exception {
		productMapper.updateContentImage(map);
	}

	public HashMap<String, Object> productDeleteImg(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			productMapper.deleteProductImg(map);

			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	// 리뷰 목록 가져오기
	public HashMap<String, Object> productReview(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Review> review = productMapper.SelectProductReview(map);
			int reviewCount = productMapper.CountProductReview(map);
			resultMap.put("review", review);
			resultMap.put("reviewCount", reviewCount);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	// 좋아요 추가 / 취소 여부
	public HashMap<String, Object> productlikeToggle(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {

			// 1. 사용자와 상품 번호로 좋아요 상태 확인
			int likeCount = productMapper.checkIfLiked(map);

			if (likeCount > 0) {
				// 좋아요 취소
				productMapper.removeLike(map);
				resultMap.put("result", "c"); // "c"는 좋아요 취소
				resultMap.put("message", "좋아요 취소되었습니다.");
			} else {
				// 좋아요 추가
				productMapper.addLike(map);
				resultMap.put("result", "a"); // "a"는 좋아요 추가
				resultMap.put("message", "좋아요 추가되었습니다.");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", "좋아요 처리 중 오류가 발생했습니다.");
		}
		return resultMap;
	}

	// 유저별 좋아요 확인
	public HashMap<String, Object> productgetLikedItems(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Wish> wish = productMapper.SelectproductWish(map);
			resultMap.put("result", "success");
			resultMap.put("wish", wish);
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	// 상품별 문의 가져오기
	public HashMap<String, Object> getproductQuestion(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<ProductQuestion> ProductQuestion = productMapper.SelectproductQuestion(map);
			int QuestionCount = productMapper.CountProductQuestion(map);

			resultMap.put("ProductQuestion", ProductQuestion);
			resultMap.put("QuestionCount", QuestionCount);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
		// TODO Auto-generated method stub
	}

	// 상품별 문의 추가하기
	public HashMap<String, Object> addproductQuestion(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			productMapper.InsertproductQuestion(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}

	@Transactional
	public HashMap<String, Object> productUpdate(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 1. 상품 기본 정보 업데이트
			int updatedRows = productMapper.updateProduct(map);

			if (updatedRows > 0) {
				resultMap.put("result", "success");
				resultMap.put("itemNo", map.get("itemNo"));
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "상품 정보 업데이트 실패");
			}
		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", "상품 업데이트 중 오류 발생: " + e.getMessage());
			throw e; // 트랜잭션 롤백을 위해 예외 다시 던짐
		}
		return resultMap;
	}

	public void deleteThumbnail(int itemNo) {
		productMapper.deleteThumbnail(itemNo);
	}
}
