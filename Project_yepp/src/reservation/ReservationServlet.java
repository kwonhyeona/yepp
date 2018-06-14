package reservation;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Calendar;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ReservationServlet
 */
@WebServlet("/doReservationServlet")
public class ReservationServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;

   /**
    * @see HttpServlet#HttpServlet()
    */
   public ReservationServlet() {
      super();
      // TODO Auto-generated constructor stub
   }

   /**
    * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
    *      response)
    */
   protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
      // TODO Auto-generated method stub
      doPost(request, response);
   }

   /**
    * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
    *      response)
    */
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
      // TODO Auto-generated method stub

      ServletContext sc = getServletContext();
      Connection conn = (Connection) sc.getAttribute("DBconnection");

      request.setCharacterEncoding("utf-8");
      response.setContentType("text/html;charset=UTF-8");

      HttpSession session = request.getSession();
      PrintWriter out = response.getWriter();

      System.out.println("ReservationServlet.java :chcek" + request.getParameter("type"));

      if (request.getParameter("type") != null) {
         // 조회버튼
         if (request.getParameter("type").equals("check")) {
            System.out.println("ReservationServlet.java :chcek" + request.getParameter("type"));
            String checkMonth = request.getParameter("checkMonth");
            String checkDay = request.getParameter("checkDay");

            String checkDate = checkMonth + "-" + checkDay;

            ArrayList<boolean[]> reserList = new ArrayList<boolean[]>();

            for (int i = 1; i <= 40; i++) {
               boolean[] seatCondition = ReservationDButil.getReserList(sc, i, checkDate);

               reserList.add(seatCondition);

            }

            session.setAttribute("reserList", reserList);
            session.setAttribute("month", checkMonth);
            session.setAttribute("day", checkDay);
            out.println("<script language=javascript>");

            out.println("alert('조회하였습니다 :) ');");
            out.println("      location.href = 'reservation/reservation.jsp'");
            out.println("</script>");

         }
      }

      if (request.getParameter("type") == null) {
         String user_id = (String) session.getAttribute("user_id");
         String seat_num = request.getParameter("seat_num");
         System.out.println(seat_num);
         int seat_id = Integer.parseInt(seat_num);
         String start_time = request.getParameter("reservation_start_time");
         String end_time = request.getParameter("reservatoin_end_time");
         String reser_month = (String) session.getAttribute("month");
         String reser_day = (String) session.getAttribute("day");
         String reser_date = reser_month + "-" + reser_day;

         ArrayList<String[]> list = ReservationDButil.mySeatList(sc, user_id);
         System.out.println(list.size());
         boolean isAlreadyReser = ReservationDButil.CheckReserOKTime(conn, seat_id, reser_date, start_time,
               end_time);

         Reservation new_reser = new Reservation();
         new_reser.setUser_id(user_id);
         new_reser.setSeat_id(seat_id);
         new_reser.setStart_time(start_time);
         new_reser.setEnd_time(end_time);
         new_reser.setReser_date(reser_date);
         // 이미 예약된 좌석인지 체크
         if (isAlreadyReser) {

            System.out.println("ReservationServlet.java : 시간체크 성공");
            // ID 한개당, 예약건수가 10개가 넘었는지 체크
            if (list.size() < 11) {

               boolean isCompleteReservation = ReservationDButil.insertReserDB(conn, new_reser);

               if (isCompleteReservation) {
                  System.out.println(" ReservationServlet.java :예약 성공");

                  Calendar oCalendar = Calendar.getInstance();
                  String now_month = String.valueOf(oCalendar.get(Calendar.MONTH) + 1);
                  String now_day = String.valueOf(oCalendar.get(Calendar.DAY_OF_MONTH));

                  String today = now_month + "-" + now_day;
                  ArrayList<boolean[]> reserList = new ArrayList<boolean[]>();

                  for (int i = 1; i <= 40; i++) {
                     boolean[] seatCondition = ReservationDButil.getReserList(sc, i, today);

                     reserList.add(seatCondition);

                  }
                  ArrayList<String[]> seatList = ReservationDButil.mySeatList(sc, user_id);

                  session.setAttribute("reserList", reserList);
                  session.setAttribute("month", now_month);
                  session.setAttribute("day", now_day);
                  session.setAttribute("reser_seat", "o");
                  session.setAttribute("mySeatList", seatList);

                  out.println("<script language=javascript>");
                  out.println("alert('예약이 완료 되었습니다. 이용해 주셔서 감사합니다:) ');");
                  out.println("      location.href = 'reservation/reservation.jsp'");
                  out.println("</script>");

               } else {

                  System.out.println(" ReservationServlet.java : DB입력 실패");
                  out.println("<script language=javascript>");
                  out.println("alert(' 죄송합니다, 예상치 못한 오류가 발생하였습니다.빠른 시일 내에 처리하겠습니다.');");
                  out.println("      location.href = 'reservation/reservation.jsp'");
                  out.println("</script>");
               }
            } else {
               System.out.println(" ReservationServlet.java : 예약된 자리가 10개 이상");
               out.println("<script language=javascript>");
               out.println("alert('예약 건수 가 10개 이상 입니다. 7일 이내의 최대 예약 시간은 30시간 입니다. ');");
               out.println("history.go(-1);");
               out.println("</script>");
            }
         } else {

            out.println("<script language=javascript>");
            out.println("alert('이미 예약된 자리 입니다. 다시 시도해 주세요!');");
            out.println("history.go(-1);");
            out.println("</script>");
         }
      }
   }

}