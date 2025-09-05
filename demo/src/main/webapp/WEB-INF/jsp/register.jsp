<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Register</title>
</head>
<body>
<h2>Register User</h2>

<form action="register" method="post">
    Username: <input type="text" name="username" required><br><br>
    Password: <input type="password" name="password" required><br><br>
    Confirm Password: <input type="password" name="confirmPassword" required><br><br>
    Phone: <input type="text" name="phone" required><br><br>
    <button type="submit">Register</button>
</form>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

</body>
</html>
