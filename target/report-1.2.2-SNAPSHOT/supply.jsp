<%--



 --%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.db.*, com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page contentType="text/html;charset=gb2312" %> 
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<html>
<head>
<title>��Ա�һ�����</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>


<body>
<%

String date=request.getParameter("date");
String mid=request.getParameter("mid");

DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");

%>
<% 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 


//�̻������ܶ�
try 
{ 

// obtain database connection.
conn = DbConnectionFactory.getInstance().getConnection("supply");




{
	stmt = conn.createStatement(); 
	 
	out.println("<h1>��Ʒ�һ���ʵʱ����:</h1>");
	out.println("<table border='1'>");
	out.println("<thead>");
	out.println("<tr>");  
	out.println("<th>#</th>");   
	out.println("<th>��Ʒ����</th>");   
	out.println("<th>�ܶһ���</th>");  
	out.println("</tr>"); 
	out.println("</thead>");
	
	rs = stmt.executeQuery("SELECT ap.merchandise_id, mer.mchnm, SUM(applyamount) AS applyamount_sum FROM applydetail ap, merchandise mer WHERE 1=1 AND ap.status !='4' and mer.id = ap.merchandise_id GROUP by ap.merchandise_id,mer.mchnm ORDER BY applyamount_sum DESC, mer.mchnm, ap.merchandise_id");
	
	out.println("<tbody>");
	long i = 1;
	while (rs.next()){ 
		out.println("<tr>");
		out.println("<td>"  + i + "</td>");
		out.println("<td>"  +rs.getString(2)+ "</td>");
		out.println("<td>"  +rs.getString(3)+ "</td>");
		out.println("</tr>");
		i++;
	}
	out.println("</tbody>");
	out.println("</table>"); 
	rs.close(); 
}



out.println("<br/>");



//
// ��Ʒ�һ�����ϸ��Ϣ
//
{
	out.println("<h1>��Ʒ�һ�����ϸ��Ϣ</h1>");
	out.println("<table border='1'>");
	out.println("<thead>");  
	out.println("<tr>");  
	out.println("<th>#</th>");   
	out.println("<th>��Ʒ����</th>");   
	out.println("<th>�һ�ʱ��</th>");
	out.println("<th>��Ա����</th>");   
	out.println("<th>����</th>");   
	out.println("<th>�һ���</th>");  
	out.println("<th>״̬<br/>��&lt;4:��ʾ���ڴ���<br/>=4: ��ʾʧ�ܣ�<br/>&gt;4: ��ʾ�һ��ɹ���</th>");  
	out.println("<th>�һ��ͷ�</th>");  
	out.println("</tr>"); 
	out.println("</thead>");
	
	rs = stmt.executeQuery("SELECT ap.merchandise_id, mer.mchnm, to_char(mp.applydt,'yyyy/mm/dd hh24:mm:ss'), ap.membername, ap.membercardcode, ap.applyamount, ap.status, ap.mchprice from applydetail ap , merchandise mer, memberapply mp WHERE 1=1 and mer.id = ap.merchandise_id and mp.id=ap.memberapply_id ORDER BY applydt DESC");
	
	out.println("<tbody>");
	long i = 1;
	while (rs.next()){ 
		out.println("<tr>");
		out.println("<td>" + i + "</td>");
		out.println("<td>" + rs.getString(2) + "</td>");
		out.println("<td>" + rs.getString(3) + "</td>");
		out.println("<td>" + rs.getString(4) + "</td>");
		out.println("<td>" + rs.getString(5) + "</td>");
		out.println("<td>" + rs.getString(6) + "</td>");
		out.println("<td>" + rs.getString(7) + "</td>");
		out.println("<td>" + rs.getString(8) + "</td>");
		out.println("</tr>");
		i++;
	}
	out.println("</tbody>");
	out.println("</table>"); 
	rs.close();
	
} // ��Ʒ�һ�����ϸ��Ϣ


} catch(Exception e) { 
	out.println(e); 
} finally {
	
	SqlUtil.close(conn);
	SqlUtil.close(stmt);
	SqlUtil.close(rs);
	
}


%>

