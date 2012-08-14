<%--

Shenzhen Airlines report requested by Sunny.

@author cyril
@since 1.3.0 2010-01-13

 --%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.util.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*, com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.data.crm.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page language="java" import="com.chinarewards.report.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/include/report_disabled.inc.jsp" %>

<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<html>
<head>
<title>深航会员注册报表 (Sunny)</title>
</head>


<body>
<%

Connection conn = null;
ResultSet rs = null; 
PreparedStatement stmt = null; 
String sql = null;

Connection crmConn = null;


try {
	
	// crm database
	crmConn = DbConnectionFactory.getInstance().getConnection("crm");
	
	PCRData cprData = new PCRData();
	
	// load the list of Cities, Province, Regions.
	Hashtable<String,String> cities = cprData.getCitiesAsMap(crmConn);
	Hashtable<String,String> provinces = cprData.getProvincesAsMap(crmConn);
	Hashtable<String,String> regions = cprData.getRegionsAsMap(crmConn);
	

	// obtain database connection.
	conn = DbConnectionFactory.getInstance().getConnection("szair");
	
	// build the SQL
	// the aim of this SQL is to select the following records:
	// - membersignup records with status = 'NEW' (newly registered)
	// - membersignup records with status = 'IN_PROCESS' (sent to Shenzhen Airline for processing)
	// - membersignup records with status = 'SUCCESS' (completed successfully);
	// - membersignup records with status = 'FAILED' or 'FAILED_SH', and from the log message 
	//   we knew that it is cause the XXX
	// -
	sql = "SELECT * FROM membersignup WHERE datasource IN ('PORTAL', 'BACKEND', 'SH_BACKEND_IMPORT') AND (status IN ('NEW', 'IN_PROCESS', 'SUCCESS') OR (status IN ('FAILED', 'FAILED_SH') AND logmessage IN ('卡号已经被注册成为临时卡并是正式会员'))) ORDER BY signupat DESC, chisurname, chifirstname";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	

	// display the result
%>

<table>
<thead>
<tr>
<th>#</th>
<th>尊鹏方的会员ID</th>
<th>尊鹏俱乐部卡号</th>
<th>姓名</th>
<th>性別</th>
<th>申请时的电话号码</th>
<th>申请时的地址</th>
<th>注册方法</th>
<th>申请状态</th>
<th>短日志</th>
<th>注册日期</th>
</tr>
</thead>
<tbody>
<%
// iterate the records
int i = 1;
while (rs.next()) {
	// string representation for signup datasource
	String sDataSource = "";
	String rsDataSource = rs.getString("datasource");
	if ("BATCH_IMPORT".equals(rsDataSource)) {
		sDataSource = "批量导入";
	} else if ("PORTAL".equals(rsDataSource)) {
		sDataSource = "Portal";
	} else if ("BACKEND".equals(rsDataSource)) {
		sDataSource = "积享通营运部";
	} else if ("SH_BACKEND_IMPORT".equals(rsDataSource)) {
		sDataSource = "深航客服FTP文件";
	} else {
		sDataSource = "不知名来源(" + JspDisplayUtil.noNull(rsDataSource) + ")";
	}
	
	// string representation of gender
	String sGender = "";
	String rsGender = rs.getString("gender");
	if ("MALE".equals(rsGender)) {
		sGender = "男";
	} else if ("FEMALE".equals(rsGender)) {
		sGender = "女";
	} else {
		sGender = "不知名性別(" + JspDisplayUtil.noNull(rsGender) + ")";
	}
	
	// string representation of member signup status
	String sStatus = "";
	String rsStatus = rs.getString("status");
	if ("NEW".equals(rsStatus)) {
		sStatus = "新申请";
	} else if ("IN_PROCESS".equals(rsStatus)) {
		sStatus = "深航处理中";
	} else if ("SUCCESS".equals(rsStatus)) {
		sStatus = "成功";
	} else if ("FAILED".equals(rsStatus)) {
		sStatus = "失败(积享通方)";
	} else if ("FAILED_SH".equals(rsStatus)) {
		sStatus = "失败(深航方)";
	} else {
		sGender = "不知名值(" + JspDisplayUtil.noNull(rsStatus) + ")";
	}
	
	
	// build the address
	String address = "";
	if (!StringUtil.isEmpty(rs.getString("provinceid"))) {
		String name = provinces.get(rs.getString("provinceid"));
		if (name != null) {
			address += name;
		}
	}
	if (!StringUtil.isEmpty(rs.getString("cityid"))) {
		String name = cities.get(rs.getString("cityid"));
		if (name != null) {
			address += name;
		}
	}
	if (!StringUtil.isEmpty(rs.getString("regionid"))) {
		String name = regions.get(rs.getString("regionid"));
		if (name != null) {
			address += name;
		}
	}
	if (!StringUtil.isEmpty(rs.getString("address"))) {
		address += rs.getString("address");
	}
	
	
%>
<tr>
<td><%=i%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("szairid"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("cardnumber"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("chisurname"))%><%=JspDisplayUtil.noNull(rs.getString("chifirstname"))%></td>
<td><%=sGender%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("mobilephone"))%></td>
<td><%=JspDisplayUtil.noNull(address)%></td>
<td><%=sDataSource%></td>
<td><%=sStatus%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("logmessage"))%></td>
<td><%=rs.getTimestamp("signupat")%></td>
</tr>
<%

	i++;

}	// while (rs.next())
	
%>
</tbody>
</table>
<%

SqlUtil.close(rs);
SqlUtil.close(stmt);
SqlUtil.close(conn);
rs = null;
stmt = null;
conn = null;


// -------------- End of first part of report ---------------- //



//
// This part of report is for batch imported member.
//

conn = DbConnectionFactory.getInstance().getConnection("crm");





//select member.id, member.chisurname, member.chilastname, member.registdate, member.lastupdatetime, member.lastupdatetime - member.registdate FROM member INNER JOIN membership ON member.id=membership.member_id INNER JOIN card ON membership.card_id=card.id INNER JOIN organization ON card.organization_id=organization.id  WHERE regsource='szair-import' AND organization.organizationno='szair' and to_char(registdate,'yyyymmdd') <> to_char(member.lastupdatetime,'yyyymmdd') and (member.lastupdatetime - registdate) > numtodsinterval(1,'hour') order by member.lastupdatetime;

} catch (Throwable t) {
	out.println(t);
} finally {
	SqlUtil.close(rs);
	SqlUtil.close(stmt);
	SqlUtil.close(conn);
	SqlUtil.close(crmConn);
}
%>
</body>
</html>