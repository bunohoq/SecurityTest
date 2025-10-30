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
	
	<!-- register.jsp -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>
	
	<h2>Register page</h2>
	
	<form method="POST" action="/java/registerok.do">
	<table class="vertical">
		<tr>
			<th>아이디</th>
			<td><input type="text" name="memberid" required></td>
		</tr>
		<tr>
			<th>비밀번호</th>
			<td><input type="password" name="memberpw" required></td>
		</tr>
		<tr>
			<th>이메일</th>
			<td><input type="text" name="email" required></td>
		</tr>
		<tr>
			<th>이름</th>
			<td><input type="text" name="membername" required></td>
		</tr>
		<tr>
			<th>성별</th>
			<td><input type="text" name="gender"  value="f" required></td>
		</tr>
		<tr>
			<th>권한</th>
			<td>
				<select name="auth">
					<option value="1">일반회원(ROLE_MEMBER)</option>
					<option value="2">관리자(ROLE_ADMIN)</option>
				</select>		
			</td>
		</tr>
	</table>
	<div>
		<button>가입하기</button>
	</div>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	</form>
	
	
</body>
</html>
