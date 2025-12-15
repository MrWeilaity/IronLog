package com.ironlog.repository;

import com.ironlog.entity.TrainRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface TrainRecordRepository extends JpaRepository<TrainRecord, Long> {
    List<TrainRecord> findByUserIdAndRecordDate(Long userId, LocalDate recordDate);
    List<TrainRecord> findByUserId(Long userId);
    
    @Query("SELECT COUNT(DISTINCT r.recordDate) FROM TrainRecord r WHERE r.userId = :userId AND r.recordDate BETWEEN :startDate AND :endDate")
    long countDistinctDates(@Param("userId") Long userId, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);
    
    List<TrainRecord> findByUserIdAndRecordDateBetween(Long userId, LocalDate startDate, LocalDate endDate);
}
