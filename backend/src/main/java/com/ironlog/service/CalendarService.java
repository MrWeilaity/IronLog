package com.ironlog.service;

import com.ironlog.entity.TrainRecord;
import com.ironlog.entity.DietLog;
import com.ironlog.repository.TrainRecordRepository;
import com.ironlog.repository.DietLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.*;

@Service
public class CalendarService {

    @Autowired
    private TrainRecordRepository trainRecordRepository;

    @Autowired
    private DietLogRepository dietLogRepository;

    public Map<String, Object> getCalendarHeatmap(Long userId, YearMonth yearMonth) {
        Map<String, Object> result = new HashMap<>();
        
        LocalDate startDate = yearMonth.atDay(1);
        LocalDate endDate = yearMonth.atEndOfMonth();
        
        List<TrainRecord> records = trainRecordRepository.findByUserIdAndRecordDateBetween(userId, startDate, endDate);
        
        // Group records by date
        Map<LocalDate, List<TrainRecord>> recordsByDate = new HashMap<>();
        for (TrainRecord record : records) {
            recordsByDate.computeIfAbsent(record.getRecordDate(), k -> new ArrayList<>()).add(record);
        }
        
        // Create heatmap data
        List<Map<String, Object>> heatmapData = new ArrayList<>();
        LocalDate current = startDate;
        
        while (!current.isAfter(endDate)) {
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", current.toString());
            
            List<TrainRecord> dayRecords = recordsByDate.getOrDefault(current, new ArrayList<>());
            
            String status;
            if (!dayRecords.isEmpty()) {
                status = "completed"; // Green dot - training completed
            } else if (current.isAfter(LocalDate.now())) {
                status = "future"; // No status - future date
            } else {
                status = "missed"; // Red dot - missed training
            }
            
            dayData.put("status", status);
            dayData.put("recordCount", dayRecords.size());
            
            heatmapData.add(dayData);
            current = current.plusDays(1);
        }
        
        result.put("yearMonth", yearMonth.toString());
        result.put("heatmap", heatmapData);
        
        return result;
    }

    public Map<String, Object> getDayDetail(Long userId, LocalDate date) {
        Map<String, Object> detail = new HashMap<>();
        
        // Get training records
        List<TrainRecord> trainRecords = trainRecordRepository.findByUserIdAndRecordDate(userId, date);
        List<Map<String, Object>> trainingData = new ArrayList<>();
        
        for (TrainRecord record : trainRecords) {
            Map<String, Object> recordData = new HashMap<>();
            recordData.put("id", record.getId());
            recordData.put("exerciseType", record.getExerciseType());
            recordData.put("duration", record.getDuration());
            recordData.put("weight", record.getWeight());
            recordData.put("reps", record.getReps());
            recordData.put("sets", record.getSetNo());
            recordData.put("notes", record.getNotes() != null ? record.getNotes() : record.getNote());
            trainingData.add(recordData);
        }
        
        // Get diet records
        List<DietLog> dietLogs = dietLogRepository.findByUserIdAndLogDate(userId, date);
        List<Map<String, Object>> dietData = new ArrayList<>();
        
        double totalCalories = 0;
        double totalProtein = 0;
        double totalCarbs = 0;
        double totalFat = 0;
        
        for (DietLog log : dietLogs) {
            Map<String, Object> logData = new HashMap<>();
            logData.put("id", log.getId());
            logData.put("mealType", log.getMealType());
            logData.put("calories", log.getCalcCalories());
            logData.put("protein", log.getCalcProtein());
            logData.put("carbs", log.getCalcCarbs());
            logData.put("fat", log.getCalcFat());
            dietData.add(logData);
            
            totalCalories += log.getCalcCalories().doubleValue();
            totalProtein += log.getCalcProtein().doubleValue();
            totalCarbs += log.getCalcCarbs().doubleValue();
            totalFat += log.getCalcFat().doubleValue();
        }
        
        detail.put("date", date.toString());
        detail.put("training", trainingData);
        detail.put("diet", dietData);
        detail.put("totalCalories", totalCalories);
        detail.put("totalProtein", totalProtein);
        detail.put("totalCarbs", totalCarbs);
        detail.put("totalFat", totalFat);
        
        return detail;
    }
}
