package com.ironlog.service;

import com.ironlog.entity.SystemSettings;
import com.ironlog.entity.SystemAnnouncement;
import com.ironlog.repository.SystemSettingsRepository;
import com.ironlog.repository.SystemAnnouncementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Service
public class SystemSettingsService {

    @Autowired
    private SystemSettingsRepository settingsRepository;

    @Autowired
    private SystemAnnouncementRepository announcementRepository;

    public Map<String, String> getAllSettings() {
        List<SystemSettings> settings = settingsRepository.findAll();
        Map<String, String> result = new HashMap<>();
        for (SystemSettings setting : settings) {
            result.put(setting.getSettingKey(), setting.getSettingValue());
        }
        return result;
    }

    public String getSetting(String key) {
        Optional<SystemSettings> setting = settingsRepository.findBySettingKey(key);
        return setting.map(SystemSettings::getSettingValue).orElse(null);
    }

    public SystemSettings updateSetting(String key, String value) {
        Optional<SystemSettings> existingOpt = settingsRepository.findBySettingKey(key);
        SystemSettings setting;
        
        if (existingOpt.isPresent()) {
            setting = existingOpt.get();
            setting.setSettingValue(value);
        } else {
            setting = new SystemSettings();
            setting.setSettingKey(key);
            setting.setSettingValue(value);
        }
        
        setting.setUpdatedAt(LocalDateTime.now());
        return settingsRepository.save(setting);
    }

    public List<SystemAnnouncement> getActiveAnnouncements() {
        return announcementRepository.findByStatusOrderByPriorityDescCreatedAtDesc(1);
    }

    public SystemAnnouncement createAnnouncement(SystemAnnouncement announcement) {
        announcement.setCreatedAt(LocalDateTime.now());
        announcement.setUpdatedAt(LocalDateTime.now());
        return announcementRepository.save(announcement);
    }

    public SystemAnnouncement updateAnnouncement(SystemAnnouncement announcement) {
        announcement.setUpdatedAt(LocalDateTime.now());
        return announcementRepository.save(announcement);
    }

    public void deleteAnnouncement(Long id) {
        announcementRepository.deleteById(id);
    }
}
