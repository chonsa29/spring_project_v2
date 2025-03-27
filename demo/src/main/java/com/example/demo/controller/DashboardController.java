package com.example.demo.controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.DashboardService;

@Controller
@RequestMapping( value = "/admin/dashboard", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @PostMapping("/todayStats.dox")
    @ResponseBody
    public Map<String, Object> getTodayStats() {
        Map<String, Object> result = new HashMap<>();
        result.put("todayOrders", dashboardService.getTodayOrderCount());
        result.put("todayCancelRequests", dashboardService.getTodayCancelRequestCount());
        result.put("todayDeliveries", dashboardService.getTodayDeliveryCount());
        result.put("pendingInquiries", dashboardService.getPendingInquiryCount());
        return result;
    }

    @PostMapping("/weeklySales.dox")
    @ResponseBody
    public List<Map<String, Object>> getWeeklySales() {
        return dashboardService.getWeeklySales();
    }

    @PostMapping("/recentOrders.dox")
    @ResponseBody
    public List<Map<String, Object>> getRecentOrders() {
        return dashboardService.getRecentOrders();
    }

    @PostMapping("/topProducts.dox")
    @ResponseBody
    public List<Map<String, Object>> getTopProducts() {
        return dashboardService.getTopProducts();
    }
}