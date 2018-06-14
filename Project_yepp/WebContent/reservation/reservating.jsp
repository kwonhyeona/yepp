<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.* ,java.text.*"%>
<html>

<!-- Bootstrap Core CSS -->
<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="../css/nav.css" rel="stylesheet" type="text/css">

<!-- Fonts -->
<link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet"
	type="text/css">
<link href="../css/animate.css" rel="stylesheet" />
<!-- Squad theme CSS -->
<link href="../css/style.css" rel="stylesheet">

<link href="../color/new.css" rel="stylesheet">

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=request.getParameter("seat_num")%> 번 자리 예약</title>
<%
	//calendar 함수를 이용하여 현재 날짜와 시간을 받아서 저장한다.
	Calendar oCalendar = Calendar.getInstance();
	int reser_month = (oCalendar.get(Calendar.MONTH) + 1);
	int reser_date = oCalendar.get(Calendar.DAY_OF_MONTH);
	int reser_hour = oCalendar.get(Calendar.HOUR_OF_DAY);
	int reser_min = oCalendar.get(Calendar.MINUTE);

	//reservation.jsp 에서 받아온 month와 date를 저장
	int month = Integer.parseInt((String) session.getAttribute("month"));
	int day = Integer.parseInt((String) session.getAttribute("day"));

	//예약시간 들을 reser_time[]배열에 30분 단위로 String으로 저장.
	String reser_time[] = {"09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00",
			"13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30",
			"19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00"};

	int now = 0;

	int seatId = Integer.parseInt(request.getParameter("seat_num"));

	//현재날짜와 예약하려는 날짜가 같으면 now =1;
	if (month == reser_month && day == reser_date) {
		now = 1;
	}
	//reser_time[]배열의 인덱스를 사용하여 비교해 주기 위해서  현재 시간을 받아와서  변환하여 저장.
	int reser_Time_Array_num = (reser_hour - 9) * 2;
	if (reser_min > 30) {
		reser_Time_Array_num += 1;
	}
%>

<script>
   function checkReser() {
      
   
      //select에서 가져온 start_time, end_time의 index를 각각 x,y에 저장 
      var x = document.getElementById("start_time").selectedIndex;
      var y = document.getElementById("end_time").selectedIndex;
   
      var t = "<%=reser_Time_Array_num%>"
      var a = "<%=now%>"

		//사용자가 예약 날짜 오늘 날짜를 선택한 경우 체크
		if (a == 1) {

			//현재시간보다 예약시작시간이 빠른지 체크
			if (t <= x) {
				//예약시간보다 종료시간이 빠른디 체크
				if (x <= y) {

					//예약시간이 3시간이상인지 체크
					if (y - x < 6) {
						document.reser_form.submit()

					} else {
						//사용자가 예약시간을 3시간 이상으로 선택한 경우 alter창
						alert("예약 시간은 최대3시간 입니다. 다시 시도해 주세요")
					}
				} else {
					//사용자가  예약시작시간보다 예약 종료시간을 더 빠른시간으로 선택한 경우  alert창
					alert("시작시간이 종료 시간 보다 같거나 빠릅니다. 다시 시도해 주세요")
				}

			} else {
				//사용자가 오늘 날짜의 현재시간보다 예약시작시간을 더 빠른 시간으로 선택한 경우  alert창
				alert("이미 지난 시간대입니다. 다른 시간대를 선택해주세요.")
			}

		} else {

			//예약시간보다 종료시간이 빠른디 체크
			if (x <= y) {
				//예약시간이 3시간이상인지 체크
				if (y - x < 6) {
					document.reser_form.submit()

				} else {
					//사용자가 예약시간을 3시간 이상으로 선택한 경우 alter창
					alert("예약 시간은 최대3시간 입니다. 다시 시도해 주세요")
				}
			} else {
				//사용자가  예약시작시간보다 예약 종료시간을 더 빠른시간으로 선택한 경우  alert창
				alert("시작시간이 종료 시간 보다 같거나 빠릅니다. 다시 시도해 주세요")
			}

		}
	}
</script>

</head>
<body>
	<section id="seat" class="home-section text-center bg-gray">

		<%--This is made by Lee Ji Eun --%>
		<%--date:  2016. 11. 21.  --%>

		<h2>자리예약 페이지</h2>

		<%
			ArrayList<boolean[]> now_reser_list = (ArrayList<boolean[]>) session.getAttribute("reserList");

			boolean[] reser_array = now_reser_list.get(seatId - 1);
		%>

		<hr>
		<div align=center style="padding: 15px;">
			<table class="table table-bordered">
				<tr align=center>
					<td colspan=28>시간별 좌석 예약 현황</td>
				</tr>
				<tr align="center">
					<td nowrap><font size="1px">자리 번호</font></td>
					<%
						for (int i = 0; i < 26; i++) {
					%>
					<td><font size="1px"><%=reser_time[i]%></font></td>
					<%
						}
					%>
				</tr>
				<tr align="center">
					<td rowspan="2" align="center"><STRONG><%=seatId%></STRONG></td>
					<%
						for (int timeSlice = 0; timeSlice < 26; timeSlice++) {
							String color;
							if (reser_array[timeSlice]) {
								color = "#8E1E0C";
							} else {
								color = "#FFFFFF";
							}
					%>
					<td bgcolor="<%=color%>" height=30px></td>
					<%
						}
					%>
				</tr>
			</table>
			<hr>
		</div>
		<div id=reservationDate align="left"
			style="width: 500px; height: 85px; margin-right: auto; margin-left: auto">
			<ul>
				<li>한번에 예약 할 수 있는 이용시간은 최대 2시간입니다.</li>
				<li>한 ID당 최대10개의 예약이 가능합니다.</li>
				<li>7일 이내의 날짜까지만 예약하실수 있습니다.</li>
				<br>

				<form method=post action="../doReservationServlet" name="reser_form">
					<input type="hidden" name="seat_num"
						value="<%=request.getParameter("seat_num")%>">

					<%
						// Date함수를 이용해서 오늘 날짜와 현재시간을 화면 상단에 보여준다.
						Date from = new Date();
						SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd   HH:mm:ss");
						String to = transFormat.format(from);
					%>
					<li>오늘 날짜 와 현재 시간 : <%=to%>
					</li>
					<li>예약할 날짜 : <%=month%>월 <%=day%>일
					</li>
					<br>
					<li>예약하시려는 시간을 선택해주세요.</li> <font
						style="text-decoration: underline">시작시간 </font> &nbsp&nbsp<select
						name="reservation_start_time" id="start_time">
						<%
							for (int i = 0; i < 26; i++) {
						%>
						<option value="<%=reser_time[i]%>"><%=reser_time[i]%>
						</option>
						<%
							}
						%>
					</select> <font style="text-decoration: underline">종료시간 </font>&nbsp&nbsp<select
						name="reservatoin_end_time" id="end_time">
						<%
							for (int i = 1; i < 27; i++) {
						%>
						<option value="<%=reser_time[i]%>">
							<%=reser_time[i]%>
						</option>
						<%
							}
						%>


						
					</select> <br> <br> 
					<div align=center> <input
						type="button" value="예약" onClick="javascript:checkReser()" />
						<input type="reset" value="취소" />
						
						</div>
		</form>
		</ul>
		</div>
	</section>
</body>
</html>