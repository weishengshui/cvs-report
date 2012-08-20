<%--

	This report shows the top X merchants.
	
	@author cyril
	@since 1.2.2 2010-04-28

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*" %>
<%@ page import="com.chinarewards.report.db.*" %>
<%@ page import="com.chinarewards.report.data.crm.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp" %>
<%


Connection conn = null;
ResultSet rs = null;
PreparedStatement stmt = null;
String sql = null;

// formatting
DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");


// topCount: Stores the maximum number of top records to be displayed per
// transaction period.
int topCount = 10;



//
// Process query parameters
//
if (request.getParameter("top") != null) {
	try {
		int n = Integer.parseInt(request.getParameter("top"));
		if (n > 0) {
			topCount = n;
		}
	} catch (NumberFormatException e) {
	}
}




%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>最高收益商户</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
<link rel="stylesheet" href="<%=ctxRootPath%>/js/jquery/plugin/tablesorter/themes/blue/style.css" type="text/css" media="print, projection, screen" />
<script type="text/javascript" src="<%=ctxRootPath%>/js/jquery/jquery-latest.js"></script>
<script type="text/javascript" src="<%=ctxRootPath%>/js/jquery/plugin/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="<%=ctxRootPath%>/js/jquery/plugin/tablesorter/custom/parser.js"></script>
<script type="text/javascript">
$(document).ready(function() 
{
	// $("").tablesorter();
} 
); 
</script>
<style type="text/css">
.rank_table {
	width: 700px;
}
.rank_table .rank_col {
	width: 40px;
}
.rank_table .amt_col {
	width: 80px;
}
.rank_table .chg_pc_col {
	width: 60px;
}
.rank_table .tx_count_col {
	width: 50px;
}
</style>
</head>
<body>

<h1>最高收益商户</h1>

本报表显示了每个月的首<%=topCount%>个最高消费额的商户。
<br/><br/>

<a href="?top=5">首5名</a> <a href="?top=10">首10名</a> <a href="?top=20">首20名</a>       
<br/>


<%
try {
	
	int groupCount = 0;
	
	// get CRM database connection
	conn = DbConnectionFactory.getInstance().getConnection("posapp");
	
	//
	// Task query all records, group by month.
	//
	
	sql = "SELECT * FROM ("
		+ "SELECT to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd') AS xaction_period, merchantid, merchantname, SUM(amountcurrency) AS amount_sum, COUNT(*) AS tx_count_sum, "
		+ "RANK() OVER (PARTITION BY to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd') ORDER BY SUM(amountcurrency) DESC NULLS LAST) AS amount_sum_rank, "
		+ "RANK() OVER (PARTITION BY to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd') ORDER BY COUNT(*) DESC NULLS LAST) AS tx_count_rank "
		+ "FROM clubpoint "
		+ "WHERE transdate >= to_date('20090601','yyyymmdd') "
		+ "AND clubid='00' AND merchantname NOT LIKE '%积享通%' AND producttypename <> 'T测试' AND amountcurrency >= 1 " 
		+ "GROUP BY to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd'), merchantid, merchantname "
		+ ") "
		+ "WHERE amount_sum_rank <= " + topCount + " "
		+ "ORDER BY xaction_period DESC, amount_sum_rank, merchantid";
	
	sql = "SELECT * FROM ("
		+ " WITH v AS ( "
		+ " SELECT to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd') AS xaction_period, merchantid, merchantname, SUM(amountcurrency) AS amount_sum, COUNT(*) AS tx_count_sum, "
		+ " RANK() OVER (PARTITION BY to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd') ORDER BY SUM(amountcurrency) DESC NULLS LAST) AS amount_sum_rank, "
		+ " RANK() OVER (PARTITION BY to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd') ORDER BY COUNT(*) DESC NULLS LAST) AS tx_count_rank, "
		+ " LAG(SUM(amountcurrency),1) OVER (PARTITION BY merchantid, merchantname ORDER BY to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd') ASC) AS last_amount, "
		+ " LAG(COUNT(*),1) OVER (PARTITION BY merchantid, merchantname ORDER BY to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd') ASC) AS last_tx_count "
		+ " FROM clubpoint "
		+ " WHERE transdate >= to_date('20090601','yyyymmdd') "
		+ " AND clubid='00' AND merchantname NOT LIKE '%积享通%' AND producttypename <> 'T测试' AND amountcurrency >= 1 " 
		+ " GROUP BY to_date(concat(to_char(transdate,'yyyymm'),'01'),'yyyymmdd'), merchantid, merchantname "
		+ " ORDER BY xaction_period, tx_count_rank, amount_sum_rank "
		+ ") "
		+ "SELECT v.*, "
		+ "LAG(amount_sum_rank,1) OVER (PARTITION BY merchantid, merchantname ORDER BY xaction_period ASC) AS last_period_amt_rank, "
		+ "LAG(amount_sum_rank,1) OVER (PARTITION BY merchantid, merchantname ORDER BY xaction_period DESC) AS next_period_amt_rank "
		+ "FROM v "
		+ ") "
		+ "WHERE amount_sum_rank <= " + topCount + " "
		+ "ORDER BY xaction_period DESC, amount_sum_rank ASC";

	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();

	//
	// show the listing on JSP.
	//
%>



<%

	// absolute eof.
	boolean eof = false;

	// whether the ResultSet reached the end.
	boolean rsEof = false;
	// whether the rs contains a unread record. If true, the loop should 
	// use the current record in the resultset instead of calling 
	// ResultSet.next().
	boolean rsBuffered = false;
	
	boolean insideGroup = false;
	
	// remember the last transaction group.
	java.util.Date lastXactGroup = null;
	
	// stores the position of the record inside a group. This is zero-based.
	// when a record is output, it is incremented by one. This is reset to 
	// zero when a group is done.
	int groupPosition = 0;

	while (!eof) {
		
		
		// if flagged to fetch record:
		// - and if result set NOT eof, fetch record.
		if (!rsEof && !rsBuffered) {
			rsEof = !rs.next();
		}
		
		// the loop stopping condition.
		if (rsEof && !rsBuffered) eof = true;
		
		// at this point, the resultset is consumed.
		rsBuffered = false;
		
		// if start of group, output starting HTML, and continue.
		if (!insideGroup && !eof) {
			
%>
<!-- Start of group -->
<table id="stat_tbl_<%=groupCount%>" class="tablesorter rank_table">
<thead>
<tr><th colspan="9"><%=rs.getTimestamp("xaction_period")%></th>
</tr>
<tr>
<th class="rank_col">排名</th>
<th class="rank_col">上次<br/>排名</th>
<th class="rank_col">下次<br/>排名</th>
<th>商户</th>
<th class="amt_col">交易额</th>
<th class="chg_pc_col">交易额<br/>升跌%</th>
<th class="tx_count_col">交易量</th>
<th class="chg_pc_col">交易量<br/>升跌%</th>
</tr>
</thead>
<tbody>
<%			
			// we are inside the group
			insideGroup = true;
			groupCount++;
			groupPosition = 0;
		}
		
		
		boolean groupChanged = false;
		
		if (!eof) {
			groupChanged = 
				(lastXactGroup != null && !lastXactGroup.equals(rs.getTimestamp("xaction_period")));
			
			// output the record
			if (!groupChanged) {
				
				boolean isNew;
				String amtChgText = "";
				String txChgText = "";
				
				// calculate the change in amount
				rs.getDouble("last_amount");
				isNew = rs.wasNull();
				if (isNew) {
					amtChgText = "(-)";
				} else {
					double diff = (rs.getDouble("amount_sum") - rs.getDouble("last_amount")) / rs.getDouble("last_amount") * 100;
					amtChgText = (diff > 0 ? "+" : "" ) + moneyFormat.format(diff) + "%";
					if (diff != 0) {
						String css = (diff > 0) ? "value_raise" : "value_drop";
						amtChgText = "<span class=\"" + css + "\">" + amtChgText + "</span>";
					}
					
				}
				
				// calculate the change in tx count
				rs.getDouble("last_tx_count");
				isNew = rs.wasNull();
				if (isNew) {
					txChgText = "(-)";
				} else {
					double diff = (rs.getDouble("tx_count_sum") - rs.getDouble("last_tx_count")) / rs.getDouble("last_tx_count") * 100;
					txChgText = (diff > 0 ? "+" : "" ) + moneyFormat.format(diff) + "%";
					if (diff != 0) {
						String css = (diff > 0) ? "value_raise" : "value_drop";
						txChgText = "<span class=\"" + css + "\">" + txChgText + "</span>";
					}
				}
				
%>
<tr>
<td><%=(groupPosition+1)%></td>
<td><%=(rs.getLong("last_period_amt_rank")!=0 ? rs.getLong("last_period_amt_rank") : "-")%></td>
<td><%=(rs.getLong("next_period_amt_rank")!=0 ? rs.getLong("next_period_amt_rank") : "-")%></td>
<td><%=rs.getString("merchantname")%><!-- <%=rs.getString("merchantid")%> --></td>
<td class="amount"><%=moneyFormat.format(rs.getDouble("amount_sum"))%></td>
<td class="amount"><%=amtChgText%></td>
<td class="amount"><%=rs.getLong("tx_count_sum")%></td>
<td class="amount"><%=txChgText%></td>
</tr>
<%		
				groupPosition++;
			}
		}
		
		
		// remember the last period.
		if (!eof) {
			lastXactGroup = rs.getTimestamp("xaction_period");
		}
		
		// if the transaction period is changed, close the HTML group, and 
		// buffer the resultset
		if (groupChanged || eof) {
%>
</tbody>
</table>
<%
			rsBuffered = true;
			insideGroup = false;
			continue;
		}
		
		
	}
%>

<script type="text/javascript">
$(document).ready(function() 
{
<%
	for (int i=0; i<groupCount; i++) {
%>
		$("#stat_tbl_<%=i%>").tablesorter();
				<%
	}
%>
} 
); 
</script>

<%
} finally {
	SqlUtil.close(stmt);
	SqlUtil.close(rs);
	SqlUtil.close(conn);
}
%>

</body>
</html>