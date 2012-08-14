<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page import="com.chinarewards.report.db.*"%>
<%@ page import="com.chinarewards.report.jsp.util.*"%>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ page import="com.chinarewards.report.jsp.util.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<%
	// input parameters
	String date = request.getParameter("date");
	String mid = request.getParameter("mid"); // merchant ID

	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
	SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
	inputDateFormat.setLenient(false);
%>
<%


	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement stmt = null;
	String sql = null;

	//商户消费总额
	try {

		java.util.Date inputDateFrom = inputDateFormat.parse(date);
		java.util.Date inputDateTo = DateUtil.add(inputDateFrom, Calendar.DATE, 1);
		conn = DbConnectionFactory.getInstance().getConnection("posapp");
		sql = "SELECT transdate, shopname, membercardid, amountcurrency amt, unitid, point ptamt, memeberid, tempmembertxid, transcardorgid, producttypename FROM clubpoint "
			+ " WHERE transdate >= to_date('" + inputDateFormat.format(inputDateFrom) + "', 'yyyy-MM-dd') " 
			+ " AND transdate < to_date('" + inputDateFormat.format(inputDateTo) + "', 'yyyy-MM-dd') "
			+ " AND merchantid = '"	+ mid + "' AND clubid='00' AND amountcurrency > 2 and isrollback = 0 ORDER BY transdate";
		System.out.println("sql = " + sql);
		stmt = conn.prepareStatement(sql);
		rs = stmt.executeQuery(sql);

%>
<html>
<head>
<title>Merchant Detail Transactions</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>
<body>

<h2>Merchant Detail Transactions</h2>

日期：<%=date%>

<br/><br/>

<a href="<%=ctxRootPath%>/datereport.jsp">返回Daily Report</a>

<br/><br/>

<!-- Table STARTS -->
<table border="1">
<!-- header starts -->
<thead>
<tr>
<th>交易日期</th>
<th>门店</th>
<th>交易所用卡号<sup><a href="#note1">1</a></sup></th>
<th>消费类型</th>
<th>消费金额</th>
<th>积分Type</th>
<th>积分</th>
</tr>
</thead>
<!-- header ends -->
<!-- body starts -->
<tbody>
<%
		while (rs.next()) {
			
			// construct the URL for memberTrans.jsp
			String mtransUrl = "";
			Hashtable<String,String> qp = new Hashtable<String,String>();
			if (!StringUtil.isEmpty(rs.getString("tempmembertxid"))) {
				qp.put("acctId", rs.getString("tempmembertxid"));
			}
			if (!StringUtil.isEmpty(rs.getString("memeberid"))) {
				qp.put("memberId", rs.getString("memeberid"));
			}
			if (!StringUtil.isEmpty(rs.getString("transcardorgid"))) {
				qp.put("orgId", rs.getString("transcardorgid"));
			}
			if (!StringUtil.isEmpty(rs.getString("membercardid"))) {
				qp.put("cardno", rs.getString("membercardid"));
			}
			if (!StringUtil.isEmpty(rs.getString("producttypename"))) {
				qp.put("producttypename", rs.getString("producttypename"));
			}
			mtransUrl = UrlUtil.buildQueryString(qp);
			if (mtransUrl != null && mtransUrl.length() > 0) {
				mtransUrl = "?" + mtransUrl;
			}
%>

<tr>
<td><%=rs.getTimestamp("transdate")%></td>		
<td><%=JspDisplayUtil.noNull(rs.getString("shopname"))%></td>
<td><a href="memberTrans.jsp<%=mtransUrl%>"><%=JspDisplayUtil.noNull(rs.getString("membercardid"))%></a> <a href="<%=ctxRootPath%>/cardsearch.jsp<%=mtransUrl%>"><img src="<%=ctxRootPath%>/images/member_icon1_16x16.jpg" border="0" alt="Member Information" title="Member Information" /></a></td>
<td><%=JspDisplayUtil.noNull(rs.getString("producttypename"))%></td>
<td class="amount"><%=moneyFormat.format(rs.getDouble("amt"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("unitid"))%></td>
<td class="amount"><%=pointFormat.format(rs.getDouble("ptamt"))%></td>
</tr>
<%
		} // while (rs.next())
			
		rs.close();

	} catch (Exception e) {
		out.println(e);
		e.printStackTrace();
	} finally {
		if (rs != null) {
			rs.close();
		}
		if (stmt != null) {
			stmt.close();
		}
		if (conn != null) {
			conn.close();
			System.out.println("connection close....");
		}
	}
%>
</tbody>
<!-- body ends -->
</table>
<!-- Table ENDS -->


<!-- Foot notes -->
<br/>

<b>备注:</b><br/>
<a name="note1"/><sup>1</sup>在2010年3月18日及之前，不论会员是用任何联盟卡、合作卡、手机号码，「交易所用卡号」所记录的是该会员所拥有的积享通普卡号。
<br/>


</body>
</html>
