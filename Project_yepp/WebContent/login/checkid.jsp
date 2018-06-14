<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*, login.DButil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ID 중복 체크 검사</title>


<script>
	function checkIdClose(id) {
		opener.joinform.user_id.value = id
		opener.joinform.checkid.value = 1
		window.close()
		opener.joinform.passwd.focus()

	}
</script>
</head>
<body>
	<center>
		<form method="post" action="checkid.jsp">

			<%
				ServletContext sc = getServletContext();
			
				boolean isCheckId;
				String id;

				id = request.getParameter("user_id");
				isCheckId = DButil.checkID(sc, id);

				if (isCheckId) {
			%>
			아이디 :
			<%=id%>
			사용가능 <a href="checkid.jsp">다른 아이디 고르기</a><br> <br> <input
				type="button" value="현재 아이디 선택"
				onClick="javascript:checkIdClose('<%=id%>')">
			<%
				} else {
			%>
			아이디 :
			<%=id%>
			사용 불가능 <br> <br> 아이디 : <input type="text" name="user_id">
			<input type="submit" value="중복체크">
			<%
				}
			%>
		</form>
	</center>
</body>
</html>