<%@ page language="java" import="java.io.*,java.sql.*,javax.sql.*,java.text.*,javax.naming.*,java.util.*"%>
<%@ page contentType="text/html;charset=gb2312" %> 

<%
 	String date = request.getParameter("date");
 	String mid = request.getParameter("mid");

 	DecimalFormat moneyFormat = new DecimalFormat("#,##0.00");
 	DecimalFormat pointFormat = new DecimalFormat("#,##0.0000");
 %>
<%
	String sDBDriver = "oracle.jdbc.driver.OracleDriver";
	String sConnStr = "jdbc:oracle:thin:@10.1.10.105:1521:CR";

	Connection conn = null;
	ResultSet rs = null;
	Statement stmt = null;

	//商户消费总额
	try {

		Class.forName(sDBDriver);
		conn = DriverManager
				.getConnection(sConnStr, "posapp", "posapp");

		stmt = conn.createStatement();

		long test = 20190921010000L;

		for (int i = 0; i < 10; i++) {
			out.println("tt" + test);
			int updateResult = stmt
					.executeUpdate("Insert into CLUBPOINT (ID,CLUBID,POINT,MERCHANTID,PAYMERCHANTID,SHOPID,SHOPNAME,TRANSDATE,SERIAL,AMOUNTCURRENCY,MEMBERCARDID,NEXTUPDATEGRADEDATE,MEMEBERID,TEMPMEMBERTXID,POSID,MERCHANTNAME,PAYMERCHANTNAME,EFFECTIVECARDID,PRODUCTTYPENAME,UNITID,UNITCODE,CONTRACTNO,POSDEGREE,TXNID,SEQUENCEID) values ('"
							+ test
							+ "','00',5.3333,'ff80808122055c2b01220c12c40d65ef','ff80808122055c2b01220c12c40d65ef',null,null,'22-SEP-09','1000113383',50,'1020000761',null,'ff80808123b7981b0123b7c2b67c0740','M100203161',null,'深圳市南山区银利茶餐厅','深圳市南山区银利茶餐厅','1020000761','餐饮','Pt_A','A类积分','商-09023-深圳银利餐厅',1,'"
							+ test + "','" + test + "')");
			stmt.close();
			rs.close();
			test = test + i;

		}
	} catch (Exception e) {
		out.println(e);
	} finally {
		if (conn != null) {
			conn.close();
			System.out.println("connection close....");
		}
		if (stmt != null) {
			stmt.close();
		}
		if (rs != null) {
			rs.close();
		}

	}
%>

