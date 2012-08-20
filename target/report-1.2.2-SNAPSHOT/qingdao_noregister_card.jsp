<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.text.*, java.util.*" %>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.data.crm.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<html>
<head>
<title>青岛未发卡报表 </title>
<link rel="stylesheet" href="<%=ctxRootPath%>/css/ui.datepicker.css" type="text/css" />
<script type="text/javascript" src="<%=ctxRootPath%>/js/jquery/jquery-latest.js"></script>
<script type="text/javascript" src="<%=ctxRootPath%>/js/jquery/jquery.ui.i18n.all.js"></script>
<script type="text/javascript" src="<%=ctxRootPath%>/js/jquery/ui.datepicker.js"></script>
<script type="text/javascript">
function checkBirth(date, dateMsg){
	var msg=document.getElementById(dateMsg);
	var birth =document.getElementById(date).value;
		if(birth.length==0){
			msg.innerHTML="请选择日期！";
			return false;
		}else{
	  	  	msg.innerHTML="";
			return true;
  	  	}
}



//获取当前格式化后的时间
function getNowFormatDate() {
   var day = new Date();
   var Year = 0;
   var Month = 0;
   var Day = 0;
   var CurrentDate = "";
   //初始化时间
   Year       = day.getFullYear();
   Month      = day.getMonth()+1;
   Day        = day.getDate();
   CurrentDate += Year + "/";
   if (Month >= 10 ){
     CurrentDate += Month + "/";
   }
   else{
     CurrentDate += "0" + Month + "/";
   }
   if (Day >= 10 ){
    CurrentDate += Day ;
   }
   else {
    CurrentDate += "0" + Day ;
   }
   return CurrentDate;
}

</script>
</head>
<%

String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");
if (startDate==null || "".equals(startDate)) {
	startDate = "";
}
if (endDate==null || "".equals(endDate)) {
	endDate = "";
}

%>
<body>
<br/>
	<form action="<%=ctxRootPath%>/qingdao_noregister_card.jsp" method="post">
		<table cellpadding="0" cellspacing="0" >
			<tr>
				<td colspan="2">
				青岛有消费但未发卡报表
				</td>
			</tr>
			<tr>
				<td width="280pix">
					&nbsp;&nbsp;&nbsp;开始时间:
					<input id="startDate" name="startDate" value="<%=startDate%>" readonly="true" onblur="checkBirth('startDate', 'startDateMsg');" onchange="checkBirth('startDate', 'startDateMsg');"/>
					<span id="startDateMsg"></span>
					<script charset="utf-8">
					jQuery('#startDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
					if (document.getElementById("startDate").value=="") 
					document.getElementById("startDate").value= getNowFormatDate();
				</script>
				</td>
				<td width="280pix">
					&nbsp;&nbsp;&nbsp;结束时间:
					<input id="endDate" name="endDate" value="<%=endDate%>" readonly="true" onblur="checkBirth('endDate', 'endDateMsg');" onchange="checkBirth('endDate', 'endDateMsg');"/>
					<span id="endDateMsg"></span>
					<script charset="utf-8">
					jQuery('#endDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
					if (document.getElementById("endDate").value=="")
					document.getElementById("endDate").value= getNowFormatDate();
				</script>
				</td>
			</tr>
			<tr align="center">
				<td colspan="2">
					<div align='center'>
					<input type="submit" value="查 询"/>
					</div>
				</td>
			</tr>
		</table>
	</form>
<br/>

<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
try {
	conn = DbConnectionFactory.getInstance().getConnection("crm");
	StringBuffer sql = new StringBuffer();
	sql.append(" select to_char(t.startdate, 'yyyy-mm-dd hh24:mi:ss') as dateStr, t.cardno ");
	sql.append(" from tempcard t , channel c, channeldelegator cd ");
	sql.append(" where t.channel_id= c.id and c.delegator_id= cd.id and cd.code='ccba' ");
	sql.append(" and t.startdate between to_date(?,'yyyy/mm/dd') and to_date(?,'yyyy/mm/dd') ");
	sql.append(" and t.status='activated' ");	
	sql.append(" order by to_char(t.startdate, 'yyyy-mm-dd hh24:mi:ss') ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1,startDate);
	pstmt.setString(2,endDate);
	rs = pstmt.executeQuery();

%>
<table>
  <tr bgcolor="#A6D5FF"> 
    <td width="40%" align="center">首次发现时间</td>
    <td align="center">卡号(有消费但未注册)</td>
  </tr>
  <%
  while (rs.next()) {
 %>
  <tr bgcolor="#FFFFFF"> 
    <td align="center"><%=rs.getString("dateStr")%></td>
    <td align="center"><%=rs.getString("cardNo")%></td>
    </tr>
  <%}%>
</table>
<br>
<%

} catch(Exception e) {
	e.printStackTrace();
}finally {
	SqlUtil.close(rs);
	SqlUtil.close(pstmt);
	SqlUtil.close(conn);
}
	
%>
<br><br>
</body>
</html>