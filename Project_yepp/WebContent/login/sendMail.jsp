<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Address"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="login.SMTPAuthenticatior"%>
<%@page import="login.RandomAuthNumber"%>
<%@page import="javax.mail.Authenticator"%>
<%@page import="java.util.Properties"%>
<%@page import="login.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	//서블릿 컨텍스트 생성
	ServletContext sc = getServletContext();

	String to = (String) request.getParameter("user_id");
	RandomAuthNumber newPasswd = null;

	boolean isMember = DButil.checkID(sc, to);

	if (!isMember) {
		//DB에 user_id 존재한다면,

		newPasswd = new RandomAuthNumber();
		boolean isChangePw = DButil.setPW(sc, to, "" + newPasswd.getRandomAuthNum());
		if (isChangePw) {
			//비밀번호 변경이 완료되었다면, 
			System.out.println("sendMail.jsp : to메일은 " + to);
			System.out.println("sendMail.jsp : newPasswd은 " + newPasswd);

			Properties p = new Properties(); // 정보를 담을 객체

			p.put("mail.smtp.host", "smtp.gmail.com"); // gmail SMTP

			p.put("mail.smtp.port", "465");
			p.put("mail.smtp.starttls.enable", "true");
			p.put("mail.smtp.auth", "true");
			p.put("mail.smtp.debug", "true");
			p.put("mail.smtp.socketFactory.port", "465");
			p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			p.put("mail.smtp.socketFactory.fallback", "false");
			// SMTP 서버에 접속하기 위한 정보들

			try {
				Authenticator auth = new SMTPAuthenticatior();
				Session ses = Session.getInstance(p, auth);

				ses.setDebug(true);

				MimeMessage msg = new MimeMessage(ses); // 메일의 내용을 담을 객체
				msg.setSubject("yepp의 임시 비밀번호입니다"); // 제목

				Address fromAddr = new InternetAddress("gusdk7656812@gmail.com");
				msg.setFrom(fromAddr); // 보내는 사람

				Address toAddr = new InternetAddress(to);
				msg.addRecipient(Message.RecipientType.TO, toAddr); // 받는 사람

				msg.setContent("" + newPasswd.getRandomAuthNum(), "text/html;charset=UTF-8"); // 내용과 인코딩

				Transport.send(msg); // 전송
			} catch (Exception e) {
				e.printStackTrace();
				out.println("<script>alert('Send Mail Failed..');history.back();</script>");
				// 오류 발생시 뒤로 돌아가도록
				return;
			}
%>

<script>
	//성공 시
	alert('메일로 새로운 비밀번호를 보냈습니다. 확인하시고 다시 로그인 해주세요.');
	location.href = 'login.html';
</script>

<%
	} else {
			System.out.println("비밀번호 자동변경 실패");
		}
	} else {
%>
<script type="text/javascript">
	alert('아이디를 잘못 입력하셨습니다.');
	history.go(-1);
</script>
<%
	return;
	}
%>