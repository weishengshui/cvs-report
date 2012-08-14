<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.coastalcity.*"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ page import="java.util.Set" %>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>
<%@ taglib uri="/report-tags" prefix="rp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Operation</title>
<link rel="stylesheet" href="<%=ctxRootPath%>/css/ui.datepicker.css"
	type="text/css" />
<script type="text/javascript"
	src="<%=ctxRootPath%>/js/jquery/jquery-latest.js"></script>
<script type="text/javascript"
	src="<%=ctxRootPath%>/js/jquery/jquery.ui.i18n.all.js"></script>
<script type="text/javascript"
	src="<%=ctxRootPath%>/js/jquery/ui.datepicker.js"></script>
<script type="text/javascript">

</script>

</head>

<frameset rows="250,*">
	<frame src="<%=ctxRootPath%>/coastalCity201207/detailCountCondition20120726.jsp">
	<frame src="<%=ctxRootPath%>/coastalCity201207/empty.jsp" name="detail">
</frameset>
<body>

</body>

</html>