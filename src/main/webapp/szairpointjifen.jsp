<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.chinarewards.report.data.*" %>
<%@ page import="com.chinarewards.report.data.posapp.*" %>
<%@ page import="com.chinarewards.report.db.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<html>
<head>
<title>深航会员消费只累积记分实时报表</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>
<%
String date=request.getParameter("date");
String mid=request.getParameter("mid");


DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");


%>
<% 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 


try { 

	conn = DbConnectionFactory.getInstance().getConnection("posapp");



stmt = conn.createStatement(); 

%>

<h2>深航会员消费只累积记分实时报表</h2>
<table border="1">
<thead>
<tr>  
<th>门店</th>   
<th>消费金额</th>  
<th>积分</th>  
<th>交易所用卡号</th>  
<th>交易时间</th>  
<th>消费商户</th>  
</tr> 
</thead>

<tbody>
<%
rs = stmt.executeQuery("SELECT c.shopname, c.amountcurrency, c.point, c.membercardid, c.transdate, c.merchantname, c.tempmembertxid, c.memeberid, c.transcardorgid FROM clubpoint c WHERE c.clubid ='00' AND c.membercardid LIKE '108%'");

while (rs.next()) {
	
	String mtQueryString = ClubPointUtil.buildMemberXactionPageQueryString(rs);
	if (mtQueryString != null && mtQueryString.length() > 0) {
		mtQueryString = "?" + mtQueryString;
	}
	
%>
<tr>
<td><%=rs.getString("shopname")%></td>
<td class="amount"><%=rs.getString("amountcurrency")%></td>
<td class="amount"><%=rs.getString("point")%></td>
<td><a href="<%=ctxRootPath%>/memberTrans.jsp<%=mtQueryString%>"><%=rs.getString(1)%></a> <a href="<%=ctxRootPath%>/cardsearch.jsp<%=mtQueryString%>"><img src="<%=ctxRootPath%>/images/member_icon1_16x16.jpg" border="0" alt="Member Information" title="Member Information" /></a></td>
<td><%=rs.getString("transdate")%></td>
<td><%=rs.getString("merchantname")%></td>
</tr> 
<%
}
%>
</tbody>
</table>
<%

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
</html>