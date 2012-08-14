<%--

	The main menu. Entry point of the whole application.
	
	@author yudy
	@author cyril

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.chinarewards.report.user.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ taglib uri="/report-tags" prefix="rp"%>
<html>
<head>
<title>主菜单</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<script>
	if (parent.document.getElementById('mainframe').cols != "20%,80%") {
		parent.document.getElementById('mainframe').cols = "20%,80%";
	}
	parent.document.getElementById('right').src = "empty.jsp";
</script>

<%
	SysUserObj user = (SysUserObj) session.getAttribute("User");

	// Note: a single page for realizing access permissions
	String accessPage = user.getLimits().getPageList().get(0);

	/**
	if ("china-rewards".equals(user)) {
		newrul = request.getContextPath() + "/generalreportmenu.jsp";

		response.sendRedirect(newrul);

		return;
	} else if ("pc".equals(user)) {
		newrul = request.getContextPath() + "/itreportmenu.jsp";

		response.sendRedirect(newrul);

		return;
		
	 **/

	if (accessPage != null) {
		String newrul = request.getContextPath() + accessPage;

		response.sendRedirect(newrul);

		return;
	} else {
%>
<center>未知用户登录</center>
<%
	}
%>
</body>
</html>