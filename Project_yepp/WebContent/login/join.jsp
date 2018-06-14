<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.awt.image.*, java.io.*, javax.imageio.*, java.net.URL, login.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:useBean id="mb" class="login.DButil"/>
<jsp:useBean id="member" class="login.Member"/>
<jsp:setProperty name="member" property="*"/>
	<%
		ServletContext sc = getServletContext();

		if (member.getImage() == null)
			System.out.println("request.getParameter(image) 가 null");

		String imagepath = member.getImage().getAbsolutePath();
		System.out.println(imagepath);

		boolean isCompleteJoin = DButil.insertDB(sc, member);

		if (isCompleteJoin) {
			System.out.println("ȸ 회원가입 성공");
	%>
	<script>
		alert("회원가입 성공");
	</script>

	<%
		response.sendRedirect("login.html");

		} else {
	%>
	<script type="text/javascript">
		alert('아이디를 잘못 입력하셨습니다.');
		history.go(-1);
	</script>
	<%
		}
	%>
</body>
</html>