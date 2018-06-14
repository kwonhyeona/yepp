<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="reservation.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>현재 예약 상황</title>
<!-- Bootstrap Core CSS -->
<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">

<!-- Squad theme CSS -->
<link href="../css/style.css" rel="stylesheet">
<link href="../color/new.css" rel="stylesheet">
</head>
<body>
	<%
		//서블릿 컨텍스트 생성
		ServletContext sc = getServletContext();

		String[] reserList = ReservationDButil.getCurrentReserList(sc);
		boolean[] isReserList = new boolean[reserList.length];

		for (int i = 0; i < reserList.length; i++) {
			if (reserList[i] != null)
				isReserList[i] = true;
			else
				isReserList[i] = false;
		}
	%>
	<br>
	<div align="center"
		style="display: inline-block; position: absolute; align: center; left: 30%; right: 30%;">
		<H2 align="center"> Current Reservation State </H2>
		<table class="table table-bordered" height="50px">
			<%
				int count = 1;
				for (int i = 0; i < 7; i++) {
			%>
			<tr align="center" valign="middle" height="75px">
				<%
					String color = null;

						for (int j = 0; j < 3; j++) {
							if (isReserList[count - 1]) {
								color = "#8E1E0C";
							} else {
								color = "#FFFFFF";
							}
				%>
				<td bgcolor="<%=color%>"><font size="4"><%=count%></font></td>
				<%
					if (count == 39)
								break;
							count++;
						}
				%>

				<td bgcolor="#ffffff"></td>
				<%
					for (int j = 3; j < 6; j++) {
							if (isReserList[count - 1]) {
								color = "#8E1E0C";
							} else {
								color = "#FFFFFF";
							}

							if (count == 39)
								break;
				%>
				<td bgcolor="<%=color%>"><font size="4"><%=count%></font></td>
				<%
					if (++count == 39)
								break;
						}
				%>
				<%
					}
				%>
			</tr>
		</table>
	</div>

</body>
</html>