<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.QQVipAdidasService"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.FunctionCountVo"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.FunctionCountOfDayVo"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.PosOfCityRecord"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.PosCount"%>

<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

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



//获取当前格式化后的时间
function getNowFormatDate() {
   var day = new Date();
   var Year = 0;
   var Month = 0;
   var Day = 0;
   var CurrentDate = "";
   //初始化时间
   Year       = day.getFullYear();
   Month      = day.getMonth()+1;
   Day        = day.getDate();
  
   
   if (Month >= 10 ){
     CurrentDate += Month + "/";
   }
   else{
     CurrentDate += "0" + Month + "/";
   }
   if (Day >= 10 ){
    CurrentDate += Day + "/";
   }
   else {
    CurrentDate += "0" + Day + "/";
   }

   CurrentDate += Year ;
   return CurrentDate;
}

</script>
</head>


<body>

<%
	String strStartFrom = request.getParameter("startFromDate");
	String strStartTo = request.getParameter("startDateTo");
	if (strStartFrom == null)
		strStartFrom = "2012/05/19";

	if (strStartTo == null)
		strStartTo = "2012/06/19";
	
	out.println("<h2>总计报表</h2>");
	
%>

<form
	action="<%=ctxRootPath%>/qqvipadidas/qqvipadidascount201205.jsp?cmd=1"
	method="post">
<table cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="2">时间区间选择</td>
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
	</tr>

	<tr align="center">
		<td colspan="2">
		<div align='center'><input type="submit" value="提交" /></div>
		</td>
	</tr>
</table>
</form>




<%
	String cmd = request.getParameter("cmd");
	if (cmd == null) {
		return;
	}

	QQVipAdidasService service = new QQVipAdidasService();
	FunctionCountVo vo = service.getQQActiveMemberCount(strStartFrom,
			strStartTo);
	
	List<FunctionCountOfDayVo> fvolist = service.getQQActiveMemberCountOfDay(strStartFrom,strStartTo);

	List<PosOfCityRecord> cityReport = service.getPosOfCityReport(
			strStartFrom, strStartTo);

	int j = 1;

	//商户消费总额
	try {

		

		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>QQVIP验证码总数</td>");
		out.println("<td>已领取礼品总数</td>");
		out.println("<td>已获取优惠总数</td>");
		out.println("<td>微信签到总数</td>");
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td>" + vo.getMemberKeyCount() + "</td>");
		out.println("<td>" + vo.getGiftCount() + "</td>");
		out.println("<td>" + vo.getPrivilegeCount() + "</td>");
		out.println("<td>" + vo.getWeixinCount() + "</td>");
		out.println("</tr>");

		out.println("</table>");
		out.println("<br><br><br>");
		
		
		out.println("<h2>每日总计报表</h2>");

		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>日期</td>");
		out.println("<td>QQVIP验证码总数</td>");
		out.println("<td>已领取礼品总数</td>");
		out.println("<td>已获取优惠总数</td>");
		out.println("<td>微信签到总数</td>");
		out.println("</tr>");
		
		for(FunctionCountOfDayVo fvo:fvolist)
		{
			
			FunctionCountVo v = fvo.getFc();
			out.println("<tr>");
			out.println("<td>" + fvo.getDay() + "</td>");
			out.println("<td>" + v.getMemberKeyCount() + "</td>");
			out.println("<td>" + v.getGiftCount() + "</td>");
			out.println("<td>" + v.getPrivilegeCount() + "</td>");
			out.println("<td>" + v.getWeixinCount() + "</td>");
			out.println("</tr>");
		}


		out.println("</table>");
		out.println("<br><br><br>");
		

		out.println("<h2>商户汇总报表</h2>");

		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>商户名称</td>");
		out.println("<td>已领取礼品总数</td>");
		out.println("<td>已获取优惠总数</td>");
		out.println("<td>微信签到总数</td>");
		out.println("<td>POS机编号 | 交易类型 | 交易次数</td>");
		out.println("</tr>");
		
		PosOfCityRecord lostRecord = null;
		
		java.util.Collections.sort(cityReport);

		for (PosOfCityRecord record : cityReport) {
			if("未知".equals(record.getCityName()))
			{
				lostRecord = record;
				continue;
			}
			List<PosCount> posCountList = record.getPosCountList();
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + record.getCityName() + "</td>");
			out.println("<td>" + record.getGiftCount() + "</td>");
			out.println("<td>" + record.getPrivilegeCount() + "</td>");
			out.println("<td>" + record.getWeixinCount() + "</td>");
			out.println("<td>");
			
			if(posCountList != null)
			{
				for (PosCount posCount : posCountList) {
					out.println(posCount.getPosId()+" | " + posCount.getAType()+" | " + posCount.getCount() + " <br>");
			
				}
			}
			out.println("</td>");
			out.println("</tr>");
		}
		
		/**
		
		if(lostRecord != null)
		{
			List<PosCount> posCountList = lostRecord.getPosCountList();
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + lostRecord.getCityName() + "</td>");
			out.println("<td>" + lostRecord.getGiftCount() + "</td>");
			out.println("<td>" + lostRecord.getPrivilegeCount() + "</td>");
			out.println("<td>" + lostRecord.getWeixinCount() + "</td>");
			out.println("<td>");
			for (PosCount posCount : posCountList) {
				out.println(posCount.getPosId()+" | " + posCount.getAType()+" | " + posCount.getCount() + " <br>");
		
			}
			out.println("</td>");
			out.println("</tr>");
		}
		**/

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {
		vo = null;
	}
	
%>