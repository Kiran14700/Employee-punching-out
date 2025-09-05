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

    // -------- LOGIN --------
    public User login(String username, String password) {
        return userRepository.findByUsernameAndPassword(username, password);
    }

    // -------- REGISTER & UPDATE USER --------
    public void saveUser(User user) {
        userRepository.save(user);
    }

    // -------- SAVE OR UPDATE TASK --------
    public void saveTask(Task task) {
        taskRepository.save(task);
    }

    // -------- TASK OPERATIONS --------
    public List<Task> getTasksByUserId(Long userId) {
        return taskRepository.findByUserId(userId);
    }

    public Task getTaskById(Long taskId) {
        return taskRepository.findById(taskId).orElse(null);
    }

    public User findUserById(Long userId) {
        return userRepository.findById(userId).orElse(null);
    }
}
