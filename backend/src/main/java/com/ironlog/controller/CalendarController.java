package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.service.CalendarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.Map;

@RestController
@RequestMapping("/api/calendar")
@CrossOrigin(origins = "*")
public class CalendarController {

    @Autowired
    private CalendarService calendarService;

    @GetMapping("/heatmap/{userId}")
    public Result<Map<String, Object>> getCalendarHeatmap(
            @PathVariable Long userId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) YearMonth yearMonth) {
        if (yearMonth == null) {
            yearMonth = YearMonth.now();
        }
        return Result.success(calendarService.getCalendarHeatmap(userId, yearMonth));
    }

    @GetMapping("/day-detail/{userId}")
    public Result<Map<String, Object>> getDayDetail(
            @PathVariable Long userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return Result.success(calendarService.getDayDetail(userId, date));
    }
}
