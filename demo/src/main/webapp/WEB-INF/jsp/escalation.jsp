<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Escalation View</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="p-4">

<h3 class="mb-4">Escalation Dashboard</h3>

<div class="row g-4">

    <!-- DUE (today, before deadline) -->
    <div class="col-md-6">
        <div class="card p-3">
            <h5>Due Today</h5>
            <input class="form-control mb-2" id="searchDue" placeholder="Search employee...">
            <ul class="list-group mt-2" id="dueList">
                <c:forEach var="emp" items="${dueEmployees}">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <button class="btn btn-link p-0" data-bs-toggle="modal" data-bs-target="#taskModal"
                                data-username="${emp.username}"
                                data-tasks='<c:forEach var="t" items="${dueTasksMap[emp.id]}"> ${t.title} — Deadline: ${t.dueDate} (${t.status})<br/> </c:forEach>'>
                            ${emp.username}
                        </button>
                        <span class="badge bg-primary rounded-pill">
                            <c:out value="${fn:length(dueTasksMap[emp.id])}" />
                        </span>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>

    <!-- ESCALATED (deadline reached/passed) -->
    <div class="col-md-6">
        <div class="card p-3">
            <h5>Escalated</h5>
            <input class="form-control mb-2" id="searchEsc" placeholder="Search employee...">
            <ul class="list-group mt-2" id="escList">
                <c:forEach var="emp" items="${escalatedEmployees}">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <button class="btn btn-link p-0" data-bs-toggle="modal" data-bs-target="#taskModal"
                                data-username="${emp.username}"
                                data-tasks='<c:forEach var="t" items="${escalatedTasksMap[emp.id]}"> ${t.title} — Deadline: ${t.dueDate} (${t.status})<br/> </c:forEach>'>
                            ${emp.username}
                        </button>
                        <span class="badge bg-danger rounded-pill">
                            <c:out value="${fn:length(escalatedTasksMap[emp.id])}" />
                        </span>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>

</div>

<!-- Modal -->
<div class="modal fade" id="taskModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Employee Tasks</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>Employee:</strong> <span id="modalEmployee"></span></p>
                <div id="modalTasks"></div>
            </div>
        </div>
    </div>
</div>

<div class="mt-4">
    <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Back to Dashboard</a>
</div>

<script>
    // Plug values into modal
    let taskModal = document.getElementById('taskModal');
    taskModal.addEventListener('show.bs.modal', function (event) {
        let button = event.relatedTarget;
        document.getElementById('modalEmployee').innerText = button.getAttribute('data-username');
        document.getElementById('modalTasks').innerHTML = button.getAttribute('data-tasks');
    });

    // Simple client-side search filters
    function attachFilter(inputId, listId) {
        const input = document.getElementById(inputId);
        const list = document.getElementById(listId);
        input.addEventListener('input', () => {
            const q = input.value.toLowerCase();
            [...list.children].forEach(li => {
                const name = li.querySelector('button').innerText.toLowerCase();
                li.style.display = name.includes(q) ? '' : 'none';
            });
        });
    }

    attachFilter('searchDue', 'dueList');
    attachFilter('searchEsc', 'escList');
</script>

</body>
</html>
