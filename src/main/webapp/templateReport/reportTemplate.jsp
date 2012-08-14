<%--

	The main menu. Entry point of the whole application.
	
	@author weishengshui

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ taglib uri="/report-tags" prefix="rp"%>
<%@ include file="/include/stdhtmlhead.inc.jsp"%>
<html>
<head>
<title>主菜单</title>
</head>

<body>

<script>
	if (parent.document.getElementById('mainframe').cols != "20%,80%") {
		parent.document.getElementById('mainframe').cols = "20%,80%";
	}
</script>
<div align="center">
<div class="box_001 edge_001">
<%
	SysUserObj user = (SysUserObj) session.getAttribute("User");
%>

<table width="400" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="286" align="left" valign="top" class="brd_001 edge_002">
		<div id="nav">
		<ul>

			<%
				if ("test".equals(user.getUsername())) {
					String startDate=request.getParameter("startDate");
					String endDate=request.getParameter("endDate");
					String activity_id=request.getParameter("activity_id");
					String activity_name= request.getParameter("activity_name");
			%>
			<li class="edge_003" onclick="javascript:clickMenu('Layer3');">
			<h2><%=activity_name %></h2>
			
			<div id="Layer3" class="list" style="display: none">

			  <a	href="<%=ctxRootPath%>/coastalCity201207/detailCount20120726.jsp"
				target="right">明细报表</a><rp:np date="20120526" /><br />

			<a
				href="<%=ctxRootPath%>/coastalCity201207/userTokenQuery.jsp"
				target=right>验证码使用查询</a> <rp:np date="20120526" /><br />
           
           
			 <!-- 
			<a href="<%=ctxRootPath%>/coastalCity201207/coastal20120726.jsp?param=HISTORYOFDAY"
				target=right>每日每商户报表</a> <rp:np date="20120726" /><br />
				
			 -->
			<a href="<%=ctxRootPath%>/templateReport/totalStatementsTemplate.jsp?startDate=<%=startDate %>&endDate=<%=endDate %>&activity_id=<%=activity_id %>"
				target=right>总计报表</a> <rp:np date="20120531" /></div>

			</li>
			<%
				} else {
			%>

			<li class="edge_003" onclick="javascript:clickMenu('Layer1');">
			<h2>会员数据修复</h2>

			<div id="Layer1" class="list" style="display: none"><a
				href="<%=ctxRootPath%>/memberloginrepair.jsp" target="right">会员登录数据修复</a><rp:np
				date="20100829" /><br />
			</div>
			</li>
			<%
				if ("it".equals(user.getUsername())) {
			%>
			<li class="edge_003" onclick="javascript:clickMenu('Layer2');">
			<h2>有消费会员积分状态</h2>

			<div id="Layer2" class="list" style="display: none"><a
				href="<%=ctxRootPath%>/memberpointstatus.jsp" target="right">有消费会员积分状态</a><rp:np
				date="20100829" /><br />
			<a href="<%=ctxRootPath%>/chinarewardsManagerReport.jsp" target=right>缤纷联盟管理报表</a>
			<rp:np date="20101026" /></div>

			</li>
			<%
				}
				}
			%>
		</ul>
		</div>
		</td>

	</tr>
</table>
</div>
</div>

<script>
	function clickMenu(param) {
		if (document.getElementById(param).style.display == "none") {
			document.getElementById(param).style.display = "";
			document.getElementById(param).focus();
		} else {
			document.getElementById(param).style.display = "none";
		}
	}

	function showMenu(param) {
		document.getElementById(param).style.display = "";
		document.getElementById(param).focus();
	}
	function hideMenu(param) {
		document.getElementById(param).style.display = "none";
	}
</script>
</body>
</html>