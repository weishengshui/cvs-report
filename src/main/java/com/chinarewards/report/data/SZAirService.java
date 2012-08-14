package com.chinarewards.report.data;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.ServletException;

import com.chinarewards.report.data.szair.SZAirClubpoint;
import com.chinarewards.report.data.szair.SZAirMembersOfSaledNoRegister;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class SZAirService {

	Logger log = Logger.getLogger("SZAirService");

	/**
	 * Query object.
	 * 
	 * @author Cyril
	 */
	private class QueryCriteria {

		public Date transactionDateFrom;

		public Date transactionDateTo;

	}

	public List<SZAirMembersOfSaledNoRegister> getSZAirMembersOfSaledNoRegister(
			Date from, Date to) throws ServletException, IOException {

		log.info("Enter getSZAirMembersOfSaledNoRegister");

		List<SZAirMembersOfSaledNoRegister> list = null;

		Connection conn = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DbConnectionFactory.getInstance().getConnection("posapp");

			QueryCriteria criteria = new QueryCriteria();
			criteria.transactionDateFrom = from;
			criteria.transactionDateTo = to;

			List<SZAirClubpoint> szCPlist = getSZAirSalesRecord(conn, criteria);
			SqlUtil.close(conn);

			conn = DbConnectionFactory.getInstance().getConnection("crm");

			list = querySZAirMembersOfSaledNoRegister(conn, szCPlist);
			SqlUtil.close(conn);

		} catch (ClassNotFoundException e) {
			throw new ServletException(e);
		} catch (SQLException e) {
			throw new ServletException(e);
		} finally {
			SqlUtil.close(conn);

		}

		log.info("Enter getSZAirMembersOfSaledNoRegister list size is "
				+ list.size());

		return list;
	}

	private List<SZAirMembersOfSaledNoRegister> querySZAirMembersOfSaledNoRegister(
			Connection conn, List<SZAirClubpoint> cplist) throws SQLException {

		log.info("Enter querySZAirMembersOfSaledNoRegister");
		List<SZAirMembersOfSaledNoRegister> list = new ArrayList<SZAirMembersOfSaledNoRegister>();

		ResultSet rs = null;
		Statement stmt = conn.createStatement();

		for (int i = 0; i < cplist.size(); i++) {
			SZAirClubpoint cp = cplist.get(i);
			String partnerMembercardno = cp.getPartnerMembercardno();

			String sql = "SELECT m.mobiletelephone, m.chisurname, m.chilastname, s.membercardno, m.registdate FROM member m, membership s where m.id = s.member_id and s.membercardno = '"
					+ partnerMembercardno + "'";

			log.info("querySZAirMembersOfSaledNoRegister sql is " + sql);
			rs = stmt.executeQuery(sql);

			boolean isMember = false;
			if (rs != null && rs.next()) {
				String mobile = rs.getString(1);
				if (mobile != null && !"".equals(mobile)) {
					isMember = true;
				}
			}

			if (!isMember) {
				SZAirMembersOfSaledNoRegister no = new SZAirMembersOfSaledNoRegister();
				no.setLastSalesDate(cp.getTransDate());
				no.setMemberCardNo(cp.getPartnerMembercardno());
				no.setShopName(cp.getShopName());
				list.add(no);
			}
		}

		if (stmt != null) {
			stmt.close();
			stmt = null;
		}

		if (rs != null) {
			rs.close();
			rs = null;
		}

		log.info("Enter querySZAirMembersOfSaledNoRegister list size is "
				+ list.size());

		return list;
	}

	private List<SZAirClubpoint> getSZAirSalesRecord(Connection conn,
			QueryCriteria criteria) throws SQLException {

		log.info("Enter getSZAirSalesRecord");
		List<SZAirClubpoint> list = new ArrayList<SZAirClubpoint>();
		Map<String, String> cardNOmap = new HashMap<String, String>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String sql = "select pd.partnermembercardno, cp.transdate, cp.shopname,pd.status from pointtransactiondetail pd, clubpoint cp where partnerid !='00' and pd.clubpoint_id = cp.id and cp.amountcurrency >1";

		if (criteria.transactionDateFrom != null) {
			sql += " AND transdate >= ?";
		}
		if (criteria.transactionDateTo != null) {
			sql += " AND transdate < ?";
		}

		sql += " ORDER by cp.transdate desc";

		log.info("query clubpoint sql is " + sql);

		// prepare statement and set parameters
		pstmt = conn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
				ResultSet.CONCUR_READ_ONLY);
		int paramIdx = 1;
		if (criteria.transactionDateFrom != null) {
			pstmt.setDate(paramIdx++, new java.sql.Date(
					criteria.transactionDateFrom.getTime()));
		}
		if (criteria.transactionDateTo != null) {
			pstmt.setDate(paramIdx++, new java.sql.Date(
					criteria.transactionDateTo.getTime()));
		}

		// execute query
		rs = pstmt.executeQuery();

		while (rs.next()) {
			String partnermembercardno = rs.getString(1);
			// only get max transDate's record
			if (!cardNOmap.containsKey(partnermembercardno)) {

				cardNOmap.put(partnermembercardno, partnermembercardno);
				SZAirClubpoint szcp = new SZAirClubpoint();

				szcp.setPartnerMembercardno(partnermembercardno);
				szcp.setTransDate(rs.getDate(2));
				szcp.setShopName(rs.getString(3));
				szcp.setStatus(rs.getString(4));
				list.add(szcp);
			}
		}

		if (pstmt != null) {
			pstmt.close();
			pstmt = null;
		}

		if (rs != null) {
			rs.close();
			rs = null;
		}
		cardNOmap = null;

		log.info("Exit getSZAirSalesRecord list size is " + list.size());

		return list;
	}

}
