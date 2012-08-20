<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page import="com.chinarewards.report.data.*"%>
<%@ page import="com.chinarewards.report.data.posapp.*"%>
<%@ page import="com.chinarewards.report.db.*"%>
<%@ page import="com.chinarewards.report.sql.*"%>
<%@ page import="com.chinarewards.report.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<html>
<head>
<title>Operation</title>

</head>


<body>



<%

	String date = request.getParameter("date");
	String mid = request.getParameter("mid");

	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");

	Connection conn = null;
	ResultSet rs = null;
	Statement stmt = null;

	//商户消费总额
	try {

		conn = DbConnectionFactory.getInstance()
				.getConnection("posapp");
		stmt = conn.createStatement();
%>
<h2>深航会员消费实时报表</h2>
<table border="1">

	<thead>
		<tr>
			<th>编号</th>
			<th>深航卡号</th>
			<th>深航卡号（链接）</th>
			<th>消费商户</th>
			<th>消费总金额</th>
			<th>积分</th>
			<th>里程</th>
			<th>交易时间</th>
			<th>门店</th>
			<th></th>
		</tr>
	</thead>
	<%
		StringBuffer sqlbuf = new StringBuffer(
					"SELECT pd.partnermembercardno, cp.paymerchantname, cp.amountcurrency, pd2.sellamount as point, pd.sellamount, cp.transdate, cp.shopname, pd.status, cp.tempmembertxid, cp.memeberid, cp.transcardorgid, cp.membercardid FROM pointtransactiondetail pd,pointtransactiondetail pd2, clubpoint cp WHERE pd.partnerid ='ff8080812523c77e0125243556691083' AND pd.clubpoint_id = cp.id AND cp.isrollback=0 and cp.amountcurrency > 2 and pd2.clubpoint_id=pd.clubpoint_id and pd2.partnerid='00' ORDER by cp.transdate DESC");

			rs = stmt
					.executeQuery(sqlbuf.toString());

			int j = 0;

			while (rs.next()) {

				String mtQueryString = ClubPointUtil
						.buildMemberXactionPageQueryString(rs);
				if (mtQueryString != null && mtQueryString.length() > 0) {
					mtQueryString = "?" + mtQueryString;
				}

				// description
				String desc = "";
				if ("OK".equals(rs.getString("status"))) {
					desc = "深航成功增加里程";
				} else {
					desc = rs.getString("status");
				}
				String memberCardNo = rs.getString(1);
				String cardno = "'".concat(memberCardNo);
	%>
	<tr>
		<td><%=++j%></td>
		<td><%=cardno%></td>
		<td><a href="<%=ctxRootPath%>/memberTrans.jsp<%=mtQueryString%>"><%=memberCardNo%></a>
		<a href="<%=ctxRootPath%>/cardsearch.jsp<%=mtQueryString%>"><img
			src="<%=ctxRootPath%>/images/member_icon1_16x16.jpg" border="0"
			alt="Member Information" title="Member Information" /></a></td>
		<td><%=rs.getString(2)%></td>
		<td class="amount"><%=rs.getDouble("amountcurrency")%></td>
		<td class="amount"><%=rs.getDouble("point")%></td>
		<td class="amount"><%=rs.getDouble("sellamount")%></td>
		<td><%=rs.getTimestamp("transdate")%></td>
		<td><%=rs.getString("shopname")%></td>
		<td><%=desc%></td>
	</tr>
	<%
		}
			out.println("</table>");

			SqlUtil.close(rs);

		} catch (Exception e) {

			out.println(e);
			e.printStackTrace();

		} finally {

			SqlUtil.close(rs);
			SqlUtil.close(stmt);
			SqlUtil.close(conn);

		}
	%>

</body>
</html>
