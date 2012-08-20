<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.member.MemberLoginRepairService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.auth.AuthUserInfo"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	int j = 1;

	//商户消费总额
	try {
		String memberId = request.getParameter("memberid");
		if (memberId == null) {
			out.println("不能获取memberid");
			return;
		}
		MemberLoginRepairService service = new MemberLoginRepairService();
		AuthUserInfo vo = service.repairMemberLogin(memberId);

		out.println("<h2>会员认证系统信息</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>用户名</td>");
		out.println("<td>密码</td>");
		out.println("<td>设定登录失败次数</td>");
		out.println("<td>当前登录失败次数</td>");
		out.println("</tr>");

		out.println("<tr>");

		out.println("<td>" + vo.getUsername() + "</td>");
		out.println("<td>" + vo.getPassword() + "</td>");
		out.println("<td>" + vo.getReverieDegree() + "</td>");
		out.println("<td>" + vo.getFailDegree() + "</td>");
		out.println("</tr>");

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {

	}
%>
