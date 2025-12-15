package com.ironlog.service;

import com.ironlog.entity.TrainRecord;
import com.ironlog.entity.DietLog;
import com.ironlog.entity.SysUser;
import com.ironlog.repository.TrainRecordRepository;
import com.ironlog.repository.DietLogRepository;
import com.ironlog.repository.SysUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class DashboardService {

    @Autowired
    private TrainRecordRepository trainRecordRepository;

    @Autowired
    private DietLogRepository dietLogRepository;

    @Autowired
    private SysUserRepository userRepository;

    public Map<String, Object> getDashboardStats(Long userId) {
        Map<String, Object> stats = new HashMap<>();
        LocalDate today = LocalDate.now();

        // Today's training count
        List<TrainRecord> todayRecords = trainRecordRepository.findByUserIdAndRecordDate(userId, today);
        stats.put("todayTrainingCount", todayRecords.size());

        // This week's training days
        LocalDate weekStart = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate weekEnd = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
        
        Set<LocalDate> trainingDays = new HashSet<>();
        LocalDate current = weekStart;
        while (!current.isAfter(weekEnd)) {
            List<TrainRecord> records = trainRecordRepository.findByUserIdAndRecordDate(userId, current);
            if (!records.isEmpty()) {
                trainingDays.add(current);
            }
            current = current.plusDays(1);
        }
        stats.put("weeklyTrainingDays", trainingDays.size());

        // This month's total training sessions
        LocalDate monthStart = today.withDayOfMonth(1);
        long monthlyTrainingDays = trainRecordRepository.countDistinctDates(userId, monthStart, today);
        stats.put("monthlyTrainingDays", monthlyTrainingDays);

        return stats;
    }

    public Map<String, Object> getWeeklyActivity(Long userId) {
        Map<String, Object> activity = new HashMap<>();
        LocalDate today = LocalDate.now();
        LocalDate weekStart = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));

        List<Map<String, Object>> dailyData = new ArrayList<>();
        int totalMinutes = 0;
        double totalVolume = 0.0;

        for (int i = 0; i < 7; i++) {
            LocalDate date = weekStart.plusDays(i);
            List<TrainRecord> records = trainRecordRepository.findByUserIdAndRecordDate(userId, date);

            int dayMinutes = records.stream()
                    .mapToInt(r -> r.getDuration() != null ? r.getDuration() : 0)
                    .sum();

            double dayVolume = records.stream()
                    .filter(r -> r.getWeight() != null && r.getReps() != null)
                    .mapToDouble(r -> r.getWeight().doubleValue() * r.getReps())
                    .sum();

            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", date.toString());
            dayData.put("dayOfWeek", date.getDayOfWeek().toString());
            dayData.put("minutes", dayMinutes);
            dayData.put("volume", dayVolume);

            dailyData.add(dayData);
            totalMinutes += dayMinutes;
            totalVolume += dayVolume;
        }

        activity.put("daily", dailyData);
        activity.put("totalMinutes", totalMinutes);
        activity.put("totalVolume", totalVolume);

        return activity;
    }

    public Map<String, Object> getBodyMetrics(Long userId) {
        Map<String, Object> metrics = new HashMap<>();

        Optional<SysUser> userOpt = userRepository.findById(userId);
        if (!userOpt.isPresent()) {
            return metrics;
        }

        SysUser user = userOpt.get();

        // Calculate BMI
        if (user.getHeight() != null && user.getWeight() != null && user.getHeight().compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal heightInMeters = user.getHeight().divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
            BigDecimal bmi = user.getWeight().divide(heightInMeters.multiply(heightInMeters), 2, RoundingMode.HALF_UP);
            metrics.put("bmi", bmi);

            // BMI category
            String category;
            if (bmi.compareTo(new BigDecimal("18.5")) < 0) {
                category = "偏瘦";
            } else if (bmi.compareTo(new BigDecimal("24")) < 0) {
                category = "正常";
            } else if (bmi.compareTo(new BigDecimal("28")) < 0) {
                category = "超重";
            } else {
                category = "肥胖";
            }
            metrics.put("bmiCategory", category);
        }

        metrics.put("height", user.getHeight());
        metrics.put("weight", user.getWeight());
        metrics.put("targetMetabolism", user.getTargetMetabolism());

        // Weight trend (last 7 days) - placeholder as we don't have a weight history table
        // In a real app, you'd have a separate table for weight history
        List<Map<String, Object>> weightTrend = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            Map<String, Object> point = new HashMap<>();
            point.put("date", LocalDate.now().minusDays(i).toString());
            point.put("weight", user.getWeight()); // In real app, fetch historical data
            weightTrend.add(point);
        }
        metrics.put("weightTrend", weightTrend);

        return metrics;
    }

    public List<Map<String, Object>> getRecentActivities(Long userId) {
        List<Map<String, Object>> activities = new ArrayList<>();
        LocalDate today = LocalDate.now();

        // Get recent training records
        for (int i = 0; i < 7; i++) {
            LocalDate date = today.minusDays(i);
            List<TrainRecord> records = trainRecordRepository.findByUserIdAndRecordDate(userId, date);

            if (!records.isEmpty()) {
                Map<String, Object> activity = new HashMap<>();
                activity.put("time", date.toString() + " " + (records.get(0).getCreatedAt() != null ? 
                    records.get(0).getCreatedAt().toLocalTime().toString() : ""));
                activity.put("title", "训练完成");
                
                String content;
                if (records.get(0).getExerciseType() != null) {
                    content = records.get(0).getExerciseType();
                } else {
                    content = "完成 " + records.size() + " 组训练";
                }
                activity.put("content", content);
                activity.put("type", "training");
                
                activities.add(activity);
            }

            // Get recent diet logs
            List<DietLog> dietLogs = dietLogRepository.findByUserIdAndLogDate(userId, date);
            if (!dietLogs.isEmpty()) {
                Map<String, Object> activity = new HashMap<>();
                activity.put("time", date.toString());
                activity.put("title", "饮食记录");
                
                double totalCalories = dietLogs.stream()
                    .mapToDouble(d -> d.getCalcCalories().doubleValue())
                    .sum();
                activity.put("content", "记录了 " + dietLogs.size() + " 餐，共 " + (int)totalCalories + " kcal");
                activity.put("type", "diet");
                
                activities.add(activity);
            }
        }

        // Sort by time descending
        activities.sort((a, b) -> ((String)b.get("time")).compareTo((String)a.get("time")));

        // Limit to 10 most recent
        return activities.stream().limit(10).collect(Collectors.toList());
    }
}
