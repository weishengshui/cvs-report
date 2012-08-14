<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* , java.text.*, javax.naming.*,java.util.*"%>
<%@ page contentType="text/html;charset=gb2312" %>
<h2>Shang Hai Transaction Report by Date</h2>

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
  conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 
  stmt = conn.createStatement(); 
  // stmt.setMaxRows(60);

  out.println("<table border='1'>");
  out.println("<tr>");
  out.println("<th>Date</th>");
  out.println("<th>Transactions</th>");
  out.println("<th>Amount</th>");
  out.println("<th>Points</th>");
  out.println("</tr>");

  rs = stmt.executeQuery("SELECT TO_CHAR(transdate, 'yyyy-mm-dd'), count(*), sum(amountcurrency), sum(point) FROM CLUBPOINT WHERE CLUBID='00' and amountcurrency>2 and merchantname like '上海%' GROUP BY TO_CHAR(transdate, 'yyyy-mm-dd') ORDER BY TO_CHAR(transdate, 'yyyy-mm-dd') DESC");
  while (rs.next()) {
    out.println("<tr>");
    out.println("<td><a href='datereportdetail_sh.jsp?date=" + rs.getString(1) + "'>" + rs.getString(1) + "</a></td>");
    out.println("<td align='right'>" + rs.getInt(2) + "</td>");
    out.println("<td align='right'>" + moneyFormat.format(rs.getDouble(3)) + "</td>");
    out.println("<td align='right'>" + pointFormat.format(rs.getDouble(4)) + "</td>");
    out.println("</tr>");
  }
} finally {
  conn.close();
}
%>
