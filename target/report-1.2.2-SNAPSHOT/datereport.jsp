<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*" %>
<%@ page import="com.chinarewards.report.db.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>
<%


/**
 * Stores min, max, median statistics.
 */
class MinMaxMedianStat {
	public double minimum;
	public double maximum;
	public double median;
}



%>
<%



// formatting
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
DecimalFormat moneyIntFormat = new DecimalFormat("#,##0");


String sTransDateSince = "2009-06-01";
String sTransDateTo = "2999-12-31";



//
// some common variables
//
// store the min, max, median 
Hashtable<Integer, MinMaxMedianStat> weekdayAmtSpendMinMaxMap = new Hashtable<Integer, MinMaxMedianStat>();
Hashtable<Integer, MinMaxMedianStat> weekdayTxCountMinMaxMap = new Hashtable<Integer, MinMaxMedianStat>();
Hashtable<Integer, MinMaxMedianStat> weekdayPointGivenMinMaxMap = new Hashtable<Integer, MinMaxMedianStat>();

// stores the member registration head count.
Hashtable<java.util.Date, Long> registerStats = new Hashtable<java.util.Date, Long>();




//
// Get request parameter
//
java.util.Date dateFrom = null;
java.util.Date dateTo = null;
{
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	sdf.setLenient(false);
	String sDateFrom = request.getParameter("df");
	String sDateTo = request.getParameter("dt");
	if (StringUtil.isEmpty(sDateFrom)) sDateFrom = sTransDateSince;
	if (sDateFrom != null) {
		try {
			dateFrom = sdf.parse(sDateFrom);
		} catch (ParseException e) {
		}
	}
	if (StringUtil.isEmpty(sDateTo)) sDateTo = sTransDateTo;
	if (sDateTo != null) {
		try {
			dateTo = sdf.parse(sDateTo);
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
}
System.out.println(dateFrom);
System.out.println(dateTo);

java.util.Date queryDateTo = null;
if (dateTo != null) {
	queryDateTo = DateUtil.add(dateTo, Calendar.DATE, 1);
}





%>
<html>
<head>
<title>Daily Report</title>
<%@ include file="/include/stdhtmlhead.inc.jsp"%>
</head>

<body>
<h1>Transaction Report by Date</h1>
..... <a href='memberReport.jsp'>Or By Member</a>
<br />
<%

	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement stmt = null;
	int paramIdx = 1;
	String sql = null;
	String txSql = null;
	
	
	try {
		
		
		// get CRM database connection
		conn = DbConnectionFactory.getInstance().getConnection("crm");

		
		//
		// Get the daily registration count. The current SQL use the following
		// selection criteria:
		// - Date is first favoured on the temporary card usage 
		// - If a registered member is related to temporary cards, that member's
		//   record is not count. Instead, it is count as temporary card as
		//   previously stated. 
		//
		
		sql = "SELECT register_date, SUM(reg_count) AS reg_count FROM (SELECT to_date(to_char(startdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS register_date, COUNT(*) AS reg_count FROM tempcard WHERE status IN ('activated', 'used') GROUP BY to_date(to_char(startdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') UNION SELECT to_date(to_char(registdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS register_date, COUNT(*) AS reg_count FROM member WHERE regsource <> 'szair-import' AND id NOT IN (SELECT memberid FROM tempcard WHERE memberid IS NOT NULL) AND tempcard_id NOT IN (SELECT id FROM tempcard) GROUP BY to_char(registdate, 'yyyy-mm-dd') ) GROUP BY register_date ORDER BY register_date DESC";
		

		// get database connection.
		conn = DbConnectionFactory.getInstance().getConnection("posapp");
		
		
		
		//
		// Calculate the min, max, median of spending stat by weekday.
		//
		// stores 
		Hashtable<String, Hashtable<Integer, MinMaxMedianStat>> wkdayMinMaxListSets = 
			new Hashtable<String, Hashtable<Integer, MinMaxMedianStat>>();
		//
		//sql = "SELECT TO_CHAR(transdate, 'D') AS transdate_weekday, MIN(tx_count) AS tx_count_min, MAX(tx_count) AS tx_count_max, MEDIAN(tx_count) AS tx_count_median, MIN(amountcurrency_sum) AS amountcurrency_sum_min, MAX(amountcurrency_sum) AS amountcurrency_sum_max, MEDIAN(amountcurrency_sum) AS amountcurrency_sum_median, MIN(point_sum) AS point_min, MAX(point_sum) AS point_max, MEDIAN(point_sum) AS point_median FROM (SELECT TO_DATE(TO_CHAR(transdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS transdate, count(*) AS tx_count, SUM(amountcurrency) AS amountcurrency_sum, sum(point) AS point_sum FROM clubpoint WHERE clubid = '00' AND amountcurrency > 2 AND clubpoint.merchantname NOT LIKE '%积享通%' AND clubpoint.producttypename <> 'T测试' AND clubpoint.transdate >= ? AND clubpoint.transdate < ? GROUP BY TO_DATE(TO_CHAR(transdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') ORDER BY TO_CHAR(transdate, 'yyyy-mm-dd') DESC) GROUP BY TO_CHAR(transdate, 'D') ORDER BY TO_CHAR(transdate, 'D')";
		sql = "SELECT TO_CHAR(transdate, 'D') AS transdate_weekday, MIN(tx_count) AS tx_count_min, MAX(tx_count) AS tx_count_max, MEDIAN(tx_count) AS tx_count_median, MIN(amountcurrency_sum) AS amountcurrency_sum_min, MAX(amountcurrency_sum) AS amountcurrency_sum_max, MEDIAN(amountcurrency_sum) AS amountcurrency_sum_median, MIN(point_sum) AS point_min, MAX(point_sum) AS point_max, MEDIAN(point_sum) AS point_median FROM (SELECT TO_DATE(TO_CHAR(transdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS transdate, count(*) AS tx_count, SUM(amountcurrency) AS amountcurrency_sum, sum(point) AS point_sum FROM clubpoint WHERE clubid = '00' AND amountcurrency > 2 AND clubpoint.merchantname NOT LIKE '%积享通%'  AND clubpoint.isrollback = 0 AND clubpoint.producttypename not like 'T%'  AND clubpoint.transdate >= ? AND clubpoint.transdate < ? GROUP BY TO_DATE(TO_CHAR(transdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') ORDER BY TO_CHAR(transdate, 'yyyy-mm-dd') DESC) GROUP BY TO_CHAR(transdate, 'D') ORDER BY TO_CHAR(transdate, 'D')";
		stmt = conn.prepareCall(sql);
		stmt.setDate(1, new java.sql.Date(dateFrom.getTime()));
		stmt.setDate(2, new java.sql.Date(queryDateTo.getTime()));
		rs = stmt.executeQuery();
		while (rs.next()) {
			// we found that the TO_CHAR('D') converts the value as:
			// "1" -> Sunday, "2" -> Monday, ..., "7" -> Saturday, which 
			// matches the Java Calendar constants for weekday e.g.
			// Calendar.MONDAY.
			Integer wkday = new Integer(rs.getString("transdate_weekday"));
			
			// tx count
			MinMaxMedianStat stat = new MinMaxMedianStat();
			stat.maximum = rs.getDouble("tx_count_max");
			stat.minimum = rs.getDouble("tx_count_min");
			stat.median = rs.getDouble("tx_count_median");
			weekdayTxCountMinMaxMap.put(wkday, stat);
			wkdayMinMaxListSets.put("交易数量", weekdayTxCountMinMaxMap);
			// amount spend
			stat = new MinMaxMedianStat();
			stat.maximum = rs.getDouble("amountcurrency_sum_max");
			stat.minimum = rs.getDouble("amountcurrency_sum_min");
			stat.median = rs.getDouble("amountcurrency_sum_median");
			weekdayAmtSpendMinMaxMap.put(wkday, stat);
			wkdayMinMaxListSets.put("消费金额", weekdayAmtSpendMinMaxMap);
			// point given
			stat = new MinMaxMedianStat();
			stat.maximum = rs.getDouble("point_max");
			stat.minimum = rs.getDouble("point_min");
			stat.median = rs.getDouble("point_median");
			weekdayPointGivenMinMaxMap.put(wkday, stat);
			wkdayMinMaxListSets.put("付出积分", weekdayPointGivenMinMaxMap);
			
		}	// while (rs.next())
		SqlUtil.close(rs);
		
		
		
		//
		// Calculate statistics.
		//
		

		// common SQL
		//txSql = "SELECT TO_CHAR(transdate, 'yyyy-mm-dd') AS transdate_str, count(*) AS tx_count, SUM(amountcurrency) AS amountcurrency_sum, sum(point) AS point_sum FROM clubpoint WHERE clubid = '00' AND amountcurrency > 2 AND clubpoint.merchantname NOT LIKE '%积享通%' AND clubpoint.producttypename <> 'T测试'";
		
		txSql = "SELECT TO_CHAR(transdate, 'yyyy-mm-dd') AS transdate_str, count(*) AS tx_count, SUM(amountcurrency) AS amountcurrency_sum, sum(point) AS point_sum FROM clubpoint WHERE clubid = '00' AND amountcurrency > 2 AND clubpoint.merchantname NOT LIKE '%积享通%'  AND clubpoint.isrollback = 0 AND clubpoint.producttypename not like 'T%' ";
		if (dateFrom != null) {
			txSql += " AND transdate >= ?";
		}
		if (dateTo != null) {
			txSql += " AND transdate < ?";
		}
		txSql += " GROUP BY TO_CHAR(transdate, 'yyyy-mm-dd') ORDER BY TO_CHAR(transdate, 'yyyy-mm-dd') DESC";
		
		
		//
		// Calculate the summary of TX count, spending amount, point given.
		//
		
		// get the maximum and minimum transaction count
		int maxTxCount = 0;
		int minTxCount = 0;
		double medianTxCount = 0;
		sql = "SELECT MAX(tx_count) AS max_tx_count, MIN(tx_count) AS min_tx_count, MEDIAN(tx_count) AS median_tx_count FROM (" + txSql + ")";
		System.out.println(sql);
		// create statement and set value
		stmt = conn.prepareStatement(sql);
		paramIdx = 1;
		if (dateFrom != null) {
			stmt.setTimestamp(paramIdx++, new Timestamp(dateFrom.getTime()));
		}
		if (queryDateTo != null) {
			stmt.setTimestamp(paramIdx++, new Timestamp(queryDateTo.getTime()));
		}
		// execute query
		rs = stmt.executeQuery();
		rs.next();
		maxTxCount = rs.getInt("max_tx_count");
		minTxCount = rs.getInt("min_tx_count");
		medianTxCount = rs.getDouble("median_tx_count");
		rs.close();
		stmt.close();
		
		// get the maximum and minimum spending amount (RMB)
		double minAmountCurrency = 0.0;
		double maxAmountCurrency = 0.0;
		double medianAmountCurrency = 0.0;
		sql = "SELECT MAX(amountcurrency_sum) AS max_amountcurrency, MIN(amountcurrency_sum) AS min_amountcurrency, MEDIAN(amountcurrency_sum) AS median_amountcurrency FROM (" + txSql + ")";
		// create statement and set value
		stmt = conn.prepareStatement(sql);
		paramIdx = 1;
		if (dateFrom != null) {
			stmt.setTimestamp(paramIdx++, new Timestamp(dateFrom.getTime()));
		}
		if (queryDateTo != null) {
			stmt.setTimestamp(paramIdx++, new Timestamp(queryDateTo.getTime()));
		}
		// execute query
		rs = stmt.executeQuery();
		rs.next();
		maxAmountCurrency = rs.getDouble("max_amountcurrency");
		minAmountCurrency = rs.getDouble("min_amountcurrency");
		medianAmountCurrency = rs.getDouble("median_amountcurrency");
		rs.close();
		stmt.close();
		
		// get the maximum and minimum point (Binfen?)
		double maxPoint = 0.0;
		double minPoint = 0.0;
		double medianPoint = 0.0;
		sql = "SELECT MAX(point_sum) AS max_point_sum, MIN(point_sum) AS min_point_sum, MEDIAN(point_sum) AS median_point FROM (" + txSql + ")";
		// create statement and set value
		stmt = conn.prepareStatement(sql);
		paramIdx = 1;
		if (dateFrom != null) {
			stmt.setTimestamp(paramIdx++, new Timestamp(dateFrom.getTime()));
		}
		if (queryDateTo != null) {
			stmt.setTimestamp(paramIdx++, new Timestamp(queryDateTo.getTime()));
		}
		// execute query
		rs = stmt.executeQuery();
		rs.next();
		maxPoint = rs.getDouble("max_point_sum");
		minPoint = rs.getDouble("min_point_sum");
		medianPoint = rs.getDouble("median_point");
		rs.close();
		stmt.close();
		
		
		out.println("<br/>");
		

		
		
		//
		// Output HTML
		//
		
		out.println("<h2>Criteria</h2>");
		out.println("<form method='get'>");
		out.println("<table>");
		out.println("<tr>");
		out.println("<td>From:</td><td><input type='text' name='df' value='" + (dateFrom != null ? dateFormat.format(dateFrom) : "") + "' maxlen='10' size='10' /> <i>(yyyy-mm-dd)</i></td>");
		out.println("<td width='20px'></td>");
		out.println("<td>To:</td><td><input type='text' name='dt' value='" + (dateTo != null ? dateFormat.format(dateTo) : "") + "'  maxlen='10' size='10' /> <i>(yyyy-mm-dd)</i></td>");
		out.println("<td>");
		out.println("<input type='submit' value='Submit' />");
		out.println("</td></tr>");
		out.println("</table>");
		out.println("</form>");
		
		
		// Summary of different statistics (TX count, spending amount, etc.)
		
		out.println("<br/>");
		out.println("<h2>Summary</h2>");
		out.println("<table>");
		out.println("<thead>");
		out.println("<tr>");
		out.println("<th>Type</th>");
		out.println("<th>最高</th>");
		out.println("<th>最低</th>");
		out.println("<th>中位数</th>");
		out.println("</tr>");
		out.println("</thead>");
		out.println("<tbody>");
		out.println("<tr>");
		out.println("<td># of TX</td>");
		out.println("<td class='amount'>" + maxTxCount + "</td>");
		out.println("<td class='amount'>" + minTxCount + "</td>");
		out.println("<td class='amount'>" + medianTxCount + "</td>");
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td>金额</td>");
		out.println("<td class='amount'>" + maxAmountCurrency + "</td>");
		out.println("<td class='amount'>" + minAmountCurrency + "</td>");
		out.println("<td class='amount'>" + medianAmountCurrency + "</td>");
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td>积分</td>");
		out.println("<td class='amount'>" + maxPoint + "</td>");
		out.println("<td class='amount'>" + minPoint + "</td>");
		out.println("<td class='amount'>" + medianPoint + "</td>");
		out.println("</tr>");
		out.println("</tbody>");
		out.println("</table>");
		
		out.println("<br/>");
		
		
		//
		// head
		//
		
		out.println("<h2 style='display: inline;'>Daily Breakdown</h2>");
		
		//
		// Display the wonderful daily chart.
		//
		
		String imgUrl = request.getContextPath() + "/DailyRevenueChartServlet";
		{
			
			String qs = "";
			if (dateFrom != null) {
				if (qs.length() > 0) qs += "&";
				qs += "df=" + dateFormat.format(dateFrom);
			}
			if (dateTo != null) {
				if (qs.length() > 0) qs += "&";
				qs += "dt=" + dateFormat.format(dateTo);
			}
			
			// for header. more image links
			{
				String imgUrl2 = imgUrl;
				String qs2 = qs;
				if (qs2.length() > 0) qs2 += "&";
				qs2 += "w=1024&h=768";
				if (qs2.length() > 0) {
					imgUrl2 += "?" + qs2;
				}
				out.println("<a href=\"" + imgUrl2 + "\">大图</a> &nbsp; ");

				imgUrl2 = imgUrl;
				qs2 = qs;
				if (qs2.length() > 0) qs2 += "&";
				qs2 += "w=1600&h=1024";
				if (qs2.length() > 0) {
					imgUrl2 += "?" + qs2;
				}
				out.println("<a href=\"" + imgUrl2 + "\">超大图</a>");
				out.println("<br/>");
			}
			
			
			if (qs.length() > 0) qs += "&";
			qs += "w=900";
			
			// append the query string
			if (qs.length() > 0) {
				imgUrl += "?" + qs;
			}
		}
		
		out.println("<img src=\"" + imgUrl + "\" /><br/>");
		
		
		
		//
		// Shows the min/max/median of all weekdays
		//
		int[] wkdays = new int[] { Calendar.MONDAY, Calendar.TUESDAY, Calendar.WEDNESDAY,
				Calendar.THURSDAY, Calendar.FRIDAY, Calendar.SATURDAY, Calendar.SUNDAY
		};

		// amount spent
		out.println("<h2>以星期作统计</h2>");
		out.println("<table>");
		out.println("<thead>");
		// first header row
		out.println("<tr>");
		out.println("<th rowspan='2'><nobr>统计类型</nobr></th>");
		for (int i = 0; i < wkdays.length; i++) {
			int wkday = wkdays[i];
			out.println("<th colspan=\"1\" style='text-align: center'>");
			out.print(DateUtil.getWeekdayString(wkday));
			out.println("</th>");
		}
		out.println("</tr>");
		// second header row
		out.println("<tr>");
		for (int i = 0; i < wkdays.length; i++) {
			//out.println("<th>最高</th>");
			//out.println("<th>最低</th>");
			out.println("<th>中位数</th>");
		}
		out.println("</tr>");
		out.println("</thead>");
		// table body: amount spent by consumer
		Iterator <Map.Entry<String, Hashtable<Integer, MinMaxMedianStat>>> iter = 
			wkdayMinMaxListSets.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry<String, Hashtable<Integer, MinMaxMedianStat>> entry = iter.next();
			Hashtable<Integer, MinMaxMedianStat> statList = entry.getValue();
			out.println("<tr>");
			out.print("<td>" + entry.getKey() + "</td>");
			for (int i = 0; i < wkdays.length; i++) {
				int wkday = wkdays[i];
				MinMaxMedianStat stat = statList.get(new Integer(wkday));
				if (stat == null) {
					out.println("<td>-</td>");
					continue;
				}
				
//				out.print("<td class='amount'>");
//				out.print(moneyIntFormat.format(stat.maximum));
//				out.println("</td>");
//				out.print("<td class='amount'>");
//				out.print(moneyIntFormat.format(stat.minimum));
//				out.println("</td>");
				out.print("<td class='amount'>");
				out.print(moneyIntFormat.format(stat.median));
				out.println("</td>");
			}
			out.println("</tr>");
		}
		out.println("</tbody>");
		out.println("</table>");
		
		
		
		out.println("<br/>");
		
		
		//
		// Display the detailed statistics as table form.
		//
		
		out.println("<table>");
		out.println("<thead>");
		out.println("<tr>");
		out.println("<th>#</th>");
		out.println("<th>Date<br/>(yyyy-mm-dd)</th>");
		out.println("<th>Weekday /<br/>Wk. of Yr.</th>");
		out.println("<th><nobr># of<br/>TX</nobr></th>");
		out.println("<th>消费金额</th>");
		out.println("<th>消费金额/TX</th>");
		out.println("<th>积分</th>");
		out.println("<th>积分/TX</th>");
		out.println("<th>TX%</th>");
		out.println("<th>消费金额%</th>");
//		out.println("<th>金额/TX%</th>");
		out.println("<th>积分%</th>");
		out.println("</tr>");
		out.println("</thead>");

		// body
		out.println("<tbody>");
		
		// query daily report
		sql = txSql;
		stmt = conn.prepareStatement(sql);
		paramIdx = 1;
		if (dateFrom != null) {
			stmt.setTimestamp(paramIdx++, new Timestamp(dateFrom.getTime()));
		}
		if (queryDateTo != null) {
			stmt.setTimestamp(paramIdx++, new Timestamp(queryDateTo.getTime()));
		}
		rs = stmt.executeQuery();
		
		
		// formatting stuff
		SimpleDateFormat parseDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		parseDateFormat.setLenient(false);
		SimpleDateFormat sdf = new SimpleDateFormat("E", Locale.CHINA);
		Calendar cal = Calendar.getInstance();
		
		// iterate records
		int i = 1;
		while (rs.next()) {
			
			// provides color background for Saturday and Sunday.
			String wkdayCssStyle = "";
			java.util.Date transDate = parseDateFormat.parse(rs.getString(1));
			cal.setTime(transDate);
			switch (cal.get(Calendar.DAY_OF_WEEK)) {
			case Calendar.SATURDAY:
				wkdayCssStyle=" style=\"background-color: #16DFF8\"";
				break;
			case Calendar.SUNDAY:
				wkdayCssStyle=" style=\"background-color: #FE0000\"";
				break;
			default:
			}
			
			// calculate the bar chart according to the weekday's median
			int weekday = DateUtil.getDateField(transDate, Calendar.DAY_OF_WEEK);
			
			MinMaxMedianStat amtSpendStat = weekdayAmtSpendMinMaxMap.get(new Integer(weekday));
			MinMaxMedianStat txCountStat = weekdayTxCountMinMaxMap.get(new Integer(weekday));
			MinMaxMedianStat pointStat = weekdayPointGivenMinMaxMap.get(new Integer(weekday));
			
			String aboveMedianColor = "#51E01D";
			String belowMedianColor = "#ED5E5E";
			//
			double amtBarWidth = 0.0;
			amtBarWidth = rs.getDouble("amountcurrency_sum") * 100 / maxAmountCurrency;
			String amtBarColor = "";
			if (amtSpendStat != null) amtBarColor = (rs.getInt("amountcurrency_sum") >= amtSpendStat.median) ? aboveMedianColor : belowMedianColor;
			//
			double txBarWidth = 0.0;
			txBarWidth = (double)rs.getInt("tx_count") * 100 / maxTxCount;
			String txBarColor = (rs.getInt("tx_count") >= txCountStat.median) ? aboveMedianColor : belowMedianColor;
			//
			double amtPerTx = rs.getDouble("amountcurrency_sum") / rs.getInt("tx_count");
			double amtPerTxBarWidth = 0.0;
			amtPerTxBarWidth = amtPerTx / (maxAmountCurrency / maxTxCount) * 100;
			String amtPerTxBarColor = (amtPerTx > maxAmountCurrency / maxTxCount) ? aboveMedianColor : belowMedianColor;
			//
			double ptBarWidth = 0.0;
			ptBarWidth = rs.getDouble("point_sum") * 100 / maxPoint;
			String ptBarColor = (rs.getInt("point_sum") > pointStat.median) ? aboveMedianColor : belowMedianColor;
			
			
			// output HTML for the row
			
			
			out.println("<tr>");
			out.println("<td>" + i + "</td>");
			out.println("<td><a href='update.jsp?date="	+ rs.getString(1) + "'>" + rs.getString(1) + "</a></td>");
			out.println("<td" + wkdayCssStyle + ">" + sdf.format(transDate) + " / " + cal.get(Calendar.WEEK_OF_YEAR) + "</td>");
			out.println("<td class=\"amount\">" + rs.getInt(2) + "</td>");
			out.println("<td class=\"amount\">"	+ moneyFormat.format(rs.getDouble(3)) + "</td>");
			out.println("<td class=\"amount\">"	+ moneyFormat.format(rs.getDouble(3) / rs.getInt(2)) + "</td>");
			out.println("<td class=\"amount\">"	+ pointFormat.format(rs.getDouble(4)) + "</td>");
			out.println("<td class=\"amount\">"	+ pointFormat.format(rs.getDouble(4) / rs.getInt(2)) + "</td>");
			out.println("<td class='reset' style=\"width: 80px\"><table class='reset' style='height: 22px; width: 100%'><tr><td class='reset' style=\"background-color: " + txBarColor + "\" width=\"" + (int)txBarWidth + "%\"></td>" + (txBarWidth < 100 ? ("<td class='reset' width=\"" + (100 - (int)txBarWidth) + "%\"></td>") : "") + "</tr></table></td>");
			out.println("<td class='reset' style=\"width: 80px\"><table class='reset' style='height: 22px; width: 100%'><tr><td class='reset' style=\"background-color: " + amtBarColor + "\" width=\"" + (int)amtBarWidth + "%\"></td>" + (amtBarWidth < 100 ? ("<td class='reset' width=\"" + (100 - (int)amtBarWidth) + "%\"></td>") : "") + "</tr></table></td>");
//			out.println("<td class='reset' style=\"width: 80px\"><table class='reset' style='height: 22px; width: 100%'><tr><td class='reset' style=\"background-color: " + amtPerTxBarColor + "\" width=\"" + (int)amtPerTxBarWidth + "%\"></td>" + (amtPerTxBarWidth < 100 ? ("<td class='reset' width=\"" + (100 - (int)amtPerTxBarWidth) + "%\"></td>") : "") + "</tr></table></td>");
			out.println("<td class='reset' style=\"width: 80px\"><table class='reset' style='height: 22px; width: 100%'><tr><td class='reset' style=\"background-color: " + ptBarColor + "\" width=\"" + (int)ptBarWidth + "%\"></td>" + (ptBarWidth < 100 ? ("<td class='reset' width=\"" + (100 - (int)ptBarWidth) + "%\"></td>") : "") + "</tr></table></td>");
			out.println("</tr>");
			i++;
		}
		out.println("</tbody>");
		out.println("</table>");
		
	} finally {
		SqlUtil.close(conn);
	}
%>
</body>
</html>