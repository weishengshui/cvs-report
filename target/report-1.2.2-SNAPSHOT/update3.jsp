<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@include file="checklogin.jsp" %> 
<%
String date=request.getParameter("date");
String mid=request.getParameter("mid");
out.println("the date is : "+date);

DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");


%>
<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@10.1.1.105:1521:CR"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 

Connection conn2 = null; 
ResultSet rs2 = null; 
Statement stmt2 = null; 

//商户消费总额
try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 

Class.forName(sDBDriver); 
conn2 = DriverManager.getConnection(sConnStr,"crm","crm"); 


stmt = conn.createStatement(); 
stmt2 = conn2.createStatement(); 
out.println("<h2>有一次及一次以上消费记录的会员和临时卡会员:</h2>");
out.println("<table border='1'>");
out.println("<tr>"); 
out.println("<td>CardID</td>"); 
out.println("<td>总消费金额</td>");   
out.println("<td>总积分</td>");  
out.println("<td>MP</td>");
out.println("<td>name</td>");
out.println("<td></td>");
out.println("</tr>"); 
rs = stmt.executeQuery("select DISTINCT membercardid,sum(amountcurrency),sum(point) from clubpoint where  amountcurrency >'2' GROUP by membercardid "); 


while (rs.next()){ 
out.println("<tr>");
out.println("<td>"  +rs.getString(1)+ "</td>");
//out.println("<td><a href='memberTrans.jsp?cardno=" +rs.getString("membercardid")+ "'>"  +rs.getString("membercardid")+ "</a> [<a href='cardsearch.jsp?nick=" +rs.getString("membercardid")+ "'>?</a>]</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td align='right'>"  + rs.getString(3)+ "</td>");


rs2 = stmt2.executeQuery("select m.mobiletelephone ,m.chisurname, m.chilastname, s.membercardno from member m, membership s where m.id = s.member_id and s.membercardno = '"+rs.getString("membercardid")+"'"); 

while (rs2.next()){ 


out.println("<td>" + rs2.getString(1) + "</td>"); 
out.println("<td>" + rs2.getString(2) + "</td>"); 
out.println("<td>" + rs2.getString(3) + "</td>"); 

break;




}

out.println("</tr>"); 

}
out.println("</table>"); 
rs.close(); 


} 
catch(Exception e) 
{ 
  out.println(e); 
}finally{
	if(conn!=null){
	    conn.close();
	    System.out.println("connection close....");
   }	
	if(stmt!=null){
	    stmt.close();
   }
	if(rs!=null){
	    rs.close();
   }
	
	if(conn2!=null){
	    conn2.close();
	    System.out.println("connection close....");
   }	
	if(stmt2!=null){
	    stmt2.close();
   }
	if(rs2!=null){
	    rs2.close();
   }	
}


%>

