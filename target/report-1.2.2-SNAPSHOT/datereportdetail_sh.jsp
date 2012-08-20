<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 
<h2>Date Transaction Report</h2>
<%
String username=request.getParameter("date");
out.println("(Shang Hai report )Date: "+username);

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
java.util.Date from = dateFormat.parse(username);
java.util.Date to = new java.util.Date(from.getTime() + 24*60*60*1000); 

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
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 

PreparedStatement ps1 = conn.prepareStatement("select count(*), sum(amountcurrency), sum(point) " 
		+ "from clubpoint where clubid='00' and merchantname like '上海%' and amountcurrency>2 and transdate >= ? and transdate < ?");
ps1.setDate(1, new java.sql.Date(from.getTime()));
ps1.setDate(2, new java.sql.Date(to.getTime()));
out.println("<br>"); 
out.println("<br>"); 
out.println("<h3>Summary<h3>"); 
out.println("<table border='1'>");
out.println("<tr>"); 


out.println("<td>总次数" +   "</td>"); 
out.println("<td> 总消费金额" +   "</td>"); 
out.println("<td> 总积分" +   "</td>");  
out.println("</tr>"); 

rs = ps1.executeQuery(); 


while (rs.next()){ 
out.println("<tr>"); 
out.println("<td>"  +rs.getString(1)+ "</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("</tr>"); 


}
out.println("</table>"); 
rs.close(); 
ps1.close();

//---- breakdown (kmtong)
out.println("<hr/>");

out.println("<h3>Breakdown</h3>");
out.println("<table border='1'>");
out.println("<tr>"); 


out.println("<td>Merchant</td>"); 
out.println("<td>Shop</td>"); 
out.println("<td>总次数" +   "</td>"); 
out.println("<td> 总消费金额" +   "</td>"); 
out.println("<td> 总积分" +   "</td>");  
out.println("</tr>"); 
	
PreparedStatement ps2 = conn.prepareStatement("select paymerchantid, shopid, paymerchantname, shopname, count(*) ttlcount, sum(amountcurrency) amt, sum(point) ptamt from clubpoint " +
" where clubid='00' and merchantname like '上海%' and amountcurrency>2 and transdate >= ? and transdate < ? GROUP BY paymerchantid,  shopid, paymerchantname, SHOPNAME order by sum(amountcurrency) desc");
ps2.setDate(1, new java.sql.Date(from.getTime()));
ps2.setDate(2, new java.sql.Date(to.getTime()));

rs = ps2.executeQuery();

while (rs.next()){ 
out.println("<tr>"); 
out.println("<td><a href='update2.jsp?date="+username+"&mid=" +rs.getString("paymerchantid") + "'>"  +rs.getString("paymerchantname")+ "</td>");
out.println("<td>"  +rs.getString("shopname")+ "</td>");
out.println("<td align='right'>"  +rs.getInt("ttlcount")+ "</td>");
out.println("<td align='right'>"  + moneyFormat.format(rs.getDouble("amt"))+ "</td>");
out.println("<td align='right'>"  + pointFormat.format(rs.getDouble("ptamt"))+ "</td>");
out.println("</tr>"); 


}
out.println("</table>"); 
rs.close(); 
ps2.close();

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

