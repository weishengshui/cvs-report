package com.chinarewards.report.data.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Logger;

import com.chinarewards.report.data.crm.MemberShipInfo;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class MemberShipService {
	Logger log = Logger.getLogger("MemberShipService");

	public boolean updateMemberCardNo(String oldcardid, String oldCardLocation,
			String newCardno) throws Exception {
		boolean result = false;
		log.info("Enter MemberShipService updateMemberCardNo  oldcardid is "
				+ oldcardid + " and newCardno is " + newCardno);

		Connection crmconn = null;
		PreparedStatement pstmt = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			crmconn.setAutoCommit(false);

			String sql = null;
			if (MemberShipInfo.MEMBERSHIP.equals(oldCardLocation.trim())) {
				sql = "update membership set membercardno = ? where id = ?";
			} else if (MemberShipInfo.TEMPCARD.equals(oldCardLocation.trim())) {
				sql = "update tempcard set cardno = ? where id = ?";
			}

			pstmt = crmconn.prepareStatement(sql);
			pstmt.setString(1, newCardno);
			pstmt.setString(2, oldcardid);
			int i = pstmt.executeUpdate();

			if (i == 1) {
				result = true;
				crmconn.commit();
			} else {
				crmconn.rollback();
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception(e);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {

			SqlUtil.close(pstmt);
			SqlUtil.close(crmconn);
		}

		log.info("Exit MemberShipService updateMemberCardNo");

		return result;
	}
}
