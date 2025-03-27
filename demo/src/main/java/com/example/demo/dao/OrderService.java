package com.example.demo.dao;

import com.example.demo.mapper.OrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;

    public List<Map<String, Object>> getOrderList(Map<String, Object> params) {
        // 검색 조건 처리
        Map<String, Object> searchParams = new HashMap<>();
        
        // 날짜 검색 조건
        if (params.containsKey("startDate") && params.containsKey("endDate")) {
            searchParams.put("startDate", params.get("startDate"));
            searchParams.put("endDate", params.get("endDate"));
        }
        
        // 주문 상태 필터
        if (params.containsKey("status")) {
            searchParams.put("status", params.get("status"));
        }
        
        // 검색어
        if (params.containsKey("searchType") && params.containsKey("searchValue")) {
            searchParams.put("searchType", params.get("searchType"));
            searchParams.put("searchValue", params.get("searchValue"));
        }
        
        return orderMapper.selectOrderList(searchParams);
    }

    public Map<String, Object> getOrderDetail(String orderId) {
        Map<String, Object> result = new HashMap<>();
        result.put("order", orderMapper.selectOrderDetail(orderId));
        result.put("items", orderMapper.selectOrderItems(orderId));
        return result;
    }

    public Map<String, Object> updateOrderStatus(Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();
        int affectedRows = orderMapper.updateOrderStatus(params);
        result.put("success", affectedRows > 0);
        return result;
    }

    public Map<String, Object> cancelOrder(Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();
        int affectedRows = orderMapper.cancelOrder(params);
        result.put("success", affectedRows > 0);
        return result;
    }
}