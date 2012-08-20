<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.text.*" %>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

// parameters
String targetBizCircleName = "coco park";
//targetBizCircleName = "罗湖商圈";	// for development
String sTransdateFrom = "2010-01-16";	// should be 2010-01-16
String sTransdateTo = "2010-02-01";		// should be 2010-02-01


// formatting
DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");



try {

	// open database connection
	conn = DbConnectionFactory.getInstance().getConnection("crm");
	
	//
	// select all shops which match Jessica's requirement:
	// - CoCo Park
	// - Extra 2 shops
	// - shop name is '现场兑换活动3'
//	String sql = "SELECT DISTINCT industrytype.id AS industrytype_id, industrytype.paravalue AS industrytype_name, shop.id AS shop_id, shop.name AS shop_name FROM shop INNER JOIN bizcircleshop ON shop.id = bizcircleshop.shop_id INNER JOIN bizcircle ON bizcircleshop.bizcircle_id=bizcircle.id LEFT JOIN merchant ON shop.merchant_id = merchant.id LEFT JOIN industrytype ON merchant.industrytype_id=industrytype.id WHERE shop.activeflag='effective' AND bizcircle.name = '" + targetBizCircleName + "' ORDER BY industrytype_id, industrytype_name, shop_id, shop_name";
	String sql = "SELECT DISTINCT industrytype.id AS industrytype_id, industrytype.paravalue AS industrytype_name, shop.id AS shop_id, shop.name AS shop_name FROM shop LEFT JOIN bizcircleshop ON shop.id = bizcircleshop.shop_id LEFT JOIN bizcircle ON bizcircleshop.bizcircle_id=bizcircle.id LEFT JOIN merchant ON shop.merchant_id = merchant.id LEFT JOIN industrytype ON merchant.industrytype_id=industrytype.id WHERE (shop.activeflag='effective' AND bizcircle.name = '" + targetBizCircleName + "') OR shop.name = '现场兑换活动3' ORDER BY industrytype_id, industrytype_name, shop_id, shop_name";
	System.out.println(sql);
//	out.println(sql);
//	out.flush();
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();

	// build the SQL filter for matching shops for the POSAPP exchange table record.
	StringBuffer shopFilter = new StringBuffer();
	while (rs.next()) {
		if (shopFilter.length() > 0) shopFilter.append(",");  
		shopFilter.append("'" + rs.getString("shop_id") + "'");
	} // while (has more shops)
	if (shopFilter.length() == 0) {
		shopFilter.append("'notexists-agdfhgs'");
	}
	SqlUtil.close(rs);
	rs = null;
	
	
	if (shopFilter.length() == 0) {
		out.println("No CoCo Park shops are found.");
		return;
	}
	
	
	// -----------
	
	
%>
<html>
<head>
<title>2010-01-16 CoCo Park 活动卡号报表</title>
</head>

<body>


<h1>活动卡号报表</h1>

<br/>

<!-- Introduction Starts -->

<h2>目的</h2>
CoCo Park 于 <b><%=sTransdateFrom%></b>至<b><%=sTransdateTo%></b>零时零晨之前的活动推广，会员的所有于该日期内的消费简讯。
<br/>

<h2>报表需求日期</h2>
2010年1月15日
<br/>

<h2>需求方</h2>
Jessica @ 产品部

<h2>改动</h2>
<table>
<tr>
<th>日期</th>
<th>描述</th>
</tr>
<tr>
<td>2010-01-23</td>
<td>加入门市"现场兑换活动3"</td>
</tr>
</table>




<br/>

<hr/>
<br/>


<!-- Introduction ENDS -->


<!-- Content BEGINS -->


<h2>吻合商圈为「<%=targetBizCircleName%>」条件的门市列表</h2>

<table>
<thead>
<tr>
<th>#</th>
<th>商户类型</th>
<th>门市</th>
</tr>
</thead>
<tbody>
<%
rs = pstmt.executeQuery();
int i = 1;
while (rs.next()) {
%>
<tr>
<td><%=i%></td>
<td><%=rs.getString("industrytype_name")%></td>
<td><%=rs.getString("shop_name")%></td>
</tr>
<%
	i++;
}

SqlUtil.close(pstmt);
pstmt = null;
SqlUtil.close(conn);

%>

</table>


<br/>

<h2>在以上门市消费过的会员卡号</h2>

<table>
<thead>
<tr>
<th>时间</th>
<th>卡号</th>
<th>门市</th>
<th>消费金额</th>
<th>积分</th>
</tr>
</thead>
<tbody>
<%


conn = DbConnectionFactory.getInstance().getConnection("posapp");

//
// Build the SQL for querying member card number which has spending 
//
sql = "SELECT transdate, membercardid, shopname, amountcurrency, point FROM clubpoint WHERE shopid IN (" + shopFilter.toString() + ") AND transdate >= {d '" + sTransdateFrom + "'} AND transdate < {d '" + sTransdateTo + "'} AND clubid = '00' AND amountcurrency > 2 AND membercardid IS NOT NULL AND membercardid <> '''' ORDER BY transdate, membercardid, shopname, amountcurrency, point";
System.out.println(sql);
//out.println(sql);
pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();

// iterate records
while (rs.next()) {
%>
<tr>
<td><%=rs.getTimestamp("transdate")%></td>
<td><%=rs.getString("membercardid")%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("shopname"))%></td>
<td><%=moneyFormat.format(rs.getDouble("amountcurrency"))%></td>
<td><%=pointFormat.format(rs.getDouble	("point"))%></td>
</tr>
<%
}
%>
</tbody>
</table>


<!-- Content ENDS -->


</body>
</html>
<%

SqlUtil.close(rs);
SqlUtil.close(pstmt);

} catch (Throwable t) {
	out.println(t);
} finally {
	SqlUtil.close(rs);
	SqlUtil.close(pstmt);
	SqlUtil.close(conn);
}
%>