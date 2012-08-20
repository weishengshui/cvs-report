<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.superpri.SuperPriDateService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.superpri.DateOFWeekRange"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	Calendar start = new GregorianCalendar();
	start.set(2010, 11, 14);

	Calendar end = new GregorianCalendar();

	SuperPriDateService service = new SuperPriDateService();

	List<DateOFWeekRange> list = null;

	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

	int j = 1;

	//商户消费总额
	try {

		list = service.getDateOFWeekRangeOfYearBetween(start, end);

		out.println("<h2>超级优惠周信息报表</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>年</td>");
		out.println("<td>周</td>");
		out.println("<td>开始时间</td>");
		out.println("<td>结束时间</td>");
		out.println("<td>总消费次数</td>");
		out.println("<td>参与会员数</td>");
		out.println("<td>已付款总消费次数</td>");
		out.println("<td>已付款参与会员数</td>");
		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			DateOFWeekRange vo = list.get(i);
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + vo.getYear() + "</td>");
			out.println("<td>" + vo.getWeekOfYear() + "</td>");
			out.println("<td>"
					+ format.format(vo.getFromday().getTime())
					+ "</td>");
			out.println("<td>" + format.format(vo.getToday().getTime())
					+ "</td>");
			out.println("<td>" + vo.getDegreeCount() + "</td>");
			out.println("<td>" + vo.getMemberCount() + "</td>");
			out.println("<td>" + vo.getPaidedDegreeCount() + "</td>");
			out.println("<td>" + vo.getPaidedMemberCount() + "</td>");
			out.println("</tr>");
		}

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {
		list = null;
	}
%>