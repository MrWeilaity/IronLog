package com.ironlog.controller;

import com.ironlog.service.WaterLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/water")
public class WaterLogController {

    @Autowired
    private WaterLogService waterLogService;

    @PostMapping("/add")
    public ResponseEntity<String> addWater(@RequestBody Map<String, Object> payload) {
        // In a real app, userId comes from security context.
        // For now, we accept it from the payload or default to 1 (Admin).
        Integer userIdInt = (Integer) payload.get("userId");
        Long userId = userIdInt != null ? Long.valueOf(userIdInt) : 1L;

        Integer amount = (Integer) payload.get("amount");

        if (amount == null || amount <= 0) {
            return ResponseEntity.badRequest().body("Invalid amount");
        }
        waterLogService.addWater(userId, amount);
        return ResponseEntity.ok("Added successfully");
    }

    @GetMapping("/today")
    public ResponseEntity<Integer> getTodayWater(@RequestParam(required = false) Long userId) {
        if (userId == null) {
            userId = 1L; // Default to admin
        }
        return ResponseEntity.ok(waterLogService.getTodayTotal(userId));
    }
}
