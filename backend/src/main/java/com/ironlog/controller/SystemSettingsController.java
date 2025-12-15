package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.entity.SystemSettings;
import com.ironlog.entity.SystemAnnouncement;
import com.ironlog.service.SystemSettingsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system")
@CrossOrigin(origins = "*")
public class SystemSettingsController {

    @Autowired
    private SystemSettingsService systemSettingsService;

    @GetMapping("/settings")
    public Result<Map<String, String>> getAllSettings() {
        return Result.success(systemSettingsService.getAllSettings());
    }

    @GetMapping("/settings/{key}")
    public Result<String> getSetting(@PathVariable String key) {
        String value = systemSettingsService.getSetting(key);
        if (value != null) {
            return Result.success(value);
        }
        return Result.error("设置项不存在");
    }

    @PutMapping("/settings/{key}")
    public Result<SystemSettings> updateSetting(@PathVariable String key, @RequestBody Map<String, String> body) {
        String value = body.get("value");
        SystemSettings setting = systemSettingsService.updateSetting(key, value);
        return Result.success("设置已更新", setting);
    }

    @PostMapping("/settings")
    public Result<Map<String, String>> updateSettings(@RequestBody Map<String, String> settings) {
        for (Map.Entry<String, String> entry : settings.entrySet()) {
            systemSettingsService.updateSetting(entry.getKey(), entry.getValue());
        }
        return Result.success("设置已保存", systemSettingsService.getAllSettings());
    }

    @GetMapping("/announcements")
    public Result<List<SystemAnnouncement>> getActiveAnnouncements() {
        return Result.success(systemSettingsService.getActiveAnnouncements());
    }

    @PostMapping("/announcements")
    public Result<SystemAnnouncement> createAnnouncement(@RequestBody SystemAnnouncement announcement) {
        SystemAnnouncement created = systemSettingsService.createAnnouncement(announcement);
        return Result.success("公告已创建", created);
    }

    @PutMapping("/announcements/{id}")
    public Result<SystemAnnouncement> updateAnnouncement(@PathVariable Long id, @RequestBody SystemAnnouncement announcement) {
        announcement.setId(id);
        SystemAnnouncement updated = systemSettingsService.updateAnnouncement(announcement);
        return Result.success("公告已更新", updated);
    }

    @DeleteMapping("/announcements/{id}")
    public Result<String> deleteAnnouncement(@PathVariable Long id) {
        systemSettingsService.deleteAnnouncement(id);
        return Result.success("公告已删除", null);
    }
}
