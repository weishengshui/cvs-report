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
//�̻������ܶ�
try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 


out.println("<br>"); 
out.println("<br>"); 
out.println("���ܻ��ܱ���������ʾ���ܺͱ��ܵ��̻����ѻ�����Ϣ"); 
out.println("<br>"); 
out.println("<br>"); 
//ÿ��merchant�������ܽ��
stmt = conn.createStatement(); 

out.println("2009-11-29 to 2009-12-05 �̻������ѻ���<br>"); 
rs = stmt.executeQuery("select sum(amountcurrency),  sum(point),merchantname from clubpoint where transdate >={d '2009-11-29'} and transdate <={d '2009-12-05'} and clubid='00'   and merchantname not like '%����ͨ%' GROUP by merchantname");
out.println("<table border='1'>");
out.println("<tr>");
out.println("<td>�����ܽ��</td>"); 
out.println("<td>�̻�</td>"); 
out.println("<td>������ͷ�</td>"); 

out.println("</tr>");
while (rs.next()){
	out.println("<tr>");
out.println("<td>" + rs.getString(1) + "</td>"); 
out.println("<td>" + rs.getString(3) + "</td>"); 
out.println("<td>" + rs.getString(2) + "</td>"); 

out.println("</tr>"); 

} 
out.println("</table>");
rs.close(); 

out.println("<br>"); 
out.println("<br>"); 
out.println("<br>"); 

//ÿ��merchant�������ܽ��
stmt = conn.createStatement(); 

out.println("2009-12-06 to 2009-12-12 �̻������ѻ���<br>"); 
rs = stmt.executeQuery("select sum(amountcurrency),  sum(point),merchantname from clubpoint where transdate >={d '2009-12-06'} and transdate <={d '2009-12-12'} and clubid='00'   and merchantname not like '%����ͨ%' GROUP by merchantname");
out.println("<table border='1'>");
out.println("<tr>");
out.println("<td>�����ܽ��</td>"); 
out.println("<td>�̻�</td>"); 
out.println("<td>������ͷ�</td>"); 

out.println("</tr>");
while (rs.next()){
	out.println("<tr>");
out.println("<td>" + rs.getString(1) + "</td>"); 
out.println("<td>" + rs.getString(3) + "</td>"); 
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

