<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="p-4">

<!-- Admin Info -->
<div class="mb-4">
    <h3>Admin Dashboard</h3>
    <p><strong>Login Time:</strong> ${inTime}</p>
    <p><strong>Total Tasks Assigned:</strong> ${taskCount}</p>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Logout</a>
</div>

<!-- Escalation View Button -->
<div class="mb-3">
    <a href="${pageContext.request.contextPath}/admin/escalation" class="btn btn-warning">
        Escalation View
    </a>
</div>

<!-- Employee List -->
<h4>Employees</h4>
<ul>
    <c:forEach var="emp" items="${employees}">
        <li>${emp.username} - Tasks: ${emp.tasks.size()}</li>
    </c:forEach>
</ul>

<!-- Add Task Button -->
<button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addTaskModal">
    Add Task
</button>

<!-- Add Task Modal -->
<div class="modal fade" id="addTaskModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Assign Task</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/assign-task" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" class="form-control" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Summary</label>
                        <input type="text" class="form-control" name="summary" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" required></textarea>
                    </div>
                    <!-- Deadline Field -->
                    <div class="mb-3">
                        <label class="form-label">Deadline (Date & Time)</label>
                        <input type="datetime-local" class="form-control" name="dueDateTime" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Assign To</label><br/>
                        <c:forEach var="emp" items="${employees}">
                            <input type="checkbox" name="userIds" value="${emp.id}" id="emp_${emp.id}">
                            <label for="emp_${emp.id}">${emp.username}</label><br/>
                        </c:forEach>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Assign</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Employees Task Table -->
<table class="table table-bordered">
    <thead class="table-light">
    <tr>
        <th>Employee Name</th>
        <th>Tasks Assigned</th>
        <th>Task Status</th>
        <th>Work Hours</th>
        <th>Tasks Left</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="emp" items="${employees}">
        <tr>
            <td>${emp.username}</td>
            <td>
                <c:forEach var="task" items="${emp.tasks}">
                    • ${task.summary}<br/>
                </c:forEach>
            </td>
            <td>
                <c:forEach var="task" items="${emp.tasks}">
                    ${task.status}<br/>
                </c:forEach>
            </td>
            <td>
                <c:choose>
                    <c:when test="${emp.inTime != null && emp.outTime != null}">
                        ${fn:substring(emp.inTime, 11, 16)} - ${fn:substring(emp.outTime, 11, 16)}
                    </c:when>
                    <c:otherwise>--</c:otherwise>
                </c:choose>
            </td>
            <td>
                <c:set var="remaining" value="0"/>
                <c:forEach var="task" items="${emp.tasks}">
                    <c:if test="${fn:toUpperCase(task.status) ne 'COMPLETED'}">
                        <c:set var="remaining" value="${remaining + 1}"/>
                    </c:if>
                </c:forEach>
                ${remaining}
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
