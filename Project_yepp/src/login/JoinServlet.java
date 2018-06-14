package login;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.sql.Connection;

import javax.imageio.ImageIO;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class JoinServlet
 */
@WebServlet("/doJoin")
public class JoinServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public JoinServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("utf-8");
		
		String user_id = request.getParameter("user_id");
		String passwd = request.getParameter("passwd");
		String name = request.getParameter("name");
		String birth = request.getParameter("birth");
		String phone = request.getParameter("phone");
		int student_id = Integer.parseInt(request.getParameter("student_id"));
		String sex = request.getParameter("sex");
		File image = new File(request.getParameter("image"));
		if(image == null)
			System.out.println("request.getParameter(image) 가 null");
		
		Member new_member = new Member();
		new_member.setUser_id(user_id);
		new_member.setPasswd(passwd);
		new_member.setName(name);
		new_member.setBirth(birth);
		new_member.setPhone(phone);
		new_member.setStudent_id(student_id);
		new_member.setSex(sex);
		new_member.setImage(image);
		
		
		
		ServletContext sc = getServletContext();
		Connection conn= (Connection) sc.getAttribute("DBconnection");
		
		boolean isCompleteJoin = DButil.insertDB(sc, new_member);
		
		if(isCompleteJoin){
			System.out.println("ȸ 회원가입 성공");
			String imagepath = image.getAbsolutePath();
			System.out.println(imagepath);
			
			response.sendRedirect("login/join.jsp");
			
		}
		else{
			PrintWriter out = response.getWriter();
			out.println("<h2>Invalid join!!<h2>");
		}
			
	}

}
