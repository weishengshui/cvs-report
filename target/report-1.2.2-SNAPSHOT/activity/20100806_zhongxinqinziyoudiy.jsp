<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page language="java"
	import="com.chinarewards.report.data.activity.ZhongXinQinZiYouDIY"%>
<%@ page language="java"
	import="com.chinarewards.report.data.crm.ConsumeData"%>
<%@ page language="java"
	import="com.chinarewards.report.data.activity.QinZiYouDIYReportVo"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>
<%@ include file="/include/stdhtmlheader.inc.jsp"%>

<%
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");

	ZhongXinQinZiYouDIY service = new ZhongXinQinZiYouDIY();
	QinZiYouDIYReportVo voo = null;

	int j = 1;

	//商户消费总额
	try {

		voo = service.getZhongXinQinZiYouDIYReport();

		out.println("<h2>中信亲子游DIY报表</h2></br></br>");

		List<ConsumeData> allDataInZhongXin = service
				.getAllChinaLifeMemberConsumeDateInZXQZYDIY(null);

		out.println("<h3>国寿会员中信亲子游门市消费明细</h3></br>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>卡号</td>");
		out.println("<td>消费门市</td>");
		out.println("<td>消费类型</td>");
		out.println("<td>消费金额</td>");
		out.println("<td>获得积分</td>");
		out.println("<td>交易时间</td>");
		out.println("</tr>");

		if (allDataInZhongXin != null) {
			for (int i = 0; i < allDataInZhongXin.size(); i++) {
				ConsumeData vo = allDataInZhongXin.get(i);
				out.println("<tr>");
				out.println("<td>" + (j++) + "</td>");
				out.println("<td>" + vo.getMemberCardNo() + "</td>");
				out.println("<td>" + vo.getShopName() + "</td>");
				out.println("<td>" + vo.getConsumeType() + "</td>");
				out.println("<td>"
						+ moneyFormat.format(vo.getConsumeMoney())
						+ "</td>");
				out.println("<td>" + pointFormat.format(vo.getPoint())
						+ "</td>");
				out.println("<td>"
						+ dateFormat.format(vo.getTransDate())
						+ "</td>");

				out.println("</tr>");
			}
		}

		out.println("</table></br>");

		Map<String, Integer> datasum = voo.getDatasum();
		List<ConsumeData> data = voo.getData();

		out.println("<h3>中信亲子游DIY汇总</h3></br>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>卡号</td>");
		out.println("<td>消费总数</td>");
		out.println("</tr>");

		if (datasum != null) {
			Set<String> keySet = datasum.keySet();
			Iterator<String> it = keySet.iterator();
			while (it.hasNext()) {
				String memberCardNo = (String) it.next();
				int sum = datasum.get(memberCardNo).intValue();

				out.println("<tr>");
				out.println("<td>" + (j++) + "</td>");
				out.println("<td>" + memberCardNo + "</td>");
				out.println("<td>" + sum + "</td>");
				out.println("</tr>");
			}

		}

		out.println("</table></br></br>");

		out.println("<h3>中信亲子游DIY明细</h3></br>");
		out.println("<table border='1'>");
		out.println("<tr>");
		out.println("<td>序号</td>");
		out.println("<td>卡号</td>");
		out.println("<td>消费门市</td>");
		out.println("<td>消费类型</td>");
		out.println("<td>消费金额</td>");
		out.println("<td>获得积分</td>");
		out.println("<td>交易时间</td>");
		out.println("</tr>");

		if (data != null) {
			for (int i = 0; i < data.size(); i++) {
				ConsumeData vo = data.get(i);
				out.println("<tr>");
				out.println("<td>" + (j++) + "</td>");
				out.println("<td>" + vo.getMemberCardNo() + "</td>");
				out.println("<td>" + vo.getShopName() + "</td>");
				out.println("<td>" + vo.getConsumeType() + "</td>");
				out.println("<td>"
						+ moneyFormat.format(vo.getConsumeMoney())
						+ "</td>");
				out.println("<td>" + pointFormat.format(vo.getPoint())
						+ "</td>");
				out.println("<td>"
						+ dateFormat.format(vo.getTransDate())
						+ "</td>");

				out.println("</tr>");
			}
		}

		out.println("</table>");

	} catch (Exception e) {
		out.println(e);
	} finally {
		voo = null;
	}
%>