<%--

Reports related to show list of TX accounts with most unused effective
points and related member information.


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

Connection crmConn = null;


// formatting
DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
DecimalFormat dateFormat = new DecimalFormat("yyyy-MM-dd");


try {
	
	// get database connection
	conn = DbConnectionFactory.getInstance().getConnection("tx");
	crmConn = DbConnectionFactory.getInstance().getConnection("crm");
	
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
	
	
	
	
%>
<html>
<head>
<title>最多未使用积分会员列表</title>
</head>

<body>



<!-- 未使用积分总额之会员及临时卡使用者 STARTS -->
<h1>未使用积分总额之会员及临时卡使用者</h1>
<table>
<thead>
<tr>
<th>积分</th>
<th>数量</th>
</tr>
</thead>
<tbody>
<%
{
	sql = "SELECT COUNT(*) AS account_count FROM (SELECT account.id, account.ownerid, account.accountid, SUM(accountbalance.units) AS units_sum FROM accountbalance INNER JOIN account ON account.id=accountbalance.account_id WHERE account.status = 'OK' AND accountbalance.unitcode='缤分' AND NOT accountbalance.expirydate < sysdate AND (account.ownerid LIKE '%@crm.china-rewards.com' OR account.accountid LIKE 'T_%') GROUP BY account.id, account.ownerid, account.accountid) stat WHERE stat.units_sum >= ?";
	stmt = conn.prepareStatement(sql);
	double point_sum_list[] = new double[] { 50, 100, 150, 200, 300, 500, 1000, 1500, 2000 };
	for (int i = 0; i<point_sum_list.length; i++) {
		double point = point_sum_list[i];
		
		// set query parameters
		stmt.clearParameters();
		stmt.setDouble(1, point);
		rs = stmt.executeQuery();
		rs.next();
%>
<tr>
<td class="amount"><%=point%> 或以上</td>
<td class="amount"><%=rs.getLong("account_count")%></td>
</tr>
<%
		SqlUtil.close(rs);
	}
	SqlUtil.close(stmt);
}
%>
</tbody>
</table>
<!-- 未使用积分总额之会员及临时卡使用者 ENDS -->





<!-- 最多未使用积分之会员列表 STARTS -->
<%

//
// Get the list of unused, effective points grouped by member ID, 
// unit code and unit ID.
//

if (false) {
	//
	// Report:
	// Unused and effective / expired points total.
	//
	
	// get all unused, effective Binfen.
	sql = "SELECT account.id, account.ownerid, account.accountid, SUM(accountbalance.units) AS units_sum FROM accountbalance INNER JOIN account ON account.id=accountbalance.account_id WHERE account.status = 'OK' AND accountbalance.unitcode='缤分' AND NOT accountbalance.expirydate < sysdate AND (account.ownerid LIKE '%@crm.china-rewards.com' OR account.accountid LIKE 'T_%') HAVING SUM(accountbalance.units) >= 50 GROUP BY account.id, account.ownerid, account.accountid ORDER BY units_sum DESC, account.id";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
%>
<h1>最多未使用积分之会员列表</h1>
<table>
<thead>
<tr>
<th>#</th>
<th>已注册</th>
<th>姓名</th>
<th>电话</th>
<th>临时卡卡号</th>
<th>积分</th>
</tr>
</thead>
<tbody>
<%

	// for querying member / tempcard records using information from the
	// Account table.
	PreparedStatement memberByTxStmt = crmConn.prepareStatement("SELECT DISTINCT member.id, member.chisurname, member.chilastname, member.mobiletelephone FROM member LEFT JOIN membership ON member.id=membership.member_id WHERE member.accountid = ? OR membership.accountid = ?");
	PreparedStatement tempCardStmt = crmConn.prepareStatement("SELECT * FROM tempcard WHERE tempcard.accountid = ?");

	// iterate records
	int i = 1;
	while (rs.next()) {
		
		// determine if the account is assoicated to a member by inspecting 
		// the owner ID.
		boolean isRegisteredAsMember = (rs.getString("ownerid") == null) ? false : true;
		String mobile = "";
		String memberName = "";
		String tempCardId = "";
		
		// get member information if it is registered.
		if (isRegisteredAsMember) {
			
			memberByTxStmt.clearParameters();
			memberByTxStmt.setString(1, rs.getString("accountid"));
			memberByTxStmt.setString(2, rs.getString("accountid"));
			ResultSet memberRs = null;
			try {
				memberRs = memberByTxStmt.executeQuery();
				if (memberRs.next()) {
					mobile = memberRs.getString("mobiletelephone");
					// Chinese name
					memberName = "";
					if (memberRs.getString("chisurname") != null) {
						memberName += memberRs.getString("chisurname");
					}
					if (memberRs.getString("chilastname") != null) {
						memberName += memberRs.getString("chilastname");
					}
				}
			} finally {
				SqlUtil.close(memberRs);
			}
			
		} else {
			
			// not registered, get the card ID from TempCard table.
			
			tempCardStmt.clearParameters();
			tempCardStmt.setString(1, rs.getString("accountid"));
			ResultSet tcRs = null;
			try {
				tcRs = tempCardStmt.executeQuery();
				if (tcRs.next()) {
					tempCardId = tcRs.getString("id");
				}
			} finally {
				SqlUtil.close(tcRs);
			}
		}
		
%>
<tr>
<td><%=i%></td>
<td><%=(isRegisteredAsMember) ? "是" : "否"%></td>
<td><%=memberName%></td>
<td><%=mobile%></td>
<td><%=tempCardId%></td>
<td class="amount"><%=pointFormat.format(rs.getDouble("units_sum"))%></td>
</tr>
<%
		i++;
	}	// while (rs.next())
	
	SqlUtil.close(memberByTxStmt);
	SqlUtil.close(tempCardStmt);
	
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
<!-- 最多未使用积分之会员列表 ENDS -->




</body>
</html>
<%

} catch (Throwable t) {
	out.println("Exception occurred:<br>");
	t.printStackTrace(new PrintWriter(out));
	t.printStackTrace(new PrintWriter(System.out));
} finally {
	// tx
	SqlUtil.close(rs);
	SqlUtil.close(stmt);
	SqlUtil.close(conn);

	// crm
	SqlUtil.close(crmConn);
}
%>