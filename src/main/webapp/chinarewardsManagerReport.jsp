<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.chinarewardsmanager.ChinarewardsManagerReportService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.chinarewardsmanager.ChinarewardsManagerReportRes"%>
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
%>
<form action="<%=ctxRootPath%>/chinarewardsManagerReport.jsp?cmd=1"
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

	//out.println("get Status is "+status);

	Calendar end = new GregorianCalendar();

	ChinarewardsManagerReportService service = new ChinarewardsManagerReportService();

	ChinarewardsManagerReportRes vo = null;

	//商户消费总额
	try {
		vo = service.getChinarewardsMamagerReport(strStartFrom,
				strStartTo);
		out.println("<h2>缤纷联盟管理报表</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>缤纷联盟新增注册会员数<br>每月申请并注册激活的缤分联盟会员数量</td>");
		out.println("<td>" + vo.getNewlyRegisterMemberNum() + "</td>");
		out.println("</tr><tr>");
		out.println("<td>缤纷联盟新增发卡会员数<br>每月持有缤分联盟或缤分联盟联名卡会员数量</td>");
		out.println("<td>" + vo.getNewlyGetCardMemberNum() + "</td>");
		out.println("</tr><tr>");
		out.println("<td>缤纷联盟新增消费会员数<br>每月新增一次及一次消费以上的会员数</td>");
		out.println("<td>" +vo.getNewlyConsumeMemberNum()+ "</td>");
		out.println("</tr><tr>");
		out.println("<td>缤纷联盟新增活跃会员数<br>每月新增3次以上消费次数或跨商户消费的会员数</td>");
		out.println("<td>" + vo.getNewlyActiveMemberNum()+ "</td>");
		out.println("</tr><tr>");
		out.println("<td>缤纷联盟新增跨商户会员数<br>每月新增跨越不同商户的消费会员数</td>");
		out.println("<td>" +vo.getNewlyCrossingShopMemberNum() + "</td>");
		out.println("</tr><tr>");
		out.println("<td>缤纷联盟缤分联盟会员每天消费次数<br>当前一月内平均每天缤分联盟会员积分累积次数</td>");
		out.println("<td>" + vo.getNewlyConsumeNumEveDay()+ "</td>");
		out.println("</tr><tr>");
		out.println("<td>缤纷联盟新增获取缤分量<br>每月缤分联盟会员奖励积分赠送量，包括已到帐及未到帐积分</td>");
		out.println("<td>" +vo.getNewlyRewardsPointNum()+ "</td>");
		out.println("</tr><tr>");
		out.println("<td>缤纷联盟新增消费总金额<br>每月缤分联盟会员在商户处消费的总金额</td>");
		out.println("<td>" +vo.getNewlyConsumeMoneyNum() + "</td>");
		out.println("</tr><tr>");
		out
				.println("<td>中国人寿消费次数<br>中国人寿会员参与超级优惠活动及在缤分联盟商户消费总次数，所有当前月活动和平日消费次数总和</td>");
		out.println("<td>" + vo.getNewlyConsumeNumOfChinaLife()+ "</td>");
		out.println("</tr><tr>");
		out.println("<td>中国人寿消费会员数<br>当前月在缤分联盟消费过的会员数</td>");
		out.println("<td>" + vo.getNewlyConsumeNumOfCLMember()+ "</td>");
		out.println("</tr><tr>");
		out.println("<td>中国人寿会员获取缤分总量<br>当前月中国人寿会员在活动和平日消费中获取的积分（缤分）总和</td>");
		out.println("<td>" + vo.getNewlyTotalPointOfChinaLife() + "</td>");
		out.println("</tr><tr>");
		out.println("<td>中国人寿消费总金额<br>当前月中国人寿会员在商户处消费的总金额</td>");
		out.println("<td>" + vo.getNewlyTotalMoneyOfChinaLife() + "</td>");
		out.println("</tr><tr>");
		out
				.println("<td>深圳航空消费次数<br>当前月深航会员参与超级优惠活动及在缤分联盟商户消费总次数，所有活动和平日消费次数总和</td>");
		out.println("<td>" + vo.getNewlyConsumeNumOfSZAir() + "</td>");
		out.println("</tr><tr>");
		out.println("<td>深圳航空消费会员数<br>当前月在缤分联盟消费过的会员数</td>");
		out.println("<td>"  + vo.getNewlyConsumeMemberNumOfSZAir() + "</td>");
		out.println("</tr><tr>");
		out
				.println("<td>深圳航空会员获取缤分总量<br>当前月深航会员在缤分联盟商户消费获得的所有缤分总和，包括已到帐和未到帐</td>");
		out.println("<td>" + vo.getNewlyTotalPointOfSZAir() + "</td>");
		out.println("</tr><tr>");
		out
				.println("<td>深圳航空会员获取里程总量<br>当前月深航会员在缤分联盟商户消费获得的所有里程总和，全部为到账</td>");
		out.println("<td>" + vo.getNewlyTotalMileageOfSZAir() + "</td>");
		out.println("</tr><tr>");
		out.println("<td>深圳航空消费总金额<br>当前月深航会员在商户处消费的总金额</td>");
		out.println("<td>" + vo.getNewlyTotalMoneyOfSZAir() + "</td>");
		out.println("</tr>");

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	}
%>

</body>
</html>