package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.service.StatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/stats")
@CrossOrigin(origins = "*")
public class StatsController {

    @Autowired
    private StatsService statsService;

    @GetMapping("/leaderboard")
    public Result<List<Map<String, Object>>> getLeaderboard(
            @RequestParam(defaultValue = "volume") String type,
            @RequestParam(defaultValue = "10") int limit) {
        return Result.success(statsService.getLeaderboard(type, limit));
    }

    @GetMapping("/user-stats/{userId}")
    public Result<Map<String, Object>> getUserStats(@PathVariable Long userId) {
        return Result.success(statsService.getUserStats(userId));
    }
    
    @GetMapping("/weight-trend/{userId}")
    public Result<List<Map<String, Object>>> getWeightTrend(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "30") int days) {
        return Result.success(statsService.getWeightTrend(userId, days));
    }
    
    @GetMapping("/exercise-distribution/{userId}")
    public Result<List<Map<String, Object>>> getExerciseDistribution(@PathVariable Long userId) {
        return Result.success(statsService.getExerciseDistribution(userId));
    }
}
