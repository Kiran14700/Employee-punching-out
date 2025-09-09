package com.example.demo.service;

import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    // Login
    public User login(String username, String password) {
        return userRepository.findByUsernameAndPassword(username, password);
    }

    // Save or update user
    public void saveUser(User user) {
        userRepository.save(user);
    }

    // Save task
    public void saveTask(Task task) {
        taskRepository.save(task);
    }

    // Get tasks by user
    public List<Task> getTasksByUserId(Long userId) {
        return taskRepository.findByUserId(userId);
    }

    // Find task by id
    public Task getTaskById(Long taskId) {
        return taskRepository.findById(taskId).orElse(null);
    }

    // Find user by id
    public User findUserById(Long userId) {
        return userRepository.findById(userId).orElse(null);
    }
}
