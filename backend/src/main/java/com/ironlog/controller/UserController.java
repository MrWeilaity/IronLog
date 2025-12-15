package com.ironlog.controller;

import com.ironlog.common.Result;
import com.ironlog.entity.SysUser;
import com.ironlog.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*") // Allow frontend access
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/{id}")
    public Result<SysUser> getUser(@PathVariable Long id) {
        Optional<SysUser> user = userService.findById(id);
        return user.map(Result::success)
                   .orElseGet(() -> Result.error("用户不存在"));
    }

    @GetMapping
    public Result<List<SysUser>> getAllUsers() {
        return Result.success(userService.findAll());
    }

    @PostMapping("/register")
    public Result<SysUser> registerUser(@RequestBody SysUser user) {
        SysUser registeredUser = userService.registerUser(user);
        return Result.success("注册成功", registeredUser);
    }

    @PostMapping("/login")
    public Result<SysUser> loginUser(@RequestBody SysUser loginRequest) {
        // Very basic login simulation
        Optional<SysUser> user = userService.findByUsername(loginRequest.getUsername());
        if (user.isPresent() && user.get().getPassword().equals(loginRequest.getPassword())) {
            // In real app, return JWT token
            return Result.success("登录成功", user.get());
        }
        return Result.error(401, "用户名或密码错误");
    }

    @PutMapping("/{id}")
    public Result<SysUser> updateUser(@PathVariable Long id, @RequestBody SysUser user) {
        user.setUserId(id);
        SysUser updatedUser = userService.updateUser(user);
        return Result.success("更新成功", updatedUser);
    }

    @DeleteMapping("/{id}")
    public Result<String> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return Result.success("删除成功", null);
    }
}
