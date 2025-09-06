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
import java.time.temporal.ChronoUnit;
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

    // -------- NEW: shift-based escalation logic --------

    /**
     * Check if a task is pending
     */
    private boolean isPending(Task t) {
        return t.getDueDate() != null && !"COMPLETED".equalsIgnoreCase(t.getStatus());
    }

    /**
     * Tasks due (mid-shift)
     * If employee worked more than half of shift hours (default 9h shift),
     * task moves to Due.
     */
    public Map<Long, List<Task>> getDueTasksByUserId() {
        LocalDateTime now = LocalDateTime.now();

        return taskRepository.findAll().stream()
                .filter(this::isPending)
                .filter(t -> t.getUser().getInTime() != null)
                .filter(t -> {
                    User emp = t.getUser();
                    LocalDateTime loginTime = emp.getInTime();
                    double shiftHours = 9.0; // full shift
                    double halfShiftHours = shiftHours / 2.0;

                    // Calculate worked hours
                    double workedHours = ChronoUnit.MINUTES.between(loginTime, now) / 60.0;

                    // Mid-shift => Due
                    return workedHours >= halfShiftHours && now.isBefore(t.getDueDate());
                })
                .collect(Collectors.groupingBy(t -> t.getUser().getId()));
    }

    /**
     * Tasks escalated (end of shift or past deadline)
     * If employee worked full shift hours or passed dueDate
     */
    public Map<Long, List<Task>> getEscalatedTasksByUserId() {
        LocalDateTime now = LocalDateTime.now();

        return taskRepository.findAll().stream()
                .filter(this::isPending)
                .filter(t -> t.getUser().getInTime() != null)
                .filter(t -> {
                    User emp = t.getUser();
                    LocalDateTime loginTime = emp.getInTime();
                    double shiftHours = 9.0;

                    double workedHours = ChronoUnit.MINUTES.between(loginTime, now) / 60.0;

                    // Escalation: worked full shift OR passed dueDate
                    return workedHours >= shiftHours || !now.isBefore(t.getDueDate());
                })
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
