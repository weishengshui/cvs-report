<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.data.QQService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.MemberShipInfo"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	String memberId = request.getParameter("memberId");
	QQService service = new QQService();
	List<MemberShipInfo> list = service
			.getCardInfoListOfMember(memberId);

	int j = 1;

	//商户消费总额
	try {

		out
				.println("<a href= 'javascript:history.go(-1) '> 返回 </a><br/>");

		out.println("<h2>会员卡信息</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>卡号</td>");
		out.println("<td>卡名称</td>");
		out.println("<td>注册时间</td>");
		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			MemberShipInfo vo = list.get(i);
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + vo.getMemberCardNo() + "</td>");
			out.println("<td>" + vo.getCardName() + "</td>");
			out.println("<td>" + vo.getStartDate() + "</td>");
			out.println("</tr>");
		}

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {

		list = null;
	}
%>
