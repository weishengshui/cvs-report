<%--

Shows the unique shop spending records of member (by card number).

@author cyril
@since 2010-01-10

 --%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.data.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page language="java" import="com.chinarewards.report.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>

<% 

Connection conn = null; 
Connection crmConn = null; 
ResultSet rs = null; 
PreparedStatement stmt = null;
String sql = null;


//
// Criteria
//
String transDateFrom = "2010-01-23";
String transDateTo = "2010-02-11";	// on or before 2010-01-31
int minUniqueShop = 2;	// minimum unique shops per member.
double minSpendingPerShop = 100; 	// minimum spending per shop.

// China Rewards staff card list
MemberCardStoreImpl memberCardStore = new MemberCardStoreImpl();
List<String> crStaffCardList = memberCardStore.getChinaRewardsCardNumberList();
String crStaffCardListSqlValues = SqlUtil.buildDelimitedValueList(crStaffCardList, true);
System.out.println("China Rewards staff card list: " + crStaffCardListSqlValues);



%>
<html>
<head>
<title>跨商户消费电影票赠送活动 (<%=transDateFrom%> 至 <%=transDateTo%>零时零晨前)</title>
</head>

<body>
<!-- Introduction begins -->

<h1>跨商户消费电影票赠送活动 (<%=transDateFrom%> 至 <%=transDateTo%>零时零晨前)</h1>
<br/>

<h2>目的</h2>
针对所有的会员的抢票活动，即所有的缤分联盟卡会员（除内部员工外），以拓展跨商户消费会员的数量。

<h2>规则</h2>
<ul>
<li>活动时间：<%=transDateFrom%> 至 <%=transDateTo%>零时零晨前</li>
<li>在任意<%=minUniqueShop%>家“缤分联盟”商户消费单笔满100元，即可赠送一张电影票。</li>
<li>参与对象：缤分联盟卡会员（除内部员工外)</li>
</ul>

<h2>报表需求日期</h2>
2010年1月2日

<br/><br/>
<hr/>
<br/>
<!-- Introduction ends -->


<!-- Content -->
<%
try {
	
	conn = DbConnectionFactory.getInstance().getConnection("posapp");
	crmConn = DbConnectionFactory.getInstance().getConnection("crm");

	// for querying member record using card number.
	PreparedStatement memberStmt = crmConn.prepareStatement("SELECT member.id, chisurname, chilastname, gender, mobiletelephone FROM member INNER JOIN membership ON member.id=membership.member_id WHERE membership.membercardno = ?");
	ResultSet memberRs = null;
	String memberCardNosFilter = null;
	if (!StringUtil.isEmpty(crStaffCardListSqlValues)) {
		memberCardNosFilter = " AND cp.membercardid NOT IN ("
				+ crStaffCardListSqlValues + ")";
	}

	
	//
	// Build the SQL statement!
	//
	
	
	// sqlMemberUniqueShopSpending:
	// query the list of card numbers
	// which the member has minimum spending amount and has spent 
	// at least 'minUniqueShop' number of unique shops.
	String sqlMemberUniqueShopSpending = "SELECT membercardid FROM (SELECT cp.membercardid, cp.shopid FROM clubpoint cp WHERE cp.clubid = '00' AND shopid IS NOT NULL AND cp.amountcurrency >= " + minSpendingPerShop + " AND cp.transdate >= {d '" + transDateFrom + "'} AND cp.transdate < {d '" + transDateTo + "'} " + memberCardNosFilter + " GROUP BY cp.membercardid, cp.shopid ORDER BY cp.membercardid, cp.shopid) GROUP BY membercardid HAVING COUNT(*) >= " + minUniqueShop;
	System.out.println("sqlMemberUniqueShopSpending: " + sqlMemberUniqueShopSpending);
	
	// sqlMemberEarliestUniqueShopSpending: 
	// Query the list of 
	// spending records of members fulfilling SQL 'sqlMemberUniqueShopSpending',
	// and the shop ID plus the earliest transaction date among
	// the same shop. Outer SQL can use these 3 information to 
	// lookup the earliest transaction record per unique shop
	String sqlMemberEarliestUniqueShopSpending = "SELECT cp.membercardid, cp.shopid, MIN(cp.transdate) AS min_transdate FROM clubpoint cp WHERE cp.clubid = '00' AND cp.amountcurrency >= " + minSpendingPerShop + " AND cp.transdate >= {d '" + transDateFrom + "'} AND cp.transdate < {d '" + transDateTo + "'} AND cp.membercardid IN (";
	sqlMemberEarliestUniqueShopSpending += sqlMemberUniqueShopSpending;
	sqlMemberEarliestUniqueShopSpending += ") GROUP BY cp.membercardid, cp.shopid ORDER BY cp.membercardid, cp.shopid";
	System.out.println("sqlMemberEarliestUniqueShopSpending: " + sqlMemberEarliestUniqueShopSpending);

	sql = "SELECT * from clubpoint, (";
	sql += sqlMemberEarliestUniqueShopSpending;
	sql += ") clubpoint_uniqueshop WHERE clubpoint.membercardid=clubpoint_uniqueshop.membercardid AND clubpoint.shopid=clubpoint_uniqueshop.shopid AND clubpoint.transdate=clubpoint_uniqueshop.min_transdate ORDER BY clubpoint.membercardid, clubpoint.shopname, clubpoint.shopid";
	
	System.out.println(sql);
	
	// Set parameters
	// criteria: non-BNK shops
	stmt = conn.prepareStatement(sql);
	// execute the query!
	rs = stmt.executeQuery();

	//
	// show result as table form
	//
%>


<table>
<thead>
<tr>
<th>会员卡号分组</th>
<th>#</th>
<th>会员卡号</th>
<th>会员姓名</th>
<th>会员电话</th>
<th>会员性别</th>
<th>商户名称</th>
<th>门市名称</th>
<th>交易金额</th>
<th>交易日期</th>
<%--<th>消费产品种类名称</th> --%>
</tr>
</thead>
<tbody>
<%
	String lastMemberCardNo = null;
	int memberUniqueSpendIdx = 1;
	while (rs.next()) {
		
		// lookup the member record
		memberStmt.clearParameters();
		memberStmt.setString(1, rs.getString("membercardid"));
		memberRs = memberStmt.executeQuery();
		boolean hasMemberInfo = memberRs.next();
		String memberName = "";
		if (hasMemberInfo) {
			if (memberRs.getString("chisurname") != null) {
				memberName = memberRs.getString("chisurname");
			}
			if (memberRs.getString("chilastname") != null) {
				memberName += memberRs.getString("chilastname");
			}
		}
		
		// check whether the member card number should be displayed
		boolean showMemberCardNo = false;
		if (lastMemberCardNo == null || !lastMemberCardNo.equals(rs.getString("membercardid"))) {
			// member card number changed. Treat as new member.
			showMemberCardNo = true;
			memberUniqueSpendIdx = 1;
		}
%>
<tr>
<td><%=(showMemberCardNo) ? JspDisplayUtil.noNull(rs.getString("membercardid")) : ""%></td>
<td><%=memberUniqueSpendIdx%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("membercardid"))%></td>
<td><%=memberName%></td>
<td><%=(hasMemberInfo && memberRs.getString("mobiletelephone")!=null) ? memberRs.getString("mobiletelephone") : ""%></td>
<td><%=(hasMemberInfo && memberRs.getInt("gender")==0 ? "男" : "女")%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("merchantname"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("shopname"))%></td>
<td style="text-align: right"><%=JspDisplayUtil.noNull(rs.getDouble("amountcurrency"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getTimestamp("transdate"))%></td>
<%--<td><%=JspDisplayUtil.noNull(rs.getString("producttypename"))%></td> --%>
</tr>
<%
		// update the last member card number.
		lastMemberCardNo = rs.getString("membercardid");

		if (hasMemberInfo) {
			SqlUtil.close(memberRs);
		}
		memberRs = null;
		
		memberUniqueSpendIdx++;

	} // while (has more clubpoint records)
%>
</tbody>
</table>

</body>

</html>
<%

} finally {

	// gracefully close the database connection
	SqlUtil.close(rs);
	SqlUtil.close(stmt);
	SqlUtil.close(conn);
	SqlUtil.close(crmConn);
	
}
%>