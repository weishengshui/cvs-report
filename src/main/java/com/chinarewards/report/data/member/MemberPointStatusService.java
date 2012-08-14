package com.chinarewards.report.data.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.chinarewards.report.data.MemberPointStatusVO;
import com.chinarewards.report.data.crm.MemberInfo;
import com.chinarewards.report.data.crm.MemberShipInfo;
import com.chinarewards.report.data.tx.AccountInfo;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class MemberPointStatusService {

	Logger log = Logger.getLogger("MemberPointStatusService");

	public List<MemberPointStatusVO> getMemberPointStatusReport()
			throws Exception {
		List<MemberPointStatusVO> result = null;

		log.info("Enter MemberPointStatusService getMemberPointStatusReport");

		Connection crmconn = null;

		Connection txconn = null;

		Connection appconn = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			appconn = DbConnectionFactory.getInstance().getConnection("posapp");

			List<String> accounts = getAccountIdsOfMember(appconn);

			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			txconn = DbConnectionFactory.getInstance().getConnection("tx");

			result = getMemberPointStatusByaccounts(crmconn, txconn, accounts);

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception(e);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			SqlUtil.close(crmconn);
			SqlUtil.close(txconn);
			SqlUtil.close(appconn);
		}

		log
				.info("Exit MemberPointStatusService getMemberPointStatusReport list size is "
						+ result.size());

		return result;
	}

	private List<String> getAccountIdsOfMember(Connection appconn) {

		log.info("Enter MemberPointStatusService getAccountIdsOfMember");

		List<String> result = new ArrayList<String>();
		String sql = "select DISTINCT(tempmembertxid) from clubpoint where tempmembertxid is not null and clubid = '00'";

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {
			pstmt = appconn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_READ_ONLY);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				result.add(rs.getString(1));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(pstmt);
		}

		log.info("Exit MemberPointStatusService getAccountIdsOfMember");

		return result;
	}

	private List<MemberPointStatusVO> getMemberPointStatusByaccounts(
			Connection crmconn, Connection txconn, List<String> accounts)
			throws Exception {

		log
				.info("Enter MemberPointStatusService getMemberPointStatusByaccounts");

		List<MemberPointStatusVO> list = new ArrayList<MemberPointStatusVO>();

		MemberService memService = new MemberService();
		for (String txAccount : accounts) {

			MemberInfo memInfo = memService.getMemberInfoFromCRMByTxAccountId(
					crmconn, txAccount);

			if (memInfo != null) {
				MemberPointStatusVO memVo = new MemberPointStatusVO();

				memVo.setMemberName(memInfo.getName());
				memVo.setMobile(memInfo.getMobile());

				List<MemberShipInfo> msList = memService
						.getMemberShipInfoListFromCRM(crmconn, memInfo.getId());

				memInfo.setMemberShipInfos(msList);

				if (msList != null) {
					for (MemberShipInfo msinfo : msList) {
						String accountId = msinfo.getAccountId();
						if (null != accountId)
							memInfo.setAccountIds(accountId);

						String cardId = msinfo.getCardId();
						if ("1".equals(cardId)) {
							memVo.setMemberCardno(msinfo.getMemberCardNo());
						}
					}
				}

				List<String> accountids = memInfo.getAccountIds();

				float totalPoint = 0;
				float validPoint = 0;
				if ((accountids != null) && (accountids.size() > 0)) {
					List<AccountInfo> accountInfos = memService
							.getAccountInfoFromTx(txconn, accountids);

					memInfo.setAccountInfos(accountInfos);

					for (AccountInfo acc : accountInfos) {
						totalPoint += acc.getValidPoint();
						totalPoint += acc.getFreezePoint();
						validPoint += acc.getValidPoint();
					}

				}

				memVo.setTotalPoint(totalPoint);
				memVo.setValidPoint(validPoint);

				list.add(memVo);
			}
		}

		log
				.info("Exit MemberPointStatusService getMemberPointStatusByaccounts");

		return list;

	}

}
