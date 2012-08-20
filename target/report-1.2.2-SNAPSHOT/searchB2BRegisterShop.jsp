<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.tiger2.B2BService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.tiger2.ShopAccountApplication"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");

	B2BService service = new B2BService();
	List<ShopAccountApplication> list = null;

	int j = 1;

	//商户消费总额
	try {

		list = service.getAllShopAccountApplication();

		out.println("<h2>B2B注册商户信息资料报表</h2>");
		out.println("<h2>注册商户数量:</h2>" + list.size());
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>商户名称</td>");
		out.println("<td>状态</td>");
		out.println("<td>营业号码</td>");
		out.println("<td>联系人姓名</td>");
		out.println("<td>联系人email</td>");
		out.println("<td>联系人电话</td>");
		out.println("<td>创建时间</td>");

		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			ShopAccountApplication vo = list.get(i);
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + vo.getShopName() + "</td>");
			out.println("<td>" + vo.getStatus() + "</td>");
			out.println("<td>" + vo.getBusinessLicenseCode() + "</td>");
			out.println("<td>" + vo.getContactPersonName() + "</td>");
			out.println("<td>" + vo.getContactEmail() + "</td>");
			out.println("<td>" + vo.getContactPhone() + "</td>");
			out.println("<td>" +vo.getCreateAt() + "</td>");

			out.println("</tr>");
		}

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {
		list = null;
	}
%>