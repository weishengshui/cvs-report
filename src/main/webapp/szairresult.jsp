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
out.println("NOK: 新会员注册成功 <br>"+
"NEA: 分配卡号出错（卡分配表中无该卡）<br>"+ 
"NEB: 分配卡号出错（卡已发）<br>"+ 
"NEC: 分配卡号出错（卡已存在，担不是该会员的）<br>"+ 
"NMC: 会员已存在，返回该会员卡号 <br>"+
"NME: 会员已存在，但被冻结<br>"+ 
"COK: 会员卡号都存在<br>"+ 
"CCE: 会员存在，卡号错误，返回该会员卡号 <br>"+
"CME: 会员存在，卡号错误，但该会员无状态正常的卡号 <br>"+
"CAE: 会员不存在 <br>"+
"OM: 系统出错 <br>"+
"OE: 其他出错 ");
out.println("<br>");
out.println("<h2>深航会员注册结果报表:</h2>");
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
out.println("<td>Result</td>");
out.println("</tr>"); 
rs = stmt.executeQuery("select  ms.appellation, ms.chisurname, ms.chifirstname, ms.cardnumber,"+
                       "ms.gender, ms.address, ms.mobilephone,ms.status,ms.signupat,ml.shairprocessresult"+
                   " from membersignup  ms, memberdataxchgmemberlink ml"+
					" where ms.datasource!='BATCH_IMPORT'"+ 
					" and ms.id= ml.membersignup_id"+ 
					" ORDER by ms.signupat desc");


while (rs.next()){ 
out.println("<tr>");
out.println("<td>"  +rs.getString(1)+ "</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");
out.println("<td>"  +rs.getString(5)+ "</td>");
out.println("<td>"  +rs.getString(6)+ "</td>");
out.println("<td>"  +rs.getString(7)+ "</td>");

String status =rs.getString(8);
if (status == null) {
	status = "";
}

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
String result =rs.getString(10);
if (result == null) {
	result = "";
}
if(result.equals("NOK")){
	out.println("<td>全新会员注册成功</td>");
}else if (result.equals("NMC") || result.equals("COK") || result.equals("NME")){
	out.println("<td>已有深航会员注册联名卡成功 </td>");
}else{
	out.println("<td> SZ AIR Wrong Message:"  +result+ "</td>");
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

