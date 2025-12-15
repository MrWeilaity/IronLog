package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.entity.FoodNutrition;
import com.ironlog.entity.DietLog;
import com.ironlog.service.NutritionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
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
    public Result<List<FoodNutrition>> searchFoods(@RequestParam(required = false) String query) {
        if (query == null || query.trim().isEmpty()) {
            // Return all foods if no query provided
            return Result.success(nutritionService.getAllFoods());
        }
        return Result.success(nutritionService.searchFoods(query));
    }
    
    @GetMapping("/foods/{id}")
    public Result<FoodNutrition> getFoodById(@PathVariable Long id) {
        return nutritionService.getFoodById(id)
                .map(Result::success)
                .orElseGet(() -> Result.error("食物不存在"));
    }

    @PostMapping("/foods")
    public Result<FoodNutrition> addFood(@RequestBody FoodNutrition food) {
        return Result.success("添加成功", nutritionService.addFood(food));
    }

    @GetMapping("/diet-logs")
    public Result<List<DietLog>> getDietLogs(
            @RequestParam Long userId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        if (date == null) {
            date = LocalDate.now();
        }
        return Result.success(nutritionService.getDietLogsByDate(userId, date));
    }

    @PostMapping("/diet-logs")
    public Result<DietLog> addDietLog(@RequestBody DietLog log) {
        return Result.success("添加成功", nutritionService.addDietLog(log));
    }

    @DeleteMapping("/diet-logs/{id}")
    public Result<String> deleteDietLog(@PathVariable Long id) {
        nutritionService.deleteDietLog(id);
        return Result.success("删除成功", null);
    }
}
