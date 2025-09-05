<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Escalation Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="p-4">

<div class="container">
    <h2 class="mb-4">Escalation Dashboard</h2>

    <div class="row">
        <!-- Due Today -->
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">Due Today</div>
                <div class="card-body">
                    <input type="text" class="form-control mb-2" placeholder="Search employee...">
                    <c:forEach var="emp" items="${dueEmployees}">
                        <div>
                            <a href="#" class="employee-link" data-bs-toggle="modal"
                               data-bs-target="#employeeTasksModal${emp.id}">
                                ${emp.username}
                            </a>
                        </div>

                        <!-- Employee Task Modal -->
                        <div class="modal fade" id="employeeTasksModal${emp.id}" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Employee Tasks</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p><strong>Employee:</strong> ${emp.username}</p>
                                        <c:forEach var="task" items="${dueTasksMap[emp.id]}">
                                            <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                                                <!-- Only title is clickable -->
                                                <a href="#" class="task-detail-link fw-bold text-primary"
                                                   data-title="${task.title}"
                                                   data-summary="${task.summary}"
                                                   data-description="${task.description}">
                                                    ${task.title}
                                                </a>

                                                <!-- Deadline + Status -->
                                                <div class="text-muted small text-end">
                                                    <div>Deadline: ${task.dueDate}</div>
                                                    <span class="badge bg-secondary">${task.status}</span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Escalated -->
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">Escalated</div>
                <div class="card-body">
                    <input type="text" class="form-control mb-2" placeholder="Search employee...">
                    <c:forEach var="emp" items="${escalatedEmployees}">
                        <div class="d-flex justify-content-between align-items-center">
                            <a href="#" class="employee-link" data-bs-toggle="modal"
                               data-bs-target="#employeeEscalationModal${emp.id}">
                                ${emp.username}
                            </a>
                            <span class="badge bg-danger">${escalationCountMap[emp.id]}</span>
                        </div>

                        <!-- Employee Escalation Task Modal -->
                        <div class="modal fade" id="employeeEscalationModal${emp.id}" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Employee Tasks</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p><strong>Employee:</strong> ${emp.username}</p>
                                        <c:forEach var="task" items="${escalatedTasksMap[emp.id]}">
                                            <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                                                <!-- Only title is clickable -->
                                                <a href="#" class="task-detail-link fw-bold text-primary"
                                                   data-title="${task.title}"
                                                   data-summary="${task.summary}"
                                                   data-description="${task.description}">
                                                    ${task.title}
                                                </a>

                                                <!-- Deadline + Status -->
                                                <div class="text-muted small text-end">
                                                    <div>Deadline: ${task.dueDate}</div>
                                                    <span class="badge bg-secondary">${task.status}</span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary mt-3">Back to Dashboard</a>
</div>

<!-- Task Detail Modal (common for all tasks) -->
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
