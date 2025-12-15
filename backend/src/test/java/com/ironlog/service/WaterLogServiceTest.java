package com.ironlog.service;

import com.ironlog.entity.WaterLog;
import com.ironlog.repository.WaterLogRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class WaterLogServiceTest {

    @Mock
    private WaterLogRepository waterLogRepository;

    @InjectMocks
    private WaterLogService waterLogService;

    @Test
    public void testAddWater() {
        WaterLog log = new WaterLog();
        log.setId(1L);
        log.setUserId(1L);
        log.setAmountMl(250);
        log.setLogDate(LocalDate.now());

        when(waterLogRepository.save(any(WaterLog.class))).thenReturn(log);

        WaterLog saved = waterLogService.addWater(1L, 250);
        assertEquals(250, saved.getAmountMl());
    }

    @Test
    public void testGetTodayTotal() {
        when(waterLogRepository.sumAmountByUserIdAndDate(anyLong(), any(LocalDate.class))).thenReturn(1000);

        Integer total = waterLogService.getTodayTotal(1L);
        assertEquals(1000, total);
    }
}
