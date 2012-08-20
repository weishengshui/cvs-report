<%--

	This report shows the transaction of a member.
	
	The input parameter can be one or more of the following:
	
	- member ID
	- organization ID of the card member used.
	- 'card number' used in transaction (can be mobile number or card number in 
	  table 'MEMBERSHIP'.
	- TX account ID.

 --%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*" %>
<%@ page import="com.chinarewards.report.db.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ page import="com.chinarewards.report.data.crm.*" %>
<%@ page import="com.chinarewards.report.jsp.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<%

// get request parameters
String queryCardNo = request.getParameter("cardno");
String queryMemberId = request.getParameter("memberId");
String queryOrgId = request.getParameter("orgId");
String queryTxAcctId = request.getParameter("acctId");




DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");


// Input parameter check: Member search criteria from query string must be
// present.
if (StringUtil.isEmpty(queryCardNo) && StringUtil.isEmpty(queryMemberId)
		&& StringUtil.isEmpty(queryOrgId) && StringUtil.isEmpty(queryTxAcctId)) {
	out.println("Missing member identification");
	return;
}


// setup the member searching parameters.
MemberLocator.Criteria criteria = new MemberLocator.Criteria();
criteria.setCardNumber(StringUtil.trimToNull(queryCardNo));
criteria.setMemberId(StringUtil.trimToNull(queryMemberId));
criteria.setOrganizationId(StringUtil.trimToNull(queryOrgId));
criteria.setTxAccountId(StringUtil.trimToNull(queryTxAcctId));


// declare variables
Connection conn = null;
ResultSet rs = null;
PreparedStatement stmt = null;
String sql = null;
MemberLocator memberLocator = null;


try {

	//
	// First step: Locate the member as hard as possible
	//

	conn = DbConnectionFactory.getInstance().getConnection("crm");
	
	// look up the member
	memberLocator = new MemberLocator();
	rs = memberLocator.searchMember(conn, criteria);
	
	boolean hasMemberInfo = false;	// unknown yet
	String memberId = null;
	List<String> accountIds = new ArrayList<String>();
	
	// if member record exists, we look up all transaction account IDs, 
	// otherwise, we use the given parameter to search for tx account.
	if (rs == null || !rs.next()) {
		
		// no Member record
		
		hasMemberInfo = false;
		
//		System.out.println("no member record");
		
		if (rs != null) SqlUtil.close(rs);
		
		if (!StringUtil.isEmpty(queryTxAcctId)) {
			// if tx account is given in the query string, we use it directly.
			accountIds.add(StringUtil.trimToNull(queryTxAcctId));
		}
		
	} else {
		
		hasMemberInfo = true;
		
//		System.out.println("has member record");
		
		// member record is located.
		memberId = rs.getString("id");
		SqlUtil.close(rs);
		
		// next phase: In order to know all transaction of this member, we
		// do the following:
		// - look up all TX account Ids
		sql = "SELECT accountid FROM member WHERE accountid IS NOT NULL AND member.id=? "
				+ " UNION "
				+ "SELECT accountid FROM membership WHERE accountid IS NOT NULL AND member_id=?";
//		System.out.println("sql = " + sql);
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, memberId);
		stmt.setString(2, memberId);
		rs = stmt.executeQuery();
		// get distinct list of account IDs.
		accountIds.clear();
		while (rs.next()) {
			accountIds.add(rs.getString(1));
		}
		SqlUtil.close(rs);
		SqlUtil.close(stmt);
		
	}
		
	// clean up resources
	if (memberLocator != null) {
		memberLocator.destroy();
		memberLocator = null;
	}
	
	

	
	//
	// Second step:
	// Search member transaction records.
	//
	

	// play with POSAPP tables
	conn = DbConnectionFactory.getInstance().getConnection("posapp");
	
	// construct the SQL
	String accountIdsFilter = SqlUtil.buildDelimitedValueList(accountIds, true);
//	System.out.println("accountIdsFilter = " + accountIdsFilter);
	sql = "SELECT transdate, merchantname, shopname, membercardid, amountcurrency amt, unitid, point ptamt, merchantid FROM clubpoint " +
		" WHERE clubid='00' AND tempmembertxid IN (" + accountIdsFilter + ") ORDER BY transdate DESC";
	System.out.println("sql = " + sql);
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
%>
<html>
<head>
<title>Transaction Report of Member</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>
<body>


<h1>Member Transaction Records</h1>

<!-- Tell whether this member is registered -->
<%
if (hasMemberInfo) {
	String qs = "memberId=" + URLEncoder.encode(memberId, "UTF-8");
%>


此為<b>已註冊</b>會員
<a href="<%=ctxRootPath%>/cardsearch.jsp?<%=qs%>"><img src="<%=ctxRootPath%>/images/member_icon1_16x16.jpg" border="0" alt="Member Information" title="Member Information" /></a>
<br/>
<% } else { %>
此為<b>非註冊</b>會員<br/>
<% } %>

<br/>
* 按交易日期排序<br/><br/>

<table border="1">
<thead>
<tr>
<th>交易日期</th>
<th>商户</th>
<th>门店</th>
<th>交易所用卡号<sup><a href="#note1">1</a></sup></th>
<th>消费金额</th>
<th>积分Type</th>
<th>积分</th>
</tr>
</thead>
<tbody>
<%
// iterate records
while (rs.next()){
	
	// build some URLs
	String merchantDetailUrl = ctxRootPath + "/update2.jsp?mid="
			+ URLEncoder.encode(rs.getString("merchantid"), "UTF-8")
			+ "&date=" + URLEncoder.encode(sdf.format(rs.getTimestamp("transdate")), "UTF-8");
	
%>
<tr>
<td><%=rs.getTimestamp("transdate")%></td>
<td><a href="<%=merchantDetailUrl%>" title="商户当天交易记录"><%=JspDisplayUtil.noNull(rs.getString("merchantname"))%></a></td>
<td><%=JspDisplayUtil.noNull(rs.getString("shopname"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("membercardid"))%></td>
<td class="amount"><%=moneyFormat.format(rs.getDouble("amt"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("unitid"))%></td>
<td class="amount"><%=pointFormat.format(rs.getDouble("ptamt"))%></td>
<%
}	// while (rs.next())

SqlUtil.close(rs); 
SqlUtil.close(stmt);


} catch (Exception e) {
	
	out.println(e);
	e.printStackTrace();
  
} finally {
	
	System.out.println("Cleaning up resource...");
	
	if (memberLocator != null) {
		memberLocator.destroy();
	}
	
	SqlUtil.close(rs);
	SqlUtil.close(stmt);
	SqlUtil.close(conn);
	
}


%>
</tbody>
</table>

<br/>

<b>备注:</b><br/>
<a name="note1"/><sup>1</sup>在2010年3月18日及之前，不论会员是用任何联盟卡、合作卡、手机号码，「交易所用卡号」所记录的是该会员所拥有的积享通普卡号。
<br/>

</body>
</html>