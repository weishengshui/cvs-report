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
	if (startDate == null || startDate.trim().length() == 0)
		return;

	if (endDate == null || endDate.trim().length() == 0)
		return;

	out.println("<h2>总计报表</h2>");
%>

<form
	action="<%=ctxRootPath%>/coastalCity201207/coastalcount20120726.jsp?cmd=1"
	method="post" onsubmit="return checkDate();">
<table cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="2">时间区间选择</td>
	</tr>

	<tr>
		<td width="280pix">&nbsp;&nbsp;&nbsp;时间从: <input
			id="startFromDate" name="startFromDate"
			value="<%=startDate == null ? "" : startDate%>" /> <span
			id="startDateMsg"></span> <script charset="utf-8">
					jQuery('#startFromDate').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
				</script></td>

		<td width="280pix">&nbsp;&nbsp;&nbsp;时间到: <input id="startDateTo"
			name="startDateTo" value="<%=endDate == null ? "" : endDate%>" />
		<span id="endDateMsg"></span> <script charset="utf-8">
					jQuery('#startDateTo').datepicker({showOn: 'both', showOtherMonths: true, 
					showWeeks: true, firstDay: 1, changeFirstDay: false,
					buttonImageOnly: true, buttonImage: '<%=ctxRootPath%>/images/calendar.gif'});
					</script></td>
	</tr>

	<tr align="center">
		<td colspan="2">
		<input type="hidden" name="activity_id" value="<%=activity_id %>">
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

	CoastlCityService service = new CoastlCityService();
	//总计报表
	FunctionCountVo vo = service.getQQMeishiActionHistoryLists(startDate, endDate);

	//每日总计报表
	List<FunctionCountOfDayVo> fcdvs = service
			.getQQMeishiActionCountOfDay(startDate, endDate);

	//商户汇总报表
	List<QQMeishiActionHistoryShopVO> historyShopVOs = service
			.getQQMeishiActionCountOfShop(startDate, endDate);

	int j = 1;
	final Font font = new Font("宋体", Font.PLAIN, 15);
	String fileName = "";
	
	//商户消费总额
	try {

		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>已领取礼品总数</td>");
		out.println("<td>已获取优惠总数</td>");
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td>" + vo.getGiftCount() + "</td>");
		out.println("<td>" + vo.getPrivilegeCount() + "</td>");
		out.println("</tr>");

		out.println("</table>");

		out.println("<br><br><br>");

		

		int sumGift = 0;
		int sumPrivilege = 0;

		j = 1;
		
		int fcdvsSize =0;
		String giftTitle = "礼品";
		String privilegeTitle = "优惠";
		if (fcdvs != null && fcdvs.size() > 0) {
			String[] weekday = {"","星期日","星期一","星期二","星期三","星期四","星期五","星期六"};
			fcdvsSize =  fcdvs.size();
			out.println("<h2>每日总计报表</h2>");
			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td>序号</td>");
			out.println("<td align='center'>Date"+"<br>"+"(yyyy / mm / dd)</td>");
			out.println("<td align='center'>Weekday / "+"<br>"+"WK.of Yr.</td>");
			out.println("<td>已领取礼品总数</td>");
			out.println("<td>已获取优惠总数</td>");
			out.println("</tr>");
			for (FunctionCountOfDayVo fvo : fcdvs) {
				FunctionCountVo v = fvo.getFc();
				int giftCount = v.getGiftCount();
				int privilegeCount = v.getPrivilegeCount();
				String ts = fvo.getDay();
				SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd");
				Date tsDate = df.parse(ts);
				Calendar cal = Calendar.getInstance();
				cal.setTime(tsDate);
				String dayOfWeekString="";
				String weekendColor="white";
				int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
				int weekOfYear = cal.get(Calendar.WEEK_OF_YEAR);
				switch(dayOfWeek){
				case Calendar.SUNDAY:
					dayOfWeekString = weekday[Calendar.SUNDAY];
					weekendColor="red";
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
					weekendColor="#18ecff";
					dayOfWeekString = weekday[Calendar.SATURDAY];
					break;
					
				}
				sumGift += giftCount;
				sumPrivilege += privilegeCount;
				out.println("<tr>");
				out.println("<td>" + j + "</td>");
				out.println("<td>" + ts + "</td>");
				out.println("<td bgcolor='" + weekendColor + "'>" + dayOfWeekString+" / "+weekOfYear + "</td>");
				out.println("<td>" + giftCount + "</td>");
				out.println("<td>" + privilegeCount + "</td>");
				out.println("</tr>");
				j++;
			}
			out.println("<tr>");
			out.println("<td colspan='3' align='center'>总计</td>");
			out.println("<td>" + sumGift + "</td>");
			out.println("<td>" + sumPrivilege + "</td>");
			out.println("</tr>");
			out.println("</table>");
			int index = (fcdvsSize-1)/10+1;
			DefaultCategoryDataset dataset = new DefaultCategoryDataset();	
			
			for(int i=0;i<fcdvsSize;){
				//统计指定时间段的消费次数
				int giftIndexSum = 0;
				int privilegeIndexSum = 0;
				String day = "";
				FunctionCountOfDayVo scountOfDayVo =  fcdvs.get(i);
				FunctionCountVo scountVo = scountOfDayVo.getFc();
				day = Integer.parseInt(scountOfDayVo.getDay().substring(5,7))+"/"+Integer.parseInt(scountOfDayVo.getDay().substring(8,10)) ;
				giftIndexSum+=scountVo.getGiftCount();
				privilegeIndexSum +=scountVo.getPrivilegeCount();
				if(index>1){
					FunctionCountOfDayVo ecountOfDayVo =  fcdvs.get(i+index-1);
					FunctionCountVo ecountVo = ecountOfDayVo.getFc();
					if(scountOfDayVo.getDay().substring(5,7).equals(ecountOfDayVo.getDay().substring(5,7))){
						day += "-"+ Integer.parseInt(ecountOfDayVo.getDay().substring(8,10));
					}else{
						day += "-"+Integer.parseInt(ecountOfDayVo.getDay().substring(5,7))+"/"+Integer.parseInt(ecountOfDayVo.getDay().substring(8,10)) ;	
					}
					
					giftIndexSum+=ecountVo.getGiftCount();
					privilegeIndexSum+=ecountVo.getPrivilegeCount();
				}
					
				for(int k = 1;k<index-1;k++){
					FunctionCountOfDayVo countOfDayVo =  fcdvs.get(i+k);
					FunctionCountVo countVo = countOfDayVo.getFc();
					giftIndexSum+=countVo.getGiftCount();
					privilegeIndexSum+=countVo.getPrivilegeCount();
				}
				dataset.addValue(giftIndexSum,giftTitle,day);
				dataset.addValue(privilegeIndexSum,privilegeTitle,day);
				i+=index;
				if(fcdvsSize-i<index){
					index = fcdvsSize-i;
				}
			}
			
			JFreeChart chart = ChartFactory.createLineChart("海岸城--按日统计", "日期",
					"交易数量", dataset, PlotOrientation.VERTICAL, true, false,
					false);
			
			CategoryPlot plot = chart.getCategoryPlot();
			chart.getTitle().setFont(font);
			Axis x_Axis = plot.getDomainAxis();
			x_Axis.setLabelFont(font);
			x_Axis.setTickLabelFont(font);
			CategoryAxis categoryAxis = plot.getDomainAxis();
			categoryAxis.setCategoryLabelPositions(CategoryLabelPositions.createUpRotationLabelPositions(Math.PI/12));
			plot.setDomainAxis(categoryAxis);
			Axis y_Axis = plot.getRangeAxis();
			y_Axis.setLabelFont(font);
			y_Axis.setTickLabelFont(font);
			y_Axis.setLabelAngle(Math.PI * 0.5);
			LegendTitle legendTitle = chart.getLegend();
			legendTitle.setItemFont(font);
			
			fileName = ServletUtilities.saveChartAsPNG(chart,
					800, 600, session);
			%>
<br>
<br>
<table>
	<tr>
		<td><img alt=""
			src="<%=ctxRootPath%>/servlet/DisplayChart?filename=<%=fileName %>">
		</td>
	</tr>
</table>
<%
		}
		


%>
<%
	out.println("<br><br><br>");

		out.println("<h2>商户礼品汇总报表</h2>");

		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>商户名称</td>");
		out.println("<td>已领取礼品总数</td>");
		out.println("<td>POS机编号 | 交易类型 | 交易次数</td>");
		out.println("</tr>");

		if (historyShopVOs != null && historyShopVOs.size() != 0) {
			for (QQMeishiActionHistoryShopVO historyShopVO : historyShopVOs) {

				String shopId = historyShopVO.getShopId();
				if (shopId.equals("01")) {
					out.println("<tr>");
					out.println("<td>" + (j++) + "</td>");
					out.println("<td>" + historyShopVO.getShopName()
							+ "</td>");
					out.println("<td>"
							+ historyShopVO.getFcv().getGiftCount()
							+ "</td>");
					out.println("<td>");

					List<EveryPosEveryTypeCount> posCountList = historyShopVO
							.getEveryPosEveryTypeCounts();
					if (posCountList != null
							&& posCountList.size() != 0) {
						for (EveryPosEveryTypeCount posCount : posCountList) {
							if (posCount.getType().equals("GIFT")) {
								out.println(posCount.getPosId() + " | "
										+ "领取礼品" + " | "
										+ posCount.getCount() + " <br>");
							}
						}
					}
					out.println("</td>");
					out.println("</tr>");
					break;
				}

			}
		}

		out.println("</table>");
		out.println("<br><br><br>");

		j = 1;
		

		if (historyShopVOs != null && historyShopVOs.size() != 0) {
			double amountSum = 0;
			int privilegeCountSum = 0;
			out.println("<h2>商户优惠汇总报表</h2>");

			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td>序号</td>");
			out.println("<td>商户名称</td>");
			out.println("<td>已获取优惠总数</td>");
			out.print("<td>优惠总金额</td>");
			out.println("<td>POS机编号 | 交易类型 | 交易次数</td>");
			out.println("</tr>");
			//金额
			DefaultCategoryDataset	amountDataset = new DefaultCategoryDataset();
			//消费次数
			DefaultCategoryDataset  consumptionNumberDataset = new DefaultCategoryDataset();
			for (QQMeishiActionHistoryShopVO historyShopVO : historyShopVOs) {
				String shopId = historyShopVO.getShopId();
				if (!shopId.equals("01")) {
					int privilegeCount = historyShopVO.getFcv()
							.getPrivilegeCount();
					double amount = historyShopVO.getAmount();
					String shopName = historyShopVO.getShopName();
					amountSum += amount;
					privilegeCountSum += privilegeCount;
					out.println("<tr>");
					out.println("<td>" + (j++) + "</td>");
					out.println("<td>" + shopName
							+ "</td>");
					out.println("<td>" + privilegeCount + "</td>");

					out.println("<td>" + amount + "</td>");

					out.println("<td>");

					List<EveryPosEveryTypeCount> posCountList = historyShopVO
							.getEveryPosEveryTypeCounts();

					if (posCountList != null
							&& posCountList.size() != 0) {
						System.out
								.println("jsp 商户优惠汇总报表 posCountList.size():"
										+ posCountList.size());
						for (EveryPosEveryTypeCount posCount : posCountList) {
							if (posCount.getType().equals("PRIVILEGE")) {
								out.println(posCount.getPosId() + " | "
										+ "获取优惠" + " | "
										+ posCount.getCount() + " <br>");
							}
						}
					}
					out.println("</td>");

					out.println("</tr>");
					amountDataset.addValue(amount,shopName,shopName);
					consumptionNumberDataset.addValue(privilegeCount,shopName,shopName);
				}
			}
			DecimalFormat df = new DecimalFormat("0.00");

			out.println("<tr>");
			out.println("<td colspan='2' align='center'>" + "总计"
					+ "</td>");
			out.println("<td>" + privilegeCountSum + "</td>");
			out.println("<td>" + df.format(amountSum) + "</td>");
			out.println("<td></td>");
			out.println("</tr>");
			out.println("</table>");
		
			JFreeChart amountChart = ChartFactory.createBarChart3D("海岸城--商户统计(优惠)","","金额",amountDataset,PlotOrientation.VERTICAL,false,false,false);
			amountChart.getTitle().setFont(font);
			CategoryPlot categoryPlot = amountChart.getCategoryPlot();
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
			
			JFreeChart consumptionNumberChart = ChartFactory.createBarChart3D("海岸城--商户统计(优惠)","","消费次数",consumptionNumberDataset,PlotOrientation.VERTICAL,false,false,false);
			consumptionNumberChart.getTitle().setFont(font);
			CategoryPlot categoryPlot2 = consumptionNumberChart.getCategoryPlot();
			Axis axis = categoryPlot2.getDomainAxis();
			axis.setLabelFont(new Font("宋体", Font.PLAIN, 15));
			axis.setTickLabelFont(font);
			categoryPlot2.setDomainAxis(domainAxis);
			Axis axis2 = categoryPlot2.getRangeAxis();
			axis2.setLabelFont(font);
			axis2.setTickLabelFont(font);
			axis2.setLabelAngle(Math.PI*0.5);
			
		 	fileName =  ServletUtilities.saveChartAsPNG(amountChart,historyShopVOs.size()*35,600,session);
			%><br>
<table>
	<tr>
		<td><img alt=""
			src="<%=ctxRootPath%>/servlet/DisplayChart?filename=<%=fileName %>"><br>
		<br>
		</td>
	</tr>
	<%
			fileName =  ServletUtilities.saveChartAsPNG(consumptionNumberChart,historyShopVOs.size()*35,600,session);
			%>
	<tr>
		<td><br>
		<img alt=""
			src="<%=ctxRootPath%>/servlet/DisplayChart?filename=<%=fileName %>"></td>
	</tr>
</table>
<%
			
		}

		
		
		
		

	} catch (Exception e) {
		e.printStackTrace();
		out.println(e);
	} finally {
		vo = null;
		fcdvs = null;
		historyShopVOs = null;
	}

	out.println("<br><br><br>");
%>
</body>
</html>