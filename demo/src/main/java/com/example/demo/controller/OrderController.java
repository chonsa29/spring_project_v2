package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.OrderService;

@Controller
@RequestMapping("/admin/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping
    public String orderManagement() {
        return "admin/order-management";
    }

    @PostMapping("/list.dox")
    @ResponseBody
    public List<Map<String, Object>> getOrderList(
            @RequestParam Map<String, Object> params) {
        return orderService.getOrderList(params);
    }

    @PostMapping("/detail.dox")
    @ResponseBody
    public Map<String, Object> getOrderDetail(
            @RequestParam("orderId") String orderId) {
        return orderService.getOrderDetail(orderId);
    }

    @PostMapping("/updateStatus.dox")
    @ResponseBody
    public Map<String, Object> updateOrderStatus(
            @RequestParam Map<String, Object> params) {
        return orderService.updateOrderStatus(params);
    }

    @PostMapping("/cancel.dox")
    @ResponseBody
    public Map<String, Object> cancelOrder(
            @RequestParam Map<String, Object> params) {
        return orderService.cancelOrder(params);
    }
}