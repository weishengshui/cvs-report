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
	String strStartFrom = request.getParameter("startFromDate");
	String strStartTo = request.getParameter("startDateTo");
	CoastlCityService service = new CoastlCityService();
	if (strStartFrom == null)
		strStartFrom = "2012/07/26";

	if (strStartTo == null)
		strStartTo = "2012/10/25";

	out.println("<h2>明细报表查询条件选择</h2>");
%>

<form
	action="<%=ctxRootPath%>/coastalCity201207/detailCountResult20120726.jsp"
	target="detail" method="post" onsubmit="return checkDate();">
<table cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="2">时间区间选择</td>
		<td>商户选择</td>
	</tr>

	<tr>
		<td width="280pix">&nbsp;&nbsp;&nbsp;时间从: <input
			id="startFromDate" name="startFromDate"
			value="<%=strStartFrom == null ? "" : strStartFrom%>" /> <span
			id="startDateMsg"></span> <script charset="utf-8">
					jQuery('#startFromDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
				</script></td>

		<td width="280pix">&nbsp;&nbsp;&nbsp;时间到: <input id="startDateTo"
			name="startDateTo" value="<%=strStartTo == null ? "" : strStartTo%>" />
		<span id="endDateMsg"></span> <script charset="utf-8">
					jQuery('#startDateTo').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
					</script></td>
		<td><select name="shopId1">
			<option value="all" selected="selected">所有商户</option>
			<%
				Map<List<String>, List<String>> merchantList = service
						.getMerchantList();
				if (merchantList == null || merchantList.size() == 0) {
					return;
				} else {
					Set<List<String>> keySet = merchantList.keySet();
					Object[] keys = keySet.toArray();
					for (int i = 0; i < keys.length; i++) {
						List<String> shopIds = (List<String>) keys[i];
						List<String> shopNames = (List<String>) merchantList
								.get(shopIds);
						for (int j = 0; j < shopIds.size(); j++) {
							String shopId = shopIds.get(j);
							String shopName = shopNames.get(j);
			%>
			<option value="<%=shopId%>"><%=shopName%></option>
			<%
				}

					}
					merchantList.clear();
				}
			%>
		</select></td>

	</tr>

	<tr align="center">
		<td colspan="3">
		<div align='center'><input type="submit" value="提交" /></div>
		</td>
	</tr>
</table>
</form>

</body>

</html>