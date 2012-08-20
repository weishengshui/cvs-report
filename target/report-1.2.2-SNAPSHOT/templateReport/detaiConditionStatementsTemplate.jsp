<%@page import="com.chinarewards.report.template.ReportTemplateService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.coastalcity.*"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ page import="java.util.Set"%>
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
<script type="text/javascript">
function checkBirth(date, dateMsg){
	var msg=document.getElementById(dateMsg);
	var birth =document.getElementById(date).value;
		if(birth.length==0){
			msg.innerHTML="请选择日期！";
			return false;
		}else{
	  	  	msg.innerHTML="";
			return true;
  	  	}
}

function checkDate(){
	var strStartFrom = document.getElementById("startFromDate").value;
	var strStartTo = document.getElementById("startDateTo").value;
	if(strStartFrom == null || strStartTo== null ){
		alert("请选择时间！");
		return false;
		}
	return true;
}

</script>


</head>

<body>

<%
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	String activity_id = request.getParameter("activity_id");
	ReportTemplateService service = new ReportTemplateService();
	if (startDate == null || endDate==null){
		out.println("<h2>请先输入时间区间</h2>");	
		return;
	}

	out.println("<h2>明细报表查询条件选择</h2>");
%>

<form
	action="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp"
	target="detail" method="post">
<table cellpadding="0" cellspacing="0">
	
	<tr>
		<td colspan="2">时间区间选择</td>
		<td>商户选择</td>
	</tr>

	<tr>
		<td width="280pix">&nbsp;&nbsp;&nbsp;时间从: <input
			id="startDate" name="startDate"
			value="<%=startDate == null ? "" : startDate%>" /> <span
			id="startDateMsg"></span> <script charset="utf-8">
					jQuery('#startDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
				</script></td>

		<td width="280pix">&nbsp;&nbsp;&nbsp;时间到: <input id="endDate"
			name="endDate" value="<%=endDate == null ? "" : endDate%>" />
		<span id="endDateMsg"></span> <script charset="utf-8">
					jQuery('#endDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
					</script></td>
		<td>
			<%
				Map<String,String> merchantList = service
						.getMerchantList(activity_id);
				if (merchantList == null || merchantList.size() == 0) {
					%>
					<span>没有商户</span>
					<%
					
				} else {
				%>
					<select name="shopId1">
			<option value="all" selected="selected">所有商户</option>		
				<%
					Set<String> keySet = merchantList.keySet();
					for (Iterator<String> it = keySet.iterator(); it.hasNext();) {
						String shopId = it.next();
						String shopName = merchantList.get(shopId);
			%>
			<option value="<%=shopId%>"><%=shopName%></option>
			<%
				}
						merchantList.clear();
					}
					
					%>
						</select>			
		</td>

	</tr>

	<tr align="center">
		<td colspan="3">
		<input type="hidden" name="activity_id" value="<%=activity_id %>" />
		<div align='center'><input type="submit" value="提交" /></div>
		</td>
	</tr>
</table>
</form>

</body>

</html>