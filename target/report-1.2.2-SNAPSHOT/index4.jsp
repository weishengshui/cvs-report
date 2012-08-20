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


//每个merchant的消费总金额
stmt = conn.createStatement(); 

out.println("每个merchant的消费总金额<br>"); 
out.println("商户名称,"); 
out.println("定购积分类别,"); 
out.println("consume RMB,"); 
out.println("point ,"); 
out.println("point value,"); 
out.println("</br>"); 
rs = stmt.executeQuery("select sum(amountcurrency),  sum(point),merchantname,unitid from clubpoint where transdate >= {d '2009-05-01'} and transdate <= {d '2009-05-31'} and clubid='00'  GROUP by merchantname,unitid order by merchantname"); 
while (rs.next()){ 

out.println("" + rs.getString(3) + ","); 
out.println("" + rs.getString(4) + ","); 

out.println("" + rs.getString(1) + ","); 
out.println("" + rs.getDouble(2) + ","); 
out.println("" + rs.getDouble(2)*0.75 + ","); 

out.println("<br>"); 

} 
rs.close(); 


stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("Member consume detail report：：<br>"); 
rs = stmt.executeQuery("select shopname, amountcurrency,point, unitcode, transdate,effectivecardid from clubpoint where transdate >= {d '2009-05-01'} and transdate <= {d '2009-05-31'} and amountcurrency >0 and clubid ='00'  ORDER BY shopname"); 

while (rs.next()){ 


out.println("" + rs.getString(1) + ""); 
out.println("" + rs.getString(2) + ""); 
out.println("" + rs.getString(3) + ""); 
out.println("" + rs.getString(4) + ""); 
out.println("" + rs.getString(5) + ""); 
out.println("" + rs.getString(6) + ""); 

out.println("<br>"); 

} 
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

