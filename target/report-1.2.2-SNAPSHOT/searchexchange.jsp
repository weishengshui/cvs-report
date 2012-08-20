<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 

<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@10.1.1.105:1521:CR"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null;
String no=request.getParameter("nick");



try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 


out.println("<br>"); 
out.println("<br>"); 
out.println("交易流水："+no); 
out.println("<br>"); 
out.println("<br>"); 
//每个merchant的消费总金额
stmt = conn.createStatement(); 

out.println("Result:<br>"); 
rs = stmt.executeQuery("select pe.exchangecd,bl.logdate from businesslog bl, posredeemorder po, posredeemexchange pe where bl.barcode='"+no+"' and po.orderno = bl.businessid and po.id = pe.redeemorder_id");
out.println("<table border='1'>");
out.println("<tr>");
out.println("<td>exhange no</td>"); 
out.println("<td>date time</td>"); 

out.println("</tr>");
while (rs.next()){
	out.println("<tr>");
out.println("<td>" + rs.getString(1) + "</td>"); 
out.println("<td>" + rs.getString(2) + "</td>"); 

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

