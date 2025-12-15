package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.entity.SysUser;
import com.ironlog.service.SystemSettingsService;
import com.ironlog.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*") // Allow frontend access
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private SystemSettingsService systemSettingsService;

    @GetMapping("/{id}")
    public Result<SysUser> getUser(@PathVariable Long id) {
        Optional<SysUser> user = userService.findById(id);
        if (user.isPresent()) {
            SysUser u = user.get();
            // Don't send password back to client
            u.setPassword(null);
            return Result.success(u);
        }
        return Result.error("用户不存在");
    }

    @GetMapping
    public Result<List<SysUser>> getAllUsers() {
        return Result.success(userService.findAll());
    }

    @PostMapping("/register")
    public Result<SysUser> registerUser(@RequestBody SysUser user) {
        SysUser registeredUser = userService.registerUser(user);
        // Don't send password back to client
        registeredUser.setPassword(null);
        return Result.success("注册成功", registeredUser);
    }

    @PostMapping("/login")
    public Result<SysUser> loginUser(@RequestBody SysUser loginRequest) {
        Map<String, String> allSettings = systemSettingsService.getAllSettings();
        boolean maintenanceMode = Boolean.parseBoolean(allSettings.get("maintenance_mode"));

        // Validate input
        if (loginRequest.getUsername() == null || loginRequest.getUsername().trim().isEmpty()) {
            return Result.error(400, "用户名不能为空");
        }
        if (loginRequest.getPassword() == null || loginRequest.getPassword().trim().isEmpty()) {
            return Result.error(400, "密码不能为空");
        }

        // Find user by username
        Optional<SysUser> userOpt = userService.findByUsername(loginRequest.getUsername());
        if (!userOpt.isPresent()) {
            return Result.error(401, "用户名或密码错误");
        }

        SysUser user = userOpt.get();
        if (maintenanceMode == true) {
            if (!"ADMIN".equals(user.getRole())) {
                return Result.error(401, allSettings.get("maintenance_message"));
            }
        }


        // Verify password - use PasswordEncoder.matches for encoded passwords
        // For backward compatibility, also check plain text passwords
        String userPassword = user.getPassword();
        String loginPassword = loginRequest.getPassword();

        boolean passwordMatches = false;
        if (userPassword.equals(loginPassword)) {
            // Plain text match (for existing users with unhashed passwords)
            passwordMatches = true;
        } else {
            // Try encoded password match
            passwordMatches = com.ironlog.common.PasswordEncoder.matches(loginPassword, userPassword);
        }

        if (!passwordMatches) {
            return Result.error(401, "用户名或密码错误");
        }

        // Don't send password back to client
        user.setPassword(null);

        // In real app, return JWT token
        return Result.success("登录成功", user);
    }

    @PutMapping("/{id}")
    public Result<SysUser> updateUser(@PathVariable Long id, @RequestBody SysUser user) {
        user.setId(id);
        Optional<SysUser> byId = userService.findById(id);
        if (byId.isPresent()) {
            user.setPassword(byId.get().getPassword());
        } else {
            throw new RuntimeException("用户不存在");
        }
        SysUser updatedUser = userService.updateUser(user);
        return Result.success("更新成功", updatedUser);
    }

    @DeleteMapping("/{id}")
    public Result<String> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return Result.success("删除成功", null);
    }
}
