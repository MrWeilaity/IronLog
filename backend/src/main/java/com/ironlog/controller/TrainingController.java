package com.ironlog.controller;

import com.ironlog.entity.TrainRecord;
import com.ironlog.entity.BaseAction;
import com.ironlog.service.TrainingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<List<TrainRecord>> getRecords(
            @RequestParam Long userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(trainingService.getRecordsByDate(userId, date));
    }

    @PostMapping("/records")
    public ResponseEntity<TrainRecord> addRecord(@RequestBody TrainRecord record) {
        return ResponseEntity.ok(trainingService.addRecord(record));
    }

    @GetMapping("/actions")
    public ResponseEntity<List<BaseAction>> searchActions(@RequestParam String query) {
        return ResponseEntity.ok(trainingService.searchActions(query));
    }

    @PostMapping("/actions")
    public ResponseEntity<BaseAction> addAction(@RequestBody BaseAction action) {
        return ResponseEntity.ok(trainingService.addAction(action));
    }
}
