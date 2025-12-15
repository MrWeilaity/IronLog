package com.ironlog.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "train_record")
public class TrainRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long userId;

    // Made nullable to support simple workout logging without specific action
    private Long actionId;

    @Column(nullable = false)
    private LocalDate recordDate;

    // Made nullable to support simple workout logging
    private Integer setNo;

    // Made nullable to support simple workout logging
    private BigDecimal weight;

    // Made nullable to support simple workout logging
    private Integer reps;

    private Integer rpe;
    private Long supersetId;
    private String note;
    
    // Additional fields for simple workout logging
    private Integer duration; // Duration in minutes
    private String exerciseType; // Type of exercise
    private String notes; // Additional notes
    
    private LocalDateTime createdAt;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getActionId() { return actionId; }
    public void setActionId(Long actionId) { this.actionId = actionId; }
    public LocalDate getRecordDate() { return recordDate; }
    public void setRecordDate(LocalDate recordDate) { this.recordDate = recordDate; }
    public Integer getSetNo() { return setNo; }
    public void setSetNo(Integer setNo) { this.setNo = setNo; }
    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }
    public Integer getReps() { return reps; }
    public void setReps(Integer reps) { this.reps = reps; }
    public Integer getRpe() { return rpe; }
    public void setRpe(Integer rpe) { this.rpe = rpe; }
    public Long getSupersetId() { return supersetId; }
    public void setSupersetId(Long supersetId) { this.supersetId = supersetId; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }
    public String getExerciseType() { return exerciseType; }
    public void setExerciseType(String exerciseType) { this.exerciseType = exerciseType; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
