package edit;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import login.DButil;
import login.Member;

public class DButil_edit {

	static PreparedStatement pstmt = null;

	public static boolean updateDB(Connection conn, String user_id, String passwd, String name, String birth, String phone,
			int student_id) {

		String sql = "update member set passwd=?, name=?, birth=?, phone=?, student_id=? where user_id=?";

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, passwd);
			pstmt.setString(2, name);
			pstmt.setString(3, birth);
			pstmt.setString(4, phone);
			pstmt.setInt(5, student_id);
			pstmt.setString(6, user_id);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}
	
	public static boolean updateImage(Connection conn, String user_id, File image){
		String sql = "update member set image=? where user_id=?";
		System.out.println("DButil_edit.java : updateImage()안");
		try {
			System.out.println("DButil_edit.java : updateImage() try문 시작");
			Member member = DButil.getMember(conn, user_id);
			System.out.println("DBUtil_edit.java : updateImage() 안 member.getUser_id() 는 " + member.getUser_id());
			member.setImage(image);
			
			FileInputStream fin = new FileInputStream(member.getImage());
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setBinaryStream(1, fin, (int) image.length());
			pstmt.setString(2, user_id);
			pstmt.executeUpdate();
			System.out.println("DButil_edit.java : updateImage() try문 끝");
		} catch (Exception e) {
			System.out.println("DButil_edit.java : updateImage() catch문 안");
			e.printStackTrace();
			System.out.println(e.getMessage());
			return false;
		}
		
		return true;
	}

}
