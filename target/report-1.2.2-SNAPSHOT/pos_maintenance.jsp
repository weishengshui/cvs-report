<%--

	The main menu. Entry point of the whole application.
	
	@author cyril
	@since 1.2.2 2010-04-26

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page import="com.chinarewards.report.db.*"%>
<%@ page import="com.chinarewards.report.data.crm.*"%>
<%@ page import="com.chinarewards.report.sql.*"%>
<%@ page import="com.chinarewards.report.util.*"%>
<%@ page import="com.chinarewards.report.data.pos.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>POS机管理报表(新)</title>
<%@ include file="/include/stdhtmlhead.inc.jsp"%>
<link rel="stylesheet"
	href="<%=ctxRootPath%>/js/jquery/plugin/tablesorter/themes/blue/style.css"
	type="text/css" media="print, projection, screen" />
<script type="text/javascript"
	src="<%=ctxRootPath%>/js/jquery/jquery-latest.js"></script>
<script type="text/javascript"
	src="<%=ctxRootPath%>/js/jquery/plugin/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript"
	src="<%=ctxRootPath%>/js/jquery/plugin/tablesorter/custom/parser.js"></script>
<script type="text/javascript">
	$(document).ready( function() {
		$("#pos_tbl").tablesorter();
	});
</script>

<style type="text/css">
.mgrp_sep {
	border-top-width: 2px;
	border-top-color: #000000;
}

.xact_blue {
	background-color: #80C0FF;
}

.xact_yellow {
	background-color: #FFFC40;
}

.xact_red {
	background-color: #FF0000;
}

/* shops which match the activity shops */
.target_shop {
	color: green;
}
</style>

</head>
<body>

<h1>POS机管理报表(新)</h1>

* 这里只显示CRM门店POS机列表中的记录，并非实际在运营部手中的POS机数目或POSM系统内的记录。
<br />
<br />

<%
	try {

		int blue = 3;
		int yellow = 7;

		PosService service = new PosService();

		List<PosReportVO> reportList = service.getPosReport();

		// show the listing on JSP.
%>

* 你可以按住SHIFT键，点选多个栏名做多重排序。
<br />

<!-- start of POS machine listing -->
<table id="pos_tbl" class="tablesorter">
	<thead>
		<tr>
			<th></th>
			<th>POS类型</th>
			<th>POS机编号</th>
			<th>执行者版本</th>
			<th>安装版本</th>
			<th>商户名称</th>
			<th>商户商业名称</th>
			<th>门店名称</th>
			<th>POS使用方式</th>
			<th>SIM卡号(CRM)</th>
			<th>安装状态</th>
			<th>CRM-POS<br />
			绑定状态</th>
			<th>未使用天数</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<%
			long i = 0;
				String rowCssClass = "";
				for (int j = 0; j < reportList.size(); j++) {
					PosReportVO vo = reportList.get(j);
					POSVO posvo = vo.getPos();

					long unUsedDays = posvo.getLastUnuseDays();

					if (unUsedDays != -1) {
						if (unUsedDays >= yellow) {
							rowCssClass = "xact_yellow";
						} else if (unUsedDays >= blue) {
							rowCssClass = "xact_blue";
						}
					} else {
						rowCssClass = "xact_red";
					}
		%>
		<tr class="<%=rowCssClass%>">
			<td><%=(i + 1)%></td>
			<td><%=posvo.getPostype()%></td>
			<td><%=posvo.getPosno()%></td>
			<td><%=posvo.getExecuteVersion() == null ? "未知"
							: posvo.getExecuteVersion()%></td>
			<td><%=posvo.getSetupVersion() == null ? "未知"
							: posvo.getSetupVersion()%></td>
			<td><%=vo.getMerchangName()%></td>
			<td><%=vo.getMerchantBusinessName()%></td>
			<td><%=vo.getShopName()%></td>
			<td><%=PosUtil.customCommTypeToText(posvo
									.getCustocommtype())%></td>
			<td><%=posvo.getSimcard()%></td>
			<td><%=PosUtil.installStatusToText(posvo
									.getInstallstatus())%></td>
			<td><%=PosUtil.activeFlagToText(posvo.getActiveflag())%></td>
			<td>
			<%
				if (unUsedDays == -1) {
							out.println("未使用");
						} else {
							out.println(unUsedDays);
						}
			%>
			</td>
			<td></td>
		</tr>
		<%
			i++;

				} // while (has more CRM shop <> POS bindings)
		%>
	</tbody>
</table>
<%
	} finally {

	}
%>

</body>
</html>