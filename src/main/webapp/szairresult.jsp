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


//�̻������ܶ�
try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"szair","szair"); 



stmt = conn.createStatement(); 
out.println("NOK: �»�Աע��ɹ� <br>"+
"NEA: ���俨�ų�������������޸ÿ���<br>"+ 
"NEB: ���俨�ų������ѷ���<br>"+ 
"NEC: ���俨�ų������Ѵ��ڣ������Ǹû�Ա�ģ�<br>"+ 
"NMC: ��Ա�Ѵ��ڣ����ظû�Ա���� <br>"+
"NME: ��Ա�Ѵ��ڣ���������<br>"+ 
"COK: ��Ա���Ŷ�����<br>"+ 
"CCE: ��Ա���ڣ����Ŵ��󣬷��ظû�Ա���� <br>"+
"CME: ��Ա���ڣ����Ŵ��󣬵��û�Ա��״̬�����Ŀ��� <br>"+
"CAE: ��Ա������ <br>"+
"OM: ϵͳ���� <br>"+
"OE: �������� ");
out.println("<br>");
out.println("<h2>���Աע��������:</h2>");
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
	out.println("<td>ȫ�»�Աע��ɹ�</td>");
}else if (result.equals("NMC") || result.equals("COK") || result.equals("NME")){
	out.println("<td>�������Աע���������ɹ� </td>");
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

