<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Login</title>
</head>
<body>
<h2>Login</h2>


<form action="login" method="post">
    Username: <input type="text" name="username" required><br><br>
    Password: <input type="password" name="password" required><br><br>
    <button type="submit">Login</button>
</form>

<br>
<!-- Register button -->
<form action="register" method="get">
    <button type="submit">You want to registerr</button>
</form>


<c:if test="${not empty error}">
    <p style="color:red">${error}</p

    <div class="alert alert-secondary" role="alert">
      ${error}}   </div>
</c:if>

</body>
</html>
