<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.ChinaLifeMemberExchangeReportVO"%>
<%@ page language="java"
	import="com.chinarewards.report.data.ChinaLifeService"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");

	ChinaLifeService service = new ChinaLifeService();
	List<ChinaLifeMemberExchangeReportVO> list = null;

	int j = 1;

	//商户消费总额
	try {

		list = service.getAllExcnangeRecordOfChinaLife();

		out.println("<h2>ChinaLife会员兑换报表</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>会员编号 </td>");
		out.println("<td>会员国寿卡号 </td>");
		out.println("<td>会员兑换卡号 </td>");
		out.println("<td>姓名</td>");
		out.println("<td>性别</td>");
		out.println("<td>商品名称</td>");
		out.println("<td>兑换数量</td>");
		out.println("<td>兑换时间</td>");
		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			ChinaLifeMemberExchangeReportVO vo = list.get(i);
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + vo.getMemberId() + "</td>");
			out.println("<td>" + vo.getChinalifeCardno() + "</td>");
			out.println("<td>" + vo.getExchangeCardno() + "</td>");
			out.println("<td>" + vo.getMembername() + "</td>");
			out.println("<td>" + vo.getSex() + "</td>");
			out.println("<td>" + vo.getMchName() + "</td>");
			out.println("<td>" + vo.getExchangeNum() + "</td>");
			out
					.println("<td>"
							+ dateFormat.format(vo.getExchangeTime())
							+ "</td>");

			out.println("</tr>");
		}
		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {
		list = null;
	}
%>