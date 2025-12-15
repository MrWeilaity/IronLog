package com.ironlog.repository;

import com.ironlog.entity.BaseAction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BaseActionRepository extends JpaRepository<BaseAction, Long> {
    List<BaseAction> findByTargetMuscle(String targetMuscle);
    List<BaseAction> findByNameContainingIgnoreCase(String name);
}
