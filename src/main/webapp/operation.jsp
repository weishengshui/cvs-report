<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.db.*, com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page contentType="text/html;charset=gb2312" %> 
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<html>
<head>
<title>Operation</title>
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
  
   
   if (Month >= 10 ){
     CurrentDate += Month + "/";
   }
   else{
     CurrentDate += "0" + Month + "/";
   }
   if (Day >= 10 ){
    CurrentDate += Day + "/";
   }
   else {
    CurrentDate += "0" + Day + "/";
   }

   CurrentDate += Year ;
   return CurrentDate;
}

</script>
</head>


<body>

<%
  String strStart = request.getParameter("startDate");
  String strEnd = request.getParameter("endDate");
  String mch = request.getParameter("mch");

  if(strStart == null)
	  strStart = "";
  if(strEnd == null)
	  strEnd = "";
  if(mch == null)
	  mch = "";

%>
<form action="<%=ctxRootPath%>/operation.jsp?cmd=1" method="post">
		<table cellpadding="0" cellspacing="0" >
			<tr>
				<td colspan="2">
				会员信息导出报表
				</td>
			</tr>
			<tr>
				<td width="280pix">
					&nbsp;&nbsp;&nbsp;开始时间:
					<input id="startDate" name="startDate" value="<%=strStart%>" readonly="true" onblur="checkBirth('startDate', 'startDateMsg');" onchange="checkBirth('startDate', 'startDateMsg');"/>
					<span id="startDateMsg"></span>
					<script charset="utf-8">
					jQuery('#startDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
					document.getElementById("startDate").value= getNowFormatDate();
				</script>
				</td>
				<td width="280pix">
					&nbsp;&nbsp;&nbsp;结束时间:
					<input id="endDate" name="endDate" value="<%=strEnd%>"  readonly="true" onblur="checkBirth('endDate', 'endDateMsg');" onchange="checkBirth('endDate', 'endDateMsg');"/>
					<span id="endDateMsg"></span>
					<script charset="utf-8">
					jQuery('#endDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
					document.getElementById("endDate").value= getNowFormatDate();
				</script>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				&nbsp;&nbsp;&nbsp;商户名称:
    				<input type='text' id = 'mch' name='mch' value="<%=mch%>" ></input>
				</td>
			</tr>
			<tr align="center">
				<td colspan="2">
					<div align='center'>
					<input type="submit" value="提交"/>
					</div>
				</td>
			</tr>
		</table>
	</form>

<% 

     String cmd = request.getParameter("cmd");
 	 if(cmd == null)
 	 {
 		 return;
 	 }
 	 

//if (true) throw new ServletException("This report is disabled.");

//formatting


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

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
DecimalFormat moneyIntFormat = new DecimalFormat("#,##0");


Connection conn = null; 
ResultSet rs = null; 
Statement stmt = null; 

try 
{ 
//obtain database connection.


/*out.println("<br>"); 
out.println("<br>"); 
out.println("<br>");
//每个门市的消费总金额
stmt = conn.createStatement(); 

out.println("每个门市的消费总金额<br>"); 
rs = stmt.executeQuery("select sum(amountcurrency),shopname from clubpoint where transdate >{d '2009-05-15'} and clubid='00'  and merchantname not like '%积享通%' GROUP by shopname"); 
while (rs.next()){ 

	out.println("<table border='1'>");
	while (rs.next()){
		out.println("<tr>");
	out.println("<td>" + rs.getString(2) + "</td>"); 
	out.println("<td>" + rs.getString(1) + "</td>"); 


	out.println("</tr>"); 

	} 
	out.println("</table>");

} 
rs.close(); 

out.println("<br>"); 
out.println("<br>"); 

//每个merchant的消费总金额
stmt = conn.createStatement(); 

out.println("每个merchant的消费总金额<br>"); 
rs = stmt.executeQuery("select sum(amountcurrency),  sum(point),merchantname from clubpoint where transdate >{d '2009-05-15'} and clubid='00'   and merchantname not like '%积享通%' GROUP by merchantname");
out.println("<table border='1'>");
while (rs.next()){
	out.println("<tr>");
out.println("<td>" + rs.getString(1) + "</td>"); 
out.println("<td>" + rs.getString(3) + "</td>"); 
out.println("<td>" + rs.getString(2) + "</td>"); 

out.println("</tr>"); 

} 
out.println("</table>");
rs.close(); 


//每个竞拍品的竞拍次数
stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("每个竞拍品的竞拍次数：：<br>"); 
rs = stmt.executeQuery("select sum(version) ,auctionprizename from auctionrecord where 1=1 group by auctionprizename"); 
while (rs.next()){ 

out.println("" + rs.getString(2) + ""); 
out.println("" + rs.getInt(1) + ""); 
out.println("<br>"); 

} 
rs.close(); 



//已经完成的抽奖次数
stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("已经完成的抽奖次数：：<br>"); 
rs = stmt.executeQuery("select count(*) from luckydrawticket where isluckydraw ='1'"); 
while (rs.next()){ 

//out.println("" + rs.getString(2) + ""); 
out.println("" + rs.getInt(1) + ""); 
out.println("<br>"); 

} 
rs.close(); 


//没有抽奖的次数
stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("没有抽奖的次数：：<br>"); 
rs = stmt.executeQuery("select count(*) from luckydrawticket where isluckydraw ='0'"); 
while (rs.next()){ 

//out.println("" + rs.getString(2) + ""); 
out.println("" + rs.getInt(1) + ""); 
out.println("<br>"); 

} 
rs.close(); 


//获得了贴纸的总人数
stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("获得了贴纸的总人数：：<br>"); 
rs = stmt.executeQuery("select count(*) from pasterofmember where time >{d '2009-05-15'}"); 
while (rs.next()){ 

//out.println("" + rs.getString(2) + ""); 
out.println("" + rs.getInt(1) + ""); 
out.println("<br>"); 

} 
rs.close(); 




//获得了贴纸,但是没有抽奖机会的总人数
stmt = conn.createStatement(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("获得了贴纸,但是没有抽奖机会的总人数：：<br>"); 
rs = stmt.executeQuery("select count(*) from pasterofmember where time >{d '2009-05-15'} and luckydrawticket_id =null"); 

while (rs.next()){ 

//out.println("" + rs.getString(2) + ""); 
out.println("" + rs.getInt(1) + ""); 
out.println("<br>"); 

} 
rs.close(); 
out.println("<br>"); 
out.println("<br>"); 
out.println("<br>"); 



*/

/*

select shopname, amountcurrency,point unitcode, producttypename from clubpoint 
where transdate > {d '2009-05-15'}
and amountcurrency >'2'
and clubid ='00'
ORDER BY shopname
*/
// to_date('2010/12/31','yyyy/mm/dd')

//  String mch = request.getParameter("mch");
String format = "'mm/dd/yyyy'";
String from = "to_date('".concat(strStart).concat("',").concat(format).concat(")");
String to = "to_date('".concat(strEnd).concat("',").concat(format).concat(")");

out.println("<h1>Member consume detail report</h1>");
String head = "select c.shopname, c.amountcurrency, c.point, c.unitcode, to_char(c.transdate,'yyyy/mm/dd hh24:mi:ss'),c.membercardid,c.effectivecardid,c.merchantname,b.businessid,c.productTypeName from clubpoint c, businesslog b where c.transdate > ";
String tail = " and  c.sequenceid = b.possequence  and c.clubid ='00'   and c.merchantname not like '%积享通%' ORDER BY c.shopname,c.transdate ";

StringBuffer sqlbuf = new StringBuffer(1024);
sqlbuf.append(head).append(from);
sqlbuf.append(" and c.transdate <=").append(to);

if(mch != null && (!"".equals(mch)))
{
	sqlbuf.append(" and (c.shopname like '%").append(mch).append("%'");
	sqlbuf.append(" or c.merchantname like '%").append(mch).append("%')");
}

sqlbuf.append(tail);

System.out.println("operation sql buffer is "+sqlbuf.toString());

conn = DbConnectionFactory.getInstance().getConnection("posapp");
stmt = conn.createStatement(); 
rs = stmt.executeQuery(sqlbuf.toString());
		 
out.println("<table border='1'>");
out.println("<thead>");
out.println("<tr>");
out.println("<th>商户/门市</th>");
out.println("<th>消费类型</th>");
out.println("<th>消费金额</th>");
out.println("<th>积分</th>");
out.println("<th>积分类型</th>");
out.println("<th>交易日期</th>");
out.println("<th>卡号/手机号</th>");
out.println("<th>普卡卡号</th>");
out.println("<th>Business ID</th>");
out.println("</tr>");
out.println("</thead>");
// result
out.println("<tbody>");
while (rs.next()){ 
out.println("<tr>");

if(rs.getString(1)!=null){
	out.println("<td>" + rs.getString("shopname") + "</td>");
}else {
	out.println("<td>" + rs.getString("merchantname") + "</td>");
}
out.println("<td>" + rs.getString("productTypeName") + "</td>");
out.println("<td class='amount'>" + moneyFormat.format(rs.getDouble("amountcurrency")) + "</td>"); 
out.println("<td class='amount'>" + pointFormat.format(rs.getDouble("point")) + "</td>");
out.println("<td>" + rs.getString("unitcode") + "</td>");
out.println("<td>" + rs.getString(5) + "</td>");
out.println("<td>" + rs.getString("membercardid") + "</td>");
out.println("<td>" + rs.getString("effectivecardid") + "</td>");
out.println("<td>" + rs.getString("businessid") + "</td>");

out.println("</tr>");

} 
out.println("</tbody>");
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

</body>
</html>