package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.entity.TrainRecord;
import com.ironlog.entity.BaseAction;
import com.ironlog.service.TrainingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/training")
@CrossOrigin(origins = "*")
public class TrainingController {

    @Autowired
    private TrainingService trainingService;

    @GetMapping("/records")
    public Result<List<TrainRecord>> getRecords(
            @RequestParam Long userId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        if (date == null) {
            date = LocalDate.now();
        }
        return Result.success(trainingService.getRecordsByDate(userId, date));
    }

    @PostMapping("/records")
    public Result<TrainRecord> addRecord(@RequestBody TrainRecord record) {
        return Result.success("添加成功", trainingService.addRecord(record));
    }

    @DeleteMapping("/records/{id}")
    public Result<String> deleteRecord(@PathVariable Long id) {
        trainingService.deleteRecord(id);
        return Result.success("删除成功", null);
    }

    @GetMapping("/actions")
    public Result<List<BaseAction>> searchActions(@RequestParam String query) {
        return Result.success(trainingService.searchActions(query));
    }

    @PostMapping("/actions")
    public Result<BaseAction> addAction(@RequestBody BaseAction action) {
        return Result.success("添加成功", trainingService.addAction(action));
    }
}
