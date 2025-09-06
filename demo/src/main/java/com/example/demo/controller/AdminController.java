package com.example.demo.controller;

import com.example.demo.entity.Admin;
import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.service.AdminService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Controller
public class AdminController {

    @Autowired
    private AdminService adminService;

    // ---------------- ADMIN DASHBOARD ----------------
    @GetMapping("/admin")
    public String adminDashboard(HttpSession session, Model model) {
        // Save admin login time in session
        if (session.getAttribute("adminLoginTime") == null) {
            session.setAttribute("adminLoginTime", LocalDateTime.now());
        }
        LocalDateTime loginTime = (LocalDateTime) session.getAttribute("adminLoginTime");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        String inTime = loginTime != null ? loginTime.format(formatter) : "--:--";

        // Fetch employees & tasks
        List<User> employees = adminService.getAllEmployees();
        List<Task> allTasks = adminService.getAllTasks();

        model.addAttribute("inTime", inTime);
        model.addAttribute("taskCount", adminService.getTotalTasksAssigned());
        model.addAttribute("employees", employees);
        model.addAttribute("allTasks", allTasks);

        return "admin"; // admin.jsp
    }

    // ---------------- ASSIGN TASK ----------------
    @PostMapping("/admin/assign-task")
    public String assignTask(@ModelAttribute Task task,
                             @RequestParam(name = "userIds", required = false) List<Long> userIds,
                             @RequestParam("dueDateTime") String dueDateTime,
                             HttpSession session) {
        if (userIds != null && !userIds.isEmpty()) {
            String adminName = (String) session.getAttribute("adminName");
            Admin admin = adminService.findAdminByUsername(adminName);

            LocalDateTime dueDate = null;
            if (dueDateTime != null && !dueDateTime.isEmpty()) {
                // Only date (time will be ignored)
                dueDate = LocalDateTime.parse(dueDateTime + "T23:59", DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            }

            for (Long userId : userIds) {
                User employee = adminService.findUserById(userId);
                if (employee != null) {
                    Task newTask = new Task();
                    newTask.setTitle(task.getTitle());
                    newTask.setSummary(task.getSummary());
                    newTask.setDescription(task.getDescription());
                    newTask.setStatus("Not Started");
                    newTask.setUser(employee);
                    newTask.setAssignedBy(admin);
                    newTask.setDueDate(dueDate); // set only date, time ignored
                    adminService.saveTask(newTask);
                }
            }
        }
        return "redirect:/admin";
    }

    // ---------------- ESCALATION VIEW ----------------
    @GetMapping("/admin/escalation")
    public String escalationView(Model model) {
        // Employees with due & escalated tasks using shift-based logic
        List<User> dueEmployees = adminService.getEmployeesWithDueTasks();
        List<User> escalatedEmployees = adminService.getEmployeesWithEscalatedTasks();

        // Maps of userId -> filtered tasks
        Map<Long, List<Task>> dueTasksMap = adminService.getDueTasksByUserId();
        Map<Long, List<Task>> escalatedTasksMap = adminService.getEscalatedTasksByUserId();

        model.addAttribute("dueEmployees", dueEmployees);
        model.addAttribute("escalatedEmployees", escalatedEmployees);
        model.addAttribute("dueTasksMap", dueTasksMap);
        model.addAttribute("escalatedTasksMap", escalatedTasksMap);

        return "escalation"; // escalation.jsp
    }
}
