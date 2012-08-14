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

public class ZhongXinQinZiYouDIY {

	Logger log = Logger.getLogger("ZhongXinQinZiYouDIY");

	public QinZiYouDIYReportVo getZhongXinQinZiYouDIYReport() throws Exception {
		log.info("Enter ZhongXinQinZiYouDIY getZhongXinQinZiYouDIYReport");

		QinZiYouDIYReportVo vo = new QinZiYouDIYReportVo();
		List<ConsumeData> list = null;

		Connection appconn = null;

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			appconn = DbConnectionFactory.getInstance().getConnection("posapp");

			// get all chinalife member consume in shop 中信亲子DIY
			List<ConsumeData> allclList = getAllChinaLifeMemberConsumeDateInZXQZYDIY(appconn);
			if (allclList == null
					|| (allclList != null && allclList.size() == 0)) {
				log
						.info("no chinalife member consume in zhongxinqingziDIY return 0");
				return vo;
			}

			LinkedHashSet<String> memberTxIds = new LinkedHashSet<String>();

			for (ConsumeData data : allclList) {
				memberTxIds.add(data.getMemberTxId());
			}

			log.info("getZhongXinQinZiYouDIYReport memberTxIds size is "
					+ memberTxIds.size());

			list = getReportData(appconn, memberTxIds);

			vo.setData(list);

			Map<String, Integer> map = getReportSumData(appconn, memberTxIds);

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

		log.info("Exit ZhongXinQinZiYouDIY getZhongXinQinZiYouDIYReport");
		return vo;
	}

	private Map<String, Integer> getReportSumData(Connection appconn,
			LinkedHashSet<String> memberTxIds) throws SQLException {

		log.info("Enter ZhongXinQinZiYouDIY getReportSumData");

		StringBuffer sqlbuf = new StringBuffer();

		Map<String, Integer> map = new HashMap<String, Integer>();

		int i = 0;
		int size = memberTxIds.size();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		sqlbuf
				.append(
						"select cp.membercardid,count(id) from clubpoint cp where clubid = '00' and shopid = '1362' and ")
				.append(

						"((cp.transdate >= to_date('2010-08-08 00:00:01','yyyy-MM-dd HH24:mi:ss') and cp.transdate < to_date('2010-08-08 23:59:59','yyyy-MM-dd HH24:mi:ss')) or ")
				.append(

						"(cp.transdate >= to_date('2010-08-14 00:00:01','yyyy-MM-dd HH24:mi:ss') and cp.transdate < to_date('2010-08-14 23:59:59','yyyy-MM-dd HH24:mi:ss')) or ")
				.append(

						"(cp.transdate >= to_date('2010-08-15 00:00:01','yyyy-MM-dd HH24:mi:ss') and cp.transdate < to_date('2010-08-15 23:59:59','yyyy-MM-dd HH24:mi:ss'))) and cp.tempmembertxid in (");

		for (String txId : memberTxIds) {
			++i;
			sqlbuf.append("'").append(txId).append("'");
			if (i < size) {
				sqlbuf.append(",");
			}

		}
		sqlbuf.append(" ) group by cp.membercardid");

		log.info("ZhongXinQinZiYouDIY getReportSumData sql is "
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

		log.info("Exit ZhongXinQinZiYouDIY getReportSumData map size is "
				+ map.size());

		return null;

	}

	public List<ConsumeData> getReportData(Connection appconn,
			LinkedHashSet<String> memberTxIds) throws SQLException {
		log.info("Enter ZhongXinQinZiYouDIY getReportData");

		List<ConsumeData> list = new ArrayList<ConsumeData>();

		StringBuffer sqlbuf = new StringBuffer();

		int i = 0;
		int size = memberTxIds.size();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		sqlbuf
				.append(
						"select cp.id,cp.membercardid,cp.shopid,cp.shopname,cp.amountcurrency,cp.point,cp.producttypename,cp.transdate,cp.tempmembertxid from clubpoint cp where clubid = '00' and shopid = '1362' and ")
				.append(

						"((cp.transdate >= to_date('2010-08-08 00:00:01','yyyy-MM-dd HH24:mi:ss') and cp.transdate < to_date('2010-08-08 23:59:59','yyyy-MM-dd HH24:mi:ss')) or ")
				.append(

						"(cp.transdate >= to_date('2010-08-14 00:00:01','yyyy-MM-dd HH24:mi:ss') and cp.transdate < to_date('2010-08-14 23:59:59','yyyy-MM-dd HH24:mi:ss')) or ")
				.append(

						"(cp.transdate >= to_date('2010-08-15 00:00:01','yyyy-MM-dd HH24:mi:ss') and cp.transdate < to_date('2010-08-15 23:59:59','yyyy-MM-dd HH24:mi:ss'))) and cp.tempmembertxid in (");

		for (String txId : memberTxIds) {
			++i;
			sqlbuf.append("'").append(txId).append("'");
			if (i < size) {
				sqlbuf.append(",");
			}

		}
		sqlbuf.append(" ) order by membercardid,shopid,transdate desc");

		log.info("ZhongXinQinZiYouDIY getReportData sql is "
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

		log.info("Exit ZhongXinQinZiYouDIY getReportData list size is "
				+ list.size());

		return list;
	}

	public List<ConsumeData> getAllChinaLifeMemberConsumeDateInZXQZYDIY(
			Connection appconn) throws Exception {
		log
				.info("Enter ZhongXinQinZiYouDIY getAllChinaLifeMemberConsumeDateInZXQZYDIY");

		boolean createConn = false;
		if (appconn == null) {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			appconn = DbConnectionFactory.getInstance().getConnection("posapp");
			createConn = true;
		}

		List<ConsumeData> list = new ArrayList<ConsumeData>();

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		String sql = "select cp.membercardid,cp.shopname,cp.amountcurrency,cp.point,cp.producttypename,cp.transdate,cp.tempmembertxid from clubpoint cp where cp.membercardid like '95519%' and clubid = '00' and shopid = '5381' order by transdate desc";

		log.info("getAllchinalife member in ZXQZYDIY sql is" + sql);

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
				.info("Exit ZhongXinQinZiYouDIY getAllChinaLifeMemberConsumeDateInZXQZYDIY list size is "
						+ list.size());
		return list;

	}
}
