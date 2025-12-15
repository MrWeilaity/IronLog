package com.ironlog.service;

import com.ironlog.entity.TrainRecord;
import com.ironlog.entity.SysUser;
import com.ironlog.repository.TrainRecordRepository;
import com.ironlog.repository.SysUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class StatsService {

    @Autowired
    private TrainRecordRepository trainRecordRepository;

    @Autowired
    private SysUserRepository userRepository;

    public List<Map<String, Object>> getLeaderboard(String type, int limit) {
        List<Map<String, Object>> leaderboard = new ArrayList<>();
        List<SysUser> users = userRepository.findAll();

        for (SysUser user : users) {
            Map<String, Object> entry = new HashMap<>();
            entry.put("userId", user.getId());
            entry.put("username", user.getUsername());
            entry.put("nickname", user.getNickname() != null ? user.getNickname() : user.getUsername());

            List<TrainRecord> records = trainRecordRepository.findByUserId(user.getId());

            if ("volume".equals(type)) {
                // Calculate total volume (weight * reps)
                double totalVolume = records.stream()
                        .filter(r -> r.getWeight() != null && r.getReps() != null)
                        .mapToDouble(r -> r.getWeight().doubleValue() * r.getReps())
                        .sum();
                entry.put("score", totalVolume);
                entry.put("unit", "kg");
            } else if ("streak".equals(type)) {
                // Calculate current streak
                int streak = calculateStreak(records);
                entry.put("score", streak);
                entry.put("unit", "天");
            } else {
                // Default: total training days
                Set<LocalDate> uniqueDates = records.stream()
                        .map(TrainRecord::getRecordDate)
                        .collect(Collectors.toSet());
                entry.put("score", uniqueDates.size());
                entry.put("unit", "天");
            }

            leaderboard.add(entry);
        }

        // Sort by score descending
        leaderboard.sort((a, b) -> Double.compare(
                ((Number) b.get("score")).doubleValue(),
                ((Number) a.get("score")).doubleValue()
        ));

        // Add rank
        for (int i = 0; i < leaderboard.size(); i++) {
            leaderboard.get(i).put("rank", i + 1);
        }

        // Return top N
        return leaderboard.stream().limit(limit).collect(Collectors.toList());
    }

    private int calculateStreak(List<TrainRecord> records) {
        if (records.isEmpty()) return 0;

        Set<LocalDate> uniqueDates = records.stream()
                .map(TrainRecord::getRecordDate)
                .collect(Collectors.toSet());

        List<LocalDate> sortedDates = new ArrayList<>(uniqueDates);
        Collections.sort(sortedDates, Collections.reverseOrder());

        int streak = 0;
        LocalDate expected = LocalDate.now();

        for (LocalDate date : sortedDates) {
            if (date.equals(expected) || date.equals(expected.minusDays(1))) {
                streak++;
                expected = date.minusDays(1);
            } else {
                break;
            }
        }

        return streak;
    }

    public Map<String, Object> getUserStats(Long userId) {
        Map<String, Object> stats = new HashMap<>();

        List<TrainRecord> records = trainRecordRepository.findByUserId(userId);
        
        // Total training days
        Set<LocalDate> uniqueDates = records.stream()
                .map(TrainRecord::getRecordDate)
                .collect(Collectors.toSet());
        stats.put("totalTrainingDays", uniqueDates.size());

        // Total volume
        double totalVolume = records.stream()
                .filter(r -> r.getWeight() != null && r.getReps() != null)
                .mapToDouble(r -> r.getWeight().doubleValue() * r.getReps())
                .sum();
        stats.put("totalVolume", totalVolume);

        // Current streak
        int streak = calculateStreak(records);
        stats.put("currentStreak", streak);

        // Total training time
        int totalMinutes = records.stream()
                .mapToInt(r -> r.getDuration() != null ? r.getDuration() : 0)
                .sum();
        stats.put("totalMinutes", totalMinutes);

        return stats;
    }

    public List<Map<String, Object>> getWeightTrend(Long userId, int days) {
        // In a real app, you'd have a weight history table
        // For now, return mock data based on user's current weight
        List<Map<String, Object>> trend = new ArrayList<>();
        
        Optional<SysUser> userOpt = userRepository.findById(userId);
        if (!userOpt.isPresent() || userOpt.get().getWeight() == null) {
            return trend;
        }

        double currentWeight = userOpt.get().getWeight().doubleValue();
        
        // Generate mock trend data
        for (int i = days - 1; i >= 0; i--) {
            Map<String, Object> point = new HashMap<>();
            point.put("date", LocalDate.now().minusDays(i).toString());
            // Add some variation for demonstration
            double variation = (Math.random() - 0.5) * 2;
            point.put("weight", Math.round((currentWeight + variation) * 10.0) / 10.0);
            trend.add(point);
        }

        return trend;
    }

    public List<Map<String, Object>> getExerciseDistribution(Long userId) {
        List<TrainRecord> records = trainRecordRepository.findByUserId(userId);
        
        // Group by exercise type
        Map<String, Long> distribution = records.stream()
                .filter(r -> r.getExerciseType() != null && !r.getExerciseType().isEmpty())
                .collect(Collectors.groupingBy(
                        TrainRecord::getExerciseType,
                        Collectors.counting()
                ));

        // Convert to list
        List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<String, Long> entry : distribution.entrySet()) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", entry.getKey());
            item.put("value", entry.getValue());
            result.add(item);
        }

        // Sort by value descending
        result.sort((a, b) -> Long.compare((Long) b.get("value"), (Long) a.get("value")));

        return result;
    }
}
