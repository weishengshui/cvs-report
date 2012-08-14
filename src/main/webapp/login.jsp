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
</head>

<body>

<script>
	if (parent.document.getElementById('mainframe').cols != "20%,80%") {
		parent.document.getElementById('mainframe').cols = "20%,80%";
	}
	parent.document.getElementById('right').src = "empty.jsp";
</script>
<%
	// check if the password is correct.
	if (request.getParameter("Name") != null
			&& request.getParameter("Password") != null) {

		String name = request.getParameter("Name");
		String password = request.getParameter("Password");

		logger.info("!Login attempt detected. Username={}, IP={}",
				new String[] { name, request.getRemoteAddr() });

		// login using authentication client
		/*
		AuthServiceProvider asp = null;
		try {
			
			asp = new AuthServiceProvider();
			asp.authenticate(name, password);
			
			logger.info("User {} logged in from ", new String[] {
					name, request.getRemoteAddr()
			});
			
		} catch (AuthenticateUserIsNotExistsException e) {
			logger.debug("User {} not found", name);
		} catch (AuthenticatePasswordErrorException e) {
			logger.debug("Password for user {} not correct", name);
		} catch (AccessLockedException e) {
			logger.debug("User {} is locked from access", name);
		} catch (IllegalStateException e) {
			logger.debug("User {} illegal state", name);
		} catch (Throwable e) {
			logger.error("Unknown error during login", e);
		} finally {
			if (asp != null) {
				asp.destroy();
			}
		}
		 */

		SysUsers sysUsers = SysUsers.getInstance();

		try {
			SysUserObj user = sysUsers.chickingUser(name, password);

			session.setAttribute("Login", "OK"); // set to logged in.
			session.setAttribute("User", user);

			// determine the next URL to visit.
			String url = request.getContextPath() + "/index.jsp";

			//if (returnUrl != null) {
			//	url = returnUrl;
			//}

			response.sendRedirect(url);
		} catch (InvalidUserException e) {
			out.println("登录错误，请输入正确名称</br></br>");
		}

		/**
		 // the hard-coded password.
		 if (name.equals("china-rewards") && password.equals("123456")) {
		 // ok, redirect to index.
		 session.setAttribute("Login", "OK"); // set to logged in.
		 session.setAttribute("User", name);

		 // determine the next URL to visit.
		 String url = request.getContextPath() + "/index.jsp";

		 //if (returnUrl != null) {
		 //	url = returnUrl;
		 //}

		 response.sendRedirect(url);
		 return;

		 } else if (name.equals("pc") && password.equals("123456")) {
		 // ok, redirect to index.
		 session.setAttribute("Login", "OK"); // set to logged in.
		 session.setAttribute("User", name);

		 // determine the next URL to visit.
		 String url = request.getContextPath() + "/index.jsp";
		 //if (returnUrl != null) {
		 //	url = returnUrl;
		 //}

		 response.sendRedirect(url);
		 return;

		 } else {
		 out.println("登录错误，请输入正确名称</br></br>");
		 }
		 **/
	}
%>
<div id="centerpoint">
<div id="dialog">
<center>
<h2>Welcome to China Rewards Report Application</h2>
<script>
	if (parent.document.getElementById('mainframe').cols != "100%,0%") {
		parent.document.getElementById('mainframe').cols = "100%,0%";

	}
</script>
<form action="login.jsp" method="POST">
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
</body>
</html>