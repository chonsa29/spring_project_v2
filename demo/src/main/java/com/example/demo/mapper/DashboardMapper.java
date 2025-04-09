package com.example.demo.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.Question;
import com.example.demo.model.QuestionReply;
import com.example.demo.model.Recipe;
@Mapper
public interface DashboardMapper {
    int selectTodayOrderCount();
    
    int selectTodayCancelRequestCount();
    
    int selectTodayDeliveryCount();
    
    int selectPendingInquiryCount();
    
    List<Map<String, Object>> selectWeeklySales();
    
    List<Map<String, Object>> selectRecentOrders();
    
    List<Map<String, Object>> selectTopProducts();
    
    List<Recipe> selectRecipeList(Map<String, Object> params);
    
    int selectRecipeCount(Map<String, Object> params);
    
    void deleteRecipe(int postId);

    // 문의
    List<Question> selectInquiryList(Map<String, Object> params);
    
    Question selectInquiryById(int qsNo);
    
    void updateInquiryStatus(@Param("qsNo") int qsNo, @Param("status") String status);
    
    // 답변
    void insertReply(QuestionReply reply);
    
    List<QuestionReply> selectRepliesByQsNo(int qsNo);
    
    void deleteReply(int replyNo);
    
    void updateReply(QuestionReply reply);
    
    List<Map<String, Object>> selectDeliveryList(Map<String, Object> params);
    
    int selectDeliveryCount(Map<String, Object> params);
    
    void updateDeliveryStatus(@Param("deliveryNo") int deliveryNo, @Param("status") String status);
    
    void updateTrackingNumber(@Param("deliveryNo") int deliveryNo, @Param("trackingNumber") String trackingNumber);

	Map<String, Object> selectDeliveryDetail(Map<String, Object> params);
}