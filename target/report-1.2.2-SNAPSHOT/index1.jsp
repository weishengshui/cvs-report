<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page language="java" import="com.chinarewards.report.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>

<html>
<head>
<title>会员消费信息报表</title>
<link rel="stylesheet" href="<%=ctxRootPath%>/js/jquery/plugin/tablesorter/themes/blue/style.css" type="text/css" media="print, projection, screen" />
<script type="text/javascript" src="<%=ctxRootPath%>/js/jquery/jquery-latest.js"></script>
<script type="text/javascript" src="<%=ctxRootPath%>/js/jquery/plugin/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="<%=ctxRootPath%>/js/jquery/plugin/tablesorter/custom/parser.js"></script>
<script type="text/javascript">
$(document).ready(function() 
{
	$("#merchantRevenueSummaryTable").tablesorter();
	$("#shopRevenueSummaryTable").tablesorter();
	$("#registerMemberSummaryTable").tablesorter();
} 
); 
</script>
</head>

<body>

<%
	// formatting
	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
	DecimalFormat rateFormat = new DecimalFormat("#,##0.0");
	DecimalFormat intFormat = new DecimalFormat("#,##0");
	SimpleDateFormat dateOnlyFormat = new SimpleDateFormat("yyyy-MM-dd");

	Connection conn = null;
	ResultSet rs = null;
	Statement stmt = null;

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
	try {

		conn = DbConnectionFactory.getInstance()
				.getConnection("posapp");
		String sTransDateSince = "2009-06-01";

		stmt = conn.createStatement();

		//
		// 商户消费
		//
		{

			out.println("<h1>商户消费 (从" + sTransDateSince + "开始)</h1>");
			rs = stmt
					.executeQuery("SELECT sum(amountcurrency) AS amountcurrency_sum, sum(point) AS point_sum FROM clubpoint WHERE transdate > {d '"
							+ sTransDateSince
							+ "'} and clubid='00' and amountcurrency > 2 AND merchantname NOT LIKE '%积享通%' AND producttypename <> 'T测试'");
			rs.next();
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>商户消费总额</th>");
			out.println("<th>商户消费总积分</th>");
			out.println("</tr>");
			out.println("</thead>");
			// show result
			out.println("<tbody>");
			out.println("<tr>");
			out.println("<td class='amount'>"
					+ intFormat.format(rs.getInt("amountcurrency_sum"))
					+ "</td>");
			out.println("<td class='amount'>"
					+ intFormat.format(rs.getInt("point_sum"))
					+ "</td>");
			out.println("</tr>");
			out.println("</tbody>");
			out.println("</table>");
			rs.close();
		}

		//
		// 消费总次数
		//
		{
			out.println("<br>");
			out.println("<h1>消费总次数 (从" + sTransDateSince + "开始)</h1>");
			stmt = conn.createStatement();
			rs = stmt
					.executeQuery("SELECT COUNT(*) FROM clubpoint WHERE transdate > {d '"
							+ sTransDateSince
							+ "'} AND clubid='00' AND amountcurrency > 2 AND merchantname NOT LIKE '%积享通%' AND producttypename <> 'T测试'");
			rs.next();
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>消费总次数</th>");
			out.println("</tr>");
			out.println("</thead>");
			// show result
			out.println("<tbody>");
			out.println("<tr>");
			out.println("<td class='amount'>"
					+ intFormat.format(rs.getInt(1)) + "</td>");
			out.println("</br>");
			out.println("</tbody>");
			out.println("</table>");
			rs.close();
		}

		out.println("<br>");

		//
		// 有 N 次及 N 次以上消费记录的唯一性会员和临时卡会员总数
		//
		out.println("<h1>有N次及N次以上消费记录的唯一性会员和临时卡会员总数 (从"
				+ sTransDateSince + "开始)</h1>");
		{

			PreparedStatement pstmt = null;

			String transDateFrom = sTransDateSince;
			String transDateTo = "2999-12-31";
			java.util.Date now = new java.util.Date();

			// reusable statement.
			//pstmt = conn.prepareStatement("SELECT COUNT(*) FROM (SELECT tempmembertxid, COUNT(*) FROM clubpoint WHERE amountcurrency > 2 AND merchantname NOT LIKE '%积享通%' AND producttypename <> 'T测试' " + " AND transdate >= to_date('" + transDateFrom + "', 'yyyy-mm-dd') AND transdate < to_date('" + transDateTo + "', 'yyyy-mm-dd') GROUP BY tempmembertxid HAVING COUNT(*) >= ?)");
			// 2010-01-28 cyril: Added more parameters for date range selection
			pstmt = conn
					.prepareStatement("SELECT COUNT(*) FROM (SELECT tempmembertxid, COUNT(*) FROM clubpoint WHERE amountcurrency > 2 AND merchantname NOT LIKE '%积享通%' AND producttypename <> 'T测试' "
							+ " AND transdate >= ? AND transdate < ? GROUP BY tempmembertxid HAVING COUNT(*) >= ?)");

			// some parameters for SQL querying.
			int count[] = { 1, 2, 3, 5, 10, 20, 50, 100 };
			int monthSpans[] = { 0, 5, 2, 1 }; // number of past months to check

			// some variable store.
			// store the last member count for a particular month span, for calculating
			// the change along a month span when the shop spending count changes.
			Hashtable<Integer, Long> lastMemberCountMap = new Hashtable<Integer, Long>();

			// prepare the map
			for (int j = 0; j < monthSpans.length; j++) {
				lastMemberCountMap.put(new Integer(monthSpans[j]),
						new Long(-1));
			}

			// output the HTML table header
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th rowspan='2'>..次及以上消费</th>");
			for (int j = 0; j < monthSpans.length; j++) {
				int monthSpan = monthSpans[j];
				java.util.Date from = DateUtil.add(now, Calendar.MONTH, -monthSpan);
				String s = "";
				if (monthSpan == 0) {
					s = "全部";
				} else {
					s = "前" + monthSpan + "月内有消费 (由" + 
						dateOnlyFormat.format(from) + "开始)";
				}
				out.println("<th colspan='5' style='text-align: center'>" + s + "</th>");
			}
			out.println("</tr>");
			out.println("<tr>");
			for (int j = 0; j < monthSpans.length; j++) {
				int monthSpan = monthSpans[j];
				out.println("<th>人数</th>");
				out.println("<th>每月<br/>平均</th>");
				out.println("<th>当前<br/>变动</th>");
				out.println("<th>当前<br/>变动率</th>");
				out.println("<th>横向活跃度<br/>变化率%</th>");
			}
			out.println("</tr>");
			out.println("</thead>");
			out.println("<tbody>");
			// output the real table content.
			for (int i = 0; i < count.length; i++) {

				// number of spending count on shops
				int c = count[i];

				out.println("<tr>");
				out.println("<td>&gt;= " + c + "</td>");
				
				// shows the statistics by month spans
				double monthSpanChangRate = -1.0;
				double lastMonthSpanCount = -1.0;
				for (int j = 0; j < monthSpans.length; j++) {

					int monthSpan = monthSpans[j];
					long lastMemberCount = lastMemberCountMap
							.get(new Integer(monthSpan));

					// calculate the "from" date
					java.util.Date from = null;
					if (monthSpan != 0) {
						from = DateUtil.add(now, Calendar.MONTH,
								-monthSpan);
						// calculate the month average as well.
					} else {
						// all date : 1970
						from = DateUtil
								.createDateFromYYYYMMDD("19000101");
					}

					// there is some testing data which the amount currency is <= RMB 2.0 .
					pstmt.clearParameters();
					pstmt.setTimestamp(1, new java.sql.Timestamp(from
							.getTime()));
					pstmt.setTimestamp(2, new java.sql.Timestamp(now
							.getTime()));
					pstmt.setInt(3, c);
					rs = pstmt.executeQuery();
					rs.next();

					// calculate the change rate
					double changeRate = 0.0; // percentage
					long pplCount = rs.getLong(1);
					if (lastMemberCount != -1) {
						changeRate = (double) (pplCount - lastMemberCount)
								/ lastMemberCount * 100.0;
					}
					// and CSS class
					String chgRateCssClass = "";
					if (changeRate > 0) {
						chgRateCssClass = " value_raise";
					} else if (changeRate < 0) {
						chgRateCssClass = " value_drop";
					}

					// calculate the month average. -1 means N/A.
					double monthAvg = -1;
					if (monthSpan != 0) {
						monthAvg = (double) pplCount / monthSpan;
					}
					
					// calculate the rate change within the same N count
					if (lastMonthSpanCount != -1) {
						monthSpanChangRate = (double) (pplCount - lastMonthSpanCount)
								/ lastMonthSpanCount * 100;
					}

					// determine the CSS class for month span rate change
					String monthSpanChgRateCssClass = "";
					if (monthSpanChangRate > 0) {
						monthSpanChgRateCssClass = " value_raise";
					} else if (monthSpanChangRate < 0) {
						monthSpanChgRateCssClass = " value_drop";
					}
					
					
					// do HTML 

					out.println("<td class='amount'>"
							+ intFormat.format(pplCount) + "</td>");
					// monthly average
					out.println("<td class='amount'>"
							+ (monthAvg == -1 ? "N/A" : intFormat
									.format(monthAvg)) + "</td>");
					// count change
					out.println("<td class='amount" + chgRateCssClass + "'>" + ((lastMemberCount != -1) ? intFormat.format(pplCount - lastMemberCount) : "-") + "</td>");
					// rate change in %
					out.println("<td class='amount" + chgRateCssClass + "'>" + ( (lastMemberCount != -0) ? rateFormat.format(changeRate) + "%" : "-") + "</td>");
					out.println("<td class='amount" + monthSpanChgRateCssClass + "'>" + ((lastMonthSpanCount != 0 && monthSpanChangRate != -1) ? rateFormat.format(monthSpanChangRate)+"%" : "-") + "</td>");

					// update the last member count for calculation changes for 
					// current month span.
					lastMonthSpanCount = pplCount;
					lastMemberCount = pplCount;
					lastMemberCountMap.put(new Integer(monthSpan),
							new Long(lastMemberCount));

				}
				out.println("</tr>");

				rs.close();

			}
			out.println("</tbody>");
			out.println("</table>");

			SqlUtil.close(pstmt);
			pstmt = null;

		}

		{

			//
			// 会员在不同门市消费总数
			//

			PreparedStatement pstmt = null;

			try {

				//
				// Build the SQL statement!
				//

				double minSpendingPerShop = 2;
				String transDateFrom = sTransDateSince;
				String transDateTo = "2999-12-31";
				java.util.Date now = new java.util.Date();

				// sqlTxAcctUniqueShopCount: Query the TX account and the number of unique shops
				// spending. Running this query get a list of unique tx accounts and shop IDs.
				String sqlTxAcctUniqueShopCount = "SELECT DISTINCT cp.tempmembertxid, cp.shopid FROM clubpoint cp WHERE cp.clubid = '00' AND cp.amountcurrency > "
						+ minSpendingPerShop
						+ " AND cp.transdate >= ? AND cp.transdate < ? AND cp.shopid IS NOT NULL AND merchantname NOT LIKE '%积享通%' AND producttypename <> 'T测试' GROUP BY cp.tempmembertxid, cp.shopid ORDER BY cp.tempmembertxid, cp.shopid";
				System.out.println("sqlTxAcctUniqueShopCount: "
						+ sqlTxAcctUniqueShopCount);

				// sqlStat: Do the actual query which obtains the total of TX account count
				// (treated as head-count) which has pay unique visit to a number of shops.
				String sqlStat = "SELECT COUNT(*) FROM (SELECT tempmembertxid, COUNT(tempmembertxid) AS unique_shop_count FROM ("
						+ sqlTxAcctUniqueShopCount
						+ ") HAVING COUNT(tempmembertxid) >= ? GROUP BY tempmembertxid)";
				System.out.println("sqlStat: " + sqlStat);

				// do the query
				// list of unique shops. 
				int uniqueShopCounts[] = new int[] { 1, 2, 3, 5, 10,
						20, 50 };
				int monthSpans[] = { 0, 5, 2, 1 }; // number of past months to check.
%>
<!-- 会员(包括临时卡持有者)在不同门市消费总数概览 STARTS -->
<br/>
<h1>会员(包括临时卡持有者)在不同门市消费总数概览 (从<%=sTransDateSince%>开始)</h1>
<table>
<thead>
<tr>
<th rowspan="2">独立门市数目</th>
<%
	for (int j = 0; j < monthSpans.length; j++) {
		int monthSpan = monthSpans[j];
		java.util.Date from = DateUtil.add(now, Calendar.MONTH, -monthSpan);
		String s = "";
		if (monthSpan == 0) {
			s = "全部";
		} else {
			s = "前" + monthSpan + "月內 (由" + 
			dateOnlyFormat.format(from) + "开始)";
		}
		out.println("<th colspan='4' style='text-align: center'>" + s + "</th>");
	}
%>
</tr>
<tr>
<%
	for (int j = 0; j < monthSpans.length; j++) {
					int monthSpan = monthSpans[j];
%>
<th>人数</th>
<th>变动</th>
<th>变动%</th>
<th>横向活跃度<br/>变化率%</th>
<%
	}
%>
</tr>
</thead>
<tbody>
<%
	// some variable store.
	// store the last member count for a particular month span, for calculating
	// the change along a month span when the shop spending count changes.
	Hashtable<Integer, Long> lastMemberCountMap = new Hashtable<Integer, Long>();

	// prepare the map
	for (int j = 0; j < monthSpans.length; j++) {
		lastMemberCountMap.put(new Integer(monthSpans[j]),
				new Long(-1));
	}

	pstmt = conn.prepareStatement(sqlStat);
	boolean showRate = true;
	for (int i = 0; i < uniqueShopCounts.length; i++) {

		int uniqueCount = uniqueShopCounts[i];
%>
<tr>
<td>&gt;= <%=uniqueCount%></td>
<%
	// calculate the statistics for each month spans
	double monthSpanChangRate = -1.0;
	double monthSpanRefChangRate = -1.0;
	double lastMonthSpanCount = -1.0;
	long refMemberCount = -1;
	for (int j = 0; j < monthSpans.length; j++) {

		int monthSpan = monthSpans[j];
		long lastMemberCount = lastMemberCountMap
				.get(new Integer(monthSpan));

		// calculate the "from" date
		java.util.Date from = null;
		if (monthSpan != 0) {
			from = DateUtil.add(now, Calendar.MONTH,
					-monthSpan);
			// calculate the month average as well.
		} else {
			// all date : 1900
			from = DateUtil
					.createDateFromYYYYMMDD("19000101");
		}

		// there is some testing data which the amount currency is <= RMB 2.0 .
		pstmt.clearParameters();
		pstmt.setTimestamp(1, new java.sql.Timestamp(
				from.getTime()));
		pstmt.setTimestamp(2, new java.sql.Timestamp(
				now.getTime()));
		pstmt.setInt(3, uniqueCount);
		rs = pstmt.executeQuery();
		rs.next();

		int pplCount = rs.getInt(1);

		// remember the people count of the first month span.
		if (j == 0) {
			refMemberCount = pplCount;
		}

		// calculate the change rate.
		double chgRate = 0.0;
		if (lastMemberCount != -1 && pplCount >= 0
				&& showRate) {
			chgRate = (double) (pplCount - lastMemberCount)
					/ lastMemberCount * 100;
		}

		// calculate the rate change within the same N count
		if (lastMonthSpanCount != -1) {
			monthSpanChangRate = (double) (pplCount - lastMonthSpanCount)
					/ lastMonthSpanCount * 100;
		}
		
		if (j != 0) {
			monthSpanRefChangRate = (double)(pplCount - refMemberCount) * 100 / refMemberCount;
		}

		// determine the CSS class
		String chgRateCssClass = "";
		if (chgRate > 0) {
			chgRateCssClass = " value_raise";
		} else if (chgRate < 0) {
			chgRateCssClass = " value_drop";
		}
		
		// determine the CSS class for month span rate change
		String monthSpanChgRateCssClass = "";
		if (monthSpanChangRate > 0) {
			monthSpanChgRateCssClass = " value_raise";
		} else if (monthSpanChangRate < 0) {
			monthSpanChgRateCssClass = " value_drop";
		}
		
		// determine the CSS class for month span rate change
		String monthSpanRefChangRateCssClass = "";
		if (monthSpanRefChangRate > 0) {
			monthSpanRefChangRateCssClass = " value_raise";
		} else if (monthSpanChangRate < 0) {
			monthSpanRefChangRateCssClass = " value_drop";
		}
		
%>
<td class="amount"><%=intFormat.format(pplCount)%></td>
<td class="amount<%=chgRateCssClass%>"><%=((lastMemberCount != -1) ? intFormat.format(pplCount - lastMemberCount) : "-")%></td>
<td class="amount<%=chgRateCssClass%>"><%=((lastMemberCount != -1) ? rateFormat.format(chgRate) + "%" : "-")%></td>
<%--<td class="amount<%=monthSpanChgRateCssClass%>"><%=((lastMonthSpanCount != 0 && monthSpanChangRate != -1 ? rateFormat.format(monthSpanChangRate)+"%" : "-"))%></td> --%>
<td class="amount<%=monthSpanRefChangRateCssClass%>"><%=((lastMonthSpanCount != 0 && monthSpanRefChangRate != -1 ? rateFormat.format(monthSpanRefChangRate)+"%" : "-"))%></td>

<%

		// update state variable for next statistics calculation
		lastMemberCount = pplCount;
		lastMemberCountMap.put(new Integer(monthSpan),
				new Long(lastMemberCount));
		
		lastMonthSpanCount = pplCount;

		if (pplCount == 0) {
			showRate = false;
		}

	} // for each month span
%>
</tr>
<%
	} // for each month
%>
</tbody>
</table>
<!-- 会员(包括临时卡持有者)在不同门市消费总数概览 ENDS -->
<%
	//
				// show result as table form
				//
			} finally {
				SqlUtil.close(rs);
				SqlUtil.close(pstmt);
			}

		}

%>
<%!
String formatIt(String s) {
	String value = "";
	if (s!=null && s.length()>0) {
		String[] arr = s.split("[.]");
		if (arr.length>1) {
			String s1 = arr[0];
			String s2 = arr[1];
			if (s2.length()>2) {
				s2 = "."+ s2.substring(0, 2);
			} else {
				s2 = "."+s2;
			}
			value = s1+s2;
		} else {
			value = arr[0];
		}
		value += "%";
	}
	return value;
}

%>

<% 
		//member Register report
		{
			out.println("<br/>");
			
			conn = DbConnectionFactory.getInstance().getConnection("crm");
			List<String[]> list = new ArrayList<String[]>();
			PreparedStatement ps = null;
			StringBuffer sql = new StringBuffer();
			
			sql.append("SELECT count(m.id) as total, ");
			sql.append("sum(decode(m.mobiletelephone,null,0,1)) as phoneTotal, ");
			sql.append("sum(decode(m.email,null,0,1)) as emailTotal, ");
			sql.append("sum(decode(m.workaddress,null,0,1)) as addressTotal ");
			sql.append("FROM member m,membership ms ");
			sql.append("WHERE ms.member_id=m.id and ms.card_id='1'");
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			while (rs.next()) {
				String[] arr = new String[8];
				arr[0] = "积享通";
				arr[1] = rs.getString("total");
				arr[2] = rs.getString("phoneTotal");
				arr[3] = rs.getString("emailTotal");
				arr[4] = rs.getString("addressTotal");
				Double dPhone = (Double.parseDouble(arr[2])/Double.parseDouble(arr[1]))*100;
				arr[5] = formatIt(String.valueOf(dPhone));
				Double dEmail = (Double.parseDouble(arr[3])/Double.parseDouble(arr[1]))*100;
				arr[6] = formatIt(String.valueOf(dEmail));
				Double dAddress = (Double.parseDouble(arr[4])/Double.parseDouble(arr[1]))*100;
				arr[7] = formatIt(String.valueOf(dAddress));
				list.add(arr);
			}
			
			sql = new StringBuffer();
			sql.append(" SELECT count(m.id) as total, ");
			sql.append(" sum(decode(m.mobiletelephone,null,0,1)) as phoneTotal,  ");
			sql.append(" sum(decode(m.email,null,0,1)) as emailTotal, ");
			sql.append(" sum(decode(m.workaddress,null,0,1)) as addressTotal ");
			sql.append(" FROM member m,channel c ");
			sql.append(" WHERE m.channel_id= c.id and c.channelcode=? ");
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1,"szair");
			rs = ps.executeQuery();
			while (rs.next()) {
				String[] arr = new String[8];
				arr[0] = "深航";
				arr[1] = rs.getString("total");
				arr[2] = rs.getString("phoneTotal");
				arr[3] = rs.getString("emailTotal");
				arr[4] = rs.getString("addressTotal");
				Double dPhone = (Double.parseDouble(arr[2])/Double.parseDouble(arr[1]))*100;
				arr[5] = formatIt(String.valueOf(dPhone));
				Double dEmail = (Double.parseDouble(arr[3])/Double.parseDouble(arr[1]))*100;
				arr[6] = formatIt(String.valueOf(dEmail));
				Double dAddress = (Double.parseDouble(arr[4])/Double.parseDouble(arr[1]))*100;
				arr[7] = formatIt(String.valueOf(dAddress));
				list.add(arr);
			}
			ps.setString(1,"soufun");
			rs = ps.executeQuery();
			while (rs.next()) {
				String[] arr = new String[8];
				arr[0] = "搜房";
				arr[1] = rs.getString("total");
				arr[2] = rs.getString("phoneTotal");
				arr[3] = rs.getString("emailTotal");
				arr[4] = rs.getString("addressTotal");
				Double dPhone = (Double.parseDouble(arr[2])/Double.parseDouble(arr[1]))*100;
				arr[5] = formatIt(String.valueOf(dPhone));
				Double dEmail = (Double.parseDouble(arr[3])/Double.parseDouble(arr[1]))*100;
				arr[6] = formatIt(String.valueOf(dEmail));
				Double dAddress = (Double.parseDouble(arr[4])/Double.parseDouble(arr[1]))*100;
				arr[7] = formatIt(String.valueOf(dAddress));
				list.add(arr);
			}
			ps.setString(1,"1234");
			rs = ps.executeQuery();
			while (rs.next()) {
				String[] arr = new String[8];
				arr[0] = "国寿";
				arr[1] = rs.getString("total");
				arr[2] = rs.getString("phoneTotal");
				arr[3] = rs.getString("emailTotal");
				arr[4] = rs.getString("addressTotal");
				Double dPhone = (Double.parseDouble(arr[2])/Double.parseDouble(arr[1]))*100;
				arr[5] = formatIt(String.valueOf(dPhone));
				Double dEmail = (Double.parseDouble(arr[3])/Double.parseDouble(arr[1]))*100;
				arr[6] = formatIt(String.valueOf(dEmail));
				Double dAddress = (Double.parseDouble(arr[4])/Double.parseDouble(arr[1]))*100;
				arr[7] = formatIt(String.valueOf(dAddress));
				list.add(arr);
			}
			
			sql = new StringBuffer();
			sql.append(" select count(t.id) as total from tempcard t, organization o where t.orgid= o.id and o.organizationno='cococ' ");
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			while (rs.next()) {
				String[] arr = new String[8];
				arr[0] = "可可西";
				arr[1] = rs.getString("total");
				list.add(arr);
			}
			
			out.println("<h1>会员注册信息统计</h1>");
			out.println("<table border=\"2\" id=\"registerMemberSummaryTable\" class=\"tablesorter\">");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>来源</th>");
			out.println("<th>注册会员总数  </th>");
			out.println("<th>有手机信息的会员 (占总数百分比) </th>");
			out.println("<th>有Email信息的会员 (占总数百分比) </th>");
			out.println("<th>有地址信息的会员 (占总数百分比) </th>");
			out.println("</tr>");
			out.println("</thead>");
			out.println("<tbody>");

			for (String[] arr : list) {
				if ("可可西".equals(arr[0])) {
					out.println("<tr>");
					out.println("<td>" + arr[0] + "</td>");
					out.println("<td colspan='4'>" + arr[1]+ "个,  (注：可可西是临时会员,未提供详细的注册信息。)</td>");
					out.println("</tr>");
				} else {
					out.println("<tr>");
					out.println("<td>" + arr[0] + "</td>");
					out.println("<td>" + arr[1]+ "</td>");
					out.println("<td>"+ arr[2]+ " ("+arr[5]+")"+ "</td>");
					out.println("<td>"+ arr[3]+ " ("+arr[6]+")"+ "</td>");
					out.println("<td>"+ arr[4]+ " ("+arr[7]+")"+ "</td>");
					out.println("</tr>");
				}
			}
			out.println("</tbody>");
			out.println("</table>");
			out.println("<br/>");
			rs.close();
			ps.close();
			conn.close();
			
		}
		
		
		//
		// 每个门市的消费总金额
		//
		{
			out.println("<br/>");
			conn = DbConnectionFactory.getInstance().getConnection("posapp");
			stmt = conn.createStatement();
			rs = stmt
					.executeQuery("SELECT sum(amountcurrency) AS amountcurrency_sum, shopname, COUNT(*) AS tx_count FROM clubpoint WHERE transdate > {d '"
							+ sTransDateSince
							+ "'} AND clubid='00' AND merchantname NOT LIKE '%积享通%' AND producttypename <> 'T测试' AND amountcurrency >= 1 GROUP BY shopname ORDER BY amountcurrency_sum DESC");

			out.println("<h1>每个门市的消费总金额 (从" + sTransDateSince
					+ "开始)</h1>");
			out.println("<table border='1' id=\"shopRevenueSummaryTable\" class=\"tablesorter\">");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>#</th>");
			out.println("<th>门市名称</th>");
			out.println("<th>交易次数</th>");
			out.println("<th>金额</th>");
			out.println("</tr>");
			out.println("</thead>");
			out.println("<tbody>");

			// write out the records
			int i = 1;
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + i + "</td>");
				out.println("<td>" + rs.getString("shopname") + "</td>");
				out.println("<td class='amount'>" + rs.getInt("tx_count") + "</td>");
				out.println("<td class='amount'>" + moneyFormat.format(rs.getDouble("amountcurrency_sum")) + "</td>");
				out.println("</tr>");
				i++;
			}
			out.println("</tbody>");
			out.println("</table>");
			rs.close();

		}

		{
			//
			//每个merchant的消费总金额
			//
			out.println("<br/>");

			stmt = conn.createStatement();
			rs = stmt
					.executeQuery("SELECT SUM(amountcurrency) AS amountcurrency_sum, SUM(point) AS point_sum, COUNT(*) AS tx_count, merchantname FROM clubpoint WHERE transdate > {d '"
							+ sTransDateSince
							+ "'} and clubid='00' AND merchantname NOT LIKE '%积享通%' AND producttypename <> 'T测试' AND amountcurrency >= 1 GROUP by merchantname ORDER BY amountcurrency_sum DESC");

			out.println("<h1>每个商户的消费总金额 (从" + sTransDateSince
					+ "开始)</h1>");
			out
					.println("<table border=\"1\" id=\"merchantRevenueSummaryTable\" class=\"tablesorter\">");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>#</th>");
			out.println("<th>商户名称</th>");
			out.println("<th>金额</th>");
			out.println("<th>交易次数</th>");
			out.println("<th>积分</th>");
			out.println("</tr>");
			out.println("</thead>");
			out.println("<tbody>");

			int i = 1;
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + i + "</td>");
				out.println("<td>" + rs.getString("merchantname")
						+ "</td>");
				out.println("<td class='amount'>"
						+ moneyFormat.format(rs
								.getDouble("amountcurrency_sum"))
						+ "</td>");
				out.println("<td class='amount'>"
						+ intFormat.format(rs.getInt("tx_count"))
						+ "</td>");
				out.println("<td class='amount'>"
						+ pointFormat.format(rs.getDouble("point_sum"))
						+ "</td>");
				out.println("</tr>");
				i++;
			}
			out.println("</tbody>");
			out.println("</table>");
			rs.close();
		}

		
		
		/*
		 //
		 // The following reports are commented out on 2010-01-15 by request of 
		 // June Yang
		 //


		 //每个竞拍品的竞拍次数
		 stmt = conn.createStatement(); 
		 out.println("<br/>");  
		 out.println("<br/>");  
		 out.println("每个竞拍品的竞拍次数：：<br>"); 
		 rs = stmt.executeQuery("select sum(version) ,auctionprizename from auctionrecord where 1=1 group by auctionprizename"); 
		 while (rs.next()){ 

		 out.println("" + rs.getString(2) + ""); 
		 out.println("" + rs.getInt(1) + ""); 
		 out.println("<br/>");  

		 } 
		 rs.close(); 



		 //已经完成的抽奖次数
		 stmt = conn.createStatement(); 
		 out.println("<br/>");  
		 out.println("<br/>");  
		 out.println("已经完成的抽奖次数：：<br>"); 
		 rs = stmt.executeQuery("select count(*) from luckydrawticket where isluckydraw ='1'"); 
		 while (rs.next()){ 

		 //out.println("" + rs.getString(2) + ""); 
		 out.println("" + rs.getInt(1) + ""); 
		 out.println("<br/>");  

		 } 
		 rs.close(); 


		 //没有抽奖的次数
		 stmt = conn.createStatement(); 
		 out.println("<br/>");  
		 out.println("<br/>");  
		 out.println("没有抽奖的次数：：<br>"); 
		 rs = stmt.executeQuery("select count(*) from luckydrawticket where isluckydraw ='0'"); 
		 while (rs.next()){ 

		 //out.println("" + rs.getString(2) + ""); 
		 out.println("" + rs.getInt(1) + ""); 
		 out.println("<br/>");  

		 } 
		 rs.close(); 


		 //获得了贴纸的总人数
		 stmt = conn.createStatement(); 
		 out.println("<br/>");  
		 out.println("<br/>");  
		 out.println("获得了贴纸的总人数：：<br>"); 
		 rs = stmt.executeQuery("select count(*) from pasterofmember where time >{d '2009-05-15'}"); 
		 while (rs.next()){ 

		 //out.println("" + rs.getString(2) + ""); 
		 out.println("" + rs.getInt(1) + ""); 
		 out.println("<br/>");  

		 } 
		 rs.close(); 




		 //获得了贴纸,但是没有抽奖机会的总人数
		 stmt = conn.createStatement(); 
		 out.println("<br/>");  
		 out.println("<br/>");  
		 out.println("获得了贴纸,但是没有抽奖机会的总人数：：<br>"); 
		 rs = stmt.executeQuery("select count(*) from pasterofmember where time >{d '2009-05-15'} and luckydrawticket_id =null"); 

		 while (rs.next()){ 

		 //out.println("" + rs.getString(2) + ""); 
		 out.println("" + rs.getInt(1) + ""); 
		 out.println("<br/>");  

		 } 
		 rs.close(); 
		 out.println("<br/>");  
		 out.println("<br/>");  
		 out.println("<br/>");  



		 */

		/*

		 select shopname, amountcurrency,point unitcode, producttypename from clubpoint 
		 where transdate > {d '2009-05-15'}
		 and amountcurrency >'2'
		 and clubid ='00'
		 ORDER BY shopname
		 */

		/*

		 //
		 // The following code was commented out on 2010-01-13 by request 
		 // of Michael and June of Production Development department.
		 //

		 stmt = conn.createStatement(); 
		 out.println("<br/>");  
		 out.println("<br/>");  
		 out.println("Member consume detail report: <br>"); 
		 rs = stmt.executeQuery("select c.shopname, c.amountcurrency,c.point, c.unitcode, to_char(c.transdate,'yyyy/mm/dd hh24:mm:ss'),c.membercardid,c.merchantname,b.businessid from clubpoint c, businesslog b where c.transdate > {d '2009-04-15'} and  c.sequenceid = b.possequence  and c.clubid ='00'   and c.merchantname not like '%积享通%' ORDER BY c.shopname,c.transdate "); 
		 out.println("<table border='1'>");

		 while (rs.next()){ 
		 out.println("<tr>");

		 if(rs.getString(1)!=null){
		 out.println("<td>" + rs.getString(1) + "</td>");

		 }else {

		 out.println("<td>" + rs.getString(7) + "</td>");


		 }
		 out.println("<td>" + rs.getString(2) + "</td>"); 
		 out.println("<td>" + rs.getString(3) + "</td>");
		 out.println("<td>" + rs.getString(4) + "</td>");
		 out.println("<td>" + rs.getString(5) + "</td>");
		 out.println("<td>" + rs.getString(6) + "</td>");
		 out.println("<td>" + rs.getString(8) + "</td>");

		 out.println("</tr>");

		 } 
		 out.println("</table>");

		 rs.close(); 
		 */

	} catch (Exception e) {

		out.println(e);
		e.printStackTrace(new PrintWriter(out));

	} finally {

		// gracefully release resources.
		SqlUtil.close(rs);
		SqlUtil.close(stmt);
		SqlUtil.close(conn);

	}
%>
</body>
</html>