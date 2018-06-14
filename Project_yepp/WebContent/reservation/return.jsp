<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" import="java.util.*, reservation.*"%>

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
<script language=JavaScript>
   function seat_return(reser_num) {
      if (confirm("정말 좌석을 반납 하시겠습니까?")) { //확인
         
         document.location.href="../doReturnServlet?reser_num=" + reser_num + "&type=return";
      } else { //취소
         return;
      }
   }
   

</script>
<title>죄석 반납 페이지</title>
</head>
<body>
   <section id="seat" class="home-section text-center bg-gray">
      <%
         Returnlist reser = new Returnlist();
         ArrayList<Returnlist> list = null;

         list = (ArrayList<Returnlist>) session.getAttribute("list");
         if (list instanceof ArrayList<?>)
      %>


      <div align="center">

         <h2>좌석 반납 페이지</h2>

         반납 하실 예약의 반납 버튼을 클릭해 주세요<br> <br>
      </div>
      <div align="center" style="padding-left: 250px; padding-right: 250px">
         <form method="post" action="../doReturnServlet" name="returnform">
            <table class="table table-bordered " >
               <tr bgcolor="FFFFFF" align=center valign=middle>

                  <td>예약번호</td>
                  <td>좌석번호</td>
                  <td>예약날짜</td>
                  <td>예약시작시간</td>
                  <td>예약종료시간</td>
                  <td>반납</td>

               </tr>

               <%
                  for (Returnlist reservate : list) {
               %>
               <tr align=center valign=middle>

                  <td><%=reservate.getReser_id()%></td>
                  <td><%=reservate.getSeat_id() %></td>
                  <td><%=reservate.getReser_date()%></td>
                  <td><%=reservate.getStart_time()%></td>
                  <td><%=reservate.getEnd_time()%></td>
                  <td><input type="button" class="btn" value="반납" onClick="javascript:seat_return(<%=reservate.getReser_id()%>)"></td>

               </tr>
               <%
                  }
               %>

            </table>

         </form>
      </div>

   </section>

</body>
</html>