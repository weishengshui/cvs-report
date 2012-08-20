<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page import="com.chinarewards.report.util.*"%>
<%@ page import="com.chinarewards.report.data.ChinaLifeService"%>
<%@ page import="com.chinarewards.report.data.crm.ConsumeData"%>
<%@ page contentType="text/html;charset=gb2312"%>
<%@include file="checklogin.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>国寿会员消费报表</title>

<style type="text/css">
.mgrp_sep {
	border-top-width: 2px;
	border-top-color: #000000;
}

.xact_blue {
	background-color: #80C0FF;
}

.xact_yellow {
	background-color: #FFFC40;
}

.xact_red {
	background-color: #FF0000;
}

/* shops which match the activity shops */
.target_shop {
	color: green;
}
</style>

</head>
<body>
<%
	int blue = 12;
	int yellow = 18;
	int red = 24;
%>
<b>标注颜色如下 </b>
<table>
	<tr>
		<td class="xact_blue">0~<%=blue%>点</td>
		<td class="xact_yellow"><%=blue%>~<%=yellow%>点</td>
		<td class="xact_red"><%=yellow%>~<%=red%>点</td>
	</tr>
</table>

<%
	String date = request.getParameter("date");
	String mid = request.getParameter("mid");

	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
%>
<%
	int i = 0;
	//商户消费总额
	try {
		ChinaLifeService service = new ChinaLifeService();

		List<ConsumeData> dataList = service.getAllConsumeData();

		out.println("<h2>国寿消费实时报表:</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>编号</td>");
		out.println("<td>卡号</td>");
		out.println("<td>消费商户</td>");
		out.println("<td>消费门市</td>");
		out.println("<td>消费类型</td>");
		out.println("<td>消费总金额</td>");
		out.println("<td>积分</td>");
		out.println("<td>交易时间</td>");
		out.println("<td>时间段</td>");
		out.println("</tr>");

		String rowCssClass = "";

		for (ConsumeData data : dataList) {

			java.util.Date d = DateUtil.getFormatDate(
					"yyyy-mm-dd hh:mm:ss", data.getTransDataStr());

			int hour = d.getHours();

			if (hour < blue && hour >= 0) {
				rowCssClass = "xact_blue";
			} else if (hour > blue && hour < yellow) {
				rowCssClass = "xact_yellow";

			} else if (hour > yellow && hour < red) {
				rowCssClass = "xact_red";
			}

			out.println("<tr>");
			out.println("<td>" + (++i) + "</td>");
			out.println("<td>" + data.getMemberCardNo() + "</td>");
			out.println("<td>" + data.getMerchantName() + "</td>");
			out.println("<td>" + data.getShopName() + "</td>");
			out.println("<td>" + data.getConsumeType() + "</td>");
			out.println("<td>" + data.getConsumeMoney() + "</td>");
			out.println("<td>" + data.getPoint() + "</td>");
			out.println("<td>" + data.getTransDataStr() + "</td>");
			out.println("<td class='" + rowCssClass + "'>&nbsp;</td>");

			out.println("</tr>");

		}
		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {

	}
%>

</body>
</html>