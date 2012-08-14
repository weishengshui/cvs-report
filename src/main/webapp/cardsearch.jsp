<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*"%>
<%@ page import="com.chinarewards.report.data.crm.*" %>
<%@ page import="com.chinarewards.report.db.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ page import="com.chinarewards.report.jsp.util.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<%--

This report tries its best to look up member information using a set of 
query parameters.

--%>
<%

//get request parameters
String queryCardNo = request.getParameter("cardno");
if (queryCardNo == null) {
	// XXX for compatibility reason.
	queryCardNo = request.getParameter("nick");
}
String queryMemberId = request.getParameter("memberId");
String queryOrgId = request.getParameter("orgId");
String queryTxAcctId = request.getParameter("acctId");



%>
<html>
<head>
<title>Member Information</title>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>

<body>
<% 

Connection conn = null;
ResultSet rs = null;
PreparedStatement stmt = null;
String sql = null;
MemberLocator memberLocator = new MemberLocator();

//setup the member searching parameters.
MemberLocator.Criteria criteria = new MemberLocator.Criteria();
criteria.setCardNumber(StringUtil.trimToNull(queryCardNo));
criteria.setMemberId(StringUtil.trimToNull(queryMemberId));
criteria.setOrganizationId(StringUtil.trimToNull(queryOrgId));
criteria.setTxAccountId(StringUtil.trimToNull(queryTxAcctId));


try { 

conn = DbConnectionFactory.getInstance().getConnection("crm");


// look up the member
memberLocator = new MemberLocator();
rs = memberLocator.searchMember(conn, criteria);

// no member record is located.
if (rs == null || !rs.next()) {
	out.println("<br/>找不到会员资料<br/>");
	return;
}

String memberId = rs.getString("id");

// output member information
%>

<!-- Member information -->

<h2>会员资料</h2>
<table>
<tr>
<th>手机号码</th>
<td><%=rs.getString("mobiletelephone")%></td>
</tr>
<tr>
<th>会员注册日期</th>
<td><%=rs.getTimestamp("registdate")%></td>
</tr>
<tr>
<th>姓, 名</th>
<td><%=JspDisplayUtil.noNull(rs.getString("chisurname"))%>, <%=JspDisplayUtil.noNull(rs.getString("chilastname"))%></td>
</tr>
</table>
<%

SqlUtil.close(rs);


// get all cards (membership) of this member.
sql = "SELECT o.name AS organization_name, c.cardname, ms.membercardno, ms.startdate, ms.activeflag FROM membership ms INNER JOIN card c ON ms.card_id=c.id INNER JOIN organization o ON o.id=c.organization_id WHERE member_id = ? AND P_TYPE <> 'MerchantSelf'";
stmt = conn.prepareStatement(sql);
stmt.setString(1, memberId);
rs = stmt.executeQuery();

%>

<!-- Card information -->

<br/>
<h2>卡资料</h2>
<table>
<thead>
<tr>
<th>公司</th>
<th>卡名</th>
<th>卡号</th>
<th>生效?</th>
<th>生效日期</th>
</tr>
</thead>
<tbody>
<%
while (rs.next()){
%>
<tr>
<td><%=rs.getString("organization_name")%></td>
<td><%=rs.getString("cardname")%></td>
<td><%=rs.getString("membercardno")%></td>
<td><%=rs.getString("activeflag")%></td>
<td><%=rs.getTimestamp("startdate")%></td>
</tr>
<%
}
%>
</tbody>
</table>


<br/>
<h2>会员消费记录</h2>
<a href="<%=ctxRootPath%>/memberTrans.jsp?memberId=<%=memberId%>">点击以查看此会员的消费记录</a>
<br/><br/>

<%

SqlUtil.close(rs);


} catch(Exception e) {
	
	out.println(e);
	e.printStackTrace();
	
} finally {
	
	// clean up resources

	if (memberLocator != null) {
		memberLocator.destroy();
		memberLocator = null;
	}
	SqlUtil.close(rs);
	SqlUtil.close(stmt);
	SqlUtil.close(conn);
	
}

%>
</body>
</html>