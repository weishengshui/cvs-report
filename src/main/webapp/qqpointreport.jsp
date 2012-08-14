<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.data.QQService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.ConsumeData"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");

	QQService service = new QQService();
	List<ConsumeData> list = null;

	int j = 1;

	//商户消费总额
	try {

		list = service.getAllQQConsumeData();

		out.println("<h2>QQ会员会员消费信息报表</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>卡号</td>");
		out.println("<td>消费门市</td>");
		out.println("<td>消费类型</td>");
		out.println("<td>消费金额</td>");
		out.println("<td>获得积分</td>");
		out.println("<td>交易时间</td>");
		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			ConsumeData vo = list.get(i);
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + vo.getMemberCardNo() + "</td>");
			out.println("<td>" + vo.getShopName() + "</td>");
			out.println("<td>" + vo.getConsumeType() + "</td>");
			out.println("<td>"
					+ moneyFormat.format(vo.getConsumeMoney())
					+ "</td>");
			out.println("<td>" + pointFormat.format(vo.getPoint())
					+ "</td>");
			out.println("<td>" + dateFormat.format(vo.getTransDate())
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