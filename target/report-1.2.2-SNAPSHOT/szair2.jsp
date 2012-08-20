<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 
<%@include file="checklogin.jsp" %>
<%
String date=request.getParameter("date");
String mid=request.getParameter("mid");


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
conn = DriverManager.getConnection(sConnStr,"szair","szair"); 



stmt = conn.createStatement(); 
 
out.println("<h2>深航会员注册实时报表:</h2>");
out.println("<table border='1'>");
out.println("<tr>");  
out.println("<td></td>");   
out.println("<td></td>");
out.println("<td></td>");  
out.println("<td></td>");  
out.println("<td></td>");  
out.println("<td></td>");  
out.println("<td></td>");
out.println("<td></td>");
out.println("<td></td>");
out.println("</tr>"); 
rs = stmt.executeQuery("select appellation, chisurname, chifirstname, cardnumber, gender, address, mobilephone,status,signupat,logmessage,datasource from membersignup where datasource!='BATCH_IMPORT' and (status='FAILED' or status='SUCCESS') and logmessage not like '%数据错%' ORDER by signupat desc");


while (rs.next()){ 
	if(rs.getString(10).equals("")){
		continue;
	}
out.println("<tr>");
out.println("<td>"  +rs.getString(1)+ "</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");
out.println("<td>"  +rs.getString(5)+ "</td>");
out.println("<td>"  +rs.getString(6)+ "</td>");
out.println("<td>"  +rs.getString(7)+ "</td>");

String status =rs.getString(8);

if(status.equals("FAILED_SH")){
	out.println("<td>szair system error</td>");
}else if (status.equals("FAILED")){
	out.println("<td>Data error+ </td>");
}else if (status.equals("IN_PROCESS")){
	out.println("<td>"  +rs.getString(8)+ "</td>");
}else if (status.equals("SUCCESS")){
	out.println("<td>SUCCESS</td>");
}else{
	out.println("<td>"  +rs.getString(8)+ "</td>");
}



out.println("<td>"  +rs.getString(9)+ "</td>");
out.println("<td>"  +rs.getString(10)+ "</td>");

String source = rs.getString(11);
if(source.equals("SH_BACKEND_IMPORT")){
	out.println("<td>深航客服</td>");
}else{
	out.println("<td>"  +source+ "</td>");	
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
	
	
}


%>

