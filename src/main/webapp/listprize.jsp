<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 

<%
String date=request.getParameter("date");
String mid=request.getParameter("mid");


DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");


%>
<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@192.168.4.12:1521:chinarewards"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 


//�̻������ܶ�
try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 



stmt = conn.createStatement(); 
 
out.println("<h2>��Ʒ�һ���ʵʱ����:</h2>");
out.println("<table border='1'>");
out.println("<tr>");  
out.println("<td>posid</td>");   
out.println("<td>���Ż��ֻ�����</td>");  
out.println("<td>�һ���ַ</td>");   
out.println("<td>����</td>");   
out.println("<td>������</td>");   
out.println("<td>��Ʒ</td>");   
out.println("<td>��ע</td>");  
out.println("</tr>"); 
rs = stmt.executeQuery("select posid,mp,address,name,ren,prize,remark from cocoparkprize ");


while (rs.next()){ 
out.println("<tr>");
out.println("<td>"  +rs.getString(1)+ "</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");
out.println("<td>"  +rs.getString(5)+ "</td>");
out.println("<td>"  +rs.getString(6)+ "</td>");
out.println("<td>"  +rs.getString(7)+ "</td>");
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

