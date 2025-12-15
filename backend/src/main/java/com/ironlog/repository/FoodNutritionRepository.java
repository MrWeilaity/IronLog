package com.ironlog.repository;

import com.ironlog.entity.FoodNutrition;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FoodNutritionRepository extends JpaRepository<FoodNutrition, Long> {
    List<FoodNutrition> findByNameContainingIgnoreCase(String name);
}
