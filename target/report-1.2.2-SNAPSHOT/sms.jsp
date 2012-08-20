<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* , java.text.*, javax.naming.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 
<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 
String sConnStr = "jdbc:oracle:thin:@10.1.1.105:1521:CR"; 

Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 

try 
{ 

Class.forName(sDBDriver); 
conn = DriverManager.getConnection(sConnStr,"posapp","posapp"); 
DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


stmt = conn.createStatement(); 
rs = stmt.executeQuery("select submitdate, destination, provider, providerused, failcount from SMSOUTBOX where status=3 order by submitdate desc");
%>
<table>
	<tr>
		<th>Submit Date</th>
		<th>Destination</th>
		<th>Provider</th>
		<th>Provider Last Used</th>
		<th>Fail Count</th>
	</tr>
<%
while (rs.next()){ 

	%>
	<tr>
		<td><%=df.format(rs.getTimestamp("submitdate"))%></td>
		<td><%=rs.getString("destination") %></td>
		<td><%=rs.getString("provider") %></td>
		<td><%=rs.getString("providerused") %></td>
		<td><%=rs.getInt("failcount") %></td>
	</tr>
	<%

}
%>
</table>
<%
rs.close(); 


}finally{
	if(conn!=null){
	    conn.close();
	    System.out.println("connection close....");
   }	
}


%>

