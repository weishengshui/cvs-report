package com.chinarewards.report.data;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.chinarewards.report.data.crm.ConsumeData;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class ConsumeDataByShopAndPosNoService {

	Logger log = Logger.getLogger("ConsumeDataByShopAndPosNoService");

	enum ORG {
		CHINA_LIFE;
	}

	public List<ConsumeData> getGuoshouConsumeData(String[] shopIds,
			Date startDate, Date endDate, String... posIds) throws Exception {

		return getAllConsumeData(shopIds, startDate, endDate, ORG.CHINA_LIFE,
				false, posIds);
	}

	public List<ConsumeData> getAllConsumeData(String[] shopIds,
			Date startDate, Date endDate, String... posIds) throws Exception {
		return getAllConsumeData(shopIds, startDate, endDate, null, true,
				posIds);
	}

	public List<ConsumeData> getAllConsumeData(String[] shopIds,
			Date startDate, Date endDate, ORG org, boolean testConsumeLimit,
			String... posIds) throws Exception {
		log.info("Enter ConsumeDataByShopAndPosNoService getAllConsumeData");

		List<ConsumeData> list = new ArrayList<ConsumeData>();
		Connection appconn = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");

			appconn = DbConnectionFactory.getInstance().getConnection("posapp");

			StringBuffer shopidsb = new StringBuffer();
			for (int i = 0; i < shopIds.length; i++) {
				shopidsb.append("'").append(shopIds[i]).append("'");
				if (i < shopIds.length - 1) {
					shopidsb.append(",");
				}
			}

			StringBuffer possb = null;
			if (posIds != null) {
				possb = new StringBuffer();
				for (int i = 0; i < posIds.length; i++) {
					possb.append("'").append(posIds[i]).append("'");
					if (i < posIds.length - 1) {
						possb.append(",");
					}
				}
			}

			StringBuffer sql = new StringBuffer();
			sql
					.append("select cp.membercardid,cp.shopname,cp.producttypename, cp.amountcurrency,cp.point, TO_CHAR(cp.transdate, 'yyyy-mm-dd hh24:mm:ss'),cp.merchantname,cp.posid from clubpoint cp where cp.clubid='00' and cp.shopid in(");
			sql.append(shopidsb.toString());
			sql.append(")");

			if (possb != null) {
				sql.append(" and posid in(");
				sql.append(possb.toString()).append(")");
			}

			if (testConsumeLimit) {
				sql.append("  and cp.amountcurrency > 1 ");
			}

			if (org != null) {
				if (org == ORG.CHINA_LIFE) {
					sql.append(" and cp.memberexternalrefid is not null ");
				} else {
					// FIXME .
					throw new UnsupportedOperationException();
				}
			}

			sql
					.append(" and cp.transdate > ? and cp.transdate <= ?  ORDER by cp.transdate desc");

			log.info("getAllConsumeData sql is " + sql);

			pstmt = appconn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

			pstmt.setDate(1, startDate);
			pstmt.setDate(2, endDate);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				ConsumeData data = new ConsumeData();
				data.setMemberCardNo(rs.getString(1));
				data.setShopName(rs.getString(2));
				data.setConsumeType(rs.getString(3));
				data.setConsumeMoney(rs.getFloat(4));
				data.setPoint(rs.getFloat(5));
				data.setTransDataStr(rs.getString(6));
				data.setMerchantName(rs.getString(7));
				data.setPosNo(rs.getString(8));
				list.add(data);
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception(e);
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

			if (appconn != null) {
				SqlUtil.close(appconn);
				appconn = null;
			}

		}

		log
				.info("Exit ConsumeDataByShopAndPosNoService getAllConsumeData list size is "
						+ (list == null ? "0" : list.size()));

		return list;
	}

}
