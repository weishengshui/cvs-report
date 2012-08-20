<%--

	The main menu. Entry point of the whole application.
	
	@author yudy
	@author cyril

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ taglib uri="/report-tags" prefix="rp"%>
<html>
<head>
<title>主菜单</title>
<%@ include file="/include/stdhtmlhead.inc.jsp"%>
</head>

<body>

<script>
	if (parent.document.getElementById('mainframe').cols != "20%,80%") {
		parent.document.getElementById('mainframe').cols = "20%,80%";
	}
</script>

<div align="center">
<div class="box_001 edge_001">
<table width="400" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="286" align="left" valign="top" class="brd_001 edge_002">
		<div id="nav">
		<ul>
			<li class="edge_003" onMouseOver="showMenu('Layer1');"
				onMouseOut="hideMenu('Layer1');">
			<h2>会员数据修复</h2>

			<div id="Layer1" class="list" style="display: none"><a
				href="<%=ctxRootPath%>/memberloginrepair.jsp" target="right">会员登录数据修复</a><rp:np
				date="20100829" /><br />
			</div>
			</li>

		</ul>
		</div>
		</td>

	</tr>
</table>
</div>
</div>

<script>
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