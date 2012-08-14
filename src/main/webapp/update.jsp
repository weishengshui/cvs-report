<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page import="com.chinarewards.report.db.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<html>
<head>
<title>Single Day Transaction Report</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>

<body>
<h2>Single Day Transaction Report</h2>

<a href="<%=ctxRootPath%>/datereport.jsp">返回Daily Report</a>

<br/><br/>

<%

String date = request.getParameter("date");
out.println("Date: " + date);

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
java.util.Date from = dateFormat.parse(date);
java.util.Date to = DateUtil.add(from, Calendar.DATE, 1);

DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");


%>
<% 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 


//商户消费总额
try 
{ 

conn = DbConnectionFactory.getInstance().getConnection("posapp");


PreparedStatement ps1 = conn.prepareStatement("SELECT count(*) AS tx_count, sum(amountcurrency) AS total_amt, sum(point) AS total_point " 
		+ "FROM clubpoint WHERE clubid='00' and amountcurrency>2 and transdate >= ? and transdate < ? and isrollback = 0");
ps1.setDate(1, new java.sql.Date(from.getTime()));
ps1.setDate(2, new java.sql.Date(to.getTime()));


out.println("<br>"); 
out.println("<br>"); 
out.println("<h3>Summary<h3>"); 

out.println("<table border='1'>");
out.println("<tr>"); 
out.println("<td>总次数</td>"); 
out.println("<td>总消费金额</td>"); 
out.println("<td>总积分</td>");  
out.println("</tr>"); 

rs = ps1.executeQuery(); 


while (rs.next()){
%>
<tr>
<td class="amount"><%=rs.getString("tx_count")%></td>
<td class="amount"><%=rs.getString("total_amt")%></td>
<td class="amount"><%=rs.getString("total_point")%></td>
</tr>
<% 


}
out.println("</table>"); 
rs.close(); 
ps1.close();

//---- breakdown (kmtong)
PreparedStatement ps2 = conn.prepareStatement("SELECT merchantid, shopid, merchantname, shopname, COUNT(*) ttlcount, SUM(amountcurrency) amt, SUM(point) ptamt FROM clubpoint " +
	" WHERE clubid='00' AND amountcurrency>2 AND transdate >= ? AND transdate < ? and isrollback = 0 GROUP BY merchantid, shopid, merchantname, SHOPNAME ORDER BY SUM(amountcurrency) DESC");
	ps2.setDate(1, new java.sql.Date(from.getTime()));
	ps2.setDate(2, new java.sql.Date(to.getTime()));
rs = ps2.executeQuery();

%>
<br/>
<hr/>
<br/>
<h3>Breakdown</h3>
<table border="1">
<thead> 
<tr>
<th>商户</th> 
<th>门店</th> 
<th>总次数</th> 
<th>总消费金额</th> 
<th>总积分</th>  
</tr> 
</thead>
<tbody> 
<%
while (rs.next()){
	String detailUrl = ctxRootPath + "/update2.jsp?date="
			+ URLEncoder.encode(date, "UTF-8")
			+ "&mid=" + URLEncoder.encode(rs.getString("merchantid"), "UTF-8");
%>
<tr> 
<td><a href="<%=detailUrl%>"><%=rs.getString("merchantname")%></td>
<td><%=rs.getString("shopname")%></td>
<td class="amount"><%=rs.getInt("ttlcount")%></td>
<td class="amount"><%=rs.getDouble("amt")%></td>
<td class="amount"><%=rs.getDouble("ptamt")%></td>
</tr> 
<%
}
%>
</tbody>
</table>
<%
SqlUtil.close(rs);
SqlUtil.close(ps2);

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