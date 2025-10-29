<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="http://bit.ly/3WJ5ilK" />
</head>
<body>
	
	<!-- customlogin.jsp -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>
	<h2>Custom Login page</h2>
	
	<form method="POST" action="/java/login">
	<table class="vertical content">
		<tr>
			<th>아이디</th>
			<td><input type="text" name="username" required></td>
		</tr>
		<tr>
			<th>암호</th>
			<td><input type="password" name="password" required></td>
		</tr>
	</table>
	<div>
		<button class="in">로그인</button>
	</div>
	
	<!-- CSRF 토큰 : 지금 POST 요청은 내가 직접하는것이다. 
		
	<input type="hidden" name="_csrf" value="6588cd74-eb04-49c1-b786-e3f4b79daf69">	
	-->
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	</form>
</body>
</html>
