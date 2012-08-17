<%@page import="java.net.URLDecoder"%>
<%@page import="com.chinarewards.report.template.ReportTemplateService"%>
<%@page import="java.util.Date"%>
<%@page import="org.jfree.chart.axis.CategoryLabelPositions"%>
<%@page import="org.jfree.chart.axis.CategoryAxis"%>
<%@page import="org.jfree.chart.plot.XYPlot"%>
<%@page import="org.jfree.chart.axis.DateAxis"%>
<%@page import="org.jfree.chart.axis.ValueAxis"%>
<%@page import="javax.swing.ImageIcon"%>
<%@page import="java.awt.Image"%>
<%@page import="java.awt.Color"%>
<%@page import="org.jfree.chart.servlet.ServletUtilities"%>
<%@page import="org.jfree.chart.plot.PlotOrientation"%>
<%@page import="org.jfree.chart.ChartFactory"%>
<%@page import="org.jfree.chart.title.LegendTitle"%>
<%@page import="org.jfree.chart.axis.Axis"%>
<%@page import="org.jfree.chart.plot.CategoryPlot"%>
<%@page import="java.awt.Font"%>
<%@page import="org.jfree.data.category.DefaultCategoryDataset"%>
<%@page import="org.jfree.chart.JFreeChart"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.coastalcity.*"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>

<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

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
function checkDate(){
	var strStartFrom = document.getElementById("startFromDate").value;
	var strStartTo = document.getElementById("startDateTo").value;
	if(strStartFrom == null || strStartTo== null){
		alert("请选择时间！");
		return false;
		}
	return true;
}
</script>
</head>


<body>

<%
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	String activity_id = request.getParameter("activity_id");
	System.out.println("startDate: " + startDate);
	System.out.println("endDate: " + endDate);
	System.out.println("activity_id: " + activity_id);
	String activity_name = request.getParameter("activity_name");
	activity_name = new String(activity_name.getBytes("ISO-8859-1"),
			"UTF-8");
	//activity_name = URLDecoder.decode(activity_name,"UTF-8");
	System.out.println("activity_name: " + activity_name);
	String activityname = URLEncoder.encode(activity_name, "UTF-8");
	if (startDate == null || startDate.trim().length() == 0)
		return;

	if (endDate == null || endDate.trim().length() == 0)
		return;

	out.println("<h2>总计报表</h2>");
%>

<form
	action="<%=ctxRootPath%>/templateReport/totalStatementsTemplate.jsp?cmd=1&activity_name=<%=activityname%>"
	method="post" onsubmit="return checkDate();">
<table cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="2">时间区间选择</td>
	</tr>

	<tr>
		<td width="280pix">&nbsp;&nbsp;&nbsp;时间从: <input id="startDate"
			name="startDate" value="<%=startDate == null ? "" : startDate%>" />
		<span id="startDateMsg"></span> <script charset="utf-8">
					jQuery('#startDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
				</script></td>

		<td width="280pix">&nbsp;&nbsp;&nbsp;时间到: <input id="endDate"
			name="endDate" value="<%=endDate == null ? "" : endDate%>" /> <span
			id="endDateMsg"></span> <script charset="utf-8">
					jQuery('#endDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
					</script></td>
	</tr>

	<tr align="center">
		<td colspan="2"><input type="hidden" name="activity_id"
			value="<%=activity_id%>">
		<div align='center'><input type="submit" value="提交" /></div>
		</td>
	</tr>
</table>
</form>

<%!public void printExchangeTypeTitle(List<String> exchangeTypes, JspWriter out)
			throws Exception {
		for (Iterator<String> it = exchangeTypes.iterator(); it.hasNext();) {
			out.println("<td width='100'>" + (String) it.next() + "总数</td>");
		}
	}%>



<%
	String cmd = request.getParameter("cmd");
	if (cmd == null) {
		return;
	}

	ReportTemplateService service = new ReportTemplateService();

	List<String> exchangeTypes = service.getExchangeTypes(activity_id);

	List<Object> totalStatements = service.getTotalStatements(
			startDate, endDate, activity_id);
	Map<String, List<Object>> totalStatementsEveryDay = service
			.getTotalStatementsEveryDay(startDate, endDate, activity_id);

	int j = 1;
	final Font font = new Font("宋体", Font.PLAIN, 15);
	String fileName = "";
	DefaultCategoryDataset dataset = null;
	DefaultCategoryDataset amountDataset = null;
	JFreeChart chart = null;

	try {
		
		if(exchangeTypes==null || exchangeTypes.size()==0){
			out.println("<br><br>没有数据可显示<br><br>");
		}else{
			
		
		//总计报表
		if (totalStatements == null) {
			out.println("没有数据可显示");
		} else {
			out.println("<table border='1'>");

			out.println("<tr>");
			printExchangeTypeTitle(exchangeTypes, out);
			out.println("</tr>");

			out.println("<tr>");
			for (Iterator<Object> it = totalStatements.iterator(); it
					.hasNext();) {
				out.println("<td width='100'>" + it.next().toString()
						+ "</td>");
			}
			totalStatements.clear();
			out.println("</tr>");
			out.println("</table>");
		}

		out.println("<br><br>");

		
		j = 1;
		int exchangeTypesCount = exchangeTypes.size();
		//每日报表
		out.println("<h2>每日总计报表</h2>");
		if (totalStatementsEveryDay == null) {
			out.println("没有数据可显示");
		} else {
			String[] weekday = { "", "星期日", "星期一", "星期二", "星期三", "星期四",
					"星期五", "星期六" };

			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td>序号</td>");
			out.println("<td align='center'>Date" + "<br>"
					+ "(yyyy / mm / dd)</td>");
			out.println("<td align='center'>Weekday / " + "<br>"
					+ "WK.of Yr.</td>");
			printExchangeTypeTitle(exchangeTypes, out);
			out.println("<td>消费总金额</td>");
			out.println("</tr>");
			Set<String> days = totalStatementsEveryDay.keySet();

			//生成表格及折线图
			dataset = new DefaultCategoryDataset();
			amountDataset = new DefaultCategoryDataset();
			List<String> predayStatementList = new ArrayList<String>(
					days);
			int predayRecordsCount = predayStatementList.size();
			//每几天统计一次
			int index = (predayRecordsCount - 1) / 10 + 1;
			double[] totalcountwithType = new double[exchangeTypesCount+1];
			for (int i = 0, dayIndex = 0; i < predayRecordsCount; i++) {

				out.println("<tr>");
				out.println("<td>" + (j++) + "</td>");
				String day_table = predayStatementList.get(i);
				SimpleDateFormat sdf = new SimpleDateFormat(
						"yyyy/MM/dd");
				Date tsDate = sdf.parse(day_table);
				Calendar cal = Calendar.getInstance();
				cal.setTime(tsDate);
				String dayOfWeekString = "";
				String weekendColor = "white";
				int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
				int weekOfYear = cal.get(Calendar.WEEK_OF_YEAR);
				switch (dayOfWeek) {
				case Calendar.SUNDAY:
					dayOfWeekString = weekday[Calendar.SUNDAY];
					weekendColor = "red";
					break;
				case Calendar.MONDAY:
					dayOfWeekString = weekday[Calendar.MONDAY];
					break;
				case Calendar.TUESDAY:
					dayOfWeekString = weekday[Calendar.TUESDAY];
					break;
				case Calendar.WEDNESDAY:
					dayOfWeekString = weekday[Calendar.WEDNESDAY];
					break;
				case Calendar.THURSDAY:
					dayOfWeekString = weekday[Calendar.THURSDAY];
					break;
				case Calendar.FRIDAY:
					dayOfWeekString = weekday[Calendar.FRIDAY];
					break;
				case Calendar.SATURDAY:
					weekendColor = "#18ecff";
					dayOfWeekString = weekday[Calendar.SATURDAY];
					break;
				}
				out.println("<td>" + day_table + "</td>");
				out.println("<td bgcolor='" + weekendColor + "'>"
						+ dayOfWeekString + " / " + weekOfYear
						+ "</td>");
				List<Object> aRecordForAmount = totalStatementsEveryDay
						.get(day_table);
				for (int k = 0; k < aRecordForAmount.size(); k++) {
						double count = (Double) aRecordForAmount.get(k);
						totalcountwithType[k]+=count;
						if(k != aRecordForAmount.size()-1){
							out.println("<td>" + (int)count + "</td>");
						}else{
						out.println("<td>" + count + "</td>");
						}
				}
				out.println("</tr>");

				//初始化折线图
				//某一时间段内，各种交易的数量
				if (dayIndex >= predayRecordsCount) {
				} else {
					double[] tmpExCount = new double[exchangeTypesCount+1];
					String day = "";
					String sday = predayStatementList.get(dayIndex);
					day = sday.substring(5, 10);
					List<Object> daycount = totalStatementsEveryDay
							.get(sday);
					for (int countIndex = 0; countIndex < daycount
							.size(); countIndex++) {
							tmpExCount[countIndex] += (Double) daycount
							.get(countIndex);
					}
					if (index > 1) {
						String eday = predayStatementList.get(dayIndex
								+ index - 1);
						if (sday.subSequence(5, 7).equals(
								eday.subSequence(5, 7))) {
							day += "-" + eday.substring(8, 10);
						} else {
							day += "-" + eday.substring(5, 10);
						}
						daycount = totalStatementsEveryDay.get(eday);
						for (int countIndex = 0; countIndex < daycount
								.size(); countIndex++) {
								tmpExCount[countIndex] += (Double) daycount
								.get(countIndex);
						}
					}
					for (int k = 1; k < index - 1; k++) {
						String tday = predayStatementList.get(dayIndex
								+ k);
						daycount = totalStatementsEveryDay.get(tday);
						for (int countIndex = 0; countIndex < daycount
								.size(); countIndex++) {
								tmpExCount[countIndex] += (Double)daycount.get(countIndex);
						}
					}
					for (int k = 0; k < exchangeTypesCount+1; k++) {
						if(k==exchangeTypesCount){
							amountDataset.addValue(tmpExCount[k],day,day);							
						}else{
							dataset.addValue(tmpExCount[k],
								exchangeTypes.get(k), day);
						}
					}
					dayIndex += index;
					if (predayRecordsCount - dayIndex < index) {
						index = predayRecordsCount - dayIndex;
					}

				}

			}
			out.println("<tr>");
			out.println("<td colspan='3' align='center'>总计</td>");
			for(int i=0;i<exchangeTypesCount+1;i++){
				if(i==exchangeTypesCount){
				out.println("<td>"+new DecimalFormat("0.00").format(totalcountwithType[i])+"</td>");
				}else{
					out.println("<td>"+(int)totalcountwithType[i]+"</td>");
				}
			}
			out.println("</tr>");
			out.println("</table>");
			chart = ChartFactory.createLineChart(activity_name
					+ "----按日统计", "日期", "交易数量", dataset,
					PlotOrientation.VERTICAL, true, false, false);
			setLineChartProperties(chart, font);
			fileName = ServletUtilities.saveChartAsPNG(chart, 800, 600,
					session);
			
		
%>
<br>
<table>
	<tr>
		<td>
		<br>
		<img alt=""
			src="<%=ctxRootPath%>/servlet/DisplayChart?filename=<%=fileName%>">
		<br>
		</td>
	</tr>
	<%
	 chart = ChartFactory.createBarChart3D(activity_name+"----按日统计","","金额",amountDataset,PlotOrientation.VERTICAL,false,false,false);
	setBarChartProperties(chart,font);
	fileName = ServletUtilities.saveChartAsPNG(chart, 800, 600,
			session);
	
	%>
	<tr>
		<td>
		<br>
		<img alt=""
			src="<%=ctxRootPath%>/servlet/DisplayChart?filename=<%=fileName%>">
		<br>
		</td>
	</tr>
</table>
<%
	}
	out.println("<br><br>");

		
		//商户总计报表，根据交易的类型进行分类
		for(Iterator<String> it = exchangeTypes.iterator();it.hasNext();){
			j=1;
			String exchangeType = it.next();
			Map<String, List<Object>> merchantStatementsWithType = service.getMerchantTotalStatementsWithExchangeType(startDate,endDate,activity_id,exchangeType);
			if(merchantStatementsWithType!=null && merchantStatementsWithType.size()>0){
				Set<String> merchantSet = merchantStatementsWithType.keySet();
				out.println("<h2>商户报表("+exchangeType+")</h2>");
				out.println("<table border='1'>");
				out.println("<tr>");
				out.println("<td>序号</td>");
				out.println("<td>商户名称</td>");
				out.println("<td>"+exchangeType+"总数</td>");
				out.println("<td>消费总金额</td>");
				out.println("<td>POS机编号 | 交易类型 | 交易次数</td>");
				out.println("</tr>");
				
				//消费金额图
				amountDataset =null;
				//交易数量图
				dataset = null;
				
				double[] totalCount = new double[3];
				if(merchantSet.size()>5){
					amountDataset = new DefaultCategoryDataset();
					dataset = new DefaultCategoryDataset();
					for(Iterator<String> it2 = merchantSet.iterator();it2.hasNext();){
						out.println("<tr>");
						String merchant = it2.next();
						List<Object> countAmountList = merchantStatementsWithType.get(merchant);
						int count = (Integer)countAmountList.get(0);
						double amount = (Double)countAmountList.get(1);
						totalCount[0] +=count;
						totalCount[1] += amount;
						amountDataset.addValue(amount,merchant,merchant);
						dataset.addValue(count,merchant,merchant);
						Map<String,Integer> posMap = (Map<String,Integer>)countAmountList.get(2);
						out.println("<td>"+(j++)+"</td>");
						out.println("<td>"+merchant+"</td>");
						out.println("<td>"+count+"</td>");
						out.println("<td>"+amount+"</td>");
						out.println("<td>");
						Set<String> posSet = posMap.keySet();
						if(posSet != null || posSet.size() >0){
						for(Iterator<String> it3 = posSet.iterator();;){
							totalCount[2]+=1;
							String posid = it3.next();
							int posCount = (Integer)posMap.get(posid);
							out.println(posid+" | "+exchangeType+" | "+posCount);
							if(it3.hasNext()){
								out.println("<br>");
							}else{
								break;
							}
						}
						}
						out.println("</td>");
						out.println("</tr>");
					}
				}else{
				for(Iterator<String> it2 = merchantSet.iterator();it2.hasNext();){
					out.println("<tr>");
					String merchant = it2.next();
					List<Object> countAmountList = merchantStatementsWithType.get(merchant);
					int count = (Integer)countAmountList.get(0);
					double amount = (Double)countAmountList.get(1);
					totalCount[0] +=count;
					totalCount[1] += amount;
					Map<String,Integer> posMap = (Map<String,Integer>)countAmountList.get(2);
					
					out.println("<td>"+(j++)+"</td>");
					out.println("<td>"+merchant+"</td>");
					out.println("<td>"+count+"</td>");
					out.println("<td>"+amount+"</td>");
					out.println("<td>");
					Set<String> posSet = posMap.keySet();
					if(posSet != null || posSet.size() >0){
						for(Iterator<String> it3 = posSet.iterator();;){
							totalCount[2]+=1;
							String posid = it3.next();
							int posCount = (Integer)posMap.get(posid);
							out.println(posid+" | "+exchangeType+" | "+posCount);
							if(it3.hasNext()){
								out.println("<br>");
							}else{
								break;
							}
						}
						}
					out.println("</td>");
					out.println("</tr>");
				}
				}
				out.println("<tr>");
				out.println("<td colspan='2' align='center'>总计</td>");
				out.println("<td>"+(int)totalCount[0]+"</td>");
				out.println("<td>"+ new DecimalFormat("0.00").format(totalCount[1]) +"</td>");
				out.println("<td>共 "+(int)totalCount[2]+" 台POS机</td>");
				out.println("</tr>");
				out.println("</table>");
				if(dataset!=null && amountDataset!=null){
					int x_length = (merchantStatementsWithType.size()*35<800)?800:merchantStatementsWithType.size()*35;
					chart = ChartFactory.createBarChart3D(activity_name+"("+exchangeType+")","","金额",amountDataset,PlotOrientation.VERTICAL,false,false,false);
					setBarChartProperties(chart,font);
					fileName = ServletUtilities.saveChartAsPNG(chart,x_length,600,session);
					chart = ChartFactory.createBarChart3D(activity_name+"("+exchangeType+")","","交易数量",dataset,PlotOrientation.VERTICAL,false,false,false);
					setBarChartProperties(chart,font);
					String filename2 = ServletUtilities.saveChartAsPNG(chart,x_length,600,session);
					%>
						<br>
						<table>
							<tr>
								<td><br><img alt=""
									src="<%=ctxRootPath%>/servlet/DisplayChart?filename=<%=fileName%>"><br>
								</td>
							</tr>
					
							<tr>
								<td><br><img alt=""
									src="<%=ctxRootPath%>/servlet/DisplayChart?filename=<%=filename2%>"><br>
								</td>
							</tr>
						</table>
					<%
				}
				out.println("<br><br>");
			}
			
		}
			
			
			
		
		
	}

	} catch (Exception e) {
		e.printStackTrace();
		out.println(e);
	} finally {
	}
%>
<%!public void setLineChartProperties(JFreeChart chart, Font font) {
		CategoryPlot plot = chart.getCategoryPlot();
		chart.getTitle().setFont(font);
		Axis x_Axis = plot.getDomainAxis();
		x_Axis.setLabelFont(font);
		x_Axis.setTickLabelFont(font);
		CategoryAxis categoryAxis = plot.getDomainAxis();
		categoryAxis.setCategoryLabelPositions(CategoryLabelPositions
				.createUpRotationLabelPositions(Math.PI / 12));
		plot.setDomainAxis(categoryAxis);
		Axis y_Axis = plot.getRangeAxis();
		y_Axis.setLabelFont(font);
		y_Axis.setTickLabelFont(font);
		y_Axis.setLabelAngle(Math.PI * 0.5);
		LegendTitle legendTitle = chart.getLegend();
		legendTitle.setItemFont(font);
	}%>
<%!public void setBarChartProperties(JFreeChart chart, Font font) {
	chart.getTitle().setFont(font);
	CategoryPlot categoryPlot = chart.getCategoryPlot();
	Axis x_axis = categoryPlot.getDomainAxis();
	x_axis.setLabelFont(font);
	x_axis.setTickLabelFont(font);
	
	CategoryAxis domainAxis = categoryPlot.getDomainAxis();
	domainAxis.setCategoryLabelPositions(CategoryLabelPositions.createUpRotationLabelPositions(Math.PI/5));
	categoryPlot.setDomainAxis(domainAxis);
	
	Axis y_axis = categoryPlot.getRangeAxis();
	y_axis.setLabelFont(font);
	y_axis.setTickLabelFont(font);
	y_axis.setLabelAngle(Math.PI*0.5);
	}%>
</body>
</html>