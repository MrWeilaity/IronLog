package com.ironlog.service;

import com.ironlog.entity.WaterLog;
import com.ironlog.repository.WaterLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class WaterLogService {

    @Autowired
    private WaterLogRepository waterLogRepository;

    public WaterLog addWater(Long userId, Integer amount) {
        WaterLog log = new WaterLog();
        log.setUserId(userId);
        log.setAmountMl(amount);
        log.setLogDate(LocalDate.now());
        return waterLogRepository.save(log);
    }

    public Integer getTodayTotal(Long userId) {
        Integer total = waterLogRepository.sumAmountByUserIdAndDate(userId, LocalDate.now());
        return total != null ? total : 0;
    }
}
