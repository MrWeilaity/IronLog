package com.ironlog.controller;

import com.ironlog.entity.FoodNutrition;
import com.ironlog.entity.DietLog;
import com.ironlog.service.NutritionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/nutrition")
@CrossOrigin(origins = "*")
public class NutritionController {

    @Autowired
    private NutritionService nutritionService;

    @GetMapping("/foods")
    public ResponseEntity<List<FoodNutrition>> searchFoods(@RequestParam String query) {
        return ResponseEntity.ok(nutritionService.searchFoods(query));
    }

    @PostMapping("/foods")
    public ResponseEntity<FoodNutrition> addFood(@RequestBody FoodNutrition food) {
        return ResponseEntity.ok(nutritionService.addFood(food));
    }

    @GetMapping("/diet-logs")
    public ResponseEntity<List<DietLog>> getDietLogs(
            @RequestParam Long userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(nutritionService.getDietLogsByDate(userId, date));
    }

    @PostMapping("/diet-logs")
    public ResponseEntity<DietLog> addDietLog(@RequestBody DietLog log) {
        return ResponseEntity.ok(nutritionService.addDietLog(log));
    }
}
