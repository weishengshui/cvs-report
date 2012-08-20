<%--

Shows the spending record of BNK members.

@author cyril
@since 2010-01-10

 --%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="checklogin.jsp" %>

<% 

Connection conn = null; 
Connection crmConn = null; 
ResultSet rs = null; 
PreparedStatement stmt = null;
String sql = null;


//
// Criteria
//
String transDateFrom = "2010-01-16";
String transDateTo = "2010-02-11";	// on or before 2010-01-31
int minUniqueShop = 2;	// minimum unique shops per member.
double minSpendingPerShop = 100; 	// minimum spending per shop.





/**
 *
 * @since 2010-01-10
 */
class ChannelInfo {
	public String channelCode;
	public String channelName;
	public String prefixCode;
	public String initNumber;
	public String numberUpperLimit;
	public int numberLength;

	public ChannelInfo(String channelCode, String channelName, 
			String prefixCode,
			String initNumber, String numberUpperLimit, int numberLength) {
		this.channelCode = channelCode;
		this.channelName = channelName;
		this.prefixCode = prefixCode;
		this.initNumber = initNumber;
		this.numberUpperLimit = numberUpperLimit;
		this.numberLength = numberLength;
	}
	
	public String getLowestCardNumber() {
		return buildCardNumber(prefixCode, initNumber, numberLength);
	}
	
	public String getHighestCardNumber() {
		return buildCardNumber(prefixCode, numberUpperLimit, numberLength);
	}
	
	protected String buildCardNumber(String prefix, String number, int length) {
		String s = "";
		if (prefix != null) s += prefix;
		// calculate the number of zeros to add in between prefix and the number
		int padlength = length - s.length();
		if (number != null) padlength -= number.length();
		for (int i=0; i<padlength; i++) {
			s += "0";
		}
		s += number;
		return s;
	}
}

List<ChannelInfo> channelInfoList = new ArrayList<ChannelInfo>();


try {
	
	// get database connection to CRM
	conn = DbConnectionFactory.getInstance().getConnection("crm");

	
	//
	// Get all channel information from the CRM system related to BNK.
	//
	sql = "select c.channelcode, c.channelname, s.prefixcode, s.initnumber, s.numberupperlimit, s.numberlength from channel c INNER JOIN sequencenumber s ON c.sequencenumber_numbercode=s.numbercode WHERE c.channelcode like 'BNK%'";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	// save the list of channels to channelInfoList.
	while (rs.next()) {
		ChannelInfo info = new ChannelInfo(rs.getString("channelcode"), 
				rs.getString("channelname"), rs.getString("prefixcode"),
				rs.getString("initnumber"), rs.getString("numberupperlimit"),
				rs.getInt("numberlength"));
		channelInfoList.add(info);
	}
	
} finally {
	// gracefully release resources
	if (rs != null) {
		try {
			rs.close();
		} catch (Throwable t) {
		}
	}
	if (stmt != null) {
		try {
			stmt.close();
		} catch (Throwable t) {
		}
	}
	if (conn != null) {
		try {
			conn.close();
		} catch (Throwable t) {
		} finally {
			conn = null;
		}
	}
}

%>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<html>
<head>
<title>BNK <%=transDateFrom%> 至 <%=transDateTo%>现场活动支持</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>

<body>

<!-- Introduction begins -->

<h1>BNK <%=transDateFrom%> 至 <%=transDateTo%>零晨零时前现场活动支持</h1>

<h2>內容</h2>
活动期间，BNK联名卡会员在任意两家“缤分联盟”商户消费且单笔满100元，即可获赠一次免费看电影的机会。
（数量有限，先到先得）。
<br/>
活动时间：<%=transDateFrom%> 至 <%=transDateTo%>零晨零时。
<br/><br/>

<h2>报表需求日期</h2>
2010年1月12日
<br/><br/>

<h2>目的</h2>
关于尽快开拓不同渠道（除了正在开发的POS机订单及现场赠送模式-预计本月底前UAT以外）以便快速解决电影票消化的问题，
经过与Jessica, Polly, June, Yudy, Ken的沟通。
<br/><br/>
<hr/>
<br/>

<h2>改动</h2>
<table>
<tr>
<th>日期</th>
<th>描述</th>
</tr>
<tr>
<td>2010-01-27</td>
<td>活动日期由2010年1月31日延至2010年2月10日</td>
</tr>
</table>


<!-- Introduction ends -->


<!-- Content -->

<h1>BNK相關的會員渠道</h1>
<%
{
	// shows the located Channel list.
	out.println("BNK 会员渠道列表总数: " + channelInfoList.size() + "<br/>");
	if (!channelInfoList.isEmpty()) {
		out.println("<ol>\n");
		for (ChannelInfo info : channelInfoList) {
			out.println("<li>字号段由: " + info.getLowestCardNumber() + "到" + info.getHighestCardNumber() + "</li>");
		}
		out.println("</ol>\n");
	}
	
}
%>
<br/>
<%
//
// Get all spending records of BNK members.
//

try {
	
	conn = DbConnectionFactory.getInstance().getConnection("posapp");
	crmConn = DbConnectionFactory.getInstance().getConnection("crm");

	// for querying member record using card number.
	PreparedStatement memberStmt = crmConn.prepareStatement("SELECT member.id, chisurname, chilastname, gender, mobiletelephone FROM member INNER JOIN membership ON member.id=membership.member_id WHERE membership.membercardno = ?");
	ResultSet memberRs = null;

	
	//
	// Build the SQL statement!
	//
	
	// criteria: BNK member only.
	// we use the card number range as the filtering criteria.
	String filter = "";
	if (!channelInfoList.isEmpty()) {
		filter = " AND (1=0";
		for (ChannelInfo info : channelInfoList) {
			filter += " OR (cp.membercardid >= ? AND cp.membercardid <= ?)";
		}
		filter += ")";
		sql += filter;
	}
	
	
	// sqlMemberUniqueShopSpending:
	// query the list of card numbers
	// which the member has minimum spending amount and has spent 
	// at least 'minUniqueShop' number of unique shops.
	String sqlMemberUniqueShopSpending = "SELECT membercardid FROM (SELECT cp.membercardid, cp.shopid FROM clubpoint cp WHERE cp.clubid = '00' AND shopid IS NOT NULL AND cp.amountcurrency >= " + minSpendingPerShop + " " + filter + " AND cp.transdate >= {d '" + transDateFrom + "'} AND cp.transdate < {d '" + transDateTo + "'} AND membercardid IS NOT NULL GROUP BY cp.membercardid, cp.shopid ORDER BY cp.membercardid, cp.shopid) GROUP BY membercardid HAVING COUNT(*) >= " + minUniqueShop;
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
//	out.println("SQL = " + sql);	// DEBUG
//	out.flush();
	// set the parameter values. The order must be the same as the SQL construction!
	int paramInt = 1;
	// criteria: BNK member only.
	if (!channelInfoList.isEmpty()) {
		for (ChannelInfo info : channelInfoList) {
			stmt.setString(paramInt++, info.getLowestCardNumber());
			stmt.setString(paramInt++, info.getHighestCardNumber());
		}
	}
	// execute the query!
	rs = stmt.executeQuery();

	//
	// show result as table form
	//
%>

<h1>符合条件的会员消费记录</h1>

<ul>
<li>消费日期由 <%=transDateFrom%>至<%=transDateTo%>零晨零时前</li>
<li>独立门市下限: <%=minUniqueShop%></li>
<li>每间门市最低消费: RMB <%=minSpendingPerShop%></li>
</ul>

<br/>

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
	SqlUtil.close(conn);
	SqlUtil.close(crmConn);
	
}
%>