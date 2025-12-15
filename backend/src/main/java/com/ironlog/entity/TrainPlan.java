package com.ironlog.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "train_plan")
public class TrainPlan {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false)
    private String planName;

    private Integer goal; // 1: Muscle, 2: Fat Loss, 3: Strength

    @Column(columnDefinition = "json")
    private String weeklySchedule; // Stored as JSON string

    private Integer isCurrent;
    private LocalDateTime createdAt;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }
    public Integer getGoal() { return goal; }
    public void setGoal(Integer goal) { this.goal = goal; }
    public String getWeeklySchedule() { return weeklySchedule; }
    public void setWeeklySchedule(String weeklySchedule) { this.weeklySchedule = weeklySchedule; }
    public Integer getIsCurrent() { return isCurrent; }
    public void setIsCurrent(Integer isCurrent) { this.isCurrent = isCurrent; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
