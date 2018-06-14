package login;

import java.io.FileInputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletContext;

import reservation.Reservation;
import reservation.ReservationDButil;

public class DButil {
	static Statement stmt = null;
	static PreparedStatement pstmt = null;
	static Connection connection = null;

	public DButil() {
		// TODO Auto-generated constructor stub
	}
	

	public static String findUser(ServletContext sc, String user_id) {
		connection = (Connection) sc.getAttribute("DBconnection");
		String sqlSt = "SELECT passwd FROM member WHERE user_id=?";
		String dbPasswd = null;

		try {
			pstmt = connection.prepareStatement(sqlSt);
			pstmt.setString(1, user_id);
			pstmt.executeQuery();

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) { 
				//user_id가 DB에 존재한다면,
				dbPasswd = rs.getString("passwd");
			} else{
				//user_id가 DB에 존재하지 않는다면, 
				return "*";
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}
		return dbPasswd;
	}

	public static boolean insertDB(ServletContext sc, Member member) {
		connection = (Connection) sc.getAttribute("DBconnection");
		
		String sql = "insert into member(user_id, passwd, name, birth, phone, student_id, sex, image) values(?,?,?,?,?,?,?,?)";

		try {
			FileInputStream fin = new FileInputStream(member.getImage());
			pstmt = connection.prepareStatement(sql);
			pstmt.setString(1, member.getUser_id());
			pstmt.setString(2, member.getPasswd());
			pstmt.setString(3, member.getName());
			pstmt.setString(4, member.getBirth());
			pstmt.setString(5, member.getPhone());
			pstmt.setInt(6, member.getStudent_id());
			pstmt.setString(7, member.getSex());
			pstmt.setBinaryStream(8, fin, (int) member.getImage().length());
			pstmt.executeUpdate();

			System.out.println("db insert 성공");
		} catch (Exception e) {
			System.out.println("DButil.java : insertDB() - db insert 실패 ");
			e.printStackTrace();
			System.out.println(e.getMessage());
			return false;
		}

		return true;
	}

	// ID 중복체크
	public static boolean checkID(ServletContext sc, String user_id) {
		connection = (Connection) sc.getAttribute("DBconnection");
		
		Boolean check = null;
		String sql = "select user_id from member where user_id=?";

		try {
			pstmt = connection.prepareStatement(sql);
			pstmt.setString(1, user_id);
			ResultSet rs = pstmt.executeQuery();

			if (!rs.next())
				// ID 사용가능
				check = true;
			else
				// ID 사용불가
				check = false;

			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return check;
	}

	public static byte[] getImg(ServletContext sc, String user_id) {
		connection = (Connection) sc.getAttribute("DBconnection");

		String sql = "select image from member where user_id=?";

		Blob img = null;
		byte[] imgData = null;

		try {
			pstmt = connection.prepareStatement(sql);
			pstmt.setString(1, user_id);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				img = rs.getBlob(1);
				imgData = img.getBytes(1, (int) img.length());

			} else {
				System.out.println("이미지를 불러올 수 없습니다.");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return imgData;
	}

	// 이미지 제외한 회원 정보 가져오기
	public static Member getMember(Connection con, String user_id) {
		Member member = new Member();
		String sql = "select * from member where user_id=?";

		try {
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, user_id);
			ResultSet rs = pstmt.executeQuery();

			rs.next();

			member.setUser_id(rs.getString("user_id"));
			member.setPasswd(rs.getString("passwd"));
			member.setName(rs.getString("name"));
			member.setBirth(rs.getString("birth"));
			member.setPhone(rs.getString("phone"));
			member.setStudent_id(rs.getInt("student_id"));
			member.setSex(rs.getString("sex"));
			member.setImage(null);

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return member;
	}

	public static String getID(ServletContext sc, String name, int student_id, String phone) {
		connection = (Connection) sc.getAttribute("DBconnection");
		
		String sql = "select user_id from member where name=? and student_id=? and phone=?";
		String user_id = null;
		try {
			pstmt = connection.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setInt(2, student_id);
			pstmt.setString(3, phone);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				user_id = rs.getString(1);
				System.out.println(user_id);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return user_id;
	}

	public static boolean setPW(ServletContext sc, String user_id, String newPasswd) {
		connection = (Connection) sc.getAttribute("DBconnection");
		
		String sql = "update member set passwd=? where user_id=?";
		try {
			pstmt = connection.prepareStatement(sql);
			pstmt.setString(1, newPasswd);
			pstmt.setString(2, user_id);

			pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}
	
	public static boolean deleteOldRecord(ServletContext sc, String todayDate){
		connection = (Connection) sc.getAttribute("DBconnection");
		String sql = "delete from reservation where reser_id=?";
		
		SimpleDateFormat format = new SimpleDateFormat("MM-dd");
		ArrayList<Reservation> list = new ArrayList<Reservation>();
		
		list = ReservationDButil.getReserList(sc);
		System.out.println(list.size());
		Date dbday = null;
		Date today = null;
		
		for(Reservation reservation : list){
			try {
				System.out.println("for 문");
				//Date타입으로 바꾸기
				dbday = format.parse(reservation.getReser_date());
				today = format.parse(todayDate);				
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
			
			int compare = dbday.compareTo(today);
			if(compare < 0){
				//날짜 지난 경우
				try {
					pstmt = connection.prepareStatement(sql);
					pstmt.setInt(1, reservation.getReser_id());
					System.out.println(dbday + "\n" + today);
					pstmt.executeUpdate();

				} catch (SQLException e) {
					e.printStackTrace();
					return false;
				}
				
				
			}
		}
		return true;
		
	}

}
