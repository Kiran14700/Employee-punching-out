<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Task Page</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="p-4">

<!-- Employee Info -->
<div class="mb-3">
    <p><strong>Username:</strong> ${name}</p>
    <p><strong>In Time:</strong> ${inTime}</p>
    <p><strong>Out Time:</strong> ${outTime}</p>
    <p><strong>No of Tasks Assigned:</strong> ${taskCount}</p>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Logout</a>
</div>

<!-- Task Buttons -->
<div class="d-grid gap-2 d-md-block">
    <c:forEach var="task" items="${tasks}" varStatus="status">
        <button class="btn btn-primary m-1" data-bs-toggle="modal" data-bs-target="#taskModal"
                data-id="${task.id}"
                data-title="${task.title}"
                data-summary="${task.summary}"
                data-description="${task.description}"
                data-priority="${task.priority}"

                data-assignedby="${task.assignedBy != null ? task.assignedBy.username : 'Admin'}"
                data-duedate="${task.dueDate != null ? task.dueDate : 'No Deadline'}"
                data-status="${task.status}">
            Task ${status.index + 1}
        </button>
    </c:forEach>
</div>

<!-- Modal for Viewing Task -->
<div class="modal fade" id="taskModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Task Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>Title:</strong> <span id="taskTitleText"></span></p>
                <p><strong>Summary:</strong> <span id="taskSummary"></span></p>
                <p><strong>Description:</strong> <span id="taskDescription"></span></p>
                <p><strong>Assigned By:</strong> <span id="taskAssignedBy"></span> Sir</p>
                <p><strong>Priority:</strong> <span id="taskPriority"></span></p>

                <p><strong>Deadline:</strong> <span id="taskDeadline"></span></p>
            </div>
            <div class="modal-footer">
                <form id="acceptForm" method="post" action="${pageContext.request.contextPath}/tasks/accept">
                    <input type="hidden" name="taskId" id="taskIdField">
                    <button type="submit" class="btn btn-success" id="acceptButton">Accept</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Fill modal values dynamically
    let taskModal = document.getElementById('taskModal');
taskModal.addEventListener('show.bs.modal', function (event) {
    let button = event.relatedTarget;
    let taskId = button.getAttribute('data-id');
    let status = button.getAttribute('data-status');

    document.getElementById('taskIdField').value = taskId;
    document.getElementById('taskTitleText').innerText = button.getAttribute('data-title');
    document.getElementById('taskSummary').innerText = button.getAttribute('data-summary');
    document.getElementById('taskDescription').innerText = button.getAttribute('data-description');

    // ✅ priority mapping
    const priorityMap = {
        "1": "Critical",
        "2": "High",
        "3": "Medium",
        "4": "Low",
        "5": "Very Low"
    };
    document.getElementById('taskPriority').innerText = priorityMap[button.getAttribute('data-priority')];

    document.getElementById('taskAssignedBy').innerText = button.getAttribute('data-assignedby');
    document.getElementById('taskDeadline').innerText = button.getAttribute('data-duedate');

    let acceptButton = document.getElementById('acceptButton');
    if (status === "In Progress" || status === "Completed") {
        acceptButton.innerText = "Accepted";
        acceptButton.classList.remove("btn-success");
        acceptButton.classList.add("btn-secondary");
        acceptButton.disabled = true;
    } else {
        acceptButton.innerText = "Accept";
        acceptButton.classList.remove("btn-secondary");
        acceptButton.classList.add("btn-success");
        acceptButton.disabled = false;
    }
});

</script>

</body>
</html>
