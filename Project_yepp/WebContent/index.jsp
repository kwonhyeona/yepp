<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="reservation.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Yepp</title>

<!-- Bootstrap Core CSS -->
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">

<!-- Fonts -->
<link href="font-awesome/css/font-awesome.min.css" rel="stylesheet"
	type="text/css">
<link href="css/animate.css" rel="stylesheet" />
<!-- Squad theme CSS -->
<link href="css/style.css" rel="stylesheet">
<link href="color/new.css" rel="stylesheet">

</head>
<body id="page-top" data-spy="scroll" data-target=".navbar-custom">
	<%
		//서블릿 컨텍스트 생성
		ServletContext sc = getServletContext();

		String[] reserList = ReservationDButil.getCurrentReserList(sc);
		boolean[] isReserList = new boolean[reserList.length];

		for (int i = 0; i < reserList.length; i++) {
			if (reserList[i] != null)
				isReserList[i] = true;
			else
				isReserList[i] = false;
		}
	%>
	<!-- Preloader -->
	<div id="preloader">
		<div id="load"></div>
	</div>

	<nav class="navbar navbar-custom navbar-fixed-top" role="navigation">
	<div class="container">
		<div class="navbar-header page-scroll">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target=".navbar-main-collapse">
				<i class="fa fa-bars"></i>
			</button>
			<a class="navbar-brand" href="index.jsp">
				<h1>Yepp</h1>
			</a>
		</div>

		<!-- Collect the nav links, forms, and other content for toggling -->
		<div
			class="collapse navbar-collapse navbar-right navbar-main-collapse">
			<ul class="nav navbar-nav">
				<li class="active"><a href="#intro">Home</a></li>
				<li><a href="#service">Service</a></li>
				<li><a href="#about">About</a></li>
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown">Play on <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="login/login.html">Login</a></li>
						<li><a href="login/join.html">Join us</a></li>
					</ul></li>
			</ul>
		</div>
		<!-- /.navbar-collapse -->
	</div>
	<!-- /.container --> </nav>


	<!-- Section: intro -->
	<section id="intro" class="intro">

	<div class="slogan">
		<h2>
			WELCOME TO <span class="text_color"> OUR RESERVATION SITE</span>
		</h2>
		<h4>YOU CAN RESERVATE THE PC EASILY</h4>
	</div>
	<div class="page-scroll">
		<a href="#service" class="btn btn-circle"> <i
			class="fa fa-angle-double-down animated"></i>
		</a>
	</div>
	</section>

	<!-- Section: services -->
	<section id="service" class="home-section text-center bg-gray">
	<div class="heading-about">
		<div class="container">
			<div class="row">
				<div class="col-lg-8 col-lg-offset-2">
					<div class="wow bounceInDown" data-wow-delay="0.4s">
						<div class="section-heading">
							<h2>Current Reservation State</h2>
							<i class="fa fa-2x fa-angle-down"></i>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div align="center" style="margin-left: 200px; margin-right: 200px">
		<table class="table table-bordered" height="50px">
			<%
				int count = 1;
				for (int i = 0; i < 7; i++) {
			%>
			<tr align="center" valign="middle" height="75px">
				<%
					String color = null;

						for (int j = 0; j < 3; j++) {
							if (isReserList[count - 1]) {
								color = "#8E1E0C";
							} else {
								color = "#FFFFFF";
							}
				%>
				<td bgcolor="<%=color%>"><font size="4"><%=count%></font></td>
				<%
					if (count == 39)
								break;
							count++;
						}
				%>

				<td bgcolor="#ffffff"></td>
				<%
					for (int j = 3; j < 6; j++) {
							if (isReserList[count - 1]) {
								color = "#8E1E0C";
							} else {
								color = "#FFFFFF";
							}

							if (count == 39)
								break;
				%>
				<td bgcolor="<%=color%>"><font size="4"><%=count%></font></td>
				<%
					if (++count == 39)
								break;
						}
				%>
				<%
					}
				%>
			</tr>
		</table>
	</div>

	</section>
	<!-- /Section: services -->
	<!-- Section: about -->
	<section id="about" class="home-section text-center">
	<div class="heading-about">
		<div class="container">
			<div class="row">
				<div class="col-lg-8 col-lg-offset-2">
					<div class="wow bounceInDown" data-wow-delay="0.4s">
						<div class="section-heading">
							<h2>Our Team</h2>
							<i class="fa fa-2x fa-angle-down"></i>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div align="center">
		<div class="container">
			<div class="row">
				<div class="col-xs-6 col-sm-3 col-md-3">
					<div class="wow bounceInUp" data-wow-delay="0.5s">
						<div class="team boxed-grey">
							<div class="inner">
								<h5></h5>
								<p class="subtitle"></p>
								<div>
									<img src="developer/zz.png" alt=""
										class="img-responsive img-circle" />
								</div>

							</div>
						</div>
					</div>
				</div>

				<div class="col-xs-6 col-sm-3 col-md-3">
					<div class="wow bounceInUp" data-wow-delay="0.2s">
						<div class="team boxed-grey">
							<div class="inner">
								<h5>Hyeon_a</h5>
								<p class="subtitle">Web developer</p>
								<div class="avatar">
									<img src="developer/hyeona.png" alt=""
										class="img-responsive img-circle" />
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-6 col-sm-3 col-md-3">
					<div class="wow bounceInUp" data-wow-delay="0.5s">
						<div class="team boxed-grey">
							<div class="inner">
								<h5>Ji_eun</h5>
								<p class="subtitle">Web developer</p>
								<div class="avatar">
									<img src="developer/jieun.PNG" alt=""
										class="img-responsive img-circle" />
								</div>

							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-6 col-sm-3 col-md-3">
					<div class="wow bounceInUp" data-wow-delay="0.5s">
						<div class="team boxed-grey">
							<div class="inner">
								<h5></h5>
								<p class="subtitle"></p>
								<div>
									<img src="developer/zz.png" alt=""
										class="img-responsive img-circle" />
								</div>

							</div>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
	</section>
	<!-- /Section: about -->
	<footer>
	<div class="container">
		<div class="row" align="center">
			<div class="col-md-12 col-lg-12"
				style="padding-left: 300px; padding-right: 300px">
				<div class="wow shake" data-wow-delay="0.4s">
					<div class="page-scroll marginbot-30">
						<a href="#intro" id="totop" class="btn btn-circle"> <i
							class="fa fa-angle-double-up animated"></i>
						</a>
					</div>
				</div>
				<p>&copy;Copyright 2016 - Kwon Hyeon-a, Lee Ji-eun..</p>
			</div>
		</div>
	</div>
	</footer>

	<!-- Core JavaScript Files -->
	<script src="js/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/jquery.easing.min.js"></script>
	<script src="js/jquery.scrollTo.js"></script>
	<script src="js/wow.min.js"></script>
	<!-- Custom Theme JavaScript -->
	<script src="js/custom.js"></script>
</body>
</html>