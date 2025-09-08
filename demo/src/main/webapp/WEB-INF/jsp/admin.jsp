<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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

                    <!-- Updated: Only Date (no time) -->
                    <div class="mb-3">
                        <label class="form-label">Deadline (Date Only)</label>
                        <input type="date" class="form-control" name="dueDateTime" required>
                    </div>

                    <div class="mb-3">
                        <label for="priority" class="form-label">Task Priority</label>
                        <select class="form-control" id="priority" name="priority" required>
                            <option value="1">Critical (Must Do Immediately)</option>
                            <option value="2">High Priority</option>
                            <option value="3" selected>Medium Priority</option>
                            <option value="4">Low Priority</option>
                            <option value="5">Very Low Priority</option>





                        </select>
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
                    <div class="mb-2">
                        <a href="#" class="task-detail-link text-primary"
                           data-bs-toggle="modal"
                           data-bs-target="#taskDetailModal"
                           data-task-id="${task.id}"
                           data-title="${task.title}"
                           data-summary="${task.summary}"
                           data-description="${task.description}">
                            ${task.summary}
                        </a>
                    </div>
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

<!-- ✅ Task Detail Modal (Fixed) -->
<div class="modal fade" id="taskDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Task Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p><strong>Title:</strong> <span id="taskModalTitleText"></span></p>
                <p><strong>Summary:</strong> <span id="taskModalSummary"></span></p>
                <p><strong>Description:</strong> <span id="taskModalDescription"></span></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="taskDetailUpdateBtn">Update</button>
                <button type="button" class="btn btn-danger" id="taskDetailDeleteBtn">Delete</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Update Task Modal -->
<div class="modal fade" id="updateTaskModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <form action="/admin/update-task" method="post" id="updateTaskForm">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Update Task</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="taskId" id="updateTaskId">
          <div class="mb-3">
            <label>Title</label>
            <input type="text" name="title" id="updateTitle" class="form-control" required>
          </div>
          <div class="mb-3">
            <label>Summary</label>
            <input type="text" name="summary" id="updateSummary" class="form-control" required>
          </div>
          <div class="mb-3">
            <label>Description</label>
            <textarea name="description" id="updateDescription" class="form-control" required></textarea>
          </div>
          <div class="mb-3">
            <label>Due Date</label>
            <input type="date" name="dueDate" id="updateDueDate" class="form-control">
          </div>
          <div class="mb-3">
            <label>Priority</label>
            <select name="priority" id="updatePriority" class="form-control">

                                <option value="1">Critical (Must Do Immediately)</option>
                                                                    <option value="2">High Priority</option>
                                                                    <option value="3" selected>Medium Priority</option>
                                                                    <option value="4">Low Priority</option>
                                                                    <option value="5">Very Low Priority</option>

            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Update</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </div>
    </form>
  </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const taskLinks = document.querySelectorAll(".task-detail-link");

    taskLinks.forEach(link => {
        link.addEventListener("click", function () {
            document.getElementById("taskModalTitleText").textContent = this.dataset.title;
            document.getElementById("taskModalSummary").textContent = this.dataset.summary;
            document.getElementById("taskModalDescription").textContent = this.dataset.description;

            document.getElementById("taskDetailUpdateBtn").dataset.taskId = this.dataset.taskId;
            document.getElementById("taskDetailDeleteBtn").dataset.taskId = this.dataset.taskId;
        });
    });

    // Update button → open Update Modal
    document.getElementById("taskDetailUpdateBtn").onclick = function () {
        const taskId = this.dataset.taskId;
        openUpdateTaskModal(
            taskId,
            document.getElementById("taskModalTitleText").textContent,
            document.getElementById("taskModalSummary").textContent,
            document.getElementById("taskModalDescription").textContent,


            '', '', // dueDate & priority left blank (can fetch if needed)
        );
    };

    // Delete button → call backend
    document.getElementById("taskDetailDeleteBtn").onclick = function () {
        const taskId = this.dataset.taskId;
        if (confirm("Are you sure you want to delete this task?")) {
            fetch('/admin/delete-task?taskId=' + taskId, { method: 'POST' })
                .then(() => location.reload());
        }
    };
});

// Function to open Update Modal
function openUpdateTaskModal(taskId, title, summary, description, dueDate, priority) {
    document.getElementById("updateTaskId").value = taskId;
    document.getElementById("updateTitle").value = title;
    document.getElementById("updateSummary").value = summary;
    document.getElementById("updateDescription").value = description;
    document.getElementById("updateDueDate").value = dueDate || '';
    document.getElementById("updatePriority").value = priority || 3;

    const updateModal = new bootstrap.Modal(document.getElementById("updateTaskModal"));
    updateModal.show();
}
</script>

</body>
</html>
