<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.superpri.ProductItemCountForSuperPriService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.superpri.ProductItemCountForSuperPri"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<html>
<head>
<title>Operation</title>
<link rel="stylesheet" href="<%=ctxRootPath%>/css/ui.datepicker.css"
	type="text/css" />
<script type="text/javascript"
	src="<%=ctxRootPath%>/js/jquery/jquery-latest.js"></script>
<script type="text/javascript"
	src="<%=ctxRootPath%>/js/jquery/jquery.ui.i18n.all.js"></script>
<script type="text/javascript"
	src="<%=ctxRootPath%>/js/jquery/ui.datepicker.js"></script>
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
	String strStartFrom = request.getParameter("startFromDate");
	String strStartTo = request.getParameter("startDateTo");

	String strEndFrom = request.getParameter("endFromDate");
	String strEndTo = request.getParameter("endDateTo");

	String status = request.getParameter("status");

	int n = -1;

	if (status != null) {
		n = Integer.valueOf(status);
	}
%>
<form
	action="<%=ctxRootPath%>/superpri/productitemcountforsupper.jsp?cmd=1"
	method="post">
<table cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="2">超级优惠合同区间选择</td>
	</tr>
	
	<tr>
		<td width="280pix">&nbsp;&nbsp;&nbsp;合同开始时间从: <input id="startFromDate"
			name="startFromDate" value="<%=strStartFrom == null ? "" : strStartFrom%>" /> <span
			id="startDateMsg"></span> <script charset="utf-8">
					jQuery('#startFromDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
				</script>
		</td>
				
		<td width="280pix">&nbsp;&nbsp;&nbsp;合同开始时间到: <input id="startDateTo"
			name="startDateTo" value="<%=strStartTo == null ? "" : strStartTo%>"/> <span
			id="endDateMsg"></span> <script charset="utf-8">
					jQuery('#startDateTo').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
				</script>
		</td>
	</tr>
	
	<tr>
		<td width="280pix">&nbsp;&nbsp;&nbsp;合同结束时间从: <input id="endFromDate"
			name="endFromDate" value="<%=strEndFrom == null ? "" : strEndFrom%>"/> <span
			id="startDateMsg"></span> <script charset="utf-8">
					jQuery('#endFromDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
				</script>
		</td>
				
		<td width="280pix">&nbsp;&nbsp;&nbsp;合同结束时间到: <input id="endDateTo"
			name="endDateTo" value="<%=strEndTo == null ? "" : strEndTo%>" /> <span
			id="endDateMsg"></span> <script charset="utf-8">
					jQuery('#endDateTo').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
				</script>
		</td>
	</tr>
	
    <tr>
       <td>合同状态：</td>>
       <td>
<%
	if (status == null || ((status != null)) && status.equals("1")) {
%>
       <input type="radio" id='status' name="status" value = "1" checked="checked">进行中</input>
       <input type="radio" id ='status' name="status" value = "2">全部</input>
       <input type="radio" id='status' name="status" value = "3">未开始</input>
       <input type="radio" id='status' name="status" value = "4">已结束</input>
<%
	} else if (status.equals("2")) {
%>
       <input type="radio" id='status' name="status" value = "1" >进行中</input>
       <input type="radio" id ='status' name="status" value = "2" checked="checked">全部</input>
       <input type="radio" id='status' name="status" value = "3">未开始</input>
       <input type="radio" id='status' name="status" value = "4">已结束</input>
<%
	} else if (status.equals("3")) {
%>
       <input type="radio" id='status' name="status" value = "1" >进行中</input>
       <input type="radio" id ='status' name="status" value = "2" >全部</input>
       <input type="radio" id='status' name="status" value = "3" checked="checked">未开始</input>
       <input type="radio" id='status' name="status" value = "4">已结束</input>
<%
	} else if (status.equals("4")) {
%>
      <input type="radio" id='status' name="status" value = "1" >进行中</input>
       <input type="radio" id ='status' name="status" value = "2" >全部</input>
       <input type="radio" id='status' name="status" value = "3" >未开始</input>
       <input type="radio" id='status' name="status" value = "4" checked="checked">已结束</input>
<%
	}
%>

       </td>
    </tr>
	<tr align="center">
		<td colspan="2">
		<div align='center'><input type="submit" value="提交" /></div>
		</td>
	</tr>
</table>
</form>

<%
	String cmd = request.getParameter("cmd");
	if (cmd == null) {
		return;
	}

	//out.println("get Status is "+status);

	Calendar end = new GregorianCalendar();

	ProductItemCountForSuperPriService service = new ProductItemCountForSuperPriService();

	List<ProductItemCountForSuperPri> list = null;

	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");

	int j = 1;

	//商户消费总额
	try {
		list = service.getAllProductItemcountForSupperPriby(strStartFrom,
				strStartTo, status, strEndFrom, strEndTo);
		out.println("<h2>超级优惠消费总计报表</h2>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>超级优惠项</td>");
		out.println("<td>所属门市</td>");
		out.println("<td>是否结束</td>");
		out.println("<td>开始时间</td>");
		out.println("<td>结束时间</td>");
		out.println("<td>总消费次数</td>");
		out.println("<td>总积分数</td>");
		out.println("<td>总消费金额</td>");
		out.println("<td>已付款总消费次数</td>");
		out.println("<td>已付款总积分数</td>");
		out.println("<td>已付款总消费金额</td>");
		out.println("</tr>");

		for (int i = 0; i < list.size(); i++) {
			ProductItemCountForSuperPri vo = list.get(i);
			String valid = "";
			if (vo.isValid()) {
				valid = "是";
			} else {
				valid = "否";
			}
			out.println("<tr>");
			out.println("<td>" + (j++) + "</td>");
			out.println("<td>" + vo.getProductItemName() + "</td>");
			out.println("<td>" + vo.getShopName() + "</td>");
			out.println("<td>" + valid + "</td>");
			out.println("<td>" + format.format(vo.getBeginTime())
					+ "</td>");
			out.println("<td>" + format.format(vo.getEndTime())
					+ "</td>");
			out.println("<td>" + vo.getTotalDegree() + "</td>");
			out.println("<td>" + pointFormat.format(vo.getTotalPoint())
					+ "</td>");
			out.println("<td>" + moneyFormat.format(vo.getTotalMoney())
					+ "</td>");
			out.println("<td>" + vo.getPaidedTotalTime() + "</td>");
			out.println("<td>" + pointFormat.format(vo.getPaidedTotalPoint())
					+ "</td>");
			out.println("<td>" + moneyFormat.format(vo.getPaidedTotalMoney())
					+ "</td>");
			out.println("</tr>");
		}

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {
		list = null;
	}
%>

</body>
</html>