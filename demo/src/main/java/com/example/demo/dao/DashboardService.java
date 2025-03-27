package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.DashboardMapper;

@Service
public class DashboardService {

    @Autowired
    private DashboardMapper dashboardMapper;

    public int getTodayOrderCount() {
        return dashboardMapper.selectTodayOrderCount();
    }

    public int getTodayCancelRequestCount() {
        return dashboardMapper.selectTodayCancelRequestCount();
    }

    public int getTodayDeliveryCount() {
        return dashboardMapper.selectTodayDeliveryCount();
    }

    public int getPendingInquiryCount() {
        return dashboardMapper.selectPendingInquiryCount();
    }

    public List<Map<String, Object>> getWeeklySales() {
        return dashboardMapper.selectWeeklySales();
    }

    public List<Map<String, Object>> getRecentOrders() {
        return dashboardMapper.selectRecentOrders();
    }

    public List<Map<String, Object>> getTopProducts() {
        return dashboardMapper.selectTopProducts();
    }
}