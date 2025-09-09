<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Register</title>
</head>
<body>
<h2>Register User</h2>

<form action="register" method="post" enctype="multipart/form-data">
    First Name: <input type="text" name="firstName" value="${user.firstName}" required><br><br>
    Last Name: <input type="text" name="lastName" value="${user.lastName}" required><br><br>
    Username: <input type="text" name="username" value="${user.username}" required><br><br>
    Password: <input type="password" name="password" value="${user.password}" required><br><br>
    Confirm Password: <input type="password" name="confirmPassword" value="${user.confirmPassword}" required><br><br>
    Phone: <input type="text" name="phone" value="${user.phone}" required><br><br>
    Upload Marksheet (PDF): <input type="file" name="marksheetFile" accept=".pdf" required><br><br>
    <button type="submit">Register</button>
</form>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>
</body>
</html>
