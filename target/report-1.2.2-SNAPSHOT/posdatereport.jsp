<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* , java.text.*, javax.naming.*,java.util.*"%>
<%@ page contentType="text/html;charset=gb2312" %>
<%@include file="checklogin.jsp" %>
<h2>Pos机注册消费会员汇总信息</h2>
<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@10.1.1.105:1521:CR"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 
DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
//商户消费总额
try 
{ 

  Class.forName(sDBDriver); 
  conn = DriverManager.getConnection(sConnStr,"crm","crm"); 
  stmt = conn.createStatement(); 
  // stmt.setMaxRows(60);

  out.println("<table border='1'>");
  out.println("<tr>");
  out.println("<th>Date</th>");
  out.println("<th>Amount</th>");
  out.println("</tr>");

  rs = stmt.executeQuery("SELECT TO_CHAR(startdate, 'yyyy-mm-dd'), count(*) FROM tempcard WHERE 1=1  and type='1' GROUP BY TO_CHAR(startdate, 'yyyy-mm-dd') ORDER BY TO_CHAR(startdate, 'yyyy-mm-dd') DESC");
  while (rs.next()) {
    out.println("<tr>");
    out.println("<td><a href='temcardbydate.jsp?date=" + rs.getString(1) + "'>" + rs.getString(1) + "</a></td>");
    out.println("<td align='right'>" + rs.getInt(2) + "</td>");
    out.println("</tr>");
  }
} finally {
  conn.close();
}
%>
