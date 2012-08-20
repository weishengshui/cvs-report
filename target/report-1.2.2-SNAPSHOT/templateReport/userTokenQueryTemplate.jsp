<%@page import="com.chinarewards.report.template.ReportTemplateService"%>
<%
	//二维码使用情况查询
	//@author weishengshui
 %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.coastalcity.*"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

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
</head>


<body>
<%
	String token = request.getParameter("token");
	String activity_id = request.getParameter("activity_id");
	out.println("<h2>验证码使用查询</h2>");
%>

	<form
		action="<%=ctxRootPath%>/templateReport/userTokenQueryTemplate.jsp?cmd=1"
		method="post">
		<table cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="2" width="100">请输入验证码：</td>
				<td>
					<input type="text" name="token"/>
					<input type="hidden" name="activity_id" value="<%=activity_id %>">
				</td>
				<td><input type="submit" value="提交" /></td>
			</tr>

		</table>
		
	</form>
	<br>




	<%
		String cmd = request.getParameter("cmd");
		if (cmd == null) {
			return;
		}
		
		out.println("<br><br><br>");
		
		if(token==null || token.trim().length()==0){
			out.println("<p>请输入验证码</p>");
			return;
		}
		
		ReportTemplateService service = new ReportTemplateService();		
		List<String> aRecord  = service.getExchangeRecordByToken(token,activity_id);

		
		if(aRecord==null || aRecord.size()==0){
			out.println("<p>该验证码输入有误或尚未使用</p>");
			out.println("<br><br><br>");
			return;
		}
		try {
			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td width='100'>商家名称</td>");
			out.println("<td width='100'>POS机编号</td>");
			out.println("<td width='100'>验证码</td>");
			out.println("<td width='100'>消费金额</td>");
			out.println("<td width='120'>交易时间</td>");
			out.println("</tr>");
			out.println("<tr>");
			for(int i=0;i<aRecord.size();i++){
				if(i==aRecord.size() -1){
					out.println("<td>" + aRecord.get(i).substring(0,19) + "</td>");
				}else{
					out.println("<td>" + aRecord.get(i) + "</td>");
				}
			}
			out.println("</tr>");

			out.println("</table>");
			out.println("<br><br><br>");
		} catch (Exception e) {
			out.println(e);
		} finally {
			service = null;
			aRecord.clear();
		}

		
	%>
</body>
</html>