package com.ironlog.repository;

import com.ironlog.entity.TrainPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TrainPlanRepository extends JpaRepository<TrainPlan, Long> {
    List<TrainPlan> findByUserId(Long userId);
    Optional<TrainPlan> findByUserIdAndIsCurrent(Long userId, Integer isCurrent);
}
