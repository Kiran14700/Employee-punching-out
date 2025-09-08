package com.example.demo.controller;

import com.example.demo.entity.Admin;
import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.repository.AdminRepository;
import com.example.demo.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private AdminRepository adminRepository;

    // ---------------- HOME REDIRECT ----------------
    @GetMapping("/")
    public String homeRedirect() {
        return "redirect:/login"; // default page = login
    }

    // ---------------- LOGIN METHODS ----------------
    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("user", new User());
        return "login"; // login.jsp
    }

    @PostMapping("/login")
    public String loginUser(@ModelAttribute("user") User user, Model model, HttpSession session) {

        // -------- ADMIN LOGIN --------
        Admin admin = adminRepository.findByUsernameAndPassword(user.getUsername(), user.getPassword());
        if (admin != null) {
            session.setAttribute("admin", admin); // ✅ store Admin object
            session.setAttribute("adminName", admin.getUsername());

            LocalDate today = LocalDate.now();
            LocalDateTime loginTime = admin.getInTime();

            // Only set once per day
            if (loginTime == null || !loginTime.toLocalDate().equals(today)) {
                loginTime = LocalDateTime.now();
                admin.setInTime(loginTime);
                adminRepository.save(admin);
            }

            return "redirect:/admin";
        }

        // -------- EMPLOYEE LOGIN --------
        User validUser = userService.login(user.getUsername(), user.getPassword());
        if (validUser != null) {
            LocalDate today = LocalDate.now();

            if (validUser.getInTime() == null || !validUser.getInTime().toLocalDate().equals(today)) {
                validUser.setInTime(LocalDateTime.now());
                userService.saveUser(validUser);
            }

            List<Task> tasks = userService.getTasksByUserId(validUser.getId());
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
            String inTime = validUser.getInTime() != null ? validUser.getInTime().format(formatter) : "--:--";
            String outTime = validUser.getOutTime() != null ? validUser.getOutTime().format(formatter) : "--:--";

            session.setAttribute("userId", validUser.getId());
            model.addAttribute("name", validUser.getUsername());
            model.addAttribute("tasks", tasks);
            model.addAttribute("inTime", inTime);
            model.addAttribute("outTime", outTime);
            model.addAttribute("taskCount", tasks.size());

            return "task"; // employee task.jsp
        } else {
            model.addAttribute("error", "Invalid Username or Password!");
            return "login";
        }
    }

    // ---------------- LOGOUT METHOD ----------------
    @GetMapping("/logout")
    public String logoutUser(HttpSession session) {
        // If admin logged in
        if (session.getAttribute("admin") != null) {
            session.invalidate();
            return "redirect:/login";
        }

        // If normal user logged in
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            User user = userService.findUserById(userId);
            if (user != null) {
                // save logout time
                user.setOutTime(LocalDateTime.now());
                userService.saveUser(user);
            }
        }

        session.invalidate(); // destroy session
        return "redirect:/login";
    }

    // ---------------- REGISTER METHODS ----------------
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        return "register"; // register.jsp
    }

    @PostMapping("/register")
    public String registerUser(@Valid @ModelAttribute("user") User user, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("error", result.getFieldError("password").getDefaultMessage());
            return "register";
        }

        if (!user.getPassword().equals(user.getConfirmPassword())) {
            model.addAttribute("error", "Passwords do not match!");
            return "register";
        }

        userService.saveUser(user);
        return "redirect:/login"; // after register → login
    }

    // ---------------- TASK PAGE (Employee) ----------------
    @GetMapping("/tasks")
    public String showTasks(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        User user = userService.findUserById(userId);
        List<Task> tasks = userService.getTasksByUserId(userId);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        String inTime = user.getInTime() != null ? user.getInTime().format(formatter) : "--:--";
        String outTime = user.getOutTime() != null ? user.getOutTime().format(formatter) : "--:--";

        model.addAttribute("tasks", tasks);
        model.addAttribute("name", user.getUsername());
        model.addAttribute("inTime", inTime);
        model.addAttribute("outTime", outTime);
        model.addAttribute("taskCount", tasks.size());

        return "task"; // employee task.jsp
    }

    // ---------------- ACCEPT TASK (Employee) ----------------
    @PostMapping("/tasks/accept")
    public String acceptTask(@RequestParam Long taskId, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Task task = userService.getTaskById(taskId);
        if (task != null && "Not Started".equals(task.getStatus())) {
            task.setStatus("In Progress"); // goes to admin dashboard
            userService.saveTask(task);
        }

        return "redirect:/tasks";
    }
}
