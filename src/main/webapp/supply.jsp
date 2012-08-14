<%--



 --%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.db.*, com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page contentType="text/html;charset=gb2312" %> 
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<html>
<head>
<title>会员兑换报表</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>


<body>
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


//商户消费总额
try 
{ 

// obtain database connection.
conn = DbConnectionFactory.getInstance().getConnection("supply");




{
	stmt = conn.createStatement(); 
	 
	out.println("<h1>商品兑换量实时报表:</h1>");
	out.println("<table border='1'>");
	out.println("<thead>");
	out.println("<tr>");  
	out.println("<th>#</th>");   
	out.println("<th>商品名称</th>");   
	out.println("<th>总兑换量</th>");  
	out.println("</tr>"); 
	out.println("</thead>");
	
	rs = stmt.executeQuery("SELECT ap.merchandise_id, mer.mchnm, SUM(applyamount) AS applyamount_sum FROM applydetail ap, merchandise mer WHERE 1=1 AND ap.status !='4' and mer.id = ap.merchandise_id GROUP by ap.merchandise_id,mer.mchnm ORDER BY applyamount_sum DESC, mer.mchnm, ap.merchandise_id");
	
	out.println("<tbody>");
	long i = 1;
	while (rs.next()){ 
		out.println("<tr>");
		out.println("<td>"  + i + "</td>");
		out.println("<td>"  +rs.getString(2)+ "</td>");
		out.println("<td>"  +rs.getString(3)+ "</td>");
		out.println("</tr>");
		i++;
	}
	out.println("</tbody>");
	out.println("</table>"); 
	rs.close(); 
}



out.println("<br/>");



//
// 商品兑换量详细信息
//
{
	out.println("<h1>商品兑换量详细信息</h1>");
	out.println("<table border='1'>");
	out.println("<thead>");  
	out.println("<tr>");  
	out.println("<th>#</th>");   
	out.println("<th>商品名称</th>");   
	out.println("<th>兑换时间</th>");
	out.println("<th>会员名字</th>");   
	out.println("<th>卡号</th>");   
	out.println("<th>兑换量</th>");  
	out.println("<th>状态<br/>（&lt;4:表示正在处理，<br/>=4: 表示失败，<br/>&gt;4: 表示兑换成功）</th>");  
	out.println("<th>兑换缤纷</th>");  
	out.println("</tr>"); 
	out.println("</thead>");
	
	rs = stmt.executeQuery("SELECT ap.merchandise_id, mer.mchnm, to_char(mp.applydt,'yyyy/mm/dd hh24:mm:ss'), ap.membername, ap.membercardcode, ap.applyamount, ap.status, ap.mchprice from applydetail ap , merchandise mer, memberapply mp WHERE 1=1 and mer.id = ap.merchandise_id and mp.id=ap.memberapply_id ORDER BY applydt DESC");
	
	out.println("<tbody>");
	long i = 1;
	while (rs.next()){ 
		out.println("<tr>");
		out.println("<td>" + i + "</td>");
		out.println("<td>" + rs.getString(2) + "</td>");
		out.println("<td>" + rs.getString(3) + "</td>");
		out.println("<td>" + rs.getString(4) + "</td>");
		out.println("<td>" + rs.getString(5) + "</td>");
		out.println("<td>" + rs.getString(6) + "</td>");
		out.println("<td>" + rs.getString(7) + "</td>");
		out.println("<td>" + rs.getString(8) + "</td>");
		out.println("</tr>");
		i++;
	}
	out.println("</tbody>");
	out.println("</table>"); 
	rs.close();
	
} // 商品兑换量详细信息


} catch(Exception e) { 
	out.println(e); 
} finally {
	
	SqlUtil.close(conn);
	SqlUtil.close(stmt);
	SqlUtil.close(rs);
	
}


%>

