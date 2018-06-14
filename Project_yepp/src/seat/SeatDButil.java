package seat;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.ServletContext;

public class SeatDButil {
	static Statement stmt = null;
	static Connection connection = null;
	
	public ArrayList<Seat> getSeatList(ServletContext sc) {
		connection = (Connection) sc.getAttribute("DBconnection");
		ArrayList<Seat> datas = new ArrayList<Seat>();

		String sql = "select * from seat order by seat_id";
		try {
			stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery(sql);

			while (rs.next()) {
				Seat seat = new Seat();
				seat.setSeat_id(rs.getInt(1));
				seat.setIs_print(rs.getString(2));
				datas.add(seat);
			}
			rs.close();

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return datas;
	}
}
