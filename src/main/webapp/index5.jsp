<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.text.*"%>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%
String username=request.getParameter("nick");
out.println("the name is : "+username);



%>
<% 

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

conn = DbConnectionFactory.getInstance().getConnection("posapp");


stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("Member consume detail report：：<br>"); 
out.println("<table border='1'>");
out.println("<tr>"); 


out.println("<td>shop name" +   "</td>"); 
out.println("<td> RMB" +   "</td>"); 
out.println("<td> Point" +   "</td>"); 
out.println("<td> Type" +   "</td>"); 
out.println("<td> time" +  "</td>"); 
out.println("<td> card id"  + "</td>");
out.println("<td>   id"+ "</td>");
out.println("<td>  transaction id "+ "</td>");
out.println("</tr>"); 
rs = stmt.executeQuery("select c.shopname, c.amountcurrency,c.point, c.unitcode, c.transdate,c.membercardid,c.txnid,b.businessid  from clubpoint c, businesslog b where c.sequenceid = b.possequence and clubid='00' and  c.membercardid='"+username+"'"); 




while (rs.next()){ 
out.println("<tr>"); 


out.println("<td>" + rs.getString(1) + "</td>"); 
out.println("<td>" + rs.getString(2) + "</td>"); 
out.println("<td>" + rs.getString(3) + "</td>"); 
out.println("<td>" + rs.getString(4) + "</td>"); 
out.println("<td>" + rs.getString(5) + "</td>"); 
out.println("<td>" + rs.getString(6) + "</td>");
out.println("<td>" + rs.getString(7) + "</td>");
out.println("<td>" + rs.getString(8) + "</td>");
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

