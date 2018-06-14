<%@page
	import="java.io.OutputStream, login.*, java.util.*, reservation.ReservationDButil"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<HTML>
<HEAD>
<TITLE>login.jsp</TITLE>
</HEAD>
<BODY>



	<%
		//서블릿 컨텍스트 생성
		ServletContext sc = getServletContext();

		//request정보 받아오기
		String user_id = request.getParameter("user_id");
		String passwd = request.getParameter("passwd");

		//
		String dbPasswd = DButil.findUser(sc, user_id);
		byte[] my_img = DButil.getImg(sc, user_id);

		if (dbPasswd.equals(passwd)) {
			// valid user and passwd
			session = request.getSession();
			
			Calendar oCalendar = Calendar.getInstance();
            String now_month =String.valueOf(oCalendar.get(Calendar.MONTH) + 1);
            String now_day = String.valueOf(oCalendar.get(Calendar.DAY_OF_MONTH));
            String today = now_month + "-" +now_day;
            
            if(DButil.deleteOldRecord(sc, today)){
            	System.out.println("login.jsp : 시간지난 레코드 삭제 완료");
            } else{
            	System.out.println("login.jsp : 시간지난 레코드 삭제 실패");
            }
            ArrayList<String[]> mySeatList = ReservationDButil.mySeatList(sc, user_id);
            ArrayList<boolean[]> reserList = new ArrayList<boolean[]>();
            

            
            for(int i=1 ; i<=40;i++){
            	boolean[] seatCondition = ReservationDButil.getReserList(sc, i, today);
                reserList.add(seatCondition);
        
            }

            session.setAttribute("month",now_month);
            session.setAttribute("day",now_day);
            session.setAttribute("mySeatList", mySeatList);
            session.setAttribute("reserList", reserList);
			session.setAttribute("user_id", request.getParameter("user_id"));
			session.setAttribute("reser_seat", "x");
			session.setAttribute("img", my_img);

		} else if (dbPasswd.equals("*")) {
			// wrong passwd
	%>
	<script type="text/javascript">
		alert('아이디를 잘못 입력하셨습니다.');
		history.go(-1);
	</script>
	<%
		return;
		} else {
	%>
	<script type="text/javascript">
		alert('비밀번호를 잘못 입력하셨습니다.');
		history.go(-1);
	</script>
	<%
		return;
		}

		Integer count = (Integer) application.getAttribute("count");
		int cnt;
		if (count == null) {
			application.setAttribute("count", 1);
			cnt = 1;
		} else
			cnt = count.intValue() + 1;
		application.setAttribute("count", cnt);
		session.setAttribute("count", cnt);

		response.sendRedirect("../reservation/reservation.jsp");
	%>

</BODY>
</HTML>