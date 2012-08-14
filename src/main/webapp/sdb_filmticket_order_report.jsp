<%--

根据电子电影票的供应商，出电子换领卷的列表。供应商的名字由Yudy提供。

This report takes the data from the Procurement System and inspect the 
tables 'Exchange', 'ApplyDetail' and 'Supplier'.


@author cyril
@since 2010-01-10

 --%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*"%>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>

<% 
String sDBDriver = "oracle.jdbc.driver.OracleDriver"; 

Connection conn = null; 
PreparedStatement stmt = null; 
ResultSet rs = null;
String sql = null;
int paramIdx = 1;

try {

// get database connection
conn = DbConnectionFactory.getInstance().getConnection("supply");

// build the SQL

// the target supplier ID.
String supplierSplrcd = "SHZ0118";	// Supplier Code 供应商代码
//supplierSplrcd = "JXT0003";	// for testing.	comment this out for production!
String supplierId = null;


%>

<%@ include file="/include/stdhtmlheader.inc.jsp" %>
<html>
<head>
<%@ include file="/include/stdhtmlhead.inc.jsp" %>
</head>

<body>

<!-- Introduction begins -->

<h1>网站电子电影票兑换订单记录</h1>

<h2>內容</h2>

<br/><br/>

<h2>报表需求日期</h2>
2010年1月15日
<br/><br/>

<h2>目的</h2>
Toby Tse
<br/><br/><br/>

<!-- Introduction ends -->


<%
// Shows the supplier information header.

// lookup the supplier information
sql = "SELECT * FROM supplier WHERE splrcd = ?";
stmt = conn.prepareStatement(sql);
// set parameters
paramIdx = 1;
stmt.setString(paramIdx++, supplierSplrcd);
// run query
rs = stmt.executeQuery();

boolean supplierFound = false;

if (rs.next()) {
	supplierFound = true;
	supplierId = rs.getString("id");
}

// show header only if supplier is found.
if (supplierFound) {
%>

<!-- Start of supplier info -->
供应商资料:
<br/>
<ul>
<li>供应商代码: <%=rs.getString("splrcd")%></li>
<li>供应商名称: <%=rs.getString("corpnm")%></li>
<li>公司营业名称: <%=rs.getString("businm")%></li>
<li>营业执照号码: <%=rs.getString("registryno")%></li>
</ul>
<br/>
<!-- End of supplier info -->

<%
	// gracefully close the resource
	if (rs!=null) {
		try {
			rs.close();
		} catch (Throwable t) {
		} finally {
			rs = null;
		}
	}
	if (stmt != null) {
		try {
			stmt.close();
		} catch (Throwable t) {
		} finally {
			stmt = null;
		}
	}
	
	//
	// Build the output table to emulate the data for importing to 訂單系統.
	//
	
	// data read from the Exchange table.
	sql = "SELECT e.id, e.startdt, e.exchangeno, ad.membername, ad.membercardcode, ad.memberaddress, ad.membertelephone, '4882' as merchandise_code, m.mchnm, e.price   FROM exchange e INNER JOIN applydetail ad ON e.applydetail_id=ad.id INNER JOIN supplier s ON e.supplier_id=s.id INNER JOIN merchandise m ON m.id=e.merchandise_id WHERE 1=1";
	if (supplierId != null) {
		sql += " AND e.supplier_id = ?";
	}
	stmt = conn.prepareStatement(sql);
	// set parameters
	paramIdx = 1;
	if (supplierId != null) {
		stmt.setString(paramIdx++, supplierId);
	}
	// order by phase
//	sql += " ORDER BY e.
	// execute query
	rs = stmt.executeQuery();
%>



<table>
<thead>
<tr>
<th>序号</th>
<th>兑换日期</th>
<th>CIF</th>
<th>姓名</th>
<th>卡号</th>
<th>性别</th>
<th>配送地址</th>
<th>联系电话</th>
<th>礼品编码</th>
<th>礼品名称</th>
<th>所需积分</th>
<th>所需现金</th>
<th>礼品单价</th>
<th>订单编号</th>
<th>供应商</th>
<th>发货日期</th>
<th>签收日期</th>
<th>备注</th>
</tr>
</thead>
<tbody>
<%
long recSerialId = 1;	// counts the serial number of record, value is 1, 2, 3...
while (rs.next()) {
%>
<tr>
<td><%=recSerialId%></td>
<td><%=rs.getTimestamp("startdt")%></td>
<td>网上会员积分兑换<%--=JspDisplayUtil.noNull(rs.getString("exchangeno"))--%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("membername"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("membercardcode"))%></td>
<td></td>
<td><%=JspDisplayUtil.noNull(rs.getString("memberaddress"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("membertelephone"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("merchandise_code"))%></td>
<td>电影票<%--=JspDisplayUtil.noNull(rs.getString("mchnm"))--%></td>
<td><%--<%=JspDisplayUtil.noNull(rs.getDouble("price"))--%></td>
<td></td>
<td></td>
<td></td>
<td>积享通</td>
<td></td>
<td></td>
<td></td>
</tr>
<%
	recSerialId++;
}
%>
</tbody>


<%
}	// if supplier is found.
%>

</table>

</body>

</html>
<%
} catch (Throwable t) {
	out.println("die");
	out.println(t);
} finally {
	// gracefully release resources
	if (rs != null) {
		try {
			rs.close();
		} catch (Throwable t) {
		}
		rs = null;
	}
	if (stmt != null) {
		try {
			stmt.close();
		} catch (Throwable t) {
		}
		stmt = null;
	}
	if (conn != null) {
		try {
			conn.close();
		} catch (Throwable t) {
		}
		conn = null;
	}
}
%>