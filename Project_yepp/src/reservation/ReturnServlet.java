package reservation;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ReturnServlet
 */
@WebServlet("/doReturnServlet")
public class ReturnServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ReturnServlet() {
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
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=UTF-8");

		ServletContext sc = getServletContext();
		Connection conn = (Connection) sc.getAttribute("DBconnection");

		HttpSession session = request.getSession();

		String user_id = (String) session.getAttribute("user_id");

		if (request.getParameter("type").equals("show")) {
			ArrayList<Returnlist> list = ReturnDButil.getSeatList(conn, user_id);

			session.setAttribute("list", list);
			response.sendRedirect("reservation/return.jsp");

			// RequestDispatcher rd =
			// request.getRequestDispatcher("../reservation/return.jsp");
			// request.setAttribute("list", list);
			// rd.forward(request, response);
		} else if (request.getParameter("type").equals("return")) {

			String reser_id = (String) request.getParameter("reser_num");
			System.out.println("ReturnServlet.java : reser_id 는 " + reser_id);

			if (reser_id != null) {
				System.out.println("ReturnServlet.java : reser_id 가 null이 아니야");

				PrintWriter out = response.getWriter();
				int reserid = Integer.parseInt(reser_id);

				boolean isCompleteDelete = ReturnDButil.deleteReservation(conn, reserid);

				if (isCompleteDelete) {

					Calendar oCalendar = Calendar.getInstance();
					String now_month = String.valueOf(oCalendar.get(Calendar.MONTH) + 1);
					String now_date = String.valueOf(oCalendar.get(Calendar.DAY_OF_MONTH));

					String today = now_month + "-" + now_date;
					ArrayList<boolean[]> reserList = new ArrayList<boolean[]>();

					for (int i = 1; i <= 40; i++) {
						boolean[] seatCondition = ReservationDButil.getReserList(sc, i, today);
						reserList.add(seatCondition);
					}

					ArrayList<String[]> seatList = ReservationDButil.mySeatList(sc, user_id);
					
					session.setAttribute("month", now_month);
					session.setAttribute("day", now_date);
					session.setAttribute("reserList", reserList);
					session.setAttribute("mySeatList", seatList);

					out.println("<script language=javascript>");
					out.println("alert('좌석이 반납 되었습니다. 이용해 주셔서 감사합니다:) ');");
					out.println("      location.href = 'reservation/reservation.jsp'");
					out.println("</script>");
				} else {
					out.println("<script language=javascript>");
					out.println("alert('죄송합니다, 예상치 못한 오류가 발생하였습니다. 빠른 시일 내에 해결하겠습니다. ');");
					out.println("      location.href = 'reservation/reservation.jsp'");
					out.println("</script>");
				}
			}

		}

	}

}