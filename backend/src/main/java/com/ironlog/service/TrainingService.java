package com.ironlog.service;

import com.ironlog.entity.TrainRecord;
import com.ironlog.entity.BaseAction;
import com.ironlog.entity.TrainPlan;
import com.ironlog.repository.TrainRecordRepository;
import com.ironlog.repository.BaseActionRepository;
import com.ironlog.repository.TrainPlanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class TrainingService {

    @Autowired
    private TrainRecordRepository trainRecordRepository;

    @Autowired
    private BaseActionRepository baseActionRepository;

    @Autowired
    private TrainPlanRepository trainPlanRepository;

    // Train Records
    public List<TrainRecord> getRecordsByDate(Long userId, LocalDate date) {
        return trainRecordRepository.findByUserIdAndRecordDate(userId, date);
    }

    public TrainRecord addRecord(TrainRecord record) {
        return trainRecordRepository.save(record);
    }

    // Actions
    public List<BaseAction> searchActions(String name) {
        return baseActionRepository.findByNameContainingIgnoreCase(name);
    }

    public List<BaseAction> getActionsByMuscle(String muscle) {
        return baseActionRepository.findByTargetMuscle(muscle);
    }

    public BaseAction addAction(BaseAction action) {
        return baseActionRepository.save(action);
    }

    // Plans
    public Optional<TrainPlan> getCurrentPlan(Long userId) {
        return trainPlanRepository.findByUserIdAndIsCurrent(userId, 1);
    }

    public TrainPlan createPlan(TrainPlan plan) {
        return trainPlanRepository.save(plan);
    }
}
