<%@page import="com.chinarewards.report.template.ReportTemplateService"%>
<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.coastalcity.*"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ page import="java.util.Set"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>
<%@ taglib uri="/report-tags" prefix="rp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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

</script>

</head>

<body>

<%
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	String activity_id = request.getParameter("activity_id");
	ReportTemplateService service = new ReportTemplateService();
	
	out.println("<h2>明细报表结果</h2>");
	if(startDate==null || startDate.trim().length()==0){
		out.println("<h2>请先输入时间！</h2>");
		return;
	}
	if(endDate == null || endDate.trim().length()==0){
		out.println("<h2>请先输入时间！</h2>");
		return;
	}
	
%>

<%
	String shopId = request.getParameter("shopId");
	String shopId1 = request.getParameter("shopId1");
	int size = 20;
	int totalCount = 0;
	int pageCount = 0;
	if (shopId == null) {
		shopId = shopId1;
		totalCount = service.getDetailRecordesCount(startDate,
				endDate, shopId,activity_id);
		pageCount = totalCount % size == 0 ? (totalCount / size)
				: (totalCount / size + 1);
	} else {
		String strPageCount = request.getParameter("pageCount");
		if (strPageCount == null) {
			System.out
					.println("detailCountResult20120726.jsp if(strPageCount==null)");
			out.println("<p>没有数据可显示</p>");
			out.println("<br><br><br>");
			return;
		}
		totalCount = Integer.parseInt(request
				.getParameter("totalCount"));
		pageCount = Integer.parseInt(strPageCount);
	}

	if (pageCount == 0) {
		System.out
				.println("detailCountResult20120726.jsp if(pageCount ==0)");
		out.println("<p>没有数据可显示</p>");
		out.println("<br><br><br>");
		return;
	}
	String strPage = request.getParameter("page");
	int intPage = 0;
	if (strPage == null) {
		intPage = 1;
	} else {
		try{
			intPage = Integer.parseInt(strPage.trim());	
		}catch(Exception e){
			return ;
		}
		
	}
	if(intPage>pageCount){
		intPage = pageCount;
	}
	if(intPage<=0){
		intPage = 1;
	}
	List<List<String>> detailRecords = service
			.getDetailRecordsLists(startDate, endDate,activity_id, shopId, (intPage-1)*size,
					size);
	

	int j = 1;

	//明细报表
	try {
		
		if (detailRecords == null || detailRecords.size() == 0) {
			System.out
					.println("detailCountResult20120726.jsp if(actionHistoryVOs==null || actionHistoryVOs.size()==0)");
			out.println("<p>没有数据可显示</p>");
			out.println("<br><br><br>");
			return;
		}else{
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td width='10'>序号</td>");
		out.println("<td width='120'>商家名称</td>");
		out.println("<td width='120'>POS机编号</td>");
		out.println("<td width='120'>验证码</td>");
		out.println("<td width='120'>消费金额</td>");
		out.println("<td width='120'>交易时间</td>");
		out.println("</tr>");
		for(Iterator<List<String>> it1 = detailRecords.iterator();it1.hasNext();){
			List<String> record = it1.next();
			out.println("<tr>");
			out.println("<td>" + j++ + "</td>");
			for(int i=0;i<record.size();i++){
				if(i== record.size()-1){
					out.println("<td>" + record.get(i).substring(0,19) + "</td>");
				}else{
					out.println("<td>" + record.get(i) + "</td>");	
				}
				
			}
			out.println("</tr>");
		}
		out.println("</table>");
		detailRecords.clear();

		if (pageCount > 1) {
			%>
			<br>
			<table border="0" cellpadding="0" cellspacing="0"><tr valign="middle"><td valign="middle">
			<%
			int before = (intPage == 1) ? 1 : (intPage - 1);
			int next = (intPage == pageCount) ? pageCount : intPage + 1;
%>

<a
	href="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp?page=1&pageCount=<%=pageCount%>&startDate=<%=startDate%>&endDate=<%=endDate%>&shopId=<%=shopId%>&totalCount=<%=totalCount%>&activity_id=<%=activity_id %>">首页</a>

<%
	out.println("&nbsp;");
%>
<a
	href="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp?page=<%=before%>&pageCount=<%=pageCount%>&startDate=<%=startDate%>&endDate=<%=endDate%>&shopId=<%=shopId%>&totalCount=<%=totalCount%>&activity_id=<%=activity_id %>">上一页</a>
<%
	out.println("&nbsp;");
			if (pageCount <= 10) {
				for (int i = 1; i <= pageCount; i++) {
%>

<a
	href="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp?page=<%=i%>&pageCount=<%=pageCount%>&startDate=<%=startDate%>&endDate=<%=endDate%>&shopId=<%=shopId%>&totalCount=<%=totalCount%>&activity_id=<%=activity_id %>"><%=i%></a>
<%
	}
				out.println("&nbsp;");
			} else {
				if (intPage == 1) {
					for (int i = 1; i <= 10; i++) {
%>
<a
	href="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp?page=<%=i%>&pageCount=<%=pageCount%>&startDate=<%=startDate%>&endDate=<%=endDate%>&shopId=<%=shopId%>&totalCount=<%=totalCount%>&activity_id=<%=activity_id %>"><%=i%></a>
<%
	out.println("&nbsp;");
					}
					out.println("......");
					out.println("&nbsp;");

				} else if (intPage > 1) {
					out.println("......");
					out.println("&nbsp;");
					if (pageCount - intPage >= 9) {
						for (int i = intPage; i <= intPage + 9; i++) {
%>
<a
	href="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp?page=<%=i%>&pageCount=<%=pageCount%>&startDate=<%=startDate%>&endDate=<%=endDate%>&shopId=<%=shopId%>&totalCount=<%=totalCount%>&activity_id=<%=activity_id %>"><%=i%></a>
<%
	out.println("&nbsp;");
						}
						out.println("......");
						out.println("&nbsp;");

					} else {
						for (int i = pageCount - 9; i <= pageCount; i++) {
%>
<a
	href="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp?page=<%=i%>&pageCount=<%=pageCount%>&startDate=<%=startDate%>&endDate=<%=endDate%>&shopId=<%=shopId%>&totalCount=<%=totalCount%>&activity_id=<%=activity_id %>"><%=i%></a>
<%
	out.println("&nbsp;");

						}
					}
				}

			}
%>


<a
	href="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp?page=<%=next%>&pageCount=<%=pageCount%>&startDate=<%=startDate%>&endDate=<%=endDate%>&shopId=<%=shopId%>&totalCount=<%=totalCount%>&activity_id=<%=activity_id %>">下一页</a>
<%
	out.println("&nbsp;");
%>
<a
	href="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp?page=<%=pageCount%>&pageCount=<%=pageCount%>&startDate=<%=startDate%>&endDate=<%=endDate%>&shopId=<%=shopId%>&totalCount=<%=totalCount%>&activity_id=<%=activity_id %>">末页</a>
<%
	out.println("&nbsp;");
			out.println("第" + intPage + "页");
			out.println("&nbsp;");
			out.println("共" + pageCount + "页");
			out.println("&nbsp;");
			out.println("共" + totalCount + "条");
			out.println("&nbsp;");
%>
</td><td valign="middle">
<form action="<%=ctxRootPath%>/templateReport/detailResultStatementsTemplate.jsp" method="get" >
	<input type="hidden" name="pageCount" value="<%=pageCount%>">
	<input type="hidden" name="startDate" value="<%=startDate%>">
	<input type="hidden" name="endDate" value="<%=endDate%>">
	<input type="hidden" name="shopId" value="<%=shopId%>">
	<input type="hidden" name="totalCount" value="<%=totalCount%>">
	<input type="hidden" name="activity_id" value="<%=activity_id%>">
	<input type="text" name="page" size="3">
	<input type="submit" value="跳转">
	
</form>
</td></tr>
</table>
<%
		}
	}
		out.println("<br><br><br>");

	} catch (Exception e) {
		out.println(e);
	} finally {
		service = null;
	}
%>
</body>

</html>