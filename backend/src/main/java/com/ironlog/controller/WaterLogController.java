package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.service.WaterLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/water")
@CrossOrigin(origins = "*")
public class WaterLogController {

    @Autowired
    private WaterLogService waterLogService;

    @PostMapping("/add")
    public Result<String> addWater(@RequestBody Map<String, Object> payload) {
        // In a real app, userId comes from security context.
        // For now, we accept it from the payload or default to 1 (Admin).
        Integer userIdInt = (Integer) payload.get("userId");
        Long userId = userIdInt != null ? Long.valueOf(userIdInt) : 1L;

        Integer amount = (Integer) payload.get("amount");

        if (amount == null || amount <= 0) {
            return Result.error("饮水量无效");
        }
        waterLogService.addWater(userId, amount);
        return Result.success("添加成功", null);
    }

    @GetMapping("/today")
    public Result<Integer> getTodayWater(@RequestParam(required = false) Long userId) {
        if (userId == null) {
            userId = 1L; // Default to admin
        }
        return Result.success(waterLogService.getTodayTotal(userId));
    }
}
