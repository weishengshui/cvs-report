<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.net.*"%>
<%@ page import="org.slf4j.*"%>
<%@ page import="com.chinarewards.authserver.client.*"%>
<%@ page import="com.chinarewards.authserver.exception.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%
	Logger logger = LoggerFactory.getLogger(getClass());

	// get the return URL from request parameter
	String returnUrl = request.getParameter("returnUrl");
	if (returnUrl != null) {
		returnUrl = URLDecoder.decode(returnUrl, "UTF-8");
	}
%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>
<html>
<head>
<title>Welcome to China Rewards Report Application</title>
<%@ include file="/include/stdhtmlhead.inc.jsp"%>
<style type="text/css">
#centerpoint {
	top: 50%;
	left: 50%;
	position: absolute;
}

#dialog {
	position:absolute ;
	width: 600px;
	margin-left: -300px;
	height: 400px;
	margin-top: -100px;
}
</style>
<script language="JavaScript"> 
if (window != top) 
top.location.href = location.href; 
</script> 
</head>

<body>


<div id="centerpoint">
<div id="dialog">
<center>
<h2>Welcome to China Rewards Report Application</h2>
<form action="login.jsp?cmd=1" method="POST">
<table>
	<tr>
		<td style="text-align: right">Login Name:</td>
		<td><input type="text" name="Name"></td>
	</tr>
	<tr>
		<td style="text-align: right">Login Password:</td>
		<td><input type="password" name="Password"></td>
	</tr>
	<tr>
		<td colspan="2" style="text-align: center"><input type="submit"
			value="OK"><br />
		</td>
	</tr>
</table>
<input type="hidden" name="returnUrl"
	value="<%if (returnUrl != null)
				out.print(returnUrl);%>" /></form>
</center>
</div>
</div>
<%
	//first enter this page
	String cmd = request.getParameter("cmd");
	if(cmd==null){
		return;
	}
	// check if the password is correct.
	if (request.getParameter("Name") != null
			&& request.getParameter("Password") != null) {

		String name = request.getParameter("Name");
		String password = request.getParameter("Password");

		logger.info("!Login attempt detected. Username={}, IP={}",
				new String[] { name, request.getRemoteAddr() });

		SysUsers sysUsers = SysUsers.getInstance();

		try {
			SysUserObj user = sysUsers.chickingUser(name, password);

			session.setAttribute("Login", "OK"); // set to logged in.
			session.setAttribute("User", user);
			
			response.sendRedirect(request.getContextPath()+ "/index.html");
			

		} catch (InvalidUserException e) {
			out.println("登录错误，请输入正确名称<br><br>");
		}

	}
%>
</body>
</html>