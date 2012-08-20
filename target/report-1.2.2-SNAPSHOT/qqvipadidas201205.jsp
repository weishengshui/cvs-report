<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.QQVipAdidasService"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.QQActiveHistoryVO"%>
<%@ page language="java"
	import="com.chinarewards.report.qqvipadidas.QQWeiXinSignIn"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");

	QQVipAdidasService service = new QQVipAdidasService();
	List<QQActiveHistoryVO> plist = null;
	List<QQWeiXinSignIn> wxlist = null;

	String param = request.getParameter("param");
	System.out.println("qqvipadidas201205 param is " + param);

	int j = 1;

	//商户消费总额
	try {

		if (param.equals("GIFT") || param.equals("PRIVILEGE")) {
			if (param.equals("GIFT")) {
				out.println("<h2>领取礼品报表</h2>");

			} else if (param.equals("PRIVILEGE")) {
				out.println("<h2>获取优惠报表</h2>");
			}

			plist = service.getQQActiveHistoryList(param);

			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td>序号</td>");
			out.println("<td>POS机编号</td>");
			out.println("<td>验证码CDKEY</td>");
			out.println("<td>消费金额</td>");
			out.println("<td>获取返点</td>");
			out.println("<td>交易时间</td>");
			out.println("</tr>");

			for (int i = 0; i < plist.size(); i++) {
				QQActiveHistoryVO vo = plist.get(i);
				out.println("<tr>");
				out.println("<td>" + (j++) + "</td>");
				out.println("<td>" + vo.getPosId() + "</td>");
				out.println("<td>" + vo.getMemberkey() + "</td>");
				out.println("<td>"
						+ moneyFormat.format(vo.getConsumeAmt())
						+ "</td>");
				out.println("<td>"
						+ moneyFormat.format(vo.getRebateAmt())
						+ "</td>");
				out.println("<td>" + vo.getTime()
						+ "</td>");

				out.println("</tr>");
			}

			out.println("</table>");

		} else if (param.equals("weixin")) {
			out.println("<h2>微信签到报表</h2>");
			wxlist = service.getQQWeiXinSignIn();

			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td>序号</td>");
			out.println("<td>POS机编号</td>");
			out.println("<td>微信号</td>");
			out.println("<td>签到时间</td>");
			out.println("</tr>");

			for (int i = 0; i < wxlist.size(); i++) {
				QQWeiXinSignIn vo = wxlist.get(i);
				out.println("<tr>");
				out.println("<td>" + (j++) + "</td>");
				out.println("<td>" + vo.getPosId() + "</td>");
				out.println("<td>" + vo.getWeixinNo() + "</td>");

				out.println("<td>" + vo.getTime()
						+ "</td>");

				out.println("</tr>");
			}
			out.println("</table>");
		}

	} catch (Exception e) {
		out.println(e);
	} finally {
		plist = null;
		wxlist = null;
	}
%>