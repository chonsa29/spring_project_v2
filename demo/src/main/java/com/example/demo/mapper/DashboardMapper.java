package com.example.demo.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DashboardMapper {
    int selectTodayOrderCount();
    int selectTodayCancelRequestCount();
    int selectTodayDeliveryCount();
    int selectPendingInquiryCount();
    List<Map<String, Object>> selectWeeklySales();
    List<Map<String, Object>> selectRecentOrders();
    List<Map<String, Object>> selectTopProducts();
}