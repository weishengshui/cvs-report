package com.chinarewards.report.data.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.chinarewards.report.data.auth.AuthUserInfo;
import com.chinarewards.report.data.crm.MemberInfo;
import com.chinarewards.report.data.crm.MemberShipInfo;
import com.chinarewards.report.data.tx.AccountInfo;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class MemberService {

	Logger log = Logger.getLogger("MemberService");

	public MemberInfo getMemberInfoFromCRMByTxAccountId(Connection crmconn,
			String txAccount) throws Exception {

		log
				.info("Enter MemberService getMemberInfoFromCRMByTxAccountId txaccount is "
						+ txAccount);
		MemberInfo memInfo = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {
			String sql = "select mem.id,mem.chisurname,mem.chilastname, mem.registdate,mem.workaddress,mem.mobiletelephone,mem.email,mem.accountid from member mem where mem.accountid = ? and mem.activeflag = 'effective'";

			pstmt = crmconn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_READ_ONLY);

			pstmt.setString(1, txAccount);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				memInfo = new MemberInfo();
				memInfo.setId(rs.getString(1));
				String firstname = rs.getString(2);
				String lastname = rs.getString(3);
				if (firstname == null)
					firstname = "";
				if (lastname == null)
					lastname = "";
				memInfo.setName(firstname.concat(lastname));
				memInfo.setRegistdate(rs.getDate(4));
				memInfo.setWorkaddress(rs.getString(5));
				memInfo.setMobile(rs.getString(6));
				memInfo.setEmail(rs.getString(7));
				String accountId = rs.getString(8);
				if (null != accountId) {
					memInfo.setAccountIds(accountId);
					memInfo.setAccountId(accountId);
				}
			} else {
				SqlUtil.close(rs);
				SqlUtil.close(pstmt);

				sql = "select mem.id,mem.chisurname,mem.chilastname, mem.registdate,mem.workaddress,mem.mobiletelephone,mem.email,mem.accountid from member mem inner join membership ms on mem.id = ms.member_id and ms.accountid = ? and mem.activeflag = 'effective'";
				pstmt = crmconn
						.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
								ResultSet.CONCUR_READ_ONLY);

				pstmt.setString(1, txAccount);

				rs = pstmt.executeQuery();

				if (rs.next()) {
					memInfo = new MemberInfo();
					memInfo.setId(rs.getString(1));
					String firstname = rs.getString(2);
					String lastname = rs.getString(3);
					memInfo.setName(firstname.concat(lastname));
					memInfo.setRegistdate(rs.getDate(4));
					memInfo.setWorkaddress(rs.getString(5));
					memInfo.setMobile(rs.getString(6));
					memInfo.setEmail(rs.getString(7));
					String accountId = rs.getString(8);
					if (null != accountId) {
						memInfo.setAccountIds(accountId);
						memInfo.setAccountId(accountId);
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(pstmt);
		}

		log
				.info("Exit MemberService getMemberInfoFromCRMByTxAccountId member is "
						+ memInfo);

		return memInfo;
	}

	public MemberInfo getMemberInfoFromCRM(Connection crmconn, String queryno,
			String queryType) throws Exception {

		log.info("Enter MemberService getMemberInfoFromCRM queryno is "
				+ queryno + " and queryType is " + queryType);

		MemberInfo memInfo = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String sql = "";

		try {

			if (queryType.equals("mobile")) {

				sql = "select mem.id,mem.chisurname,mem.chilastname, mem.registdate,mem.workaddress,mem.mobiletelephone,mem.email,mem.accountid from member mem where mem.mobiletelephone = ? and mem.activeflag = 'effective'";

			} else if (queryType.equals("cardno")) {

				sql = "select mem.id,mem.chisurname,mem.chilastname, mem.registdate,mem.workaddress,mem.mobiletelephone,mem.email,mem.accountid from member mem inner join membership ms on mem.id = ms.member_id and ms.membercardno = ? and mem.activeflag = 'effective'";

			}

			log.info("sql is :" + sql);

			pstmt = crmconn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_READ_ONLY);

			pstmt.setString(1, queryno.trim());

			rs = pstmt.executeQuery();

			if (rs.next()) {
				memInfo = new MemberInfo();
				memInfo.setId(rs.getString(1));
				String firstname = rs.getString(2);
				String lastname = rs.getString(3);
				memInfo.setName(firstname.concat(lastname));
				memInfo.setRegistdate(rs.getDate(4));
				memInfo.setWorkaddress(rs.getString(5));
				memInfo.setMobile(rs.getString(6));
				memInfo.setEmail(rs.getString(7));
				String accountId = rs.getString(8);
				if (null != accountId) {
					memInfo.setAccountIds(accountId);
					memInfo.setAccountId(accountId);
				}

			} else {
				if (queryType.equals("cardno")) {
					sql = "select mem.id,mem.chisurname,mem.chilastname, mem.registdate,mem.workaddress,mem.mobiletelephone,mem.email,mem.accountid from member mem where mem.id = (select memberid from tempcard tc where tc.cardno = ? and tc.memberid is not null)";

					pstmt = crmconn.prepareStatement(sql,
							ResultSet.TYPE_FORWARD_ONLY,
							ResultSet.CONCUR_READ_ONLY);

					pstmt.setString(1, queryno.trim());

					rs = pstmt.executeQuery();

					if (rs.next()) {
						memInfo = new MemberInfo();
						memInfo.setId(rs.getString(1));
						String firstname = rs.getString(2);
						String lastname = rs.getString(3);
						memInfo.setName(firstname.concat(lastname));
						memInfo.setRegistdate(rs.getDate(4));
						memInfo.setWorkaddress(rs.getString(5));
						memInfo.setMobile(rs.getString(6));
						memInfo.setEmail(rs.getString(7));
						String accountId = rs.getString(8);
						if (null != accountId) {
							memInfo.setAccountIds(accountId);
							memInfo.setAccountId(accountId);
						}
					}
				}

			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {

			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}

		}

		log.info("Exit MemberService getMemberInfoFromCRM ");

		return memInfo;

	}

	public List<MemberShipInfo> getMemberShipInfoListFromCRM(
			Connection crmconn, String memberid) throws Exception {

		log
				.info("Enter MemberService getMemberShipInfoListFromCRM memberid is "
						+ memberid);

		List<MemberShipInfo> list = new ArrayList<MemberShipInfo>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String sql = "";

		try {

			sql = "select ms.membercardno,ms.startdate,ms.accountid, car.cardname,car.id,ms.id from membership ms INNER JOIN card car on ms.card_id = car.id and ms.activeflag in('effective') and ms.member_id = ?";

			log.info("sql is :" + sql);

			pstmt = crmconn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_READ_ONLY);

			pstmt.setString(1, memberid.trim());

			rs = pstmt.executeQuery();

			while (rs.next()) {

				MemberShipInfo info = new MemberShipInfo();
				info.setCardLocation(MemberShipInfo.MEMBERSHIP);
				info.setMemberId(memberid);
				info.setMemberCardNo(rs.getString(1));
				info.setStartDate(rs.getDate(2));
				info.setAccountId(rs.getString(3));
				info.setCardName(rs.getString(4));
				info.setCardId(rs.getString(5));
				info.setId(rs.getString(6));
				list.add(info);

			}

			rs.close();
			pstmt.close();

			sql = "select temp.cardno, temp.accountid, temp.status,temp.startdate,temp.id, org.name from tempcard temp INNER join organization org on temp.orgid = org.id and temp.memberid = ?";

			pstmt = crmconn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_READ_ONLY);

			pstmt.setString(1, memberid.trim());

			rs = pstmt.executeQuery();

			while (rs.next()) {

				String cardno = rs.getString(1);

				if (!isContainer(list, cardno)) {
					MemberShipInfo info = new MemberShipInfo();
					info.setCardLocation(MemberShipInfo.TEMPCARD);
					info.setMemberId(memberid);
					info.setMemberCardNo(cardno);
					info.setAccountId(rs.getString(2));
					info.setStartDate(rs.getDate(4));
					info.setId(rs.getString(5));
					info.setCardName(rs.getString(6));
					list.add(info);
				}

			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {

			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}

		}

		log.info("Exit MemberService getMemberShipInfoListFromCRM ");

		return list;

	}

	private boolean isContainer(List<MemberShipInfo> list, String cardno) {
		boolean result = false;

		for (MemberShipInfo msinfo : list) {
			if (msinfo.getMemberCardNo().trim().equals(cardno.trim()))
				result = true;
		}
		return result;
	}

	public AuthUserInfo getAuthUserInfoFromAuth(Connection authconn,
			String memberid) throws Exception {

		log.info("Enter MemberService getAuthUserInfoFromAuth memberid is "
				+ memberid);

		AuthUserInfo info = null;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String sql = "";

		try {

			sql = "select id, username, password, validatenumber, lastlogin, createdate, loginonce, reveriedegree, faildegree, flag from auth_user au where au.username like ?";

			log.info("sql is :" + sql);

			pstmt = authconn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_READ_ONLY);

			pstmt.setString(1, "%" + memberid.trim() + "%");

			rs = pstmt.executeQuery();

			while (rs.next()) {

				info = new AuthUserInfo();
				info.setId(rs.getString(1));
				info.setUsername(rs.getString(2));
				info.setPassword(rs.getString(3));
				info.setValidateNumber(rs.getString(4));
				info.setLastLogin(rs.getDate(5));
				info.setCreateDate(rs.getDate(6));
				info.setLoginOnce(rs.getBoolean(7));
				info.setReverieDegree(rs.getInt(8));
				info.setFailDegree(rs.getInt(9));
				info.setFlag(rs.getDate(10));

			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {

			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}

		}

		log.info("Exit MemberService getAuthUserInfoFromAuth ");
		return info;

	}

	public AuthUserInfo repairMemberLogin(String memberid) throws Exception {
		log.info("Enter MemberService repairMemberLogin memberid is "
				+ memberid);

		AuthUserInfo result = null;
		Connection authconn = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String sql = "";

		try {

			authconn = DbConnectionFactory.getInstance().getConnection("auth");

			sql = "update auth_user set faildegree = 0 where username like ?";

			log.info("sql is :" + sql);

			pstmt = authconn.prepareStatement(sql);

			pstmt.setString(1, "%" + memberid.trim() + "%");

			int i = pstmt.executeUpdate();

			if (i == 1) {
				result = getAuthUserInfoFromAuth(authconn, memberid);
			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {

			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}

			if (authconn != null) {
				authconn.close();
				authconn = null;
			}

		}

		log.info("Exit MemberService repairMemberLogin result is " + result);

		return result;

	}

	public List<AccountInfo> getAccountInfoFromTx(Connection txconn,
			List<String> accountids) throws Exception {

		log.info("Enter MemberService getAccountInfoFromTx accountid is "
				+ accountids);

		List<AccountInfo> infos = new ArrayList<AccountInfo>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		StringBuffer sql = new StringBuffer();

		try {

			sql
					.append("select id,accountId,ownerId,defaultUnitCode,avoidExpiry,creditLimit,usedCredit,status,settlementDate from account where accountId in (");
			int size = accountids.size();
			for (int i = 0; i < size; i++) {
				sql.append("'").append(accountids.get(i)).append("'");
				if (i < size - 1)
					sql.append(",");
			}
			sql.append(")");
			log.info("sql is :" + sql.toString());

			pstmt = txconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				AccountInfo info = new AccountInfo();
				info.setId(rs.getString(1));
				info.setAccountId(rs.getString(2));
				info.setOwnerId(rs.getString(3));
				info.setDefaultUnitCode(rs.getString(4));
				info.setAvoidExpiry(rs.getBoolean(5));
				info.setCreditLimit(rs.getDouble(6));
				info.setUsedCredit(rs.getDouble(7));
				info.setStatus(rs.getString(8));
				info.setSettlementDate(rs.getDate(9));
				infos.add(info);

				String sql1 = "select sum(units) from accountbalance where account_id = '"
						+ info.getId() + "' and type = '0' and unitcode = '缤分'";

				log.info("query accountbalance sql1 is " + sql1);

				PreparedStatement pstmt1 = txconn
						.prepareStatement(sql1, ResultSet.TYPE_FORWARD_ONLY,
								ResultSet.CONCUR_READ_ONLY);

				ResultSet rs1 = pstmt1.executeQuery();

				if (rs1.next()) {
					info.setValidPoint(rs1.getFloat(1));
				}
				SqlUtil.close(rs1);
				SqlUtil.close(pstmt1);

				sql1 = "select sum(units) from merchantsalesqueue where member_id = '"
						+ info.getId() + "' and status = 'P'";

				pstmt1 = txconn
						.prepareStatement(sql1, ResultSet.TYPE_FORWARD_ONLY,
								ResultSet.CONCUR_READ_ONLY);

				rs1 = pstmt1.executeQuery();

				if (rs1.next()) {
					info.setFreezePoint(rs1.getFloat(1));
				}
				SqlUtil.close(rs1);
				SqlUtil.close(pstmt1);

			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {

			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}

		}

		log.info("Exit MemberService getAccountInfoFromTx size is "
				+ infos.size());

		return infos;
	}

	public void invalidMemberByMemberId(String memberId) throws Exception {

		log.info("Enter MemberService invalidMemberByMemberId  memberId is "
				+ memberId);

		Connection crmconn = null;
		PreparedStatement pstmt = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			crmconn.setAutoCommit(false);

			String sql = "update member set activeflag = 'invalid' where id = '"
					+ memberId + "'";

			pstmt = crmconn.prepareStatement(sql);
			int i = pstmt.executeUpdate();

			sql = "update membership set activeflag = 'invalid' where member_id = '"
					+ memberId + "'";

			pstmt = crmconn.prepareStatement(sql);
			i = pstmt.executeUpdate();

			crmconn.commit();

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

		log.info("Exit MemberService invalidMemberByMemberId ");

	}

}
