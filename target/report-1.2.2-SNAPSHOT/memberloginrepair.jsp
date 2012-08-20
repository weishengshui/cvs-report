<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.member.MemberLoginRepairService"%>
<%@ page language="java"
	import="com.chinarewards.report.data.auth.AuthUserInfo"%>
<%@ page language="java"
	import="com.chinarewards.report.data.tx.AccountInfo"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.MemberInfo"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.MemberShipInfo"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<html>
<head>
<title>Welcome to China Rewards Report Application</title>
<%@ include file="/include/stdhtmlhead.inc.jsp"%>
<style type="text/css">
#centerpoint {
	top: 50%;
	left: 50%;
	position: absolute;
}

#dialog {
	position: relative;
	width: 600px;
	margin-left: -300px;
	height: 400px;
	margin-top: -200px;
}
</style>
</head>

<body>

<%
	String requestUrl = request.getRequestURL().toString();
	// check if the password is correct.
	String queryno = request.getParameter("queryno");
	String type = request.getParameter("type");
	if (queryno != null && type != null) {
		MemberLoginRepairService service = new MemberLoginRepairService();
		MemberInfo vo = service.getMemberInfo(queryno, type);

		if (vo != null) {

			SysUserObj user = (SysUserObj) session.getAttribute("User");

			List<MemberShipInfo> msinfos = vo.getMemberShipInfos();
			AuthUserInfo userinfo = vo.getAuthUserInfo();
			List<AccountInfo> accountInfos = vo.getAccountInfos();
			int j = 1;

			//商户消费总额
			try {

				out.println("<h2>会员注册信息</h2>");

				out.println("<table border='1'>");
				out.println("<tr>");
				out.println("<td>姓名</td>");
				out.println("<td>地址</td>");
				out.println("<td>手机号</td>");
				out.println("<td>email</td>");
				out.println("<td>注册时间</td>");
				out.println("<td>积分账户</td>");
				out.println("<td>会员卡</td>");
				out.println("</tr>");

				out.println("<tr>");
				out.println("<td>" + vo.getName() + "</td>");
				out.println("<td>" + vo.getWorkaddress() + "</td>");
				out.println("<td>" + vo.getMobile() + "</td>");
				out.println("<td>" + vo.getEmail() + "</td>");
				out.println("<td>" + vo.getRegistdate() + "</td>");
				out.println("<td>" + vo.getAccountId() + "</td>");
				out.println("<td>");
				out.println("<table border='1'>");
				out.println("<tr>");
				out.println("<td>卡号</td>");
				out.println("<td>卡名称</td>");
				out.println("<td>卡帐号</td>");
				out.println("<td>注册时间</td>");
				out.println("<td>卡归属表</td>");
				if ("it".equals(user.getUsername())) {
					out.println("<td>更改卡号</td>");
				}
				out.println("</tr>");

				for (MemberShipInfo msinfo : msinfos) {

					out.println("<tr>");
					out.println("<td>" + msinfo.getMemberCardNo()
							+ "</td>");
					out
							.println("<td>" + msinfo.getCardName()
									+ "</td>");
					out.println("<td>" + msinfo.getAccountId()
							+ "</td>");
					out.println("<td>" + msinfo.getStartDate()
							+ "</td>");
					out.println("<td>" + msinfo.getCardLocation()
							+ "</td>");
					if ("it".equals(user.getUsername())) {
						String newrul = request.getContextPath()
								+ "/membershiprelate.jsp?membershipId="
								+ msinfo.getId() + "&membershipno="
								+ msinfo.getMemberCardNo()
								+ "&cardlocation="
								+ msinfo.getCardLocation() + "&step=1";

						out.println("<td><a href=" + newrul
								+ ">更改会员卡号</a></td>");
					}
					out.println("</tr>");
				}

				out.println("</table>");
				out.println("</td>");
				out.println("</table>");
				out.println("</br>");

				if (userinfo == null) {
					out
							.println("<h2><font color='red'>异常：会员登录帐号为空</font></h2>");
				} else {
					out.println("<h2>会员登录帐号信息</h2>");

					out.println("<table border='1'>");
					out.println("<tr>");
					out.println("<td>用户名</td>");
					out.println("<td>密码</td>");
					out.println("<td>设定登录失败次数</td>");
					out.println("<td>当前登录失败次数</td>");
					out.println("<td>修复</td>");
					out.println("</tr>");

					out.println("<tr>");
					out.println("<td>" + userinfo.getUsername()
							+ "</td>");
					out.println("<td>" + userinfo.getPassword()
							+ "</td>");
					out.println("<td>" + userinfo.getReverieDegree()
							+ "</td>");
					out.println("<td>" + userinfo.getFailDegree()
							+ "</td>");

					out.println("</td>");

					String newrul = request.getContextPath()
							+ "/authuserrepair.jsp?memberid="
							+ vo.getId();

					out.println("<td>" + "<a href=" + newrul
							+ ">会员登录数据修复</a>" + "</td>");

					out.println("</tr>");

					out.println("</table>");
				}

				if (accountInfos == null
						|| (accountInfos != null && accountInfos.size() == 0)) {
					out
							.println("<h2><font color='red'>异常：会员积分帐号为空</font></h2>");
				} else {
					out.println("<h2>会员积分帐号信息</h2>");

					out.println("<table border='1'>");
					out.println("<tr>");
					out.println("<td>accountId</td>");
					out.println("<td>ownerId</td>");
					out.println("<td>status</td>");
					out.println("</tr>");

					for (AccountInfo ainfo : accountInfos) {
						out.println("<tr>");
						out.println("<td>" + ainfo.getAccountId()
								+ "</td>");
						out.println("<td>" + ainfo.getOwnerId()
								+ "</td>");
						out.println("<td>" + ainfo.getStatus()
								+ "</td>");
					}

					out.println("</table>");
				}

				if ("it".equals(user.getUsername())) {
					String newrul = request.getContextPath()
							+ "/disablemember.jsp?memberid="
							+ vo.getId();

					out
							.println("</br><center><a href="
									+ newrul
									+ " onclick='return confirm(\"您确定要删除此会员数据?\")'>设置该会员为无效</a></center>");
				}

				List<String> accountids = vo.getAccountIds();
				StringBuffer consumerecordbuf = new StringBuffer();
				consumerecordbuf.append(request.getContextPath()
						+ "/allconsumerecordofmember.jsp");

				String flag = "";

				int k = 0;
				for (String accountid : accountids) {
					if (k == 0) {
						flag = "?";
					} else {
						flag = "&";
					}

					consumerecordbuf.append(flag).append("accountid=")
							.append(accountid);
				}

				out.println("</br><center><a href='"
						+ consumerecordbuf.toString()
						+ "'>查看会员的所有消费记录</a></center>");

				out.println("</br><center><a href='" + requestUrl
						+ "'>返回会员登录数据修复</a></center>");

				return;
			} catch (Exception e) {
				out.println(e);
			} finally {
				vo = null;
			}
		} else {
			//out.println("<font color='red'>未能查询到会员信息,请重新输入</font>");
%>
<center>
<h2><font color='red'>未能查询到会员信息,请重新输入</font></h2>
</center>
<%
	}
	}

	if (true) {
%>
<center>
<form action="memberloginrepair.jsp" method="POST">
<table>
	<tr>
		<td style="text-align: right">查询号码:</td>
		<td><input type="text" name="queryno"></td>
	</tr>
	<tr>
		<td style="text-align: right">类型选择:</td>
		<td><input type=radio name="type" value="mobile" checked>手机号
		<input type=radio name="type" value="cardno">卡号</td>
	</tr>
	<tr>
		<td colspan="2" style="text-align: center"><input type="submit"
			value="OK"><br />
		</td>
	</tr>
</table>
</form>
</center>
</body>
</html>

<%
	}
%>
