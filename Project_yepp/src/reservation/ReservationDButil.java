package reservation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

import javax.servlet.ServletContext;

public class ReservationDButil {
	static Statement stmt = null;
	static PreparedStatement pstmt = null;

	// 이미 예약된 좌석인지 아닌지 check해주는 함수 예약가능하면 true, 불가능하면 false를 반환
	public static boolean CheckReserOKTime(Connection con, int Seat_id, String Reser_date, String start_time,
			String end_time) {
		String sql = "select start_time, end_time from reservation " + "where seat_id =?" + " and reser_date=?";

		// 사용자가 예약할 시작시간을 가져와 String형으로 변환후 비교를 위해 다시 double형으로 변환한다.
		double startTime = Double.parseDouble(start_time.substring(0, 2));

		// 예약할 시간이 (" " : 00) 인지 (" " : 30) 인지 확인해 (" " : 30)이면
		// startTime 에0.5를 더해준다.
		if (start_time.substring(3, 4).equals("3")) {
			startTime = startTime + 0.5;
		}
		
		double endTime = Double.parseDouble(end_time.substring(0, 2));
		if (end_time.substring(3, 4).equals("3")) {
			endTime = endTime + 0.5;
		}
		System.out.println("ReservationDButil.java : double_reser_end_time" + endTime);
		ArrayList<CheckTime> datas = new ArrayList<CheckTime>();

		try {
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Seat_id);
			pstmt.setString(2, Reser_date);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				CheckTime check = new CheckTime();
				check.setStart_time(rs.getString("start_time"));
				check.setEnd_time(rs.getString("end_time"));
				datas.add(check);
			}
			rs.close();

		} catch (Exception e) {
			System.out.println("reservationDButil.java : db조회 실패");
			e.printStackTrace();
			return false;
		}

		for (CheckTime reser_check : datas) {

			// DB에서 start_time과 end_time들을 가져와 비교해 주기 위해서
			// Substring함수를 이용해서 Sting으로 변환온 후 비교를 위해 double형으로 한번더 변환
			double double_start_time = Double.parseDouble(reser_check.getStart_time().substring(0, 2));

			// 예약시작시간이 (" ":30)인지 (" " :00) 인지 체크해주고 (" ":30)이면 0.5를 더해준다.
			if (reser_check.getStart_time().substring(3, 4).equals("3")) {
				double_start_time = double_start_time + 0.5;
			}

			System.out.println("ReservationDButil.java :" + double_start_time);

			double double_end_time = Double.parseDouble(reser_check.getEnd_time().substring(0, 2));

			// 예약 종료시간이 (" ":30)인지 (" " :00) 인지 체크해주고 (" ":30)이면 0.5를 더해준다.
			if (reser_check.getEnd_time().substring(3, 4).equals("3")) {
				double_end_time = double_end_time + 0.5;
			}
			System.out.println("ReservationDButil.java :" + double_end_time);

			// 각각 비교한 값을 result변수에 저장
			int result1 = Double.compare(double_start_time, startTime);
			int result2 = Double.compare(double_end_time, startTime);
			int result3 = Double.compare(double_start_time, endTime);
			int result4 = Double.compare(double_end_time, endTime);
			System.out.println("ReservationDButil.java result1 :" + result1);
			System.out.println("ReservationDButil.java result2 :" + result2);
			System.out.println("ReservationDButil.java result3 :" + result3);
			System.out.println("ReservationDButil.java result4 :" + result4);

			// 예약할 예약시작시간이 이미예약된 예약시작시간보다 같거나 느리고(비교값이 같거나 작고 ) 예약된 예약종료시간보다 작을
			// 때 (비교값이 클때)
			// 예약 불가능 한 시간임으로 false return
			if (result1 != 1 && result2 == 1) {
				return false;
			}
			// 예약할 예약종료시간이 이미 예약된 예약시작시간보다 늦거나 (비교값이 크고) 예약된 예약종료시간보다 같거나
			// 빠를때(비교값이 같거나 작을 때)
			// 예약 불가능 한 시간임으로 false return
			if (result3 == -1 && result4 != -1) {
				return false;
			}

		}

		return true;
	}

	public static ArrayList<String[]> mySeatList(ServletContext sc, String user_id) {
		Connection conn = (Connection) sc.getAttribute("DBconnection");
		ArrayList<String[]> list = new ArrayList<String[]>();

		String sql = "select seat_id, reser_date, start_time, end_time from reservation where user_id=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);

			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				String[] reservation = new String[4];
				reservation[0] = "" + rs.getInt("seat_id");
				reservation[1] = rs.getString("reser_date");
				reservation[2] = rs.getString("start_time");
				reservation[3] = rs.getString("end_time");

				list.add(reservation);

			}

			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public static boolean insertReserDB(Connection con, Reservation reservation) {
		String sql = "insert into reservation(user_id, seat_id, start_time, end_time, reser_date) values(?,?,?,?,?)";
		PreparedStatement pstmt;

		try {

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, reservation.getUser_id());
			pstmt.setInt(2, reservation.getSeat_id());
			pstmt.setString(3, reservation.getStart_time());
			pstmt.setString(4, reservation.getEnd_time());
			pstmt.setString(5, reservation.getReser_date());
			pstmt.executeUpdate();
			System.out.println("reservationDButil.java : db insert 성공");
		} catch (Exception e) {
			System.out.println("reservationDButil.java :db insert 실패 ");
			e.printStackTrace();
			System.out.println(e.getMessage());
			return false;
		}

		return true;
	}

	public static ArrayList<Reservation> getReserList(ServletContext sc) {
		Connection conn = (Connection) sc.getAttribute("DBconnection");
		ArrayList<Reservation> list = new ArrayList<Reservation>();

		String sql = "select * from reservation";
		try {
			stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(sql);

			while (rs.next()) {
				Reservation reservation = new Reservation();
				reservation.setReser_id(rs.getInt("reser_id"));
				reservation.setUser_id(rs.getString("user_id"));
				reservation.setSeat_id(rs.getInt("seat_id"));
				reservation.setStart_time(rs.getString("start_time"));
				reservation.setEnd_time(rs.getString("end_time"));
				reservation.setReser_date(rs.getString("reser_date"));

				list.add(reservation);

			}

			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public static String[] getCurrentReserList(ServletContext sc) throws ParseException {
		Connection conn = (Connection) sc.getAttribute("DBconnection");
		String[] list = new String[39];
		Arrays.fill(list, null);

		SimpleDateFormat format1 = new SimpleDateFormat("kk:mm");
		SimpleDateFormat format2 = new SimpleDateFormat("MM-dd");
		
		Date currentTime = format1.parse(format1.format(new Date()));
		String today = format2.format(new Date());
		
		String sql = "select seat_id, start_time, end_time from reservation where reser_date='" + today + "'";
		try {
			stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			Date dbStartTime = null, dbEndTime = null;
			
			while (rs.next()) {
				
				dbStartTime = format1.parse(rs.getString("start_time"));
				dbEndTime = format1.parse(rs.getString("end_time"));

				if (dbStartTime.compareTo(currentTime) < 0 && currentTime.compareTo(dbEndTime) < 0)
					list[rs.getInt("seat_id") - 1] = "" + rs.getInt("seat_id");
				
				
			}

			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public static boolean[] getReserList(ServletContext sc, int seat_id, String reser_date) {
		Connection connection = (Connection) sc.getAttribute("DBconnection");

		boolean[] reserList = new boolean[26];
		Arrays.fill(reserList, false);

		String sql = "select start_time, end_time from reservation where seat_id =? and reser_date=?";

		ArrayList<CheckTime> datas = new ArrayList<CheckTime>();

		try {
			pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, seat_id);
			pstmt.setString(2, reser_date);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				CheckTime check = new CheckTime();
				check.setStart_time(rs.getString("start_time"));
				check.setEnd_time(rs.getString("end_time"));
				datas.add(check);
			}
			rs.close();

		} catch (Exception e) {
			System.out.println("reservationDButil.java : db list조회 실패");
			e.printStackTrace();

		}

		for (CheckTime reser_check : datas) {

			// Substring함수를 이용해서 Sting으로 변환후 int형으로 변환
			int startTime = Integer.parseInt(reser_check.getStart_time().substring(0, 2));

			startTime = (startTime - 9) * 2;
			// 예약된 예약시작시간이 (" ":30)인지 (" " :00) 인지 체크해주고 (" ":30)이면 1를 더해준다.
			if (reser_check.getStart_time().substring(3, 4).equals("3")) {
				startTime = startTime + 1;
			}


			// Substring함수를 이용해서 Sting으로 변환후 int형으로 변환
			int endTime = Integer.parseInt(reser_check.getEnd_time().substring(0, 2));
			endTime = ((endTime - 9) * 2) - 1;
			// 예약된 예약 종료시간이 (" ":30)인지 (" " :00) 인지 체크해주고 (" ":30)이면 1를 더해준다.

			if (reser_check.getEnd_time().substring(3, 4).equals("3")) {
				endTime = endTime + 1;
			}

			// ReserList의 int_start_time부터 int_end_time 까지 값을 true로 변경
			for (int i = startTime; i <= endTime; i++) {
				reserList[i] = true;
			}
		}
		return reserList;
	}

}