<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*"%>
<%@ page contentType="text/html;charset=utf-8" %> 
<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@10.1.1.105:1521:CR"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 


try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"portal","portal"); 


//竞拍品的点击率
stmt = conn.createStatement(); 
//stmt.executeQuery("create table aaa(aaa int)");
//stmt.executeUpdate("insert into bbb values(456)"); 
out.println("竞拍品的点击率");


out.println("<br>"); 

out.println("<table border='1'"); 
out.println("<tr><td>serial</td><td>  count</td></tr>"); 
rs = stmt.executeQuery("select giftid, clicknum from clickrate where giftid is not null"); 
while (rs.next()){ 

out.println("<tr>");
out.println("<td>" + rs.getString(1) +    "</td>"); 
out.println("<td>" + rs.getString(2) +    "</td>"); 

out.println("</tr>"); 

}
out.println("</table>");  
rs.close(); 


out.println("<br>"); 
out.println("<br>"); 


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

