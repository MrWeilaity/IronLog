package com.ironlog.repository;

import com.ironlog.entity.WaterLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface WaterLogRepository extends JpaRepository<WaterLog, Long> {
    List<WaterLog> findByUserIdAndLogDate(Long userId, LocalDate logDate);

    @Query("SELECT SUM(w.amountMl) FROM WaterLog w WHERE w.userId = :userId AND w.logDate = :date")
    Integer sumAmountByUserIdAndDate(@Param("userId") Long userId, @Param("date") LocalDate date);
}
