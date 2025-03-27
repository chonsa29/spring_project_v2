package com.example.demo.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
@Mapper
public interface OrderMapper {
    List<Map<String, Object>> selectOrderList(Map<String, Object> params);
    Map<String, Object> selectOrderDetail(String orderId);
    List<Map<String, Object>> selectOrderItems(String orderId);
    int updateOrderStatus(Map<String, Object> params);
    int cancelOrder(Map<String, Object> params);
}