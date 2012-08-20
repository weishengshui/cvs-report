<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page import="com.chinarewards.report.util.*"%>
<%@ page
	import="com.chinarewards.report.data.ConsumeDataByShopAndPosNoService"%>
<%@ page import="com.chinarewards.report.data.crm.ConsumeData"%>
<%@ page contentType="text/html;charset=gb2312"%>
<%@include file="../checklogin.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>会员消费报表</title>

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
	String[] shopIds = request.getParameterValues("shopId");
	String[] posIds = request.getParameterValues("posId");

	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
	GregorianCalendar gc = new GregorianCalendar(2011, 04, 05);
	java.sql.Date startDate = new java.sql.Date(gc.getTimeInMillis());

	GregorianCalendar gc1 = new GregorianCalendar(2011, 04, 31, 23, 59,
			59);
	gc1.set(Calendar.MILLISECOND, 999);
	java.sql.Date endDate = new java.sql.Date(gc1.getTimeInMillis());
%>
<%
	int i = 0;
	try {
		ConsumeDataByShopAndPosNoService service = new ConsumeDataByShopAndPosNoService();

		List<ConsumeData> dataList = service.getGuoshouConsumeData(
				shopIds, startDate, endDate, posIds);

		out.println("<h2>爱陶乐记录实时报表20110505－20110531:</h2>");

		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>pos编号</td>");
		out.println("<td>卡号</td>");
		out.println("<td>消费商户</td>");
		out.println("<td>消费门市</td>");
		out.println("<td>消费类型</td>");
		out.println("<td>消费总金额</td>");
		out.println("<td>积分</td>");
		out.println("<td>交易时间</td>");
		out.println("</tr>");

		for (ConsumeData data : dataList) {
			++i;
			out.println("<tr>");
			out.println("<td>" + i + "</td>");
			out.println("<td>" + data.getPosNo() + "</td>");
			out.println("<td>" + data.getMemberCardNo() + "</td>");
			out.println("<td>" + data.getMerchantName() + "</td>");
			out.println("<td>" + data.getShopName() + "</td>");
			out.println("<td>" + data.getConsumeType() + "</td>");
			out.println("<td>" + data.getConsumeMoney() + "</td>");
			out.println("<td>" + data.getPoint() + "</td>");
			out.println("<td>" + data.getTransDataStr() + "</td>");

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