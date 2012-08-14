<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.OnceConsumeShopService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.posapp.OnceConsumeShopReportVO"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	OnceConsumeShopService service = new OnceConsumeShopService();
	List<OnceConsumeShopReportVO> list = service
			.getOnceConsumeShopReportList();

	//商户消费总额
	try {

		out.println("<h2>2个月内交易只有1-10笔的商户的最后一次会员的消费记录报表</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>消费门市名称</td>");
		out.println("<td>门市地址</td>");
		out.println("<td>门市2月内消费次数</td>");
		out.println("<td>会员卡号</td>");
		out.println("<td>会员手机号</td>");
		out.println("<td>会员姓名</td>");
		out.println("<td>消费金额</td>");
		out.println("<td>积分</td>");
		out.println("<td>时间</td>");
		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			OnceConsumeShopReportVO vo = list.get(i);
			out.println("<tr>");
			out.println("<td>" + vo.getShopName() + "</td>");
			out.println("<td>" + vo.getShopAddress() + "</td>");
			out.println("<td>" + vo.getConsumeNum() + "</td>");
			out.println("<td>" + vo.getMemberCardNo() + "</td>");
			out.println("<td>" + vo.getMemberMobile() + "</td>");
			out.println("<td>" + vo.getMemberName() + "</td>");
			out.println("<td>" + vo.getConsumeMoney() + "</td>");
			out.println("<td>" + vo.getPoint() + "</td>");
			out.println("<td>" + vo.getDate() + "</td>");
			out.println("</tr>");
		}

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {

		list = null;
	}
%>

