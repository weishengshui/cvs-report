<%--

Shenzhen Airlines report requested by Sunny.

@author cyril
@since 1.3.0 2010-01-13

 --%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.util.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*, com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ page language="java" import="com.chinarewards.report.data.crm.*" %>
<%@ page language="java" import="com.chinarewards.report.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<html>
<head>
<title>深航会员注册报表  2010-01-27版</title>
</head>


<body>

<a href="sunny-20100127.jsp">对数版</a> | <a href="sunny-20100127.jsp?crm=1">积享通客服版</a>

<%

// Parameters

boolean showMoreMemberInfo = false;

// show more information under CRM mode
if (request.getParameter("crm") != null) {
	showMoreMemberInfo = true;
}




Connection conn = null;
ResultSet rs = null; 
PreparedStatement stmt = null; 
String sql = null;

Connection crmConn = null;

PCRData cprData = new PCRData();

// load the list of Cities, Province, Regions.
Hashtable<String,String> cities = null;
Hashtable<String,String> provinces = null;
Hashtable<String,String> regions = null;


try {
	
	// crm
	crmConn = DbConnectionFactory.getInstance().getConnection("crm");
	
	// obtain database connection.
	conn = DbConnectionFactory.getInstance().getConnection("szair");
	
	
	cities = cprData.getCitiesAsMap(crmConn);
	provinces = cprData.getProvincesAsMap(crmConn);
	regions = cprData.getRegionsAsMap(crmConn);
	
	
	// build the SQL
	// the aim of this SQL is to select the following records:
	// - membersignup records with status = 'NEW' (newly registered)
	// - membersignup records with status = 'IN_PROCESS' (sent to Shenzhen Airline for processing)
	// - membersignup records with status = 'SUCCESS' (completed successfully);
	// - membersignup records with status = 'FAILED' or 'FAILED_SH', and from the log message 
	//   we knew that it is cause the XXX
	// -
	//SELECT * FROM membersignup WHERE datasource IN ('PORTAL', 'BACKEND', 'SH_BACKEND_IMPORT') AND ((status IN ('FAILED', 'FAILED_SH') AND logmessage NOT IN ('卡号已经被注册成为临时卡并是正式会员'))) ORDER BY signupat DESC, chisurname, chifirstname
	sql = "SELECT * FROM membersignup WHERE datasource IN ('PORTAL', 'BACKEND', 'SH_BACKEND_IMPORT') AND (status IN ('NEW', 'IN_PROCESS', 'SUCCESS') OR (status IN ('FAILED', 'FAILED_SH') AND logmessage IN ('卡号已经被注册成为临时卡并是正式会员'))) ORDER BY signupat DESC, chisurname, chifirstname";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	

	// display the result
%>


<h1>尊鹏-缤分联盟卡申请详细报表</h1>

<b>目录</b><br/>
<a href="#success_list">深航成功及待申请之列表</a><br/>
<a href="#success_batch_import_list">17万导入之会员并通过Portal或积享通客服重覆申请成功之列表</a><br/>
<a href="#failed_list">深航失败之列表</a><br/>



<a name="success_list" ></a>
<h2>深航成功及待申请之列表</h2>
这报表包含了通过Portal、积享通客服及深航客服的成功注册结果。<br/>

<table>
<thead>
<tr>
<th>#</th>
<th>尊鹏方的会员ID</th>
<th>尊鹏俱乐部卡号</th>
<th>姓名</th>
<th>性別</th>
<%
if (showMoreMemberInfo) {
%>
<th>申请时的电话号码</th>
<th>申请时的地址</th>
<%
}
%>
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
		sStatus = "不知名值(" + JspDisplayUtil.noNull(rsStatus) + ")";
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
<%
if (showMoreMemberInfo) {
%>
<td><%=JspDisplayUtil.noNull(rs.getString("mobilephone"))%></td>
<td><%=JspDisplayUtil.noNull(address)%></td>
<%
}
%>
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
rs = null;
stmt = null;





// -------------- End of first part of report ---------------- //



//
// This part of report is for batch imported member.
//

// query the list of batch imported members.
stmt = crmConn.prepareStatement("SELECT organizationmember.refid, member.id, member.chisurname, member.chilastname, member.gender, member.registdate, member.lastupdatetime, membership.membercardno, member.lastupdatetime - member.registdate FROM member INNER JOIN membership ON member.id=membership.member_id INNER JOIN card ON membership.card_id=card.id INNER JOIN organization ON card.organization_id=organization.id LEFT JOIN organizationmember ON member.id=organizationmember.member_id WHERE regsource='szair-import' AND organization.organizationno='szair' and to_char(registdate,'yyyymmdd') <> to_char(member.lastupdatetime,'yyyymmdd') and (member.lastupdatetime - registdate) > numtodsinterval(1,'hour') ORDER BY member.lastupdatetime");
rs = stmt.executeQuery();
%>
<br/>
<a name="success_batch_import_list" ></a>
<h2>17万导入之会员并通过Portal或积享通客服重覆申请成功之列表</h2>
这报表包含了曾经被积享通成功批量导入的会员，已该会员曾经透过Portal或积享通客服去重覆递交申请的列表。<br/>
注: 此表单并没有包含该会员第一次登记之记录。<br/>
<table>
<thead>
<tr>
<th>#</th>
<th>尊鹏会员ID</th>
<th>尊鹏俱乐部卡号</th>
<th>姓名</th>
<th>性別</th>
<th>会员最近更新资料日期</th>
</tr>
</thead>
<tbody>
<%
i = 1;
while (rs.next()) {
%>
<tr>
<td><%=i%></td>
<td><%=rs.getString("refid")%></td>
<td><%=rs.getString("membercardno")%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("chisurname"))%><%=JspDisplayUtil.noNull(rs.getString("chilastname"))%></td>
<td><%=GenderUtil.toString(rs.getInt("gender"))%></td>
<td><%=rs.getTimestamp("lastupdatetime")%></td>
</tr>
<%
	i++;
}	// while (rs.next())

SqlUtil.close(rs);
SqlUtil.close(stmt);
%>
</tbody>
</table>
<%


// -----------------------------------

// build the SQL
// the aim of this SQL is to select the recipicol result of the above SQL, 
// which shows a list of records.
sql = "SELECT membersignup.*, szairbackendimporttask.receivedfilename AS szairbackendimport_filename FROM membersignup LEFT JOIN szairbackendimporttask ON membersignup.szairbackendimporttask_id=szairbackendimporttask.id WHERE datasource IN ('PORTAL', 'BACKEND', 'SH_BACKEND_IMPORT') AND ((status IN ('FAILED', 'FAILED_SH') AND logmessage NOT IN ('卡号已经被注册成为临时卡并是正式会员'))) ORDER BY signupat DESC, chisurname, chifirstname";
stmt = conn.prepareStatement(sql);
rs = stmt.executeQuery();



// display the result
%>


<a name="failed_list"></a>
<h2>深航失败之列表</h2>
这报表包含了通过Portal、积享通客服及深航客服的成功注册结果。
<table>
<thead>
<tr>
<th>#</th>
<th>尊鹏方的会员ID</th>
<th>尊鹏俱乐部卡号</th>
<th>姓名</th>
<th>性別</th>
<%
if (showMoreMemberInfo) {
%>
<th>申请时的电话号码</th>
<th>申请时的Email</th>
<th>申请时的地址</th>
<%
}
%>
<th>注册方法</th>
<th>申请状态</th>
<th>短日志</th>
<th>注册日期</th>
<th>文檔名稱</th>
</tr>
</thead>
<tbody>
<%
//iterate the records
i = 1;
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
<%
if (showMoreMemberInfo) {
%>
<td><%=JspDisplayUtil.noNull(rs.getString("mobilephone"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("email"))%></td>
<td><%=JspDisplayUtil.noNull(address)%></td>
<%
}
%>
<td><%=sDataSource%></td>
<td><%=sStatus%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("logmessage"))%></td>
<td><%=rs.getTimestamp("signupat")%></td>
<td><%=rs.getString("szairbackendimport_filename")%></td>
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





//-------------- End of first part of report ---------------- //

%>
<%

// last block of code.

} catch (Throwable t) {
	t.printStackTrace(new PrintWriter(out));
} finally {
	SqlUtil.close(rs);
	SqlUtil.close(stmt);
	SqlUtil.close(conn);
	SqlUtil.close(crmConn);
}
%>
</body>
</html>