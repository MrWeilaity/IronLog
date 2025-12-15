package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
@CrossOrigin(origins = "*")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping("/stats/{userId}")
    public Result<Map<String, Object>> getDashboardStats(@PathVariable Long userId) {
        return Result.success(dashboardService.getDashboardStats(userId));
    }

    @GetMapping("/weekly-activity/{userId}")
    public Result<Map<String, Object>> getWeeklyActivity(@PathVariable Long userId) {
        return Result.success(dashboardService.getWeeklyActivity(userId));
    }

    @GetMapping("/body-metrics/{userId}")
    public Result<Map<String, Object>> getBodyMetrics(@PathVariable Long userId) {
        return Result.success(dashboardService.getBodyMetrics(userId));
    }
    
    @GetMapping("/recent-activities/{userId}")
    public Result<java.util.List<Map<String, Object>>> getRecentActivities(@PathVariable Long userId) {
        return Result.success(dashboardService.getRecentActivities(userId));
    }
}
