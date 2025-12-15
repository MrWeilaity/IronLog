package com.ironlog.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "diet_log")
public class DietLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false)
    private Long foodId;

    @Column(nullable = false)
    private LocalDate logDate;

    @Column(nullable = false)
    private Integer mealType; // 1: Breakfast, 2: Lunch, 3: Dinner, 4: Snack

    @Column(nullable = false)
    private BigDecimal intakeAmount;

    @Column(nullable = false)
    private BigDecimal calcCalories;

    @Column(nullable = false)
    private BigDecimal calcProtein;

    @Column(nullable = false)
    private BigDecimal calcFat;

    @Column(nullable = false)
    private BigDecimal calcCarbs;

    private LocalDateTime createdAt;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getFoodId() { return foodId; }
    public void setFoodId(Long foodId) { this.foodId = foodId; }
    public LocalDate getLogDate() { return logDate; }
    public void setLogDate(LocalDate logDate) { this.logDate = logDate; }
    public Integer getMealType() { return mealType; }
    public void setMealType(Integer mealType) { this.mealType = mealType; }
    public BigDecimal getIntakeAmount() { return intakeAmount; }
    public void setIntakeAmount(BigDecimal intakeAmount) { this.intakeAmount = intakeAmount; }
    public BigDecimal getCalcCalories() { return calcCalories; }
    public void setCalcCalories(BigDecimal calcCalories) { this.calcCalories = calcCalories; }
    public BigDecimal getCalcProtein() { return calcProtein; }
    public void setCalcProtein(BigDecimal calcProtein) { this.calcProtein = calcProtein; }
    public BigDecimal getCalcFat() { return calcFat; }
    public void setCalcFat(BigDecimal calcFat) { this.calcFat = calcFat; }
    public BigDecimal getCalcCarbs() { return calcCarbs; }
    public void setCalcCarbs(BigDecimal calcCarbs) { this.calcCarbs = calcCarbs; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
