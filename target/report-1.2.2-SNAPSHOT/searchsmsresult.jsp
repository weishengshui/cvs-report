<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 
 

<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@10.1.1.105:1521:CR"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null;
String no=new String(request.getParameter("nick").getBytes("ISO-8859-1"),"gb2312");
if(no.indexOf("码")>0){
	out.println("输入的内容不合理！！！");	
	return;
}


try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 


out.println("<br>"); 
out.println("<br>"); 
out.println("content："+no); 
out.println("<br>"); 
out.println("<br>"); 
//每个merchant的消费总金额 
stmt = conn.createStatement(); 

out.println("Result:<br>"); 
rs = stmt.executeQuery("select destination, sentdate, content from smsoutbox where content like '%"+no+"%'");
out.println("<table border='1'>");
out.println("<tr>");
out.println("<td>mobile phone</td>"); 
out.println("<td>send date</td>"); 
out.println("<td>content</td>"); 
out.println("</tr>");
while (rs.next()){
	out.println("<tr>");
out.println("<td>" + rs.getString(1) + "</td>"); 
out.println("<td>" + rs.getString(2) + "</td>"); 
out.println("<td>" + rs.getString(3) + "</td>"); 
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

