package com.ironlog.service;

import com.ironlog.entity.SysUser;
import com.ironlog.entity.TrainRecord;
import com.ironlog.entity.SystemAnnouncement;
import com.ironlog.repository.SysUserRepository;
import com.ironlog.repository.TrainRecordRepository;
import com.ironlog.repository.DietLogRepository;
import com.ironlog.repository.SystemAnnouncementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AdminService {

    @Autowired
    private SysUserRepository userRepository;

    @Autowired
    private TrainRecordRepository trainRecordRepository;

    @Autowired
    private DietLogRepository dietLogRepository;

    @Autowired
    private SystemAnnouncementRepository announcementRepository;

    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        // Total users
        long totalUsers = userRepository.count();
        stats.put("totalUsers", totalUsers);

        // Active users today (users with training or diet records today)
        LocalDate today = LocalDate.now();
        Set<Long> activeUserIds = new HashSet<>();
        
        // Get all users who have training records today
        List<SysUser> allUsers = userRepository.findAll();
        for (SysUser user : allUsers) {
            List<TrainRecord> userTodayRecords = trainRecordRepository.findByUserIdAndRecordDate(user.getId(), today);
            if (!userTodayRecords.isEmpty()) {
                activeUserIds.add(user.getId());
            }
        }
        
        stats.put("activeToday", activeUserIds.size());

        // Total training records this month
        LocalDate monthStart = today.withDayOfMonth(1);
        long monthlyTrainings = 0;
        for (SysUser user : allUsers) {
            List<TrainRecord> monthRecords = trainRecordRepository.findByUserIdAndRecordDateBetween(
                user.getId(), monthStart, today);
            monthlyTrainings += monthRecords.size();
        }
        stats.put("monthlyTrainings", monthlyTrainings);

        // System status
        stats.put("systemStatus", "正常");

        // Chart data for user growth (last 7 days)
        List<Map<String, Object>> userGrowthData = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            LocalDateTime startOfDay = date.atStartOfDay();
            LocalDateTime endOfDay = date.plusDays(1).atStartOfDay();
            
            long newUsers = allUsers.stream()
                .filter(u -> u.getCreatedAt() != null && 
                             !u.getCreatedAt().isBefore(startOfDay) && 
                             u.getCreatedAt().isBefore(endOfDay))
                .count();
            
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", date.toString());
            dayData.put("count", newUsers);
            userGrowthData.add(dayData);
        }
        stats.put("userGrowthChart", userGrowthData);

        // Chart data for training activity (last 7 days)
        List<Map<String, Object>> activityData = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            
            long dayTrainings = 0;
            for (SysUser user : allUsers) {
                List<TrainRecord> records = trainRecordRepository.findByUserIdAndRecordDate(user.getId(), date);
                dayTrainings += records.size();
            }
            
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", date.toString());
            dayData.put("count", dayTrainings);
            activityData.add(dayData);
        }
        stats.put("activityChart", activityData);

        return stats;
    }

    public List<Map<String, Object>> getRecentUsers(int limit) {
        // Get all users and sort by created date
        List<SysUser> users = userRepository.findAll().stream()
                .sorted((a, b) -> {
                    if (a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
                    if (a.getCreatedAt() == null) return 1;
                    if (b.getCreatedAt() == null) return -1;
                    return b.getCreatedAt().compareTo(a.getCreatedAt());
                })
                .limit(limit)
                .collect(Collectors.toList());

        List<Map<String, Object>> result = new ArrayList<>();
        for (SysUser user : users) {
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("id", user.getId());
            userMap.put("username", user.getUsername());
            userMap.put("nickname", user.getNickname());
            userMap.put("createdAt", user.getCreatedAt() != null ? user.getCreatedAt().toString() : "");
            result.add(userMap);
        }

        return result;
    }

    public Map<String, Object> getSystemHealth() {
        Map<String, Object> health = new HashMap<>();
        
        try {
            // Check if we can query the database
            long userCount = userRepository.count();
            health.put("database", "healthy");
            health.put("userCount", userCount);
            
            // Memory info
            Runtime runtime = Runtime.getRuntime();
            long totalMemory = runtime.totalMemory() / (1024 * 1024);
            long freeMemory = runtime.freeMemory() / (1024 * 1024);
            long usedMemory = totalMemory - freeMemory;
            
            health.put("totalMemoryMB", totalMemory);
            health.put("usedMemoryMB", usedMemory);
            health.put("freeMemoryMB", freeMemory);
            
            health.put("status", "healthy");
        } catch (Exception e) {
            health.put("status", "unhealthy");
            health.put("error", e.getMessage());
        }
        
        return health;
    }

    public boolean resetUserPassword(Long userId, String newPassword) {
        Optional<SysUser> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            SysUser user = userOpt.get();
            // Encode password before saving
            user.setPassword(com.ironlog.common.PasswordEncoder.encode(newPassword));
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
            return true;
        }
        return false;
    }
}
