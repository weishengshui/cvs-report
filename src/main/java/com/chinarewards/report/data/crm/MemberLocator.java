/**
 * 
 */
package com.chinarewards.report.data.crm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * 
 * 
 * @author cyril
 * @since 0.1.0 2010-04-06
 */
public class MemberLocator {

	/**
	 * Search criteria
	 * 
	 * @author cyril
	 * @since 1.2.2 2010-04-06
	 */
	public static class Criteria {

		private String memberId;

		private String txAccountId;

		private String organizationId;

		private String cardNumber;

		/**
		 * @return the memberId
		 */
		public String getMemberId() {
			return memberId;
		}

		/**
		 * @param memberId
		 *            the memberId to set
		 */
		public void setMemberId(String memberId) {
			this.memberId = memberId;
		}

		/**
		 * @return the txAccountId
		 */
		public String getTxAccountId() {
			return txAccountId;
		}

		/**
		 * @param txAccountId
		 *            the txAccountId to set
		 */
		public void setTxAccountId(String txAccountId) {
			this.txAccountId = txAccountId;
		}

		/**
		 * @return the organizationId
		 */
		public String getOrganizationId() {
			return organizationId;
		}

		/**
		 * @param organizationId
		 *            the organizationId to set
		 */
		public void setOrganizationId(String organizationId) {
			this.organizationId = organizationId;
		}

		/**
		 * @return the cardNumber
		 */
		public String getCardNumber() {
			return cardNumber;
		}

		/**
		 * @param cardNumber
		 *            the cardNumber to set
		 */
		public void setCardNumber(String cardNumber) {
			this.cardNumber = cardNumber;
		}

	}

	/**
	 * Query by member ID.
	 */
	private PreparedStatement pstmtFindMemberById;

	/**
	 * Query member by mobile telephon.
	 */
	private PreparedStatement pstmtFindMemberByMobile;

	/**
	 * Query member by organization and card number in membership.
	 */
	private PreparedStatement pstmtFindMemberByOrgIdCardNumber;

	/**
	 * Query member by matching TX account ID in member table and membership
	 * table.
	 */
	private PreparedStatement pstmtFindMemberByTxAccountId;

	/**
	 * Query member with associated membership which matches the memberCardNo.
	 */
	private PreparedStatement pstmtFindMemberByMembershipCardNum;

	/**
	 * Search member using the given criteria.
	 * 
	 * @param conn
	 * @param criteria
	 * @return
	 */
	public ResultSet searchMember(Connection conn, Criteria criteria)
			throws SQLException {

		PreparedStatement stmt = null;

		if (criteria.getMemberId() != null) {
			// by member ID
			stmt = getPstmtFindMemberById(conn);
			stmt.clearParameters();
			stmt.setString(1, criteria.getMemberId());
		} else if (criteria.getOrganizationId() != null
				&& criteria.getCardNumber() != null) {
			// organization ID and card number present, means membership exists
			stmt = getPstmtFindMemberByOrgIdCardNumber(conn);
			stmt.clearParameters();
			stmt.setString(1, criteria.getOrganizationId());
			stmt.setString(2, criteria.getCardNumber());
		} else if (criteria.getTxAccountId() != null) {
			// tx account ID can be present in table MEMBER, MEMBERSHIP
			stmt = getPstmtFindMemberByTxAccountId(conn);
			stmt.clearParameters();
			stmt.setString(1, criteria.getTxAccountId());
			stmt.setString(2, criteria.getTxAccountId());
		} else if (criteria.getCardNumber() != null) {
			// only has a card number. A card number may represent a
			// mobile phone number or a membership card number
			String num = criteria.getCardNumber();
			if (num.length() == 11) {
				// in the old day (before approx. 2010-03-1x), a 11-digit
				// number represents a mobile number
				stmt = getPstmtFindMemberByMobile(conn);
				stmt.clearParameters();
				stmt.setString(1, num);
			} else {
				// treat as number card number in the membership table.
				stmt = getPstmtFindMemberByMembershipCardNum(conn);
				stmt.clearParameters();
				stmt.setString(1, num);
			}

		} else {
			// unsupported
			return null;
		}

		return stmt.executeQuery();
	}

	/**
	 * Initialize the prepared statement which use member ID to locate member.
	 * 
	 * @param conn
	 * @return the statement
	 * @throws SQLException
	 */
	private PreparedStatement getPstmtFindMemberById(Connection conn)
			throws SQLException {
		if (pstmtFindMemberById == null) {
			pstmtFindMemberById = conn
					.prepareStatement("SELECT * FROM member WHERE ID=?");
		}
		return pstmtFindMemberById;
	}

	/**
	 * Initialize the prepared statement which use organization ID and card
	 * number.
	 * 
	 * @param conn
	 * @return the statement
	 * @throws SQLException
	 */
	private PreparedStatement getPstmtFindMemberByOrgIdCardNumber(
			Connection conn) throws SQLException {
		if (pstmtFindMemberByOrgIdCardNumber == null) {
			pstmtFindMemberByOrgIdCardNumber = conn
					.prepareStatement("SELECT m.* FROM member m "
							+ "INNER JOIN membership ms ON m.id=ms.member_id "
							+ "INNER JOIN card c ON ms.card_id=c.id "
							+ "INNER JOIN organization o ON o.id=c.organization_id "
							+ "WHERE o.id=? AND ms.membercardno=?");
		}
		return pstmtFindMemberByOrgIdCardNumber;
	}

	private PreparedStatement getPstmtFindMemberByTxAccountId(Connection conn)
			throws SQLException {
		if (pstmtFindMemberByTxAccountId == null) {
			pstmtFindMemberByTxAccountId = conn
					.prepareStatement("SELECT * FROM member WHERE accountid = ? "
							+ " UNION "
							+ "SELECT member.* FROM member INNER JOIN membership ON member.id=membership.member_id AND membership.accountid IS NOT NULL AND membership.accountid=?");
		}
		return pstmtFindMemberByTxAccountId;
	}

	private PreparedStatement getPstmtFindMemberByMobile(Connection conn)
			throws SQLException {
		if (pstmtFindMemberByMobile == null) {
			pstmtFindMemberByMobile = conn
					.prepareStatement("SELECT * FROM member WHERE mobiletelephone = ?");
		}
		return pstmtFindMemberByMobile;
	}

	private PreparedStatement getPstmtFindMemberByMembershipCardNum(
			Connection conn) throws SQLException {
		if (pstmtFindMemberByMembershipCardNum == null) {
			pstmtFindMemberByMembershipCardNum = conn.prepareStatement("SELECT member.* FROM member " +
					"INNER JOIN membership ON member.id=membership.member_id " +
					"WHERE membership.membercardno = ?");
		}
		return pstmtFindMemberByMembershipCardNum;
	}

	/**
	 * Clean up this object and release any resources owned by this class.
	 */
	public void destroy() {
		if (pstmtFindMemberById != null) {
			close(pstmtFindMemberById);
		}
		if (pstmtFindMemberByOrgIdCardNumber != null) {
			close(pstmtFindMemberByOrgIdCardNumber);
		}
		if (pstmtFindMemberByTxAccountId != null) {
			close(pstmtFindMemberByTxAccountId);
		}
		if (pstmtFindMemberByMobile != null) {
			close(pstmtFindMemberByMobile);
		}
		if (pstmtFindMemberByMembershipCardNum != null) {
			close(pstmtFindMemberByMembershipCardNum);
		}
	}

	/**
	 * Close the statement and mute all Throwable.
	 * 
	 * @param stmt
	 */
	private void close(Statement stmt) {
		if (stmt == null)
			return;
		try {
			stmt.close();
		} catch (Throwable t) {
		}
	}

}
