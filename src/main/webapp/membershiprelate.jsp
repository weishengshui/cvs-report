<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.member.MemberShipService"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<html>
<head>

<script language="javaScript">
	function validate() {

		if (form1.newcardno.value.length == 0) {
			alert("输入内容不能为空！");
			form1.newcardno.focus();
			return false;
		}

		return true;
	}
</script>
</head>
<body>

<%
	String step = request.getParameter("step");

	if (step == null) {
		out.println("step is null");

	} else {

		if ("1".equals(step)) {
			String membershipId = request.getParameter("membershipId");
			String memberCardno = request.getParameter("membershipno");
			String cardLocation = request.getParameter("cardlocation");

			if (membershipId == null) {
				out.println("membershipId is null");
				return;
			}

			if (memberCardno == null) {
				out.println("memberCardno is null");
				return;
			}

			if (cardLocation == null) {
				out.println("cardLocation is null");
				return;
			}
			out.println("<center><h1>会员卡号更新</h1></center>");
			out
					.println("<form name = 'form1' action='membershiprelate.jsp' method='get' onsubmit='return validate();'>");
			out
					.println("<br><input type='hidden' name='step' value='2'/>");
			out
					.println("<br><input type='hidden' name='membershipId' value='"
							+ membershipId + "'/></center>");
			out
					.println("<br><input type='hidden' name='cardlocation' value='"
							+ cardLocation + "'/></center>");

			out
					.println("<br><center><lable>cardlocation:</lable><input type='text' name='cardlocationtext' value='"
							+ cardLocation
							+ "' disabled='disabled'/></center>");
			out
					.println("<br><center><lable>oldCardno:</lable><input type='text' name='memberCardno' value='"
							+ memberCardno
							+ "' disabled='disabled'/></center>");
			out
					.println("<br><center><lable>newCardno:</lable><input type='text' name='newcardno'/></center>");
			out
					.println("<br><center><input type='submit' value='Submit'/></center>");
			out.println("</form>");

		} else if ("2".equals(step)) {
			String membershipId = request.getParameter("membershipId");
			String newCardno = request.getParameter("newcardno");
			String cardLocation = request.getParameter("cardlocation");

			if (membershipId == null) {
				out.println("membershipId is null");
				return;
			}

			if (cardLocation == null) {
				out.println("cardLocation is null");
				return;
			}

			if (newCardno == null) {
				out.println("newCardno is null");
				return;
			}

			MemberShipService service = new MemberShipService();
			boolean result = service.updateMemberCardNo(membershipId,
					cardLocation, newCardno);

			if (result) {
				out
						.println("<br><br><br><center><h1>修改会员卡号成功!</h1></center>");
			} else {
				out
						.println("<br><br><br><center><h1>修改会员卡号失败!</h1></center>");
			}

			out
					.println("<br><br><br><center><a href='"
							+ ctxRootPath
							+ "/memberloginrepair.jsp'>返回会员登录数据修复</a></center>");
		}

	}
%>
</body>
</html>
