package com.chinarewards.report.data.activity;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.chinarewards.report.data.crm.ConsumeData;
import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class PanYuQinZiYouReportService {

	Logger log = Logger.getLogger("PanYuQinZiYouReportService");

	final String pyshiopId = "5380";

	public QinZiYouDIYReportVo getPanYuQinZiYouReportReport() throws Exception {
		log
				.info("Enter PanYuQinZiYouReportService getPanYuQinZiYouReportReport");

		QinZiYouDIYReportVo vo = new QinZiYouDIYReportVo();
		List<ConsumeData> list = null;

		Connection appconn = null;

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			appconn = DbConnectionFactory.getInstance().getConnection("posapp");

			// get all chinalife member consume in shop 番禺亲子游
			List<ConsumeData> allclList = getAllChinaLifeMemberConsumeDateInPYQZY(appconn);

			ZhongXinQinZiYouDIY diy = new ZhongXinQinZiYouDIY();

			if (allclList == null
					|| (allclList != null && allclList.size() == 0)) {
				log
						.info("no chinalife member consume in getPanYuQinZiYouReportReport return 0");
				return vo;
			}
			LinkedHashSet<String> memberTxIds = new LinkedHashSet<String>();

			for (ConsumeData data : allclList) {
				memberTxIds.add(data.getMemberTxId());
			}

			log.info("getPanYuQinZiYouReportReport memberTxIds size is "
					+ memberTxIds.size());

			List<ConsumeData> diydates = diy
					.getReportData(appconn, memberTxIds);

			List<String> diyIds = null;

			if (diydates != null && diydates.size() > 0) {
				diyIds = new ArrayList<String>();

				for (ConsumeData data : diydates) {
					diyIds.add(data.getClubpointId());
				}
			}

			list = getReportData(appconn, memberTxIds, diyIds);

			vo.setData(list);

			Map<String, Integer> map = getReportSumData(appconn, memberTxIds,
					diyIds);

			vo.setDatasum(map);

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new Exception(e);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {

			if (appconn != null) {
				SqlUtil.close(appconn);
				appconn = null;
			}

		}

		log
				.info("Exit PanYuQinZiYouReportService getPanYuQinZiYouReportReport");
		return vo;
	}

	private Map<String, Integer> getReportSumData(Connection appconn,
			LinkedHashSet<String> memberTxIds, List<String> diyIds)
			throws SQLException {

		log.info("Enter PanYuQinZiYouReportService getReportSumData");

		StringBuffer sqlbuf = new StringBuffer();

		Map<String, Integer> map = new HashMap<String, Integer>();

		int i = 0;
		int size = memberTxIds.size();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		sqlbuf
				.append(
						"select cp.membercardid,count(id) from clubpoint cp where clubid = '00' and cp.shopid != '5380' and ")
				.append(

						"(cp.transdate >= to_date('2010-08-01 00:00:01','yyyy-MM-dd HH24:mi:ss') and cp.transdate < to_date('2010-08-31 23:59:59','yyyy-MM-dd HH24:mi:ss')) and cp.tempmembertxid in (");

		for (String txId : memberTxIds) {
			++i;
			sqlbuf.append("'").append(txId).append("'");
			if (i < size) {
				sqlbuf.append(",");
			}

		}
		sqlbuf.append(" )");

		if (diyIds != null && diyIds.size() > 0) {

			sqlbuf.append(" and cp.id not in (");
			int j = 0;
			int size2 = diyIds.size();
			for (String diyId : diyIds) {
				++j;
				sqlbuf.append("'").append(diyId).append("'");
				if (j < size2) {
					sqlbuf.append(",");
				}

			}
			sqlbuf.append(")");
		}

		sqlbuf.append(" group by cp.membercardid");

		log.info("PanYuQinZiYouReportService getReportSumData sql is "
				+ sqlbuf.toString());

		pstmt = appconn.prepareStatement(sqlbuf.toString(),
				ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

		rs = pstmt.executeQuery();

		while (rs.next()) {
			String memberCardNo = rs.getString(1);
			int sum = rs.getInt(2);
			map.put(memberCardNo, sum);
		}

		if (rs != null)
			rs.close();
		if (pstmt != null)
			pstmt.close();

		log
				.info("Exit PanYuQinZiYouReportService getReportSumData map size is "
						+ map.size());

		return null;

	}

	private List<ConsumeData> getReportData(Connection appconn,
			LinkedHashSet<String> memberTxIds, List<String> diyIds)
			throws SQLException {
		log.info("Enter PanYuQinZiYouReportService getReportData");

		List<ConsumeData> list = new ArrayList<ConsumeData>();

		StringBuffer sqlbuf = new StringBuffer();

		int i = 0;
		int size = memberTxIds.size();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		sqlbuf
				.append(
						"select cp.id,cp.membercardid,cp.shopid,cp.shopname,cp.amountcurrency,cp.point,cp.producttypename,cp.transdate,cp.tempmembertxid from clubpoint cp where clubid = '00' and cp.shopid != '5380' and ")
				.append(

						"(cp.transdate >= to_date('2010-08-01 00:00:01','yyyy-MM-dd HH24:mi:ss') and cp.transdate < to_date('2010-08-31 23:59:59','yyyy-MM-dd HH24:mi:ss')) and cp.tempmembertxid in (");

		for (String txId : memberTxIds) {
			++i;
			sqlbuf.append("'").append(txId).append("'");
			if (i < size) {
				sqlbuf.append(",");
			}

		}

		sqlbuf.append(" )");

		if (diyIds != null && diyIds.size() > 0) {

			sqlbuf.append(" and cp.id not in (");
			int j = 0;
			int size2 = diyIds.size();
			for (String diyId : diyIds) {
				++j;
				sqlbuf.append("'").append(diyId).append("'");
				if (j < size2) {
					sqlbuf.append(",");
				}

			}
			sqlbuf.append(")");
		}

		sqlbuf.append(" order by membercardid,shopid,transdate desc");

		log.info("PanYuQinZiYouReportService getReportData sql is "
				+ sqlbuf.toString());

		pstmt = appconn.prepareStatement(sqlbuf.toString(),
				ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

		rs = pstmt.executeQuery();

		while (rs.next()) {
			ConsumeData data = new ConsumeData();

			String clubpointId = rs.getString(1);
			String memberCardNo = rs.getString(2);
			String shopName = rs.getString(3);
			float consumeMoney = rs.getFloat(4);
			float point = rs.getFloat(5);
			String consumeType = rs.getString(6);
			Date transDate = rs.getDate(7);
			String memberTxId = rs.getString(8);

			data.setClubpointId(clubpointId);
			data.setMemberCardNo(memberCardNo);
			data.setConsumeMoney(consumeMoney);
			data.setConsumeType(consumeType);
			data.setPoint(point);
			data.setShopName(shopName);
			data.setTransDate(transDate);
			data.setMemberTxId(memberTxId);

			list.add(data);
		}

		if (rs != null)
			rs.close();
		if (pstmt != null)
			pstmt.close();

		log.info("Exit PanYuQinZiYouReportService getReportData list size is "
				+ list.size());

		return list;
	}

	public List<ConsumeData> getAllChinaLifeMemberConsumeDateInPYQZY(
			Connection appconn) throws Exception {
		log
				.info("Enter PanYuQinZiYouReportService getAllChinaLifeMemberConsumeDateInPYQZY");

		boolean createConn = false;
		if (appconn == null) {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			appconn = DbConnectionFactory.getInstance().getConnection("posapp");
			createConn = true;
		}

		List<ConsumeData> list = new ArrayList<ConsumeData>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String sql = "select cp.membercardid,cp.shopname,cp.amountcurrency,cp.point,cp.producttypename,cp.transdate,cp.tempmembertxid from clubpoint cp where cp.membercardid like '95519%' and clubid = '00' and shopid = '5380' order by transdate desc";

		log.info("getAllchinalife member in PYQZY sql is" + sql);

		pstmt = appconn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY,
				ResultSet.CONCUR_READ_ONLY);

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

			data.setMemberCardNo(memberCardNo);
			data.setConsumeMoney(consumeMoney);
			data.setConsumeType(consumeType);
			data.setPoint(point);
			data.setShopName(shopName);
			data.setTransDate(transDate);
			data.setMemberTxId(memberTxId);

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
				.info("Exit PanYuQinZiYouReportService getAllChinaLifeMemberConsumeDateInPYQZY list size is "
						+ list.size());
		return list;

	}

}
