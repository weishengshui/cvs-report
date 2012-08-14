<%--

Reports related to the account balance (point oriented) of all members.


@author cyril
@since 1.3.0 2010-01-18

--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.text.*, java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page language="java" import="com.chinarewards.report.util.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%
Connection conn = null; 
ResultSet rs = null; 
PreparedStatement stmt = null;
String sql = null;

// formatting
DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");


try {
	
	// get database connection
	conn = DbConnectionFactory.getInstance().getConnection("tx");

	
	// All selection criteria is as follow:
	//
	// - unit code is '缤分'
	// - member accounts only: identified by owner ID with suffix 
	//   '@crm.china-rewards.com' or account ID starts with 'T_'.
	// - account status is OK
	// - expiry date in account balance is inclusive: any records falls on
	//   or later than the date is considered expired. In short:
	//   - accountbalance.expirydate >= <target_date>: Any points on or
	//     after the target_date is considered effective.
	//   - accountbalance.expirydate > <target_date>: Any points on or
	//     after the target_date is considered expired.
	
	
	
	
	//
	// Report:
	// Unused and effective / expired points total.
	//
	
	// get all unused, effective Binfen.
	sql = "SELECT SUM(accountbalance.units) AS units_sum FROM accountbalance INNER JOIN account ON account.id=accountbalance.account_id WHERE account.status = 'OK' AND accountbalance.unitcode='缤分' AND accountbalance.expirydate >= sysdate AND (account.ownerid LIKE '%@crm.china-rewards.com' OR account.accountid LIKE 'T_%') ORDER BY account.id, accountbalance.expirydate";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	rs.next();
	double unusedEffectivePoints = rs.getDouble("units_sum");
	SqlUtil.close(rs);
	rs = null;
	SqlUtil.close(stmt);
	stmt = null;
	
	// get all unused, expired Binfen.
	sql = "SELECT SUM(accountbalance.units) AS units_sum FROM accountbalance INNER JOIN account ON account.id=accountbalance.account_id WHERE account.status = 'OK' AND accountbalance.unitcode='缤分' AND accountbalance.expirydate < sysdate AND (account.ownerid LIKE '%@crm.china-rewards.com' OR account.accountid LIKE 'T_%') ORDER BY account.id, accountbalance.expirydate";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	rs.next();
	double unusedExpiredPoints = rs.getDouble("units_sum");
	SqlUtil.close(rs);
	rs = null;
	SqlUtil.close(stmt);
	stmt = null;
	
%>
<html>
<head>
<title>会员积分情况报告</title>
</head>

<body>



<!-- 会员积分情况 STARTS -->
<h1>会员积分情况</h1>
<table>
<thead>
<tr>
<th>未使用未过期积分</th>
<th>未使用已过期积分</th>
</tr>
</thead>
<tbody>
<tr>
<td><%=unusedEffectivePoints%></td>
<td><%=unusedExpiredPoints%></td>
</tr>
</tbody>
</table>
<!-- 会员积分情况 ENDS -->



<!-- 未使用积分种类明细 STARTS -->
<%

//
// Get the list of unused, effective points grouped by unit code and unit 
// ID.
//

{
	// get all unused, effective Binfen.
	sql = "SELECT accountbalance.unitcode, accountbalanceunit.unit_id, SUM(accountbalanceunit.units) AS units_sum FROM accountbalance INNER JOIN account ON account.id=accountbalance.account_id INNER JOIN accountbalanceunit ON accountbalance.id= accountbalanceunit.acbalance_id WHERE account.status = 'OK' AND accountbalance.unitcode='缤分' AND accountbalance.expirydate >= sysdate AND (account.ownerid LIKE '%@crm.china-rewards.com' OR account.accountid LIKE 'T_%') GROUP BY accountbalance.unitcode, accountbalanceunit.unit_id";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
%>
<br/>
<h1>未使用积分种类明细</h1>
<table>
<thead>
<tr>
<th>种类</th>
<th>子种类</th>
<th>积分</th>
</tr>
</thead>
<tbody>
<%
	// iterate records
	while (rs.next()) {
%>
<tr>
<td><%=rs.getString("unitcode")%></td>
<td><%=rs.getString("unit_id")%></td>
<td class="amount"><%=pointFormat.format(rs.getDouble("units_sum"))%></td>
</tr>
<%
	}	// while (rs.next())
%>
</tbody>
</table>
<%
	// release resources
	SqlUtil.close(stmt);
	stmt = null;
	SqlUtil.close(rs);
	rs = null;
}
%>
<!-- 未使用积分种类明细 ENDS -->




<!-- 即将到期积分 STARTS -->
<br/>
<h1>即将到期积分</h1>
<table>
<thead>
<tr>
<th>日期</th>
<th>该月将过期积分</th>
<th>累计将过期积分</th>
</tr>
</thead>
<tbody>
<%
{
	//
	// Reports: Shows the points to be expired for the future months.
	//

	// query
	sql = "SELECT accountbalance.expirydate, SUM(accountbalance.units) AS units_sum FROM accountbalance INNER JOIN account ON account.id=accountbalance.account_id WHERE account.status = 'OK' AND accountbalance.unitcode='缤分' AND NOT accountbalance.expirydate < sysdate AND (account.ownerid LIKE '%@crm.china-rewards.com' OR account.accountid LIKE 'T_%') GROUP BY accountbalance.expirydate ORDER BY accountbalance.expirydate";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	double cumulativePoint = 0;
	while (rs.next()) {
		
		cumulativePoint += rs.getDouble("units_sum");
%>
<tr>
<td><%=dateFormat.format(rs.getDate("expirydate"))%></td>
<td class="amount"><%=pointFormat.format(rs.getDouble("units_sum"))%></td>
<td class="amount"><%=pointFormat.format(cumulativePoint)%></td>
</tr>
<%
	}	// while (rs.next())
	

}
%>
</tbody>
</table>
<!-- 即将到期积分 END -->




</body>
</html>
<%

} catch (Throwable t) {
	out.println("Exception occurred:<br>");
	t.printStackTrace(new PrintWriter(out));
	t.printStackTrace(System.out);
} finally {
	SqlUtil.close(rs);
	SqlUtil.close(stmt);
	SqlUtil.close(conn);
}
%>