<%--

	Logout page.
	
	@author cyril
	@since 2010-01-13

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp" %>
<%

	session.invalidate();
	response.sendRedirect(request.getContextPath()+ "/login.jsp");

%>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<html>
<head>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
<title>Logout</title>
</head>

<body>
<script>
if(parent.document.getElementById('mainframe').cols!="100%,0%")
{
  parent.document.getElementById('mainframe').cols="100%,0%";
}
</script>
Go back to the <a href="<%=request.getContextPath() %>/login.jsp">login</a> page.
</body>
</html>