package com.ironlog.service;

import com.ironlog.entity.FoodNutrition;
import com.ironlog.entity.DietLog;
import com.ironlog.repository.FoodNutritionRepository;
import com.ironlog.repository.DietLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class NutritionService {

    @Autowired
    private FoodNutritionRepository foodRepository;

    @Autowired
    private DietLogRepository dietLogRepository;

    public List<FoodNutrition> searchFoods(String query) {
        return foodRepository.findByNameContainingIgnoreCase(query);
    }

    public FoodNutrition addFood(FoodNutrition food) {
        return foodRepository.save(food);
    }

    public List<DietLog> getDietLogsByDate(Long userId, LocalDate date) {
        return dietLogRepository.findByUserIdAndLogDate(userId, date);
    }

    public DietLog addDietLog(DietLog log) {
        // Here we could fetch the FoodNutrition to calculate calories/macros accurately
        // But for now, we assume the frontend or caller provides the calculated values
        // OR we implement the calculation logic:

        FoodNutrition food = foodRepository.findById(log.getFoodId()).orElse(null);
        if (food != null && log.getIntakeAmount() != null) {
             // Calculate ratio: intake / std_unit
             // Use BigDecimal for precision, but double for simplicity in this example or BigDecimal logic
             // Ideally use BigDecimal arithmetic.
             // Skipped for brevity, trusting input or simple storage for now.
        }

        return dietLogRepository.save(log);
    }

    public void deleteDietLog(Long id) {
        dietLogRepository.deleteById(id);
    }
}
