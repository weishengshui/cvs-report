<%--

Shenzhen Airlines report.

Shows summary of application result sent from Shenzhen Airlines FTP backend
(daily).


@author cyril
@since 1.3.0 2010-04-07

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.text.*, java.util.*" %>
<%@ page import="com.chinarewards.report.db.*, com.chinarewards.report.jsp.util.*" %>
<%@ page import="com.chinarewards.report.data.crm.*" %>
<%@ page import="com.chinarewards.report.sql.*" %>
<%@ page import="com.chinarewards.report.util.*" %>

<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<html>
<head>
<title>深航客服FTP申请结果一览</title>
<style type="text/css">
.fail {
	background-color: #FA6E8C;
}
.success {
	background-color: #97F576;
}
.doc_warn {
	background-color: #FAEB1E;
}
</style>
</head>


<body>

<h1>深航客服FTP申请结果一览</h1>

<!-- Introduction STARTS -->
本报表显示了每天深航方主动提交的申请的处理结果概览。其申请是由深航经FTP单方向传送给积享通。
<br/><br/>
<!-- Introduction ENDS -->

<%

SimpleDateFormat dateOnlyFormat = new SimpleDateFormat("yyyy-MM-dd");


Connection conn = null;
ResultSet rs = null; 
PreparedStatement stmt = null; 
String sql = null;



try {

	// crm database
	conn = DbConnectionFactory.getInstance().getConnection("szair");
	
	
	
	// query the application summary.
	sql = "SELECT shbkend.id, to_date(substr(shbkend.receivedfilename,18,8),'yyyymmdd') AS file_date, shbkend.receivedfilename, shbkend.importdate, shbkend.processstate, ms.status, count(*) AS status_count "
		+ "FROM szairbackendimporttask shbkend LEFT JOIN membersignup ms ON shbkend.id=ms.szairbackendimporttask_id "
		+ "GROUP BY shbkend.id, shbkend.importdate, shbkend.processstate, shbkend.receivedfilename, ms.status "
		+ "ORDER BY shbkend.receivedfilename DESC, shbkend.id, ms.status ASC";
//	System.out.println("sql = " + sql);
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	
	// some global statistics
	long totalNew = 0;
	long totalSuccess = 0;
	long totalFailed = 0;
	long totalOthers = 0;
	long total = 0;
	
%>
<table>
<thead>
<tr>
<th>#</th>
<th>檔案</th>
<th>檔案日期</th>
<th>處理狀態</th>
<th>新增日期</th>
<th>新增</th>
<th>成功</th>
<th>失敗</th>
<th>其他</th>
<th>總數</th>
</tr>
</thead>
<tbody>
<%

// iterate the records

boolean eof = false;
long fileCount = 0;
String lastTaskId = null;
String filename = null;
String id = null;
java.util.Date iDate = null;
String taskId = null;
String taskProcessState = null;
java.util.Date fileDate = null;
java.util.Date importDate = null;
// stores the counter for each status.
long successCount = 0;
long newCount = 0;
long failCount = 0;
long otherCount = 0;
long doctotal = 0;
// monthly statistics
long monthlySuccessCount = 0;
long monthlyNewCount = 0;
long monthlyFailCount = 0;
long monthlyOtherCount = 0;
long monthlyDocTotal = 0;
//
int iYear = -1;
int iMonth = -1;
int lastYear = -1;
int lastMonth = -1;


	// new start of a file from szair backend FTP.
	
	// iterate until task is changed	
	while (!eof) {
		
		// try to read record
		eof = !rs.next();
		
		boolean needToProcessBatch = false;
		boolean needToShowMonthlySummary = false;
		String signupStatus = null;
		
		if (!eof) {
			taskId = rs.getString("id");
			signupStatus = rs.getString("status");
			
			// check whether we need to output monthly summary.
			iDate = rs.getTimestamp("file_date");
			Calendar cal = Calendar.getInstance();
			cal.setTime(iDate);
			iYear = cal.get(Calendar.YEAR);
			iMonth = cal.get(Calendar.MONTH);
			
			if (lastYear == -1) {
				lastYear = cal.get(Calendar.YEAR);
			}
			if (lastMonth == -1) {
				lastMonth = cal.get(Calendar.MONTH);
			}
		}
		
		// no more record, break the loop
		if (eof || (lastTaskId != null && !lastTaskId.equals(taskId))) {
			needToProcessBatch = true;
		}
		
		// check whether we need to display monthly summary.
		if (eof || (lastYear != iYear || lastMonth != iMonth)) {
			needToShowMonthlySummary = true;
		}
		
		if (lastTaskId == null) {
			// first time
			if (!eof) {
				id = rs.getString("id");
				filename = rs.getString("receivedfilename");
				taskProcessState = rs.getString("processstate");
				fileDate = rs.getTimestamp("file_date");
				importDate = rs.getTimestamp("importdate");
			}
		}
		
		
		//
		// Show file summary.
		//
		if (needToProcessBatch) {
			
			// Another file is detected (since record ID is changed)
			// echo the result now!
			
			// echo result.
			String failCssClass = "";
			String successCssClass = "";
			if (failCount > 0) {
				failCssClass += " fail";
			}
			if (successCount > 0) {
				successCssClass += " success";
			}
			
			// task processing state
			String taskProcessStateCss = "";
			if (!"COMPLETED".equals(taskProcessState)) {
				taskProcessStateCss = " doc_warn";
			}
		
%>
<tr>
<td><%=(fileCount + 1)%></td>
<td><a href="<%=ctxRootPath%>/szair/reg_shbackend_signup_detail.jsp?id=<%=URLEncoder.encode(id,"UTF-8")%>" title="查看申请文件内容"><%=filename%></a></td>
<td><%=dateOnlyFormat.format(fileDate)%></td>
<td class="<%=taskProcessStateCss%>"><%=taskProcessState%></td>
<td><%=importDate%></td>
<td class="amount"><%=newCount%></td>
<td class="amount<%=successCssClass%>"><%=successCount%></td>
<td class="amount<%=failCssClass%>"><%=failCount%></td>
<td class="amount"><%=otherCount%></td>
<td class="amount"><%=doctotal%></td>
</tr>
<%

			// ok, reset every statistics
			newCount = 0;
			successCount = 0;
			failCount = 0;
			otherCount = 0;
			doctotal = 0;

			// some statistics needed to be updated.
			fileCount++;
			lastTaskId = taskId;
			
		}
		

		//
		// Show monthly summary
		//
		if (needToShowMonthlySummary) {
			
			
%>	
<tr>
<td>&nbsp;</td>
<td><%=lastYear%>年<%=lastMonth+1%>月总结:</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td class="amount"><%=monthlyNewCount%></td>
<td class="amount success"><%=monthlySuccessCount%></td>
<td class="amount fail"><%=monthlyFailCount%></td>
<td class="amount"><%=monthlyOtherCount%></td>
<td class="amount"><%=monthlyDocTotal%></td>
</tr>
<%			
		
			// reset monthly summary.
			monthlySuccessCount = 0;
			monthlyNewCount = 0;
			monthlyFailCount = 0;
			monthlyOtherCount = 0;
			monthlyDocTotal = 0;
		}
		

		
		if (eof) break;
		
		
		// update statistics for next turn.
		id = rs.getString("id");
		filename = rs.getString("receivedfilename");
		taskProcessState = rs.getString("processstate");
		fileDate = rs.getTimestamp("file_date");
		importDate = rs.getTimestamp("importdate");
		
		// remember the filename
		long count = rs.getLong("status_count");
		
		// increment total.
		if (signupStatus != null) {
			doctotal += count;
			total += count;
			monthlyDocTotal += count;
		}
		
		// update signup result statistics
		if ("NEW".equals(signupStatus)) {
			newCount += count;
			totalNew += count;
			monthlyNewCount += count;
		} else if ("SUCCESS".equals(signupStatus)) {
			successCount += count;
			totalSuccess += count;
			monthlySuccessCount += count;
		} else if ("FAILED".equals(signupStatus)) {
			failCount += count;
			totalFailed += count;
			monthlyFailCount += count;
		} else if (signupStatus == null) {
			// no records.
		} else {
			otherCount += count;
			totalOthers += count;
			monthlyOtherCount += count;
		}
			
		// update the last remembered field
		lastTaskId = taskId;
		lastYear = iYear;
		lastMonth = iMonth;
		
	}	// while (not end-of-record) or (task file changed) 

%>
</tbody>
<tfoot>
<tr>
<td>&nbsp;</td>
<td><b>总结</b></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
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
	throw t;
} finally {
	SqlUtil.close(rs);
	SqlUtil.close(stmt);
	SqlUtil.close(conn);
}
%>
</body>
</html>