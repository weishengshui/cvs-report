<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.SZAirService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.szair.SZAirMembersOfSaledNoRegister"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	String sTransDateSince = "2009-06-01";
	String sTransDateTo = "2999-12-31";
	java.util.Date dateFrom = null;
	java.util.Date dateTo = null;
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		sdf.setLenient(false);
		String sDateFrom = request.getParameter("df");
		String sDateTo = request.getParameter("dt");
		if (StringUtil.isEmpty(sDateFrom))
			sDateFrom = sTransDateSince;
		if (sDateFrom != null) {
			try {
				dateFrom = sdf.parse(sDateFrom);
			} catch (ParseException e) {
			}
		}
		if (StringUtil.isEmpty(sDateTo))
			sDateTo = sTransDateTo;
		if (sDateTo != null) {
			try {
				dateTo = sdf.parse(sDateTo);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
	}
	System.out.println(dateFrom);
	System.out.println(dateTo);

	java.util.Date queryDateTo = null;
	if (dateTo != null) {
		queryDateTo = DateUtil.add(dateTo, Calendar.DATE, 1);
	}

	SZAirService service = new SZAirService();
	List<SZAirMembersOfSaledNoRegister> list = service
			.getSZAirMembersOfSaledNoRegister(dateFrom, dateTo);

	//商户消费总额
	try {

		out.println("<h2>Criteria</h2>");
		out.println("<form method='get'>");
		out.println("<table>");
		out.println("<tr>");
		out
				.println("<td>From:</td><td><input type='text' name='df' value='"
						+ (dateFrom != null ? dateFormat
								.format(dateFrom) : "")
						+ "' maxlen='10' size='10' /> <i>(yyyy-mm-dd)</i></td>");
		out.println("<td width='20px'></td>");
		out
				.println("<td>To:</td><td><input type='text' name='dt' value='"
						+ (dateTo != null ? dateFormat.format(dateTo)
								: "")
						+ "'  maxlen='10' size='10' /> <i>(yyyy-mm-dd)</i></td>");
		out.println("<td>");
		out.println("<input type='submit' value='Submit' />");
		out.println("</td></tr>");
		out.println("</table>");
		out.println("</form>");

		out.println("<h2>深航会员已消费未注册会员数量:</h2>" + list.size());
		out.println("<h2>深航会员已消费未注册会员信息报表:</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>深航卡号</td>");
		out.println("<td>交易时间</td>");
		out.println("<td>shop name</td>");
		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			SZAirMembersOfSaledNoRegister noregister = list.get(i);
			out.println("<tr>");
			out
					.println("<td>" + noregister.getMemberCardNo()
							+ "</td>");
			out.println("<td>" + noregister.getLastSalesDate()
					+ "</td>");
			out.println("<td>" + noregister.getShopName() + "</td>");
			out.println("</tr>");
		}

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {

		list = null;
	}
%>

