<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.text.*, java.util.*" %>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.data.crm.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ include file="/include/global.inc.jsp" %>
<%@ include file="/checklogin.jsp" %>
<%

/**
 * This report is created for the activity of 酷党连锁 10元唱K活動.
 *
 *
 * @since 2010-03-18
 * @author cyril
 */


Connection conn = null;
Connection crmConn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
PreparedStatement pstmtMemberByCardNum = null;
PreparedStatement pstmtMemberByMobile = null;
PreparedStatement pstmtMemberById = null;
ResultSet rsMember = null;


//
//Configuration parameters
//
boolean isTesting = false;

String targetMerchantBizName = "酷党连锁机构";
String targetMerchantId = null;

List<String> targetShopIds = new ArrayList<String>();

String sTransdateFrom = "2010-03-16";	// should be 2010-03-16
String sTransdateTo = "2010-06-01";		// should be 2010-06-01, exclusive
// sHighlightTransaction: For transactions made on or after this day, 
// they will be highlighted with color
String sHighlightTransactionSince = "2010-04-07";
// For transaction >= this value, transaction records will be highlighted.
// This parameter is used in conjunction with sHighlightTransactionSince.
double highlightXactionAmount1 = 200.0;
double highlightXactionAmount2 = 300.0;


// ---------- ---------- //
if (request.getParameter("debug") != null) {
	isTesting = true;
}



// enable test mode
if (isTesting) {
	targetMerchantBizName = "雨花西餐厅";
	sTransdateFrom = "2009-06-01";
	sTransdateTo = "2099-12-31";
	sHighlightTransactionSince = "2009-10-01";
}



// formatting
DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat xactDateFormat = new SimpleDateFormat("yyyy-MM-dd");




// -------------------- Logic Starts -------------------- //


try {
	
	
	//
	// Create the temporary table if NOT exist
	//
	// open database connection
	conn = DbConnectionFactory.getInstance().getConnection("posapp");
	// FIXME checks temporary table existence
	boolean createTempTable;
	createTempTable = !DbUtil.isTableExists(conn, "TMP_RPT_CLUBPOINT");
	if (createTempTable) {
		System.out.println("Table 'tmp_rpt_clubpoint' not found, creating from clubpoint...");
		// create temp table, using the same data structure of clubpoint.
		// report name is tmp_rpt_clubpoint.
		String sql = "CREATE GLOBAL TEMPORARY TABLE tmp_rpt_clubpoint ON COMMIT PRESERVE ROWS AS SELECT * FROM clubpoint";
		pstmt = conn.prepareStatement(sql);
		pstmt.execute();
	}
	// close database connection
	SqlUtil.close(pstmt);
	SqlUtil.close(conn);

	
	
	
	
	
	// open database connection
	conn = DbConnectionFactory.getInstance().getConnection("crm");
	
	
	//
	// Load the list of CoolParty shops.
	//
	// Criteria:
	// - merchant.business () = '酷党连锁机构';
	// - (NOT EFFECTIVE) AND shop.name NOT LIKE '%酷党连锁南山店%'
	//
	// Trick: As of 2010-03-16, the shop IDs for related shops are
	// 1509 to 1515 inclusive.
	//
	String sql = "SELECT DISTINCT industrytype.id AS industrytype_id, industrytype.paravalue AS industrytype_name, merchant.id AS merchant_id, shop.id AS shop_id, shop.name AS shop_name FROM shop LEFT JOIN merchant ON shop.merchant_id = merchant.id LEFT JOIN industrytype ON merchant.industrytype_id=industrytype.id WHERE (shop.activeflag='effective' AND businessname = '"+targetMerchantBizName+"')  ORDER BY industrytype_id, industrytype_name, shop_id, shop_name";
	//System.out.println("sql=" + sql);
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	// build the SQL filter for matching shops for the POSAPP exchange 
	// table record. Variable: shopFilter
	// Sample output:
	// (shops found): '123a0bd8fggfdf','123a0bd8fggfdasdadf','94a123a0bd8fggfdf'
	// (no shop found)" 'notexists-agdfhgs'
	StringBuffer shopFilter = new StringBuffer();
	while (rs.next()) {
		if (shopFilter.length() > 0) shopFilter.append(",");  
		shopFilter.append("'" + rs.getString("shop_id") + "'");
		
		targetShopIds.add(rs.getString("shop_id"));
		
		// save the merchant ID if not.
		if (targetMerchantId == null) targetMerchantId = rs.getString("merchant_id");
		
	} // while (has more shops)
	if (shopFilter.length() == 0) {
		shopFilter.append("'notexists-agdfhgs'");
	}
	System.out.println("shopFilter=" + shopFilter);
	SqlUtil.close(rs);
	rs = null;
	
	System.out.println(targetShopIds);
	
	if (shopFilter == null || shopFilter.length() == 0) {
		out.println("找不到" + targetMerchantBizName + "分店");
		return;
	}
	
	
	// -----------
	
	
%>
<html>
<head>
<title>2010-03-16 10元唱翻天</title>
<style type="text/css">
.mgrp_sep {
	border-top-width: 2px;
	border-top-color: #000000;
}
/* transaction amount >= ? level 1 */
.xact_lv1 {
	background-color: #FFFC40;
}
/* transaction amount >= ? level 2 */
.xact_lv2 {
	background-color: #F57676;
}
/* shops which match the activity shops */
.target_shop {
	color: green;
}
</style>
</head>

<body>

<%=(isTesting ? "<b>TESTING!</b><br/><br/>":"")%>

<h1>10元唱翻天消费者记录</h1>
<br/>

<!-- Introduction Starts -->

<h2>目的</h2>
近期即将推出的天王星活动，活动时间为3月16日—4月15日。活动时间内在天王星消费的会员。
<br/>
2010-04-15: 由于活动反应良好，故时间延长到2010年6月1日前。
<br/>

<h2>规则</h2>
<ul>
<li>活动时间：<%=sTransdateFrom%> 至 <%=sTransdateTo%>零时零晨前。</li>
<li>活动对象：活动时间内在天王星消费的会员。</li>
<li>需要的是在活动时间内在天王星消费的会员在活动期间的消费记录。</li>
</ul>

<h2>报表需求日期</h2>
2010年3月12日
<br/>

<h2>需求方</h2>
Jessica @ 产品部

<!-- Changelog -->
<h2>改动</h2>
<table>
<tr>
<th>日期</th>
<th>描述</th>
</tr>
<tr>
<td>2010-03-18</td>
<td>首次发报。</td>
</tr>
<tr>
<td>2010-03-25</td>
<td>以会员作分组。</td>
</tr>
<tr>
<td>2010-04-06</td>
<td>对4月7日及以后的消费，多于200及300元的消费作不同颜色的显示。</td>
</tr>
<tr>
<td>2010-04-15</td>
<td>由于活动反应良好，故时间延长到2010年6月1日前。</td>
</tr>
</table>




<br/>

<hr/>
<br/>


<!-- Introduction ENDS -->


<!-- Content BEGINS -->

<%--

	Shows the list of shops for verification.

 --%>

<h2>吻合商戶公司營業名稱为「<%=targetMerchantBizName%>」条件的门市列表</h2>

<table>
<thead>
<tr>
<th>#</th>
<th>商户类型</th>
<th>门市</th>
</tr>
</thead>
<tbody>
<%
rs = pstmt.executeQuery();
int i = 1;
while (rs.next()) {
%>
<tr>
<td><%=i%></td>
<td><%=rs.getString("industrytype_name")%></td>
<td><%=rs.getString("shop_name")%><!--<%=rs.getString("shop_id")%>--></td>
</tr>
<%
	i++;
}

SqlUtil.close(pstmt);
pstmt = null;
SqlUtil.close(conn);
conn = null;

%>

</table>

<%--

	Shows the list of shops for verification ENDS.

 --%>



<%--

	Shows transaction records.

 --%>
<br/>

<h2>符合条件的消费记录</h2>

<b>解说</b>
<table>
<tr>
<td class="xact_lv1">&gt;=<%=highlightXactionAmount1%>元</td>
<td class="xact_lv2">&gt;=<%=highlightXactionAmount2%>元</td>
</tr>
</table>
吻合条件的门市会设置为<span class="target_shop">绿色</span>。


<br/><br/>

<table>
<thead>
<tr>
<th>#</th>
<th>有会员<br/>资料?</th>
<%--<th>消费时所用卡号/<br/>手机号分组</th> --%>
<th>会员名称</th>
<th>会员手机</th>
<th>会员姓别</th>
<th>#</th>
<th>消费时所用卡号/<br/>手机号</th>
<th>商户</th>
<th>门市</th>
<th>消费金额</th>
<th>积分</th>
<th>消费时间</th>
</tr>
</thead>
<tbody>
<%





conn = DbConnectionFactory.getInstance().getConnection("posapp");
crmConn = DbConnectionFactory.getInstance().getConnection("crm");



// this is a general filter which filtered out unwanted records in the  
// clubpoint table.
String spendingFilter = "clubid = '00' AND amountcurrency > 2 AND transdate >= to_date('"+sTransdateFrom+"','yyyy-mm-dd') AND transdate < to_date('"+sTransdateTo+"','yyyy-mm-dd')";



//prepare a statement for querying member record
pstmtMemberByCardNum = crmConn.prepareStatement("SELECT * FROM member INNER JOIN membership ON member.id=membership.member_id WHERE membership.membercardno=?");
pstmtMemberByMobile = crmConn.prepareStatement("SELECT * FROM member WHERE member.mobiletelephone=?");
pstmtMemberById = crmConn.prepareStatement("SELECT * FROM member WHERE member.id=?");



//must turn off APP database's auto-commit or data will be lost!
//conn.setAutoCommit(false);



// This SQL selects transaction records which matched the criteria.
// To revise:
// 1: transaction records made in the above shops
// 2: Using TX account ID (tempmembertxid), those transaction records in point
// 1) will be returned.
String sqlMatchActivityTarget = "SELECT * FROM clubpoint WHERE " + spendingFilter + " AND tempmembertxid IN (";
sqlMatchActivityTarget += "SELECT DISTINCT tempmembertxid FROM clubpoint WHERE " + spendingFilter + " AND ( shopid IN (" + shopFilter + ") OR merchantid='" + targetMerchantId + "' )";
sqlMatchActivityTarget += ")";
sqlMatchActivityTarget += " ORDER BY membercardid, transdate DESC";
System.out.println("sqlMatchActivityTarget: " + sqlMatchActivityTarget);


//
// Step: Insert transaction data within the activity's interval
//

// clear old data (should be unnecessary)
sql = "DELETE FROM tmp_rpt_clubpoint";
pstmt = conn.prepareStatement(sql);
pstmt.execute();
SqlUtil.close(pstmt);
// pour in the data within the activity interval
sql = "INSERT INTO tmp_rpt_clubpoint " + sqlMatchActivityTarget;
pstmt = conn.prepareStatement(sql);
pstmt.execute();
SqlUtil.close(pstmt);


// *** From now on, we process data in the temporary table *** //


//
// Step: Fix data in the tmp table.
// Goal: Fill in the member ID by whatever means.
// Assumption: 
// - Attribute 'membercardid' is NEVER null.
// - We use 'membercardid' to look up the member
//
// get the list of transaction records without member ID.
System.out.println("Fixing data in temporary report table");
sql = "SELECT * FROM tmp_rpt_clubpoint WHERE memeberid is null";
pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();
while (rs.next()) {

	String inputCardNum = rs.getString("membercardid");
	
	if (inputCardNum == null) {
		throw new RuntimeException("membercardid of ClubPoint Record (ID=" 
			+ rs.getString("id") + " is null!");
	}
	
	// look up member using various attempt
	
	// if it is phone number, lookup the Member entity's mobiletelephone.
	if (inputCardNum.length() == 11) {
		pstmtMemberByMobile.clearParameters();
		pstmtMemberByMobile.setString(1, inputCardNum);
		rsMember = pstmtMemberByMobile.executeQuery();
	} else {
		// assume it is a card number, search the member using the card num.
		pstmtMemberByCardNum.clearParameters();
		pstmtMemberByCardNum.setString(1, inputCardNum);
		rsMember = pstmtMemberByCardNum.executeQuery();
	}
	if (rsMember.next()) {
		// able to locate the member information, so fill it in.
		pstmt = conn.prepareStatement("UPDATE tmp_rpt_clubpoint SET memeberid=? WHERE id=?");
		pstmt.setString(1, rsMember.getString("id"));	// member ID
		pstmt.setString(2, rs.getString("id"));		// club point record ID
		pstmt.executeUpdate();
		SqlUtil.close(pstmt);
	}
	
	SqlUtil.close(rsMember);
}
SqlUtil.close(pstmt);

System.out.println("Data fixed");

//
// END OF Step: Fix data in the tmp table.
//







//
// Build the SQL for querying transaction records in POSAPP ClubPoint table
// which fulfil the criteria.
//

sql = "SELECT * FROM tmp_rpt_clubpoint ORDER BY memeberid ASC, membercardid ASC, transdate DESC";
System.out.println("SQL for selecting club point transaction records: [" + sql + "]");	// DEBUG
pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();



// iterate records
String lastCardNumber = null;
String lastMemberId = null;
long cardNumberGroupIdx = 0;
long idx = 0;

String memberName = null;
String memberMobile = null;
String memberGender = null;

java.util.Date xactDate = xactDateFormat.parse(sHighlightTransactionSince);

while (rs.next()) {
	
	String currentMemberId = rs.getString("memeberid");
	String currentCardNumber = rs.getString("membercardid");
	
	boolean hasMemberInfo = (currentMemberId != null);
	boolean showCardNumberGroup = true;
	
	if (currentMemberId != null && currentMemberId.equals(lastMemberId)) {
		// same 'identity'
		showCardNumberGroup = false;
		cardNumberGroupIdx += 1;
	} else if (currentMemberId == null && currentCardNumber.equals(lastCardNumber)) {
		showCardNumberGroup = false;
		cardNumberGroupIdx += 1;
	} else {
		// card number / telephone number changed
		cardNumberGroupIdx = 1;
		
		// load member information
		memberName = null;
		memberMobile = null;
		memberGender = null;
		
		if (currentMemberId != null) {
			pstmtMemberById.clearParameters();
			pstmtMemberById.setString(1, currentMemberId);
			
			rsMember = pstmtMemberById.executeQuery();
			if (rsMember.next()) {
				memberName = "" + rsMember.getString("chisurname") + rsMember.getString("chilastname");
				memberMobile = rsMember.getString("mobileTelephone");
				memberGender = GenderUtil.toString(rsMember.getInt("gender"));
			} else {
				hasMemberInfo = false;
			}
			SqlUtil.close(rsMember);
			
		} else {
			hasMemberInfo = false;
		}
		
		
	}
	
	
	// highlight CoolParty shops
	String shopCssStyle = "";
	if (rs.getString("shopid") != null && targetShopIds.contains(rs.getString("shopid"))) {
		shopCssStyle = " style=\"color: green\"";
	}
	
	idx++;
	
	
	String tdCssClass = showCardNumberGroup ? " class=\"mgrp_sep\"" : "";
	
	// determine the table row color
	String rowCssClass = "";
	if (!rs.getTimestamp("transdate").before(xactDate)) {
		double amt = rs.getDouble("amountcurrency");
		if (amt >= highlightXactionAmount2) {
			rowCssClass = "xact_lv2";
		} else if (amt >= highlightXactionAmount1) {
			rowCssClass = "xact_lv1";
		}
	}
	 
	
%>
<tr class="<%=rowCssClass%>">
<td<%=tdCssClass%>><%=idx%></td>
<td<%=tdCssClass%>><%=(currentMemberId!=null?"是":"否")%><!-- memberId:<%=JspDisplayUtil.noNull(rs.getString("memeberid"))%> --></td>
<%--<td><%=(showCardNumberGroup ? currentCardNumber : "")%></td> --%>
<td<%=tdCssClass%>><%=(showCardNumberGroup ? JspDisplayUtil.noNull(memberName) : "")%></td>
<td<%=tdCssClass%>><%=(showCardNumberGroup ? JspDisplayUtil.noNull(memberMobile) : "")%></td>
<td<%=tdCssClass%>><%=(showCardNumberGroup ? JspDisplayUtil.noNull(memberGender) : "")%></td>
<td<%=tdCssClass%>><%=cardNumberGroupIdx%></td>
<td<%=tdCssClass%>><%=rs.getString("membercardid")%></td>
<td<%=tdCssClass%> <%=shopCssStyle%>><%=JspDisplayUtil.noNull(rs.getString("merchantname"))%></td>
<td<%=tdCssClass%> <%=shopCssStyle%>><%=JspDisplayUtil.noNull(rs.getString("shopname"))%><!--<%=rs.getString("shopid")%>--></td>
<td<%=tdCssClass%> style="text-align: right"><%=moneyFormat.format(rs.getDouble("amountcurrency"))%></td>
<td<%=tdCssClass%> style="text-align: right"><%=pointFormat.format(rs.getDouble("point"))%></td>
<td<%=tdCssClass%>><%=simpleDateFormat.format(rs.getTimestamp("transdate"))%></td>
</tr>
<%
	lastMemberId = currentMemberId;
	lastCardNumber = currentCardNumber; 
}
System.out.println("All transaction records iterated");
%>
</tbody>
</table>


<!-- Content ENDS -->


</body>
</html>
<%

SqlUtil.close(rs);
SqlUtil.close(pstmt);

} catch (Throwable t) {
	out.println(t);
	t.printStackTrace();
	throw t;
} finally {
	
	if (conn != null) {
		try {
			//conn.setAutoCommit(true);
		} catch (Throwable t) {
		}
	}
	
	// general
	SqlUtil.close(rs);
	SqlUtil.close(rsMember);
	// CRM related.
	SqlUtil.close(pstmt);
	SqlUtil.close(pstmtMemberById);
	SqlUtil.close(pstmtMemberByCardNum);
	SqlUtil.close(pstmtMemberByMobile);
	// connections
	SqlUtil.close(conn);
	SqlUtil.close(crmConn);

}
%>