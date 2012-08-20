<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.member.MemberPointStatusService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.MemberPointStatusVO"%>
<%@ page language="java"
	import="com.chinarewards.report.data.tx.AccountInfo"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.MemberInfo"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.MemberShipInfo"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");

	MemberPointStatusService service = new MemberPointStatusService();
	List<MemberPointStatusVO> list = null;

	int j = 1;

	//商户消费总额
	try {

		list = service.getMemberPointStatusReport();

		out.println("<h2>有消费的会员积分状态报表</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>会员姓名</td>");
		out.println("<td>会员卡号</td>");
		out.println("<td>手机号</td>");
		out.println("<td>总积分</td>");
		out.println("<td>有效积分</td>");
		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			MemberPointStatusVO vo = list.get(i);
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + vo.getMemberName() + "</td>");
			out.println("<td>" + vo.getMemberCardno() + "</td>");
			out.println("<td>" + vo.getMobile() + "</td>");
			out.println("<td>" + vo.getTotalPoint() + "</td>");
			out.println("<td>" + vo.getValidPoint() + "</td>");
			out.println("</tr>");
		}

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {
		list = null;
	}
%>