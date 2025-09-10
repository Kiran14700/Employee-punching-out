<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Employee Escalation</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="p-4">

<div class="container">
    <h2 class="mb-4">My Escalation Dashboard</h2>

    <!-- User Info -->
    <div class="mb-3">
        <p><strong>Welcome:</strong> ${name}</p>
<p><strong>Login Time:</strong> ${inTime}</p>
        <p><strong>Total Tasks Assigned:</strong> ${taskCount}</p>
    </div>

    <div class="row">
        <!-- Due Tasks -->
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">Due Today</div>
                <div class="card-body">
                    <c:forEach var="task" items="${dueTasks}">
                        <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                            <a href="#" class="task-detail-link fw-bold text-primary"
                               data-title="${task.title}"
                               data-summary="${task.summary}"
                               data-description="${task.description}">
                                ${task.title}
                            </a>
                            <div class="text-muted small text-end">
                                <div>Deadline: ${task.dueDate}</div>
                                <span class="badge bg-secondary">${task.status}</span>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty dueTasks}">
                        <div class="text-center text-muted">No due tasks</div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Escalated Tasks -->
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">Escalated</div>
                <div class="card-body">
                    <c:forEach var="task" items="${escalatedTasks}">
                        <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                            <a href="#" class="task-detail-link fw-bold text-danger"
                               data-title="${task.title}"
                               data-summary="${task.summary}"
                               data-description="${task.description}">
                                ${task.title}
                            </a>
                            <div class="text-muted small text-end">
                                <div>Deadline: ${task.dueDate}</div>
                                <span class="badge bg-danger">${task.status}</span>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty escalatedTasks}">
                        <div class="text-center text-muted">No escalated tasks</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/tasks" class="btn btn-secondary mt-3">Back to Tasks</a>
</div>

<!-- Modal for Task Details -->
<div class="modal fade" id="taskDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Task Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>Title:</strong> <span id="taskTitle"></span></p>
                <p><strong>Summary:</strong> <span id="taskSummary"></span></p>
                <p><strong>Description:</strong> <span id="taskDescription"></span></p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".task-detail-link").forEach(function (element) {
        element.addEventListener("click", function (event) {
            event.preventDefault();
            document.getElementById("taskTitle").textContent = this.getAttribute("data-title");
            document.getElementById("taskSummary").textContent = this.getAttribute("data-summary");
            document.getElementById("taskDescription").textContent = this.getAttribute("data-description");
            new bootstrap.Modal(document.getElementById("taskDetailModal")).show();
        });
    });
});
</script>

</body>
</html>
