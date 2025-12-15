package com.ironlog.service;

import com.ironlog.entity.SysUser;
import com.ironlog.repository.SysUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private SysUserRepository userRepository;

    public SysUser registerUser(SysUser user) {
        // In a real app, password should be hashed here
        // user.setPassword(passwordEncoder.encode(user.getPassword()));
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        if (user.getCreatedAt() == null) {
            user.setCreatedAt(now);
        }
        if (user.getUpdatedAt() == null) {
            user.setUpdatedAt(now);
        }
        return userRepository.save(user);
    }

    public Optional<SysUser> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public Optional<SysUser> findById(Long id) {
        return userRepository.findById(id);
    }

    public List<SysUser> findAll() {
        return userRepository.findAll();
    }

    public SysUser updateUser(SysUser user) {
        user.setUpdatedAt(java.time.LocalDateTime.now());
        return userRepository.save(user);
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }
}
