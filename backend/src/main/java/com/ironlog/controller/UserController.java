package com.ironlog.controller;

import com.ironlog.entity.SysUser;
import com.ironlog.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*") // Allow frontend access
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/{id}")
    public ResponseEntity<SysUser> getUser(@PathVariable Long id) {
        Optional<SysUser> user = userService.findById(id);
        return user.map(ResponseEntity::ok)
                   .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("/register")
    public ResponseEntity<SysUser> registerUser(@RequestBody SysUser user) {
        SysUser registeredUser = userService.registerUser(user);
        return ResponseEntity.ok(registeredUser);
    }

    @PostMapping("/login")
    public ResponseEntity<String> loginUser(@RequestBody SysUser loginRequest) {
        // Very basic login simulation
        Optional<SysUser> user = userService.findByUsername(loginRequest.getUsername());
        if (user.isPresent() && user.get().getPassword().equals(loginRequest.getPassword())) {
            // In real app, return JWT token
            return ResponseEntity.ok("Login Successful");
        }
        return ResponseEntity.status(401).body("Invalid credentials");
    }
}
