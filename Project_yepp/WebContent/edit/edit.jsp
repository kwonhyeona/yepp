<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*,login.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=session.getAttribute("user_id") + "님 정보수정"%></title>

<!-- Bootstrap Core CSS -->
<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">

<!-- Squad theme CSS -->
<link href="../css/style.css" rel="stylesheet">
<link href="../color/new.css" rel="stylesheet">

<script language="javascript">
	function isValid() {
		//passwd 유효성 검사
		if (editform.passwd.value == "" || editform.rpasswd.value == "")
			alert('패스워드를 입력해주세요')
		else if (editform.passwd.value != editform.rpasswd.value)
			alert('패스워드가 같지 않습니다.')
		else if (editform.passwd.value.length < 6)
			alert('패스워드는 6자리 이상으로 입력해주세요')
		else if (editform.passwd.value
				.match(/[a-zA-Z0-9]*[^a-zA-Z0-9\n]+[a-zA-Z0-9]*$/))
			alert("패스워드는 문자, 숫자, 특수문자의 조합으로 6~16자리로 입력해주세요.")

		else if (editform.name.value == "")
			alert('이름을 입력해주세요')
		else if (editform.birth.value == "" || editform.birth.value.length != 8)
			alert('생년월일을 올바르게 입력해주세요')
		else if (editform.phone.value == ""
				|| (editform.phone.value.length != 11))
			alert('핸드폰 번호 11자리를 입력해주세요')
		else if (editform.student_id.value == ""
				|| (editform.student_id.value.length != 8))
			alert('학번 8자리를 입력해주세요')
		else
			document.editform.submit()

	}

	function changeImage(user_id) {
		console.log("edit.jsp : changeImage 메소드 안")
		window.open("edit_image.jsp?user_id=" + user_id + "&complete=false",
				"height=10,width=20")
	}

	function editComplete() {
		location.href = 'reservation/reservation.jsp'
	}
</script>
</head>
<body>
	<%
		ServletContext sc = getServletContext();
		Connection conn = (Connection) sc.getAttribute("DBconnection");

		String passwd = "";
		String phone = "";
		int student_id = -1;

		String user_id = (String) session.getAttribute("user_id");
		if (user_id != null) {
			//등록이 아닌 경우, 출력을 위해 선택한 게시의 각 필드 내용을 저장 
			Member member = new Member();
			member = DButil.getMember(conn, user_id);

			passwd = member.getPasswd();
			phone = member.getPhone();
			student_id = member.getStudent_id();
	%>
	<div
		style="display: inline-block; position: absolute; align: center; left: 30%; right: 30%;">
		<br><H2 align="center">EDIT INFORMATION</H2>
		<HR>
		<form name=editform method=post action="../doEdit">
			<input type="hidden" name="user_id"
				value="<%=session.getAttribute("user_id")%>">
			<table class="table table-striped table-bordered table-hover">
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="passwd" size="20"
						value="<%=member.getPasswd()%>"></td>
				</tr>
				<tr>
					<td>비밀번호 확인</td>
					<td><input type="password" name="rpasswd" size="20"
						value="<%=member.getPasswd()%>"></td>
				</tr>
				<tr>
					<td>이름</td>
					<td><input type="text" name="name" size="20"></td>
				</tr>
				<tr>
					<td>생년월일<font color="red">(yyyymmdd)</font></td>
					<td><input type="text" name="birth" size="20"></td>
				</tr>
				<tr>
					<td>전화번호('-' 없이 입력해주세요.)</td>
					<td><input type="text" name="phone" size="20"
						value="<%=member.getPhone()%>"></td>
				</tr>
				<tr>
					<td>학번</td>
					<td><input type="text" name="student_id" size="20"
						value="<%=member.getStudent_id()%>"></td>
				</tr>
				<tr>
					<td rowspan="2">프로필 사진</td>
					<td><img src="../photo.jsp?" name="member_img" height="100"
						width="100" class="round" onerror="this.src='no_img.gif';"></img>
				</tr>
				<tr>
					<td><input type="button" name="edit_image" value="사진 바꾸기"
						onClick="javascript:changeImage('<%=session.getAttribute("user_id")%>')"></td>
				<tr>

					<td colspan=2 align=center><input type="hidden" name="type"
						value="edit_info"> <input type="button" value="정보수정"
						name="edit" onClick="javascript:isValid()" class="btn"> <input
						type="reset" name="reset" value="취소" onClick="history.go(-1)"
						class="btn"></td>
				</tr>
			</table>
		</form>
	</div>

	<%
		} else {
	%>
	<script>
		alert("세션이 만료되었습니다.")
	</script>
	<%
		}
	%>
</body>
</html>