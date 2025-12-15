package com.ironlog.repository;

import com.ironlog.entity.TrainRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface TrainRecordRepository extends JpaRepository<TrainRecord, Long> {
    List<TrainRecord> findByUserIdAndRecordDate(Long userId, LocalDate recordDate);
    List<TrainRecord> findByUserId(Long userId);
}
