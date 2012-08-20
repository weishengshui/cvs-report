<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page import="com.chinarewards.report.db.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ page import="com.chinarewards.report.jsp.util.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<html>
<head>
<title>Transaction Report by Member</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>

<body>

<h1>Transaction Report by Member</h1>
.....<a href='datereport.jsp'>Or By Date</a><br/>
<%


String cardno=request.getParameter("cardno");

DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");


%>
<% 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 

//商户消费总额
try { 

conn = DbConnectionFactory.getInstance().getConnection("posapp");

stmt = conn.createStatement(); 

out.println("<table border='1'>");
out.println("<thead>");
out.println("<tr>"); 
out.println("<th>#</th>"); 
out.println("<th>Card Number</th>"); 
out.println("<th># of TX</th>"); 
out.println("<th>金额</th>"); 
out.println("<th>积分</th>");  
out.println("</tr>"); 
out.println("</thead>");
rs = stmt.executeQuery("SELECT membercardid, count(*) ttlcnt, SUM(amountcurrency) amt, SUM(point) ptamt FROM clubpoint " +
	" WHERE CLUBID='00' GROUP BY membercardid ORDER BY membercardid"); 

out.println("<tbody>");
int i = 1;
while (rs.next()){
	String mtransUrl = "?cardno=" + URLEncoder.encode(rs.getString("membercardid"), "UTF-8");
%>
<tr>
<td><%=i%></td>
<td><a href="memberTrans.jsp<%=mtransUrl%>"><%=JspDisplayUtil.noNull(rs.getString("membercardid"))%></a> <a href="<%=ctxRootPath%>/cardsearch.jsp<%=mtransUrl%>"><img src="<%=ctxRootPath%>/images/member_icon1_16x16.jpg" border="0" alt="Member Information" title="Member Information" /></a></td>
<td class="amount"><%=rs.getInt("ttlcnt")%></td>
<td class="amount"><%=moneyFormat.format(rs.getDouble("amt"))%></td>
<td class="amount"><%=pointFormat.format(rs.getDouble("ptamt"))%></td>
</tr>
<%
	i++;
}
out.println("</tbody>");
out.println("</table>"); 
rs.close(); 


} catch(Exception e) { 
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