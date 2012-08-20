<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 

<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@10.1.1.105:1521:CR"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 

/*
select count(*) from clubpoint where transdate >'15-MAY-09'
and clubid='00';

//the summay payment in each shop
select sum(amountcurrency),shopname from clubpoint where transdate >'15-MAY-09'
and clubid='00' GROUP by shopname;

//the auction count for each gift
select sum(version) ,auctionprizename from auctionrecord where 1=1 group by auctionprizename;


//lucky draw summary
select count(*) from luckydrawticket ;

#finish the luck draw summary
select count(*) from luckydrawticket where isluckydraw ='1';

// not finish the luck draw summary
select count(*) from luckydrawticket where isluckydraw ='0';

//get the paster 
select distinct memberid from pasterofmember where time >'01-MAY-09';

//get the paster not creating the lucky chance
select distinct memberid from pasterofmember where time >'01-MAY-09' and luckydrawticket_id =null;
*/
//商户消费总额
try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 


out.println("<br>"); 
out.println("<br>"); 
out.println("<br>"); 
out.println("<br>"); 
//每个merchant的消费总金额
stmt = conn.createStatement(); 

out.println("惊喜实时报表<br>"); 
rs = stmt.executeQuery("select s.merchandisename,o.keyaccountname,o.membername, o.productname, o.suppliershopname, o.suppliermerchantname, o.completedtime from surpriseorder s ,keyaccountorder o where s.keyaccountorder_id = o.id order by o.completedtime desc");
out.println("<table>");
while (rs.next()){
	out.println("<tr>");
out.println("<td>" + rs.getString(1) + "</td>"); 
out.println("<td>" + rs.getString(2) + "</td>"); 
out.println("<td>" + rs.getString(3) + "</td>");
out.println("<td>" + rs.getString(4) + "</td>"); 
out.println("<td>" + rs.getString(5) + "</td>"); 
out.println("<td>" + rs.getString(6) + "</td>"); 
out.println("<td>" + rs.getString(7) + "</td>"); 
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

