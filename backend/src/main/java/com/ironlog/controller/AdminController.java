package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @GetMapping("/dashboard-stats")
    public Result<Map<String, Object>> getDashboardStats() {
        return Result.success(adminService.getDashboardStats());
    }

    @GetMapping("/recent-users")
    public Result<List<Map<String, Object>>> getRecentUsers(@RequestParam(defaultValue = "10") int limit) {
        return Result.success(adminService.getRecentUsers(limit));
    }

    @GetMapping("/system-health")
    public Result<Map<String, Object>> getSystemHealth() {
        return Result.success(adminService.getSystemHealth());
    }

    @PutMapping("/users/{id}/reset-password")
    public Result<String> resetUserPassword(@PathVariable Long id, @RequestBody Map<String, String> body) {
        String newPassword = body.get("password");
        if (newPassword == null || newPassword.trim().isEmpty()) {
            return Result.error("密码不能为空");
        }
        boolean success = adminService.resetUserPassword(id, newPassword);
        if (success) {
            return Result.success("密码重置成功", null);
        }
        return Result.error("用户不存在");
    }
}
