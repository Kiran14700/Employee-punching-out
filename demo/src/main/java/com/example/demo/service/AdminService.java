package com.example.demo.service;

import com.example.demo.entity.Admin;
import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.repository.AdminRepository;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AdminService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private AdminRepository adminRepository;

    // -------- existing helpers --------
    public List<User> getAllEmployees() {
        List<User> employees = userRepository.findByRole("EMPLOYEE");
        for (User emp : employees) {
            emp.setTasks(taskRepository.findByUserId(emp.getId()));
        }
        return employees;
    }

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public Long getTotalTasksAssigned() {
        return taskRepository.count();
    }

    public Long getRemainingTasks(Long userId) {
        return taskRepository.findByUserId(userId)
                .stream()
                .filter(t -> !"COMPLETED".equalsIgnoreCase(t.getStatus()))
                .count();
    }

    public User findUserById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    public void saveTask(Task task) {
        taskRepository.save(task);
    }

    public Admin findAdminByUsername(String username) {
        return adminRepository.findAll()
                .stream()
                .filter(a -> a.getUsername().equals(username))
                .findFirst()
                .orElse(null);
    }

    // -------- NEW: escalation logic --------
    private boolean isPending(Task t) {
        return t.getDueDate() != null && !"COMPLETED".equalsIgnoreCase(t.getStatus());
    }

    /** Due = same calendar day as "now", and now is BEFORE the due time (i.e., deadline later today) */
    public Map<Long, List<Task>> getDueTasksByUserId() {
        LocalDateTime now = LocalDateTime.now();
        LocalDate today = now.toLocalDate();
        return taskRepository.findAll().stream()
                .filter(this::isPending)
                .filter(t -> t.getDueDate().toLocalDate().isEqual(today))
                .filter(t -> now.isBefore(t.getDueDate()))
                .collect(Collectors.groupingBy(t -> t.getUser().getId()));
    }

    /** Escalated = deadline reached or passed (now >= dueDate), regardless of day */
    public Map<Long, List<Task>> getEscalatedTasksByUserId() {
        LocalDateTime now = LocalDateTime.now();
        return taskRepository.findAll().stream()
                .filter(this::isPending)
                .filter(t -> !now.isBefore(t.getDueDate())) // now >= dueDate
                .collect(Collectors.groupingBy(t -> t.getUser().getId()));
    }

    public List<User> getEmployeesWithDueTasks() {
        Map<Long, List<Task>> map = getDueTasksByUserId();
        if (map.isEmpty()) return Collections.emptyList();
        return userRepository.findAllById(map.keySet());
    }

    public List<User> getEmployeesWithEscalatedTasks() {
        Map<Long, List<Task>> map = getEscalatedTasksByUserId();
        if (map.isEmpty()) return Collections.emptyList();
        return userRepository.findAllById(map.keySet());
    }
}
