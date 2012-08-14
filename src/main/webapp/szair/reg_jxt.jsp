<%--

Shenzhen Airlines report.

Shows summary of application result sent from Shenzhen Airlines FTP backend
(daily).


@author cyril
@since 1.3.0 2010-04-07

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.util.*" %>
<%@ page import="com.chinarewards.report.db.*, com.chinarewards.report.jsp.util.*" %>
<%@ page import="com.chinarewards.report.data.crm.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>

<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<html>
<head>
<title>积享通方尊鹏-缤分联盟卡申请文件报表一览</title>
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

<h1>积享通方尊鹏-缤分联盟卡申请文件报表一览</h1>

<!-- Introduction STARTS -->
这报表显示了由积享通的Portal和400客服每天所发展的会员申请文件状态。
所有申请每天都会经FTP先发送到深航方的系统，待对方处理后再取得处理结果。
<br/><br/>
<!-- Introduction ENDS -->

<%

Connection conn = null;
ResultSet rs = null; 
PreparedStatement stmt = null; 
String sql = null;


try {

	// crm database
	conn = DbConnectionFactory.getInstance().getConnection("szair");
	
	
	
	// query the application summary.
	sql = "SELECT shbkend.id, shbkend.receivedfilename, ms.status, count(*) AS status_count "
		+ "FROM szairbackendimporttask shbkend LEFT JOIN membersignup ms ON shbkend.id=ms.szairbackendimporttask_id "
		+ "GROUP BY shbkend.id, shbkend.receivedfilename, ms.status "
		+ "ORDER BY shbkend.receivedfilename DESC, shbkend.id, ms.status ASC";
	
	sql = "SELECT b.id, spfi.filename AS sendplaintext_filename, TO_DATE(SUBSTR(spfi.filename, 15,8),'yyyymmdd') AS file_date, "
		+ "b.processstate, b.processresult, "
		+ "COUNT(CASE WHEN ms.status='NEW' THEN ms.id ELSE NULL END) AS new_count, "
		+ "COUNT(CASE WHEN ms.status='SUCCESS' THEN ms.id ELSE NULL END) as success_count, "
		+ "COUNT(CASE WHEN ms.status='FAILED' THEN ms.id ELSE NULL END) as fail_count, "
		+ "COUNT(CASE WHEN ms.status='FAILED_SH' THEN ms.id ELSE NULL END) as failsh_count, "
		+ "COUNT(CASE WHEN ms.status NOT IN ('NEW','SUCCESS','FAILED','FAILED_SH') THEN ms.id ELSE NULL END) as other_count, "
		+ "COUNT(ms.id) as total_count "
		+ "FROM memberdataxchgbatch b LEFT JOIN memberdataxchgmemberlink l ON b.id=l.memberdataxchgbatch_id "
		+ "LEFT JOIN membersignup ms ON l.membersignup_id=ms.id "
		+ "LEFT JOIN fileitem spfi ON b.sentplaintextfile_id=spfi.id "
		+ "GROUP BY b.id, spfi.filename,TO_DATE(SUBSTR(spfi.filename, 15,8),'yyyymmdd'), b.processstate, b.processresult "
		+ "ORDER BY spfi.filename DESC";
	
	System.out.println("sql for daily summary = " + sql);
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	
	// some global statistics
	long totalNew = 0;
	long totalSuccess = 0;
	long totalFailed = 0;
	long totalOthers = 0;
	long total = 0;
	long fileCount = 0;
	
	long monthTotalNew = 0;
	long monthTotalSuccess = 0;
	long monthTotalFailed = 0;
	long monthTotalOthers = 0;
	long monthTotal = 0;
	
%>
<table>
<thead>
<tr>
<th>#</th>
<th>档案</th>
<th>处理状态</th>
<th>处理结果</th>
<th>新增</th>
<th>成功</th>
<th>失败</th>
<th>其他</th>
<th>总数</th>
</tr>
</thead>
<tbody>
<%

	// iterate the records
	
	java.util.Date lastDate = null;
	java.util.Calendar cal = Calendar.getInstance();
	
	while (rs.next()) {
		
		// remember some iterated states
		cal.setTime(rs.getTimestamp("file_date"));
		int iYear = cal.get(Calendar.YEAR);
		int iMonth = cal.get(Calendar.MONTH);
		int lastYear = -1;
		int lastMonth = -1;
		boolean showMonthlyStat = false;
		if (lastDate != null) {
			cal.setTime(lastDate);
			lastYear = cal.get(Calendar.YEAR);
			lastMonth = cal.get(Calendar.MONTH);
			if (!(iYear==lastYear && iMonth==lastMonth)) {
				showMonthlyStat = true;
			}
		}

		// Prepare CSS class and styles
		// echo result.
		String failCssClass = "";
		String successCssClass = "";
		if (rs.getLong("fail_count")+rs.getLong("failsh_count") > 0) {
			failCssClass += " fail";
		}
		if (rs.getLong("success_count") > 0) {
			successCssClass += " success";
		}
		
		// whether to display subtotal for month
		if (showMonthlyStat) {
%>
<tr>
<td></td>
<td><%=lastYear%>年<%=lastMonth+1%>月总结:</td>
<td></td>
<td></td>
<td class="amount"><%=monthTotalNew%></td>
<td class="amount<%=successCssClass%>"><%=monthTotalSuccess%></td>
<td class="amount<%=failCssClass%>"><%=monthTotalFailed%></td>
<td class="amount"><%=monthTotalOthers%></td>
<td class="amount"><%=monthTotal%></td>
</tr>
<%
			// reset monthly stat
			monthTotalNew = 0;
			monthTotalSuccess = 0;
			monthTotalFailed = 0;
			monthTotalOthers = 0;
			monthTotal = 0;
		}
		
		
		// output HTML
%>
<tr>
<td><%=(fileCount + 1)%></td>
<td><a href="<%=ctxRootPath%>/szair/reg_jxt_signup_detail.jsp?id=<%=URLEncoder.encode(rs.getString("id"))%>" title="查看申请文件内容"><%=rs.getString("sendplaintext_filename")%></a></td>
<td class="amount"><%=rs.getString("processstate")%></td>
<td class="amount"><%=rs.getString("processresult")%></td>
<td class="amount"><%=rs.getLong("new_count")%></td>
<td class="amount<%=successCssClass%>"><%=rs.getLong("success_count")%></td>
<td class="amount<%=failCssClass%>"><%=rs.getLong("fail_count")+rs.getLong("failsh_count")%></td>
<td class="amount"><%=rs.getLong("other_count")%></td>
<td class="amount"><%=rs.getLong("total_count")%></td>
</tr>
<%
		// calculate statistics
		total += rs.getLong("total_count");
		totalNew += rs.getLong("new_count");
		totalSuccess += rs.getLong("success_count");
		totalFailed += rs.getLong("fail_count")+rs.getLong("failsh_count");
		totalOthers = rs.getLong("other_count");
		
		// monthly stat
		monthTotalNew += rs.getLong("new_count");
		monthTotalSuccess += rs.getLong("success_count");
		monthTotalFailed += rs.getLong("fail_count")+rs.getLong("failsh_count");
		monthTotalOthers = rs.getLong("other_count");
		monthTotal += rs.getLong("total_count");
		
		fileCount++;
		
		lastDate = rs.getTimestamp("file_date");
		
	}	// while (not end-of-record) or (task file changed) 

%>
</tbody>
<tfoot>
<tr>
<td>&nbsp;</td>
<td><b>总结</b></td>
<td></td>
<td></td>
<td class="amount"><%=totalNew%></td>
<td class="amount"><%=totalSuccess%></td>
<td class="amount"><%=totalFailed%></td>
<td class="amount"><%=totalOthers%></td>
<td class="amount"><%=total%></td>
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