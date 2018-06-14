<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="login.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>아이디 찾기</title>
</head>
<body>

	<%
		request.setCharacterEncoding("UTF-8");

		//서블릿 컨텍스트 생성
		ServletContext sc = getServletContext();

		String name = request.getParameter("name");
		int student_id = Integer.parseInt(request.getParameter("student_id"));
		String phone = request.getParameter("phone");
		String searchId = DButil.getID(sc, name, student_id, phone);
	%>

	<div align="center">
		<form method="post" action="login.html">
			<%
				if (searchId != null) {
			%>
			<%=name%>님의 아이디는 <b> <%=searchId%></b> 입니다.
			<p>
				<input type="submit" value="로그인하기">
				<input type="button" value="비밀번호 찾기" onclick="javascript:window.location='searchPwForm.html'">

				<%
					} else {
				%>
				이름 또는 학번이 틀렸습니다.
			<p>
				<input type="button" value="다시 입력하기"
					onclick="javascript:window.location='searchIdForm.html'">
				<%
					}
				%>
			
		</form>
	</div>

</body>

</html>