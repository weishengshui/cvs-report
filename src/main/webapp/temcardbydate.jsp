<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 
<h2>pos机注册成为正式会员报表</h2>
<%
String username=request.getParameter("date");
out.println("Date: "+username);

DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");


%>
<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@10.1.1.105:1521:CR"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 


//商户消费总额
try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"crm","crm"); 


stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("<h3>Summary<h3>"); 
out.println("<table border='1'>");
out.println("<tr>"); 


out.println("<td>名字" +   "</td>"); 
out.println("<td> 注册时间" +   "</td>"); 
out.println("<td> 最后更新时间" +   "</td>");
out.println("<td> 手机号码" +   "</td>"); 
out.println("<td> email" +   "</td>"); 
out.println("<td> status" +   "</td>");
out.println("<td> card" +   "</td>");
out.println("</tr>"); 

rs = stmt.executeQuery("select  m.chilastname, m.chisurname,m.registdate, m.lastupdatetime,m.mobiletelephone,m.email,m.memberstatus,s.membercardno from tempcard t, member m ,membership s where m.id = s.member_id   and s.membercardno not like 'M%' and t.id = m.mobiletelephone and registdate >= {d '"+username+"'"+"} and registdate  <to_date('"+username+"','yyyy-mm-dd')+1"); 


while (rs.next()){ 
out.println("<tr>"); 
out.println("<td>"  +rs.getString(1)+rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");
out.println("<td>"  +rs.getString(5)+ "</td>");
out.println("<td>"  +rs.getString(6)+ "</td>");
out.println("<td>"  +rs.getString(7)+ "</td>");
out.println("<td><a href='memberTrans.jsp?cardno=" +rs.getString(8)+ "'>"  +rs.getString(8)+ "</a> </td>");
out.println("</tr>"); 


}
out.println("</table>"); 
rs.close(); 

out.println("<h2>portal注册成为正式会员报表</h2> ");

stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("<table border='1'>");
out.println("<tr>"); 


out.println("<td>名字" +   "</td>"); 
out.println("<td> 注册时间" +   "</td>"); 
out.println("<td> 最后更新时间" +   "</td>");
out.println("<td> 手机号码" +   "</td>"); 
out.println("<td> email" +   "</td>");
out.println("<td> status" +   "</td>");
out.println("<td> card" +   "</td>"); 
out.println("</tr>"); 

rs = stmt.executeQuery("select  m.chilastname, m.chisurname,registdate, m.lastupdatetime,m.mobiletelephone,m.email,m.memberstatus,s.membercardno from  member m,membership s  where regsource='portal' and s.membercardno not like 'M%' and m.id = s.member_id and registdate >= {d '"+username+"'"+"} and registdate  <to_date('"+username+"','yyyy-mm-dd')+1"); 


while (rs.next()){ 
out.println("<tr>"); 
out.println("<td>"  +rs.getString(1)+rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");
out.println("<td>"  +rs.getString(5)+ "</td>");
out.println("<td>"  +rs.getString(6)+ "</td>");
out.println("<td>"  +rs.getString(7)+ "</td>");
out.println("<td><a href='memberTrans.jsp?cardno=" +rs.getString(8)+ "'>"  +rs.getString(8)+ "</a> </td>");
out.println("</tr>"); 


}
out.println("</table>"); 
rs.close(); 



out.println("<h2>crm注册成为正式会员报表</h2> ");

stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("<table border='1'>");
out.println("<tr>"); 


out.println("<td>名字" +   "</td>"); 
out.println("<td> 注册时间" +   "</td>"); 
out.println("<td> 最后更新时间" +   "</td>");
out.println("<td> 手机号码" +   "</td>"); 
out.println("<td> email" +   "</td>");
out.println("<td> status" +   "</td>"); 
out.println("</tr>"); 

rs = stmt.executeQuery("select  m.chilastname, m.chisurname,m.registdate, m.lastupdatetime,m.mobiletelephone,m.email,m.memberstatus ,s.membercardno from  member m,membership s   where regsource='crm'  and s.membercardno not like 'M%' and m.id = s.member_id and registdate >= {d '"+username+"'"+"} and registdate  <to_date('"+username+"','yyyy-mm-dd')+1"); 


while (rs.next()){ 
out.println("<tr>"); 
out.println("<td>"  +rs.getString(1)+rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");
out.println("<td>"  +rs.getString(5)+ "</td>");
out.println("<td>"  +rs.getString(6)+ "</td>");
out.println("<td>"  +rs.getString(7)+ "</td>");
out.println("<td><a href='memberTrans.jsp?cardno=" +rs.getString(8)+ "'>"  +rs.getString(8)+ "</a> </td>");
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
}


%>

