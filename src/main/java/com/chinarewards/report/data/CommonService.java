package com.chinarewards.report.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

import com.chinarewards.report.data.crm.ConsumeData;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class CommonService {

	Logger log = Logger.getLogger("CommonService");

	public boolean checkOrgOfMemberCardNo(Connection crmconn,
			String organizationno, String memberCardNo) throws Exception {

		log
				.info("Enter CommonService checkOrgOfMemberCardNo organizationno is "
						+ organizationno
						+ " and memberCardNo = "
						+ memberCardNo);
		boolean bool = false;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {

			String sql = "select org.organizationno from membership ms , card car , organization org WHERE ms.card_id = car.id and car.organization_id = org.id and ms.membercardno = ?";

			pstmt = crmconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			pstmt.setString(1, memberCardNo);

			rs = pstmt.executeQuery();

			if (rs.next()) {

				String orgNo = rs.getString(1);

				if (orgNo.trim().equals(organizationno)) {
					bool = true;
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

		log.info("Exit CommonService checkOrgOfMemberCardNo result is " + bool);

		return bool;
	}

	public List<ConsumeData> getAllMemberConsumeDateOfAccountid(
			String[] accountIds, Connection appconn) throws Exception {
		log.info("Enter CommonService getAllMemberConsumeDateOfAccountid");

		boolean createConn = false;
		if (appconn == null) {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			appconn = DbConnectionFactory.getInstance().getConnection("posapp");
			createConn = true;
		}

		List<ConsumeData> list = new ArrayList<ConsumeData>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		StringBuffer sqlbuf = new StringBuffer();
		sqlbuf
				.append("select cp.membercardid,cp.shopname,cp.amountcurrency,cp.point,cp.producttypename,cp.transdate,cp.tempmembertxid,cp.contractno from clubpoint cp where ");

		StringBuffer midbuf = new StringBuffer();
		midbuf.append(" cp.tempmembertxid in (");

		int k = 0;
		int size = accountIds.length;
		for (String accountid : accountIds) {
			midbuf.append("'").append(accountid).append("'");
			if (k < size - 1) {
				midbuf.append(",");
			}
		}

		midbuf.append(")");

		sqlbuf.append(midbuf.toString());

		sqlbuf
				.append(" and cp.clubid = '00' and cp.isrollback = 0 order by transdate desc");

		log.info("getAllMemberConsumeDateOfAccountid sql is"
				+ sqlbuf.toString());

		pstmt = appconn.prepareStatement(sqlbuf.toString(),
				ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

		rs = pstmt.executeQuery();

		while (rs.next()) {
			ConsumeData data = new ConsumeData();

			String memberCardNo = rs.getString(1);
			String shopName = rs.getString(2);
			float consumeMoney = rs.getFloat(3);
			float point = rs.getFloat(4);
			String consumeType = rs.getString(5);
			Date transDate = rs.getDate(6);
			String memberTxId = rs.getString(7);
			String contractno = rs.getString(8);

			data.setMemberCardNo(memberCardNo);
			data.setConsumeMoney(consumeMoney);
			data.setConsumeType(consumeType);
			data.setPoint(point);
			data.setShopName(shopName);
			data.setTransDate(transDate);
			data.setMemberTxId(memberTxId);
			data.setContractNo(contractno);

			list.add(data);
		}

		if (rs != null)
			rs.close();
		if (pstmt != null)
			pstmt.close();

		if (createConn && (appconn != null)) {
			SqlUtil.close(appconn);
			appconn = null;
		}
		log
				.info("Exit CommonService getAllMemberConsumeDateOfAccountid list size is "
						+ list.size());
		return list;

	}
}
