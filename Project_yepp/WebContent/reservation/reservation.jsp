<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import=" java.util.* ,java.text.*, seat.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>예약하기</title>

<!-- Bootstrap Core CSS -->
<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="../css/nav.css" rel="stylesheet" type="text/css">
<link href="../css/round.css" rel="stylesheet" type="text/css">

<!-- Fonts -->
<link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet"
	type="text/css">
<link href="../css/animate.css" rel="stylesheet" />
<!-- Squad theme CSS -->
<link href="../css/style.css" rel="stylesheet">

<link href="../color/new.css" rel="stylesheet">


<script>
	if (subscribed == "true") {
		alert("Peep Peep..");
	}
	//function login() {
	//   alert("Welcome to our page");
	//}

	function logout() {
		if (confirm("Thank You, See you again."))
			location.href = '../login/logout.jsp';
	}

	function openNav() {
		document.getElementById("mySidenav").style.width = "250px";
	}

	function closeNav() {
		document.getElementById("mySidenav").style.width = "0px";
	}

	function seat_return() {
		if (confirm("좌석 반납 페이지로 이동하시겠습니까?") == true) { //확인
			document.returnform.submit()
		} else { //취소
			return;
		}
	}
	function seat_reservating(row) {
		if (confirm(row + "번째 좌석을 예약하시겠습니까?")) {
			window.open("reservating.jsp?seat_num=" + row)
		} else {
			return;
		}
	}
</script>
<jsp:useBean id="seatdb" class="seat.SeatDButil"></jsp:useBean>
</head>
<body>
<body id="page-top" data-spy="scroll" data-target=".navbar-custom"
	onload="login()">
	<%
		ArrayList<String[]> my_seat_list = (ArrayList<String[]>) session.getAttribute("mySeatList");
		if (my_seat_list.size() > 0)
			session.setAttribute("reser_seat", "O");
		else
			session.setAttribute("reser_seat", "X");
	%>
	<!-- Preloader -->
	<div id="preloader">
		<div id="load"></div>
	</div>

	<nav class="navbar navbar-custom navbar-fixed-top" role="navigation">

	<div class="container">

		<div class="navbar-header page-scroll">
			<span style="font-size: 30px; cursor: pointer" onclick="openNav()">&#9776;
			</span> <a class="navbar-brand" href="reservation.jsp">
				<h1>Yepp</h1>
			</a>
		</div>

		<!-- Collect the nav links, forms, and other content for toggling -->
		<div
			class="collapse navbar-collapse navbar-right navbar-main-collapse">
			<ul class="nav navbar-nav">

				<li class="active" onclick="logout()"><a>Logout</a></li>
			</ul>
		</div>
		<!-- /.navbar-collapse -->
	</div>
	<div id="mySidenav" class="sidenav">
		<a class="closebtn" onclick="closeNav()">&times;</a>
		<div align="center">
			<img src="../photo.jsp?" height="100" width="100" class="round"
				onerror="this.src='no_img.gif';"></img><br> <br>
		</div>
		<form method=post name="returnform" action="../doReturnServlet">
			<ul>

				<li><%=session.getAttribute("user_id")%> 님!</li>
				<li>자리 예약 : <%=session.getAttribute("reser_seat")%> <input
					type=hidden value="show" name="type"> <input type=button
					value="반납" onClick="javascript:seat_return()"></li>
			</ul>
		</form>

		<div style="overflow: auto; height: 300px;">
			<%
				if (my_seat_list.size() > 0) {
					for (String[] reser : my_seat_list) {
			%>
			<ul>
				<hr>
				<li>예약 PC : <%=reser[0]%> 번
				</li>
				<li>예약 날짜 : <%=reser[1]%>
				</li>
				<li>예약 시간 : <%=reser[2]%> ~ <%=reser[3]%></li>
			</ul>
			<hr>
			<%
				}
				}
			%>
		</div>

		<form method=post action="../edit/edit.jsp">
			<div align="right">
				<input type=submit value="정보수정">
			</div>
		</form>
	</div>



	<!-- /.container --> </nav>

	<section id="intro" class="home-section text-center bg-gray">
	<div align=right style="padding: 20px;">
		<h5>
			TOTAL :
			<%=session.getAttribute("count")%>
		</h5>
	</div>

	<%
		String month = (String) session.getAttribute("month");
		String day = (String) session.getAttribute("day");
	%>
	<h3><%=month%>월
		<%=day%>
		일
	</h3>
	<h5>예약할 PC의 번호를 선택해 주세요</h5>
	</section>
	<%
		//예약시간 들을 reser_time[]배열에 30분 단위로 String으로 저장.
		String reser_time[] = { "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00",
				"13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30",
				"19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00" };
	%>

	<table class="table">
		<tr>
			<td align=left rowspan=2>
				<div align=left style="padding: 15px;">
					<table style="cellspacing: 10px">
						<tr>
							<td width=87px height=15px border=1><font size=1>＊예약가능:</font></td>
							<td width=65px bgcolor="#FFFFFF"></td>
						</tr>
						<tr>
							<td width=90px height=15px><font size=1>＊예약불가능:</font></td>
							<td width=65px bgcolor="#8E1E0C"></td>
						</tr>
					</table>
				</div>
			</td>
			<td padding=80px></td>
			<td align=right>
				<div align="right" style="padding: 15px;">
					<form method=post action="../doReservationServlet">

						* 예약 날짜 : <select name="checkMonth" id="month">

							<%
								Calendar oCalendar = Calendar.getInstance();
								int sMonth = (oCalendar.get(Calendar.MONTH) + 1);
								int sDay = oCalendar.get(Calendar.DAY_OF_MONTH);

								//isMonth 가 true 이면 예약 날짜 출력시 현재 달만 출력되고, false 이면 다음달 선택할 수 있도록 출력하다.
								boolean isMonth = true;
								//31일까지 있는 달인 경우
								if (sMonth == 1 || sMonth == 3 || sMonth == 5 || sMonth == 7 || sMonth == 8 || sMonth == 10
										|| sMonth == 12) {
									if (sDay > 25)
										isMonth = false;

								} //2월인 경우 
								else if (sMonth == 2) {
									if (sDay > 22)
										isMonth = false;
								} // 30일 까지 있는 달인 경우 
								else {
									if (sDay > 24)
										isMonth = false;
								}
							%>

							<%
								if (isMonth) {
							%>

							<option value="<%=sMonth%>">
								<%=sMonth%></option>

							<%
								} else {
									//reser_month가 12월인경우 1월로 변경해서 출력.
									if (sMonth == 12) {
							%>
							<option value="<%=sMonth%>">
								<%=sMonth%></option>
							<option value="<%=sMonth - 11%>">
								<%=sMonth - 11%></option>
							<%
								} else {
							%>

							<option value="<%=sMonth%>">
								<%=sMonth%></option>
							<option value="<%=sMonth + 1%>">
								<%=sMonth + 1%></option>
							<%
								}
								}
							%>

						</select> 월 <select name="checkDay" id="date">
							<%
								//현재 날짜를 j에 저장. j가 31,30,28을 넘어갈 경우 각각 31,28,32를 빼서, 다음달 1일부터 출력되게 한다.
								for (int j = sDay; j < sDay + 8; j++) {

									if (sMonth == 1 || sMonth == 3 || sMonth == 5 || sMonth == 7 || sMonth == 8 || sMonth == 10
											|| sMonth == 12) {
										if (j >= 32)
											j = j - 31;

									} else if (sMonth == 2) {
										if (j >= 29)
											j = j - 28;
									} else {
										if (j >= 31)
											j = j - 30;

									}
							%>

							<option value="<%=j%>"><%=j%></option>
							<%
								}
							%>
						</select>일 <input type=hidden name="type" value="check" /> <input
							type="submit" value="조회" />
					</form>
				</div>
				<div style="padding: 15px;">
					<a href="current.jsp"><font color="#8E1E0C">현재 예약 상황
							보러가기 </font></a>
				</div>
			</td>
		</tr>
	</table>
	<div align=center style="padding:5px;">
		<table class="table table-bordered ">

			<tr >

				<td colspan=28 align=center>예약 현황
			</tr>

			<tr>
				<td nowrap><font size="1px">자리 번호</font></td>
				<td align=left nowrap><font size="1px">프린터</font></td>
				<%
					for (int k = 0; k < 26; k++) {
				%>
				<td align="left" ><font size="1px"><%=reser_time[k]%></font></td>
				<%
					}
				%>
			</tr>

			<%
				//서블릿 컨텍스트 생성
				ServletContext sc = getServletContext();

				//예약 리스트와 자리 리스트 가져오기
				ArrayList<boolean[]> now_reser_list = (ArrayList<boolean[]>) session.getAttribute("reserList");
				ArrayList<Seat> seatList = seatdb.getSeatList(sc);
				for (int i = 0; i < 39; i++) {
					int row = i + 1;
					boolean[] reser_array = now_reser_list.get(i);
					Seat seat = seatList.get(i);
					String print = null;
					if (seat.getIs_print().equals("T"))
						print = "O";
					else
						print = "X";
			%>


			<tr>
				<td align=center>
					<form name=seat_form method=post action="reservating.jsp">
						<input type="button" class="btn" value="<%=seat.getSeat_id()%>"
							name="seat_num"
							onClick="javascript:seat_reservating('<%=seat.getSeat_id()%>')">
					</form>
				</td>
				<td align=center valign=middle><font size="1px" ><%=print%></font></td>
				<%
					for (int timeSlice = 0; timeSlice < 26; timeSlice++) {
							String color;
							if (reser_array[timeSlice]) {
								color = "#8E1E0C";
							} else {
								color = "#FFFFFF";
							}
				%>

				<td bgcolor="<%=color%>"></td>
				<%
					}
					}
				%>
			
		</table>
		</div>


	<hr>

	<footer>
	<div class="container">
		<div class="row" align="center">
			<div class="col-md-12 col-lg-12"
				style="padding-left: 300px; padding-right: 300px">
				<div class="wow shake" data-wow-delay="0.4s">
					<div class="page-scroll marginbot-30">
						<a href="#intro" id="totop" class="btn btn-circle"> <i
							class="fa fa-angle-double-up animated"></i>
						</a>
					</div>
				</div>
				<p>&copy;Copyright 2016 - Kwon Hyeon-a, Lee Ji-eun.</p>
			</div>
		</div>
	</div>
	</footer>

	<!-- Core JavaScript Files -->
	<script src="../js/jquery.min.js"></script>
	<script src="../js/bootstrap.min.js"></script>
	<script src="../js/jquery.easing.min.js"></script>
	<script src="../js/jquery.scrollTo.js"></script>
	<script src="../js/wow.min.js"></script>
	<!-- Custom Theme JavaScript -->
	<script src="../js/custom.js"></script>

</body>


</html>