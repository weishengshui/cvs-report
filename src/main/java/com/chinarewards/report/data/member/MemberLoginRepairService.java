package com.chinarewards.report.data.member;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

import com.chinarewards.report.data.auth.AuthUserInfo;
import com.chinarewards.report.data.crm.MemberInfo;
import com.chinarewards.report.data.crm.MemberShipInfo;
import com.chinarewards.report.data.tx.AccountInfo;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class MemberLoginRepairService {
	Logger log = Logger.getLogger("memberloginrepair");

	public MemberInfo getMemberInfo(String queryno, String querytype)
			throws Exception {
		log.info("Enter memberloginrepair getMemberInfo");

		MemberInfo memberInfo = null;

		Connection authconn = null;

		Connection crmconn = null;

		Connection txconn = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			crmconn = DbConnectionFactory.getInstance().getConnection("crm");

			MemberService memberService = new MemberService();
			memberInfo = memberService.getMemberInfoFromCRM(crmconn, queryno,
					querytype);

			if (memberInfo == null)
				return null;

			List<MemberShipInfo> msList = memberService
					.getMemberShipInfoListFromCRM(crmconn, memberInfo.getId());

			memberInfo.setMemberShipInfos(msList);
			if (msList != null) {
				for (MemberShipInfo msinfo : msList) {
					String accountId = msinfo.getAccountId();
					if (null != accountId)
						memberInfo.setAccountIds(accountId);
				}
			}

			authconn = DbConnectionFactory.getInstance().getConnection("auth");

			AuthUserInfo authUserInfo = memberService.getAuthUserInfoFromAuth(
					authconn, memberInfo.getId());

			memberInfo.setAuthUserInfo(authUserInfo);

			txconn = DbConnectionFactory.getInstance().getConnection("tx");

			List<String> accountids = memberInfo.getAccountIds();

			if ((accountids != null) && (accountids.size() > 0)) {
				List<AccountInfo> accountInfos = memberService
						.getAccountInfoFromTx(txconn, accountids);

				memberInfo.setAccountInfos(accountInfos);
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception(e);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			SqlUtil.close(crmconn);
			SqlUtil.close(authconn);
			SqlUtil.close(txconn);
		}

		log.info("Exit memberloginrepair getMemberInfo list size is ");

		return memberInfo;
	}

	public AuthUserInfo repairMemberLogin(String memberid) throws Exception {
		MemberService memberService = new MemberService();
		return memberService.repairMemberLogin(memberid);
	}

}
