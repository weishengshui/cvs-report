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
<%
	SysUserObj user = (SysUserObj) session.getAttribute("User");
%>

<table width="400" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="286" align="left" valign="top" class="brd_001 edge_002">
		<div id="nav">
		<ul>

			<%
				if ("adidas".equals(user.getUsername())) {
			%>
			<li class="edge_003" onclick="javascript:clickMenu('Layer3');">
			<h2>QQVIP专享adidas</h2>

			<div id="Layer3" class="list" style="display: none"><a
				href="<%=ctxRootPath%>/qqvipadidas/qqvipadidas201205.jsp?param=GIFT"
				target=right>QQVIP领取礼品报表</a> <rp:np date="20120521" /><br />
             <a	href="<%=ctxRootPath%>/qqvipadidas/qqvipadidas201205.jsp?param=PRIVILEGE"
				target="right">QQVIP获取优惠报表</a><rp:np date="20120521" /><br />
			<a href="<%=ctxRootPath%>/qqvipadidas/qqvipadidas201205.jsp?param=weixin"
				target=right>QQ微信签订报表</a> <rp:np date="20120521" /><br />

			<a href="<%=ctxRootPath%>/qqvipadidas/qqvipadidas201205.jsp?param=HISTORYOFDAY"
				target=right>每日每店报表</a> <rp:np date="20120531" /><br />

			<a href="<%=ctxRootPath%>/qqvipadidas/qqvipadidascount201205.jsp"
				target=right>总计报表</a> <rp:np date="20120523" /></div>

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