<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 
<%@include file="checklogin.jsp" %>
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


//�̻������ܶ�
try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 



stmt = conn.createStatement(); 


out.println("<h2>�����ǻ�����ܱ���:</h2>");
out.println("<table border='1'>");
out.println("<tr>");  
   
out.println("<td>�����ѽ��</td>");
out.println("<td>�����ѻ���</td>");
out.println("<td>�����Ѵ���</td>");
out.println("</tr>"); 
rs = stmt.executeQuery("select  sum(amountcurrency),sum(point), SUM(posdegree) from clubpoint where 1=1 and clubid='00' and amountcurrency >'2' and transdate >={d '2009-09-05'} and shopid in ('221','323','423','124','426','125','220','324','329','133','134','135','136','437','225','433','438','231','440','212','230')");


while (rs.next()){ 
out.println("<tr>");
out.println("<td>"  +rs.getString(1)+ "</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("</tr>"); 

}
out.println("</table>"); 
rs.close(); 

out.println("<h2>�����ǻ���Ѱ����б���:</h2>");
out.println("<table border='1'>");
out.println("<tr>");  
out.println("<td>��������</td>");   
out.println("<td>�����ѽ��</td>");
out.println("<td>�����ѻ���</td>");
out.println("<td>�����Ѵ���</td>");
out.println("</tr>"); 
rs = stmt.executeQuery("select  shopname ,sum(amountcurrency),sum(point), SUM(posdegree) from clubpoint where 1=1 and clubid='00' and amountcurrency >'2' and transdate >={d '2009-09-05'} and shopid in ('221','323','423','124','426','125','220','324','329','133','134','135','136','437','225','433','438','231','440','212','230') GROUP by shopname");


while (rs.next()){ 
out.println("<tr>");
out.println("<td>"  +rs.getString(1)+ "</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");
out.println("</tr>"); 

}
out.println("</table>"); 
rs.close(); 






out.println("<h2>�����ǻ������ϸ����100Ԫ�ģ�:</h2>");
out.println("<table border='1'>");
out.println("<tr>");  
out.println("<td>����</td>");   
out.println("<td>ʱ��</td>");
out.println("<td>���ѽ��</td>");   
out.println("<td>����</td>");  
out.println("<td>card number</td>"); 
out.println("</tr>"); 
rs = stmt.executeQuery("select  shopname , to_char(transdate,'yyyy/mm/dd hh24:mi:ss'), amountcurrency, point,membercardid  from clubpoint where 1=1 and clubid='00'  and amountcurrency >'2' and transdate >={d '2009-09-05'} and shopid in ('221','323','423','124','426','125','220','324','329','133','134','135','136','437','225','433','438','231','440','212','230') and amountcurrency>=100 order by transdate desc");


while (rs.next()){ 
out.println("<tr>");
out.println("<td>"  +rs.getString(1)+ "</td>");
out.println("<td>"  +rs.getString(2)+ "</td>");
out.println("<td>"  +rs.getString(3)+ "</td>");
out.println("<td>"  +rs.getString(4)+ "</td>");
out.println("<td>"  +rs.getString(5)+ "</td>");

out.println("</tr>"); 

}
out.println("</table>"); 
rs.close(); 





out.println("<h2>�����ǻ���Ѱ���Ա����:</h2>");
out.println("<table border='1'>");
out.println("<tr>");  
out.println("<td>��Ա</td>");  
out.println("<td>����</td>");  
out.println("<td>����</td>");   
out.println("<td>ʱ��</td>");
out.println("<td>���ѽ��</td>");   
out.println("<td>����</td>");  
out.println("</tr>"); 
rs = stmt.executeQuery("select tempmembertxid, membercardid,shopname,to_char(transdate,'yyyy/mm/dd hh24:mi:ss'), amountcurrency, point   from clubpoint where 1=1 and clubid='00' and amountcurrency >'2' and transdate >={d '2009-09-05'} and shopid in ('221','323','423','124','426','125','220','324','329','133','134','135','136','437','225','433','438','231','440','212','230') and amountcurrency>=2 order by tempmembertxid, transdate");

String txid = "";
while (rs.next()){ 
	out.println("<tr>");
	if(!txid.equals(rs.getString(1))){
		txid=rs.getString(1);
		out.println("<td>"  +rs.getString(1)+ "</td>");
	}else{
		out.println("<td>"  + "</td>");
	}
	


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

