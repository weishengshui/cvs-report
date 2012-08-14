<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.member.MemberService"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<html>
<head></head>
<body>

<%
	String memberId = request.getParameter("memberid");
	if (memberId == null) {
		out.println("不能获取memberid");
		return;
	}

	MemberService service = new MemberService();
	service.invalidMemberByMemberId(memberId);
	
	out.println("<br><br><br><center><h1>删除会员数据成功!</h1></center>");
	out.println("<br><br><br><center><a href='" + ctxRootPath
			+ "/memberloginrepair.jsp'>返回会员登录数据修复</a></center>");
%>
</body>
</html>
