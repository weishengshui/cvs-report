<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<html>
<head>
<title>报表 </title>
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

<body>
<br/>
	<form action="<%=ctxRootPath%>/report.html?cmd=reportShop" method="post">
		<table cellpadding="0" cellspacing="0" >
			<tr>
				<td colspan="2">
				商户信息导出报表
				</td>
			</tr>
			<tr>
				<td width="280pix">
					&nbsp;&nbsp;&nbsp;开始时间:
					<input id="startDate" name="startDate" readonly="true" onblur="checkBirth('startDate', 'startDateMsg');" onchange="checkBirth('startDate', 'startDateMsg');"/>
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
					<input id="endDate" name="endDate" readonly="true" onblur="checkBirth('endDate', 'endDateMsg');" onchange="checkBirth('endDate', 'endDateMsg');"/>
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
				<select name="flag">
    				<option value="1" selected>按商户修改时间查</option>
					<option value="2" >按门市修改时间查</option>
					<option value="3" >按合同修改时间查</option>
				</select>
				</td>
			</tr>
			<tr align="center">
				<td colspan="2">
					<div align='center'>
					<input type="submit" value="导 出"/>
					</div>
				</td>
			</tr>
		</table>
	</form>
<br/>
</body>
</html>