<%--

Shenzhen Airlines report.

Shows the member signup detail of a specified batch.

@author cyril
@since 1.3.0 2010-05-12

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.util.*" %>
<%@ page import="com.chinarewards.report.db.*, com.chinarewards.report.jsp.util.*" %>
<%@ page import="com.chinarewards.report.data.crm.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>
<%@ page import="com.chinarewards.report.data.szair.*" %>

<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<html>
<head>
<title>积享通方尊鹏-缤分联盟卡申请文件报表明细</title>
<style type="text/css">
.fail {
	background-color: #FA6E8C;
}
.success {
	background-color: #97F576;
}
</style>
</head>


<body>

<h1>积享通方尊鹏-缤分联盟卡申请文件报表明细</h1>

<!-- Introduction STARTS -->
这报表显示了由积享通的Portal和400客服每天所发展的会员申请文件状态。
所有申请每天都会经FTP先发送到深航方的系统，待对方处理后再取得处理结果。
<br/><br/>
<!-- Introduction ENDS -->

<%



// Get query parameters
String batchId = request.getParameter("id");




Connection conn = null;
ResultSet rs = null; 
PreparedStatement stmt = null; 
String sql = null;


try {

	// crm database
	conn = DbConnectionFactory.getInstance().getConnection("szair");
	
	
	// find the target batch
	sql = "SELECT b.*, spfi.filename AS sentplaintext_filename FROM memberdataxchgbatch b LEFT JOIN fileitem spfi ON b.sentplaintextfile_id=spfi.id WHERE b.id=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, batchId);
	rs = stmt.executeQuery();
	if (!rs.next()) {
		// no batch found.
		out.println("申请文件不存在");
		SqlUtil.close(stmt);
		SqlUtil.close(rs);
		return;
	}
	
	// display file details
%>
<h2>申请文件内容</h2>
<table>
<tr>
<th>檔案</th>
<td><%=rs.getString("sentplaintext_filename")%></td>
</tr>
<tr>
<th>文件生成日期</th>
<td><%=rs.getTimestamp("createdat")%></td>
</tr>
<tr>
<th>文件修改日期日期</th>
<td><%=rs.getTimestamp("modifiedat")%></td>
</tr>
<tr>
<th>处理状态</th>
<td><%=rs.getString("processstate")%></td>
</tr>
<tr>
<th>处理结果</th>
<td><%=rs.getString("processresult")%></td>
</tr>
</table>
<%
	SqlUtil.close(stmt);
	SqlUtil.close(rs);
	
	//
	
	
	// query the application summary.
	sql = "SELECT ms.*, l.shairprocessresult "
		+ "FROM memberdataxchgbatch b LEFT JOIN memberdataxchgmemberlink l ON b.id=l.memberdataxchgbatch_id "
		+ "LEFT JOIN membersignup ms ON l.membersignup_id=ms.id "
		+ "WHERE b.id = ?"
		+ "ORDER BY ms.signupat";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, batchId);
	rs = stmt.executeQuery();
	
	
%>
<br/>
<h2>申请记录明细</h2>
<table>
<thead>
<tr>
<th>#</th>
<th>申请来源</th>
<th>尊鹏方的会员ID</th>
<th>尊鹏俱乐部卡号</th>
<th>姓名</th>
<th>性別</th>
<th>手提电话</th>
<th>申请状态</th>
<th>深航返回码</th>
<th>短日志</th>
</tr>
</thead>
<tbody>
<%
	int i = 0;
	while (rs.next()) {
%>
<tr>
<td><%=(i+1)%><!-- <%=rs.getString("id")%> --></td>
<td><%=SzairUtil.dataSourceToText(rs.getString("dataSource"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("szairid"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("cardnumber"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("chisurname"))%><%=JspDisplayUtil.noNull(rs.getString("chifirstname"))%></td>
<td><%=SzairUtil.memberSignupGenderToText(rs.getString("gender"))%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("mobilephone"))%></td>
<td><%=SzairUtil.memberSignupStatusToText(rs.getString("status"))%></td>
<td><%=rs.getString("shairprocessresult")%></td>
<td><%=JspDisplayUtil.noNull(rs.getString("logmessage"))%></td>
</tr>
<%
		i++;
	}	// while (has more record)
%>
</tbody>
<tfoot>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td><b>总数:</b> <%=i%></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</tfoot>
</table>
<%

} catch (Throwable t) {
	out.println(t);
	t.printStackTrace();
} finally {
	SqlUtil.close(rs);
	SqlUtil.close(stmt);
	SqlUtil.close(conn);
}
%>
</body>
</html>