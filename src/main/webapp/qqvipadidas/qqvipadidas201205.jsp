<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.QQVipAdidasService"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.QQActiveHistoryVO"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.QQActiveHistoryVOOfShop"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.QQActiveHistoryVOOfShopOfDayVo"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.QQWeiXinSignIn"%>
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

	String param = request.getParameter("param");

	if (strStartTo == null)
		strStartTo = "2012/06/19";

	if (param.equals("GIFT") || param.equals("PRIVILEGE")) {
		if (param.equals("GIFT")) {
			out.println("<h2>领取礼品报表</h2>");
			if (strStartFrom == null)
				strStartFrom = "2012/05/19";

		} else if (param.equals("PRIVILEGE")) {
			out.println("<h2>获取优惠报表</h2>");
			if (strStartFrom == null)
				strStartFrom = "2012/05/19";
		}

	} else if (param.equals("weixin")) {
		out.println("<h2>微信签到报表</h2>");
		if (strStartFrom == null)
			strStartFrom = "2012/05/19";

	} else if (param.equals("HISTORYOFDAY")) {
		out.println("<h2>每日每店报表</h2><br>");
		if (strStartFrom == null)
			strStartFrom = "2012/06/05";
	}
%>

<form
	action="<%=ctxRootPath%>/qqvipadidas/qqvipadidas201205.jsp?cmd=1&param=<%=param%>"
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

	SimpleDateFormat dateFormat = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");
	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");

	QQVipAdidasService service = new QQVipAdidasService();
	List<QQActiveHistoryVO> plist = null;
	List<QQWeiXinSignIn> wxlist = null;

	param = request.getParameter("param");
	System.out.println("qqvipadidas201205 param is " + param);

	int j = 1;

	//商户消费总额
	try {

		if (param.equals("GIFT") || param.equals("PRIVILEGE")) {

			plist = service.getQQActiveHistoryList(param, strStartFrom,
					strStartTo);

			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td>序号</td>");
			out.println("<td>商户名称</td>");
			out.println("<td>POS机编号</td>");
			out.println("<td>验证码CDKEY</td>");
			out.println("<td>消费金额</td>");
			out.println("<td>获取返点</td>");
			out.println("<td>交易时间</td>");
			out.println("</tr>");

			for (int i = 0; i < plist.size(); i++) {
				QQActiveHistoryVO vo = plist.get(i);
				out.println("<tr>");
				out.println("<td>" + (j++) + "</td>");
				out.println("<td>" + vo.getMerchantName() + "</td>");
				out.println("<td>" + vo.getPosId() + "</td>");
				out.println("<td>" + vo.getMemberkey() + "</td>");
				out.println("<td>"
						+ moneyFormat.format(vo.getConsumeAmt())
						+ "</td>");
				out.println("<td>"
						+ moneyFormat.format(vo.getRebateAmt())
						+ "</td>");
				out.println("<td>" + vo.getTime() + "</td>");

				out.println("</tr>");
			}

			out.println("</table>");

		} else if (param.equals("weixin")) {

			wxlist = service
					.getQQWeiXinSignIn(strStartFrom, strStartTo);

			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td>序号</td>");
			out.println("<td>POS机编号</td>");
			out.println("<td>微信号</td>");
			out.println("<td>签到时间</td>");
			out.println("</tr>");

			for (int i = 0; i < wxlist.size(); i++) {
				QQWeiXinSignIn vo = wxlist.get(i);
				out.println("<tr>");
				out.println("<td>" + (j++) + "</td>");
				out.println("<td>" + vo.getPosId() + "</td>");
				out.println("<td>" + vo.getWeixinNo() + "</td>");

				out.println("<td>" + vo.getTime() + "</td>");

				out.println("</tr>");
			}
			out.println("</table>");
		} else if (param.equals("HISTORYOFDAY")) {

			List<QQActiveHistoryVOOfShopOfDayVo> daylist = service
					.getQQActiveHistoryListOfShopOfDay(strStartFrom,
							strStartTo);
			if(daylist.isEmpty())
			{
				return;
			}
			for (QQActiveHistoryVOOfShopOfDayVo vo : daylist) {
				out.print("<h3>");
				out.print(vo.getDay());
				out.println(":</h3>");

				List<QQActiveHistoryVOOfShop> shoplist = vo
						.getListOfday();
				java.util.Collections.sort(shoplist);

				out.println("<table border='1'>");

				out.println("<tr>");
				out.println("<td>商户名称</td>");
				out.println("<td>POS机编号</td>");
				out.println("<td>验证码CDKEY</td>");
				out.println("<td>消费金额</td>");
				out.println("<td>获取返点</td>");
				out.println("<td>交易时间</td>");
				out.println("</tr>");

				for (QQActiveHistoryVOOfShop voshop : shoplist) {
					out.println("<tr>");
					out
							.println("<td>" + voshop.getShopName()
									+ "</td>");

					//print posid list
					out.println("<td><table border='0'>");
					List<QQActiveHistoryVO> volist = voshop.getVoList();

					for (QQActiveHistoryVO hvo : volist) {

						out.println("<tr><td>" + hvo.getPosId()
								+ "</td></tr>");

					}
					out.println("</table></td>");

					//print cdkey list
					out.println("<td><table border='0'>");

					for (QQActiveHistoryVO hvo : volist) {

						out.println("<tr><td>" + hvo.getMemberkey()
								+ "</td></tr>");

					}
					out.println("</table></td>");

					//print consume money list
					out.println("<td><table border='0'>");

					for (QQActiveHistoryVO hvo : volist) {

						out.println("<tr><td>"
								+ moneyFormat.format(hvo
										.getConsumeAmt())
								+ "</td></tr>");

					}
					out.println("</table></td>");

					//print rebate money list
					out.println("<td><table border='0'>");

					for (QQActiveHistoryVO hvo : volist) {

						out.println("<tr><td>"
								+ moneyFormat
										.format(hvo.getRebateAmt())
								+ "</td></tr>");

					}
					out.println("</table></td>");

					//print time list
					out.println("<td><table border='0'>");

					for (QQActiveHistoryVO hvo : volist) {

						out.println("<tr><td>" + hvo.getTime()
								+ "</td></tr>");

					}
					out.println("</table></td>");

					out.println("</tr>");
				}

				out.println("</table>");

			}
		}

	} catch (Exception e) {
		out.println(e.getMessage());
	} finally {
		plist = null;
		wxlist = null;
	}
%>