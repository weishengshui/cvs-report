/**
 * 
 */
package com.chinarewards.report.data.posapp;

import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;

import com.chinarewards.report.util.StringUtil;
import com.chinarewards.report.util.UrlUtil;

/**
 * 
 * 
 * @author cyril
 * @since 1.2.2 2010-04-07
 */
public class ClubPointUtil {

	/**
	 * Build a query string from the result set which contains data from the 
	 * POSAPP database with table CLUBPOINT.
	 * 
	 * @param rs
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 */
	public static final String buildMemberXactionPageQueryString(ResultSet rs)
			throws UnsupportedEncodingException, SQLException {

		// construct the URL for memberTrans.jsp
		String mtransUrl = "";
		Hashtable<String, String> qp = new Hashtable<String, String>();
		if (!StringUtil.isEmpty(rs.getString("tempmembertxid"))) {
			qp.put("acctId", rs.getString("tempmembertxid"));
		}
		if (!StringUtil.isEmpty(rs.getString("memeberid"))) {
			qp.put("memberId", rs.getString("memeberid"));
		}
		if (!StringUtil.isEmpty(rs.getString("transcardorgid"))) {
			qp.put("orgId", rs.getString("transcardorgid"));
		}
		if (!StringUtil.isEmpty(rs.getString("membercardid"))) {
			qp.put("cardno", rs.getString("membercardid"));
		}
		mtransUrl = UrlUtil.buildQueryString(qp);

		return mtransUrl;
	}

}
