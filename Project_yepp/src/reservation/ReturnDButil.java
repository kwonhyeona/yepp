package reservation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;


public class ReturnDButil {
	//static ArrayList<Reservation> datas = new ArrayList<Reservation>();

	public static ArrayList<Returnlist> getSeatList(Connection con, String user_id) {
		ArrayList<Returnlist> list = null;
		String sql = "SELECT seat_id, reser_id, reser_date, start_time ,end_time FROM reservation WHERE user_id=?";

		PreparedStatement pstmt;
		try {

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, user_id);

			ResultSet rs = pstmt.executeQuery();
			list = new ArrayList<Returnlist>();
			
			while (rs.next()) {
				Returnlist reser = new Returnlist();
				reser.setReser_id(rs.getInt("reser_id"));
				reser.setReser_date(rs.getString("reser_date"));
				reser.setStart_time(rs.getString("start_time"));
				reser.setEnd_time(rs.getString("end_time"));
				reser.setSeat_id(rs.getInt("seat_id"));
				list.add(reser);

			}
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return list;
	}
	
	public static boolean deleteReservation(Connection con, int reser_id) {

		String sql = "delete from reservation where reser_id=?";

		PreparedStatement pstmt;
		try {

			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, reser_id);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	

}
