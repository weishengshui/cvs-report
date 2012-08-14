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
<title>可可西对接报表 - 商品</title>
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

		conn = DbConnectionFactory.getInstance()
				.getConnection("supply");
		stmt = conn.createStatement();
		// subcat -> root cat tree
		Map<String, String> rootMap = new HashMap<String, String>();
		// all root cat tree
		Set<String> root = new HashSet<String>();

		//
		// 商品分组信息
		//
		{
			out.println("<h1>商品分组信息</h1>");
			rs = stmt
					.executeQuery("SELECT id, name, PID, length(PID) l FROM GIFTTYPE WHERE id <> '0' ORDER BY l, PID, POSITION");
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>商品分组编号</th>");
			out.println("<th>兑换分组描述</th>");
			out.println("</tr>");
			out.println("</thead>");
			// show result
			out.println("<tbody>");
			while (rs.next()) {
				String id = rs.getString("id");
				String pid = rs.getString("PID"); // parent
				if ("0".equals(pid)) {
					root.add(id);
					out.println("<tr>");
					out.println("<td>" + id + "</td>");
					out
							.println("<td>" + rs.getString("name")
									+ "</td>");
					out.println("</tr>");
				} else {
					// no dump, just build the tree
					rootMap.put(id, pid);
					if (!root.contains(pid)) {
						// search for the root
						String ppid = rootMap.get(pid);
						if (ppid != null && root.contains(ppid)) {
							rootMap.put(id, ppid);
						}
					}
				}
			}
			out.println("</tbody>");
			out.println("</table>");
			rs.close();
		}

		//
		// 商品区域信息
		//
		{
			out.println("<h1>商品区域信息</h1>");
			rs = stmt
					.executeQuery("SELECT distinct s.region_id, p.name, c.name, r.regionnm "
							+ "FROM SUPPLYSITE s, REGION r, CITY c, PROVINCE p "
							+ "WHERE s.region_id = r.id"
							+ " AND r.city_id = c.id"
							+ " AND c.province_id = p.id"
							+ " ORDER BY p.name, c.name, r.regionnm");
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>兑换区域编号</th>");
			out.println("<th>兑换区域描述</th>");
			out.println("</tr>");
			out.println("</thead>");
			// show result
			out.println("<tbody>");
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString(1) + "</td>");
				out.println("<td>" + rs.getString(2) + "."
						+ rs.getString(3) + "." + rs.getString(4)
						+ "</td>");
				out.println("</tr>");
			}
			out.println("</tbody>");
			out.println("</table>");
			rs.close();
		}

		out.println("<br>");

		//
		// 商品信息
		//
		{
			out.println("<h1>商品信息</h1>");
			rs = stmt
					.executeQuery("SELECT m.mchcd, m.mchnm, m.mchdesc, m.gifttype_id," // 1-4
							+ " p.id, p.issmall, s.region_id "
							+ "FROM MERCHANDISE m, SUPPLYCONTRACTDETAIL cd, SUPPLYCONTRACT c, SUPPLIER s, "
							+ "     MCHPICTURE p "
							+ "WHERE m.id = cd.merchandise_id"
							+ " AND c.id = cd.contract_id"
							+ " AND s.id = c.supplier_id "
							+ " AND m.id = p.merchandise_id(+)"
							+ " AND m.mchCd in ('101058','101059','101060','101061','101062','101063','101064','101065','101066','101067','101068','101069','101070','101071','101072','101073','101074','101075','101076','101077','101078','101079','101080','101081','101082','101083','101084','101085','101086','101087','101088','101089','101090','101091','101092','101093','101094','101095','101096','101097','101098','101099','101100','101101','101102','101103','101104','101105','101106','101107','101108','101109','101110','101111','101112','101113','101114','101115','101116','101117','101118','101119','101120','101121','101122','101123','101124','101125','101126','101127','101128','101129','101130','101131','101132','101133','101134','101135','101136','101137','101138','101139','101140','101141','101142','101143','101144','101145','101146','101147','101148','101149','101150','101151','101152','101153','101154','101155','101156','101157','101158','101159','101160','101161','101162','101163','101164','101165','101166','101167','101168','101169','101170','101171','101172','101173','101174','101175','101176','101177','101178','101179','101180','101181','101182','101183','101184','101185','101186','101187','101188','101189','101190','101191','101192','101193','101194','101195','101196','101197','101198','101199','101200','101201','101202','101203','101204','101205','101206','101207','101208','101209','101210','101211','101212','101213','101214','101215','101216','101217','101218','101219','101220','101221','101222','101223','101224','101225','101226','101227','101228','101229','101230','101231','101232','101233','101234','101235','101236','101237','101238','101239')"
							+ " ORDER BY m.mchcd");
			out.println("<table>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>礼品编号，商品在缤分联盟的唯一标识，用于兑换商品时传递到缤分联盟</th>");
			out.println("<th>礼品名称</th>");
			out.println("<th>详细信息</th>");
			out.println("<th>商品所属的商品分组编号</th>");
			out.println("<th>图片url</th>");
			out.println("<th>是否是小图片</th>");
			out.println("<th>兑换区域编号</th>");
			out.println("</tr>");
			out.println("</thead>");
			// show result
			out.println("<tbody>");
			String last_mchNo = null;
			String last_mchName = null;
			String last_mchDesc = null;
			String last_catid = null;
			String last_rootPID = null;
			List<String> last_imageURLs = new LinkedList<String>();
			List<String> last_imageSmall = new LinkedList<String>();
			List<String> last_regionIds = new LinkedList<String>();
			while (rs.next()) {
				String mchNo = rs.getString(1);
				String mchName = rs.getString(2);
				String mchDesc = rs.getString(3);
				String catid = rs.getString(4);
				String imageSMALL = rs.getString(6);
				String regionID = rs.getString(7);
				String rootPID = null;
				if (rootMap.containsKey(catid)) {
					rootPID = rootMap.get(catid);
				} else {
					rootPID = catid;
				}
				String imageID = rs.getString(5);
				String imageURL = "NO IMAGE";
				if (imageID != null) {
					imageURL = "http://www.jifen.cc/gift/images/"
							+ imageID;
				}

				// check duplicate, meaning either multiple images or multiple regionids
				if (mchNo.equals(last_mchNo)) {
					if (imageID != null
							&& !last_imageURLs.contains(imageURL)) {
						last_imageURLs.add(imageURL);
						last_imageSmall.add(imageSMALL);
					}
					if (!last_regionIds.contains(regionID)) {
						last_regionIds.add(regionID);
					}
				} else {
					// output (ignore the first difference
					if (last_mchNo != null) {
						// URLs
						StringBuffer urls = new StringBuffer();
						{
							Iterator<String> i = last_imageURLs
									.iterator();
							while (i.hasNext()) {
								urls.append(i.next());
								if (i.hasNext()) {
									urls.append(",");
								}
							}
						}
						// SMALL
						StringBuffer smalls = new StringBuffer();
						{
							Iterator<String> i = last_imageSmall
									.iterator();
							while (i.hasNext()) {
								smalls.append(i.next());
								if (i.hasNext()) {
									smalls.append(",");
								}
							}
						}
						// REGIONS
						StringBuffer regions = new StringBuffer();
						{
							Iterator<String> i = last_regionIds
									.iterator();
							while (i.hasNext()) {
								regions.append(i.next());
								if (i.hasNext()) {
									regions.append(",");
								}
							}
						}
						out.println("<tr>");
						out.println("<td>" + last_mchNo + "</td>");
						out.println("<td>" + last_mchName + "</td>");
						out.println("<td>" + last_mchDesc + "</td>");
						out.println("<td>" + last_rootPID + "</td>");
						out.println("<td>" + urls + "</td>");
						out.println("<td>" + smalls + "</td>");
						out.println("<td>" + regions + "</td>");
						out.println("</tr>");
					}
					// clear after printout
					last_mchNo = mchNo;
					last_mchName = mchName;
					last_mchDesc = mchDesc;
					last_rootPID = rootPID;

					// first element
					last_imageURLs.clear();
					last_imageSmall.clear();
					last_regionIds.clear();
					last_imageURLs.add(imageURL);
					last_imageSmall.add(imageSMALL);
					last_regionIds.add(regionID);
				}
			}
			// output the last element
			if (last_mchNo != null) {
				// URLs
				StringBuffer urls = new StringBuffer();
				{
					Iterator<String> i = last_imageURLs.iterator();
					while (i.hasNext()) {
						urls.append(i.next());
						if (i.hasNext()) {
							urls.append(",");
						}
					}
				}
				// SMALL
				StringBuffer smalls = new StringBuffer();
				{
					Iterator<String> i = last_imageSmall.iterator();
					while (i.hasNext()) {
						smalls.append(i.next());
						if (i.hasNext()) {
							smalls.append(",");
						}
					}
				}
				// REGIONS
				StringBuffer regions = new StringBuffer();
				{
					Iterator<String> i = last_regionIds.iterator();
					while (i.hasNext()) {
						regions.append(i.next());
						if (i.hasNext()) {
							regions.append(",");
						}
					}
				}
				out.println("<tr>");
				out.println("<td>" + last_mchNo + "</td>");
				out.println("<td>" + last_mchName + "</td>");
				out.println("<td>" + last_mchDesc + "</td>");
				out.println("<td>" + last_rootPID + "</td>");
				out.println("<td>" + urls + "</td>");
				out.println("<td>" + smalls + "</td>");
				out.println("<td>" + regions + "</td>");
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