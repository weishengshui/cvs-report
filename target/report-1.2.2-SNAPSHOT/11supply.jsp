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
String sConnStr = "jdbc:oracle:thin:@10.1.1.105:1521:CR"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 


//商户消费总额
try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"supply","supply"); 
stmt = conn.createStatement(); 


out.println("<h2>（11月）商品兑换量详细信息:</h2>");
out.println("<table border='1'>");
out.println("<tr>");  
out.println("<td>exchange no</td>");   
out.println("<td>数量</td>");
out.println("<td>供应商名字</td>");   
out.println("<td>生效时间</td>");   
out.println("<td></td>"); 
out.println("<td></td>"); 
out.println("</tr>"); 
rs = stmt.executeQuery("select ex.exchangeno, ex.amount,su.businm, ex.startdt, me.mchnm, me.mchprice from exchange ex, supplier su,merchandise me  where  ex.startdt>={d '2009-11-01'} and ex.startdt<{d '2009-12-01'} and ex.merchandise_id= me.id  and ex.supplier_id=su.id ORDER by su.businm");



while (rs.next()){ 
out.println("<tr>");
out.println("<td>"  +rs.getString(1)+ "</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");
out.println("<td>"  +rs.getString(5)+ "</td>");
out.println("<td>"  +rs.getString(6)+ "</td>");


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

