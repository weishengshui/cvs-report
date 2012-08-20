<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.* ,javax.naming.*, java.text.*, java.util.*" %>
<%@ page language="java" import="com.chinarewards.report.jsp.util.*" %>
<%@ page language="java" import="com.chinarewards.report.data.crm.*" %>
<%@ page language="java" import="com.chinarewards.report.db.*" %>
<%@ page language="java" import="com.chinarewards.report.sql.*" %>
<%@ include file="/include/global.inc.jsp" %>
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
ResultSet rsMember = null;


//
//Configuration parameters
//
boolean isTesting = false;

String targetMerchantBizName = "酷党连锁机构";
String targetMerchantId = null;

List<String> targetShopIds = new ArrayList<String>();

String sTransdateFrom = "2010-03-16";	// should be 2010-03-16
String sTransdateTo = "2010-04-16";		// should be 2010-04-16, exclusive

// enable test mode
if (isTesting) {
	targetMerchantBizName = "雨花西餐厅";
	sTransdateFrom = "2009-06-01";
	sTransdateTo = "2099-12-31";
}



// formatting
DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");





try {
	
	
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
	System.out.println("sql=" + sql);
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
</head>

<body>

<%=(isTesting ? "<b>TESTING!</b><br/><br/>":"")%>

<h1>10元唱翻天消费者记录</h1>
<br/>

<!-- Introduction Starts -->

<h2>目的</h2>
近期即将推出的天王星活动，活动时间为3月16日—4月15日。活动时间内在天王星消费的会员。
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

<h2>改动</h2>
<table>
<tr>
<th>日期</th>
<th>描述</th>
</tr>
<tr>
<td>2010-03-18</td>
<td>首次发报</td>
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

<table>
<thead>
<tr>
<th>#</th>
<th>消费时所用卡号/<br/>手機號分組</th>
<th>#</th>
<th>會員名稱</th>
<th>會員手機</th>
<th>會員姓別</th>
<th>消费时所用卡号/<br/>手機號</th>
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

//
// Build the SQL for querying transaction records in POSAPP ClubPoint table
// which fulfil the criteria
//

String spendingFilter = "clubid = '00' AND amountcurrency > 2 AND transdate >= to_date('"+sTransdateFrom+"','yyyy-mm-dd') AND transdate < to_date('"+sTransdateTo+"','yyyy-mm-dd')";

sql = "SELECT * FROM clubpoint WHERE " + spendingFilter + " AND tempmembertxid IN (";
// sql += "SELECT distinct tempmembertxid FROM clubpoint WHERE " + spendingFilter + " AND NOT ( shopid IN (" + shopFilter + ") OR merchantid='" + targetMerchantId + "' )";
// sql += " INTERSECT ";
sql += "SELECT DISTINCT tempmembertxid FROM clubpoint WHERE " + spendingFilter + " AND ( shopid IN (" + shopFilter + ") OR merchantid='" + targetMerchantId + "' )";
sql += ")";
sql += " ORDER BY membercardid, transdate DESC";
System.out.println("SQL for selecting shops: [" + sql + "]");	// DEBUG
pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();

// prepare a statement for querying member record
pstmtMemberByCardNum = crmConn.prepareStatement("SELECT * FROM member INNER JOIN membership ON member.id=membership.member_id WHERE membership.membercardno=?");
pstmtMemberByMobile = crmConn.prepareStatement("SELECT * FROM member WHERE member.mobiletelephone=?");


// iterate records
String lastCardNumber = null;
long cardNumberGroupIdx = 0;
long idx = 0;

String memberName = null;
String memberMobile = null;
String memberGender = null;

while (rs.next()) {
	
	String currentCardNumber = rs.getString("membercardid");
	boolean showCardNumberGroup = true;
	
	
	if (currentCardNumber.equals(lastCardNumber)) {
		// same 'identity'
		showCardNumberGroup = false;
		cardNumberGroupIdx += 1;
	} else {
		// card number / telephone number changed
		cardNumberGroupIdx = 1;
		
		// try the best to query the member info
		if (currentCardNumber.length()==11) {	// is a mobile number
			// System.out.println("currentCardNumber = [" + currentCardNumber + "], is a mobile number");
			pstmtMemberByMobile.clearParameters();
			pstmtMemberByMobile.setString(1, currentCardNumber);
			rsMember = pstmtMemberByMobile.executeQuery();
		} else {	// treat as card number
			// System.out.println("currentCardNumber = [" + currentCardNumber + "], is a card number");
			pstmtMemberByCardNum = crmConn.prepareStatement("SELECT * FROM member INNER JOIN membership ON member.id=membership.member_id WHERE membership.membercardno = ?");
			pstmtMemberByCardNum.setString(1, currentCardNumber);
			rsMember = pstmtMemberByCardNum.executeQuery();
		}
		
		if (rsMember.next()) {
			memberName = "" + rsMember.getString("chisurname") + rsMember.getString("chilastname");
			memberMobile = rsMember.getString("mobileTelephone");
			memberGender = GenderUtil.toString(rsMember.getInt("gender"));
		} else {
			memberName = null;
			memberMobile = null;
			memberGender = null;
		}
		SqlUtil.close(rsMember);
		
	}
	
	
	// highlight CoolParty shops
	String shopCssStyle = "";
	if (rs.getString("shopid") != null && targetShopIds.contains(rs.getString("shopid"))) {
		shopCssStyle = " style=\"color: green\"";
	}
	
	idx++;
	
%>
<tr>
<td><%=idx%></td>
<td><%=(showCardNumberGroup ? currentCardNumber : "")%></td>
<td><%=cardNumberGroupIdx%></td>
<td><%=(showCardNumberGroup ? memberName : "")%></td>
<td><%=(showCardNumberGroup ? memberMobile : "")%></td>
<td><%=(showCardNumberGroup ? memberGender : "")%></td>
<td><%=rs.getString("membercardid")%></td>
<td<%=shopCssStyle%>><%=JspDisplayUtil.noNull(rs.getString("merchantname"))%></td>
<td<%=shopCssStyle%>><%=JspDisplayUtil.noNull(rs.getString("shopname"))%><!--<%=rs.getString("shopid")%>--></td>
<td style="text-align: right"><%=moneyFormat.format(rs.getDouble("amountcurrency"))%></td>
<td style="text-align: right"><%=pointFormat.format(rs.getDouble("point"))%></td>
<td><%=simpleDateFormat.format(rs.getTimestamp("transdate"))%></td>
</tr>
<%
	lastCardNumber = currentCardNumber;
}
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
} finally {
	// general
	SqlUtil.close(rs);
	SqlUtil.close(pstmt);
	SqlUtil.close(conn);
	// CRM related.s
	SqlUtil.close(pstmtMemberByCardNum);
	SqlUtil.close(pstmtMemberByMobile);
	SqlUtil.close(crmConn);

}
%>