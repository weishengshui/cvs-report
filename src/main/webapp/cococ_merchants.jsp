<%@ page language="java"
	import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,java.util.*"%>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*"%>
<%@ page language="java" import="com.chinarewards.report.db.*"%>
<%@ page language="java" import="com.chinarewards.report.sql.*"%>
<%@ page language="java" import="com.chinarewards.report.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/global.inc.jsp"%>
<%@ include file="/checklogin.jsp"%>

<html>
<head>
<title>可可西对接报表 - 商户</title>
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
	$(document).ready(function() {
		$("#merchantRevenueSummaryTable").tablesorter();
		$("#shopRevenueSummaryTable").tablesorter();
	});
</script>
</head>

<body>

<%
	// formatting
	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
	DecimalFormat rateFormat = new DecimalFormat("#,##0.0");
	DecimalFormat intFormat = new DecimalFormat("#,##0");
	SimpleDateFormat dateOnlyFormat = new SimpleDateFormat("yyyy-MM-dd");

	Connection conn = null;
	ResultSet rs = null;
	Statement stmt = null;

	try {

		conn = DbConnectionFactory.getInstance().getConnection("crm");
		stmt = conn.createStatement();

		//
		// 行业类型
		//
		{

			out.println("<h1>行业类型</h1>");
			rs = stmt
					.executeQuery("SELECT id, parakey, paravalue FROM INDUSTRYTYPE WHERE activeflag = 'effective'");
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>编号</th>");
			out.println("<th>类型键</th>");
			out.println("<th>类型值</th>");
			out.println("</tr>");
			out.println("</thead>");
			// show result
			out.println("<tbody>");
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString("id") + "</td>");
				out.println("<td>" + rs.getString("parakey") + "</td>");
				out.println("<td>" + rs.getString("paravalue")
						+ "</td>");
				out.println("</tr>");
			}
			out.println("</tbody>");
			out.println("</table>");
			rs.close();
		}

		//
		// 商户 (we should filter all merchant without valid contract)
		//
		{
			out.println("<h1>商户</h1>");
			rs = stmt
					.executeQuery("SELECT distinct m.id, m.industrytype_id, m.businessname, mi.images_id, m.customerAverageSpending, m.isRecommendation, m.hadRemark "
							+ "FROM MERCHANT m, MERCHANT_IMAGE mi, CONTRACT c, COOPERATIONDETAIL cd "
							+ "WHERE m.id = mi.merchant_id(+)"
							+ " AND m.activeflag = 'effective'"
							+ " AND m.id = cd.merchant_id"
							+ " AND c.cooperationdetail_id = cd.id"
							+ " AND c.activeflag = 'effective'"
							+ " AND c.status = '生效'"
							+ " AND c.P_TYPE = 'PointContract'"
							+ " AND (sysdate BETWEEN c.effectivebegin AND c.effectiveend)"
							+ " AND m.merchanttype_id <> '5'");
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>商户编号</th>");
			out.println("<th>对应的行业类型编号</th>");
			out.println("<th>商户名称</th>");
			out.println("<th>商户图片URL</th>");
			out.println("<th>人均消费</th>");
			out.println("<th>是否推荐商户</th>");
			out.println("<th>商户简介信息</th>");
			out.println("</tr>");
			out.println("</thead>");
			// show result
			out.println("<tbody>");
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString("id") + "</td>");
				out.println("<td>" + rs.getString("industrytype_id")
						+ "</td>");
				out.println("<td>" + rs.getString("businessname")
						+ "</td>");
				String imageId = rs.getString("images_id");
				if (imageId != null) {
					String imageURL = "http://www.jifen.cc/merchant/images/"
							+ imageId;
					out.println("<td>" + imageURL + "</td>");
				} else {
					out.println("<td>NO IMAGE</td>");
				}
				out.println("<td>"
						+ rs.getString("customerAverageSpending")
						+ "</td>");
				out.println("<td>" + rs.getString("isRecommendation")
						+ "</td>");
				out.println("<td>" + rs.getString("hadRemark")
						+ "</td>");
				out.println("</tr>");
			}
			out.println("</tbody>");
			out.println("</table>");
			rs.close();
		}

		out.println("<br>");

		//
		// 门市
		//
		{
			out.println("<h1>门市</h1>");
			rs = stmt
					.executeQuery("SELECT s.merchant_id, s.id, s.name, s.parseregion, s.contactaddress," // 1-5
							+ " s.contactphone, s.freeparkingavailable, s.creditcardacceptable, s.remark, s.favorinfo," // 6-10
							+ " bc.name, s.recommendStatus " // 11-12
							+ "FROM SHOP s, BIZCIRCLESHOP bcs, BIZCIRCLE bc "
							+ "WHERE s.activeflag = 'effective'"
							+ " AND s.id = bcs.shop_id(+)"
							+ " AND bcs.bizcircle_id = bc.id"
							+ " AND bc.isdefaulttype = '1'" // show portal bizcircle only
							+ " AND s.merchant_id IN (SELECT m.id "
							+ "   FROM MERCHANT m, CONTRACT c, COOPERATIONDETAIL cd "
							+ "   WHERE m.activeflag = 'effective'"
							+ "   AND m.id = cd.merchant_id"
							+ "   AND c.cooperationdetail_id = cd.id"
							+ "   AND c.activeflag = 'effective'"
							+ "   AND c.status = '生效'"
							+ "   AND c.P_TYPE = 'PointContract'"
							+ "   AND (sysdate BETWEEN c.effectivebegin AND c.effectiveend)"
							+ "   AND m.merchanttype_id <> '5')"
							+ " ORDER BY s.id");
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>门市所属商户编号</th>");//1
			out.println("<th>门市编号</th>");//2
			out.println("<th>门市名称</th>");//3
			out.println("<th>门市地址</th>");//4+5
			out.println("<th>联系电话</th>");//6
			out.println("<th>是否免费停车</th>");//7
			out.println("<th>是否刷卡</th>");//8
			out.println("<th>营业时间</th>");//9
			out.println("<th>特惠信息</th>");//10
			out.println("<th>所属商圈名称</th>");//11
			out.println("<th>是否推荐商户</th>");//12
			out.println("</tr>");
			out.println("</thead>");
			// show result
			out.println("<tbody>");
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString(1) + "</td>");
				out.println("<td>" + rs.getString(2) + "</td>");
				out.println("<td>" + rs.getString(3) + "</td>");
				out.println("<td>" + rs.getString(4) + rs.getString(5)
						+ "</td>");
				out.println("<td>" + rs.getString(6) + "</td>");
				out.println("<td>" + rs.getString(7) + "</td>");
				out.println("<td>" + rs.getString(8) + "</td>");
				out.println("<td>" + rs.getString(9) + "</td>");
				out.println("<td>"
						+ (rs.getString(10) != null
								? rs.getString(10)
								: "") + "</td>");
				out.println("<td>" + rs.getString(11) + "</td>");
				out.println("<td>" + rs.getString(12) + "</td>");
				out.println("</tr>");
			}
			out.println("</tbody>");
			out.println("</table>");
			rs.close();
		}

		//
		// 消费类型 (we should filter all merchant without valid contract)
		//
		{
			out.println("<h1>门市消费属性</h1>");
			rs = stmt
					.executeQuery("SELECT cs.shop_id, p.name, d.discountRate, c.priority, c.id "
							+ "FROM CONTRACTDETAIL d, CONTRACT c, CONTRACT_SHOP cs, PRODUCTTYPEITEM p "
							+ "WHERE d.pointcontract_id = c.id "
							+ " AND d.activeflag = 'effective'"
							+ " AND c.activeflag = 'effective'"
							+ " AND p.activeflag = 'effective'"
							+ " AND c.status = '生效'"
							+ " AND c.P_TYPE = 'PointContract'"
							+ " AND (sysdate BETWEEN c.effectivebegin AND c.effectiveend)"
							+ " AND c.id = cs.pointcontracts_id "
							+ " AND d.producttypeitem_id = p.id "
							+ " AND d.discountRate > 0 "
							+ " AND cs.shop_id IN ("
							// show only shops above
							+ "SELECT s.id "
							+ "FROM SHOP s "
							+ "WHERE s.activeflag = 'effective'"
							+ " AND s.merchant_id IN (SELECT m.id "
							+ "   FROM MERCHANT m, CONTRACT c, COOPERATIONDETAIL cd "
							+ "   WHERE m.activeflag = 'effective'"
							+ "   AND m.id = cd.merchant_id"
							+ "   AND c.cooperationdetail_id = cd.id"
							+ "   AND c.activeflag = 'effective'"
							+ "   AND c.status = '生效'"
							+ "   AND c.P_TYPE = 'PointContract'"
							+ "   AND (sysdate BETWEEN c.effectivebegin AND c.effectiveend)"
							+ "   AND m.merchanttype_id <> '5')"
							+ ")"
							+ " ORDER BY cs.shop_id ASC, c.priority DESC ");
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>消费属性所属门市编号</th>");
			out.println("<th>消费类型名称</th>");
			out.println("<th>返点比例</th>");
			out.println("</tr>");
			out.println("</thead>");
			// show result
			out.println("<tbody>");
			String lastShop = null;
			String lastPriority = null;
			while (rs.next()) {
				/*
				String shop = rs.getString(1);
				String priority = rs.getString(4);
				if (shop.equals(lastShop) && !priority.equals(lastPriority)) {
					continue;
				}
				lastShop = shop;
				lastPriority = priority;
				 */
				out.println("<tr>");
				out.println("<td>" + rs.getString(1) + "</td>");
				out.println("<td>" + rs.getString(2) + "</td>");
				out.println("<td>" + rs.getString(3) + "</td>");
				out.println("</tr>");
			}
			out.println("</tbody>");
			out.println("</table>");
			rs.close();
		}

		out.println("<br>");

	} catch (Exception e) {

		out.println(e);
		e.printStackTrace(new PrintWriter(out));

	} finally {

		// gracefully release resources.
		SqlUtil.close(rs);
		SqlUtil.close(stmt);
		SqlUtil.close(conn);

	}
%>
</body>
</html>