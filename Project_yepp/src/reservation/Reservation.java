package reservation;

public class Reservation {
	private int reser_id;
	private String user_id;
	private int seat_id;
	private String start_time;
	private String end_time;
	private String reser_date;

	public int getReser_id() {
		return reser_id;
	}

	public void setReser_id(int reser_id) {
		this.reser_id = reser_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public int getSeat_id() {
		return seat_id;
	}

	public void setSeat_id(int seat_id) {
		this.seat_id = seat_id;
	}

	public String getStart_time() {
		return start_time;
	}

	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}

	public String getEnd_time() {
		return end_time;
	}

	public void setEnd_time(String end_time) {
		this.end_time = end_time;
	}

	public String getReser_date() {
		return reser_date;
	}

	public void setReser_date(String reser_date) {
		this.reser_date = reser_date;
	}

}
