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
conn = DriverManager.getConnection(sConnStr,"crm","crm"); 

int i=0;

stmt = conn.createStatement(); 
out.println("generated:�Ѿ���pos���Ǽ�");
out.println("activated:�Ѿ�����");
out.println("used:�Ѿ�ע���Ϊ��ʽ��Ա");
out.println("<br>");
out.println("<h2>���ٻ�Աע��ʵʱ����:</h2>");
out.println("<table border='1'>"); 
out.println("<tr>");  
out.println("<td>no</td>");  
out.println("<td>card no</td>");   
out.println("<td>status</td>");
out.println("<td>REG date</td>");  
out.println("<td>if not null,��ʾΪ��ʽ��Ա</td>");  
out.println("</tr>"); 
rs = stmt.executeQuery("select cardno, status, startdate, memberid from tempcard where length(cardno)=19 order by startdate desc");


while (rs.next()){ 
out.println("<tr>");
out.println("<td>"+(++i)+ "</td>");
out.println("<td>"  +rs.getString(1)+ "</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");

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

