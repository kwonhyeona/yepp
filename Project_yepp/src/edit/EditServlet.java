package edit;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class EditServlet
 */
@WebServlet("/doEdit")
public class EditServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public EditServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	public void init(ServletConfig config) throws ServletException {
		System.out.println("*** initializing controller servlet.");
		super.init(config);
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
		request.setCharacterEncoding("UTF-8");

		ServletContext sc = getServletContext();
		Connection conn = (Connection) sc.getAttribute("DBconnection");

		if (request.getParameter("type").equals("image")) {
			System.out.println("EditServlet.java : type 이 image");
			File image = new File(request.getParameter("change_img"));

			if (image == null)
				System.out.println("request.getParameter(image) 가 null");

			boolean isComplete = DButil_edit.updateImage(conn, request.getParameter("user_id"), image);

			if (isComplete) {
				System.out.println("EditServlet.java : update image 성공");
				String imagepath = image.getAbsolutePath();
				System.out.println("EditServlet.java : imagepath 는 " + imagepath);

				HttpSession session = request.getSession();
				
				session.setAttribute("complete", "true");
				
				response.sendRedirect("edit/edit_image.jsp?complete=true");

			} else {
				PrintWriter out = response.getWriter();
				out.println("<h2>updating image fail!!<h2>");
			}

		} else {
			System.out.println("EditServlet.java : request의 type이 image가 아닐 때 ");
			int student_id = Integer.parseInt(request.getParameter("student_id"));
			boolean isEdit = DButil_edit.updateDB(conn, request.getParameter("user_id"), request.getParameter("passwd"),
													request.getParameter("name"), request.getParameter("birth"),
													request.getParameter("phone"), student_id );
			
			if(isEdit){
				response.sendRedirect("reservation/reservation.jsp");
			}
				

		}
	}

}
