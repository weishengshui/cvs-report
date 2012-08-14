<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.net.*" %>
<%@ page language="java" import="com.chinarewards.report.http.util.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<%

// get the return URL from request parameter
String returnUrl = request.getParameter("returnUrl");

/**
if (returnUrl != null) {
	returnUrl = URLDecoder.decode(returnUrl, "UTF-8");
}
**/

// absolute login URL
String loginUrl = ServletUtil.getDomainUrl(request) + request.getContextPath() + "/login.jsp";

/**
if (returnUrl != null) {
	loginUrl += "?returnUrl=" + URLEncoder.encode(returnUrl, "UTF-8");
}
**/

// timeout
int timeout = 3;

%>

<html>
<head>
<title>Session Expired</title>
<meta http-equiv="refresh" content="<%=timeout%>;url=<%=loginUrl%>">
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>

<body>
<script>
if(parent.document.getElementById('mainframe').cols!="100%,0%")
{
  parent.document.getElementById('mainframe').cols="100%,0%";
}
</script>
Please login first!
<br/><br/>
You will be redirected to the login page in <%=timeout%> seconds or click <a href="<%=loginUrl%>">here</a>.
</body>

</html>