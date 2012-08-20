<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.data.QQService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.MemberInfo"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.MemberShipInfo"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	QQService service = new QQService();
	List<MemberInfo> list = service.getAllQQRegiaterMemberInfo();

	int j = 1;

	//商户消费总额
	try {

		out.println("<h2>QQ会员注册信息报表</h2>");
		out.println("<h2>QQ会员总数：" + list.size() + "</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>姓名</td>");
		out.println("<td>地址</td>");
		out.println("<td>手机号</td>");
		out.println("<td>email</td>");
		out.println("<td>qq号</td>");
		out.println("<td>注册时间</td>");
		out.println("<td>会员卡</td>");
		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			MemberInfo vo = list.get(i);
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + vo.getName() + "</td>");
			out.println("<td>" + vo.getWorkaddress() + "</td>");
			out.println("<td>" + vo.getMobile() + "</td>");
			out.println("<td>" + vo.getEmail() + "</td>");
			out.println("<td>" + vo.getQqnum() + "</td>");
			out.println("<td>" + vo.getRegistdate() + "</td>");
			out.println("<td>");
			List<MemberShipInfo> msinfos = vo.getMemberShipInfos();
			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td>卡号</td>");
			out.println("<td>卡名称</td>");
			out.println("<td>注册时间</td>");
			out.println("</tr>");

			for (MemberShipInfo msinfo : msinfos) {

				out.println("<tr>");
				out
						.println("<td>" + msinfo.getMemberCardNo()
								+ "</td>");
				out.println("<td>" + msinfo.getCardName() + "</td>");
				out.println("<td>" + msinfo.getStartDate() + "</td>");
				out.println("</tr>");
			}

			out.println("</table>");
			out.println("</td>");
			/**
			out.println("<td>"
					+ "<a href='./qqmembercardinfo.jsp?memberId="
					+ vo.getId() + "'>会员卡信息</a>" + "</td>");

			out.println("</tr>");
			 **/
		}

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {

		list = null;
	}
%>
