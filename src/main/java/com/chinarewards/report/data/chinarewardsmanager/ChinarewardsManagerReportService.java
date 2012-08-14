package com.chinarewards.report.data.chinarewardsmanager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;

import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class ChinarewardsManagerReportService {

	Logger log = Logger.getLogger("ChinarewardsManagerReportService");

	public ChinarewardsManagerReportRes getChinarewardsMamagerReport(
			String contractStartDateFromStr, String contractStartDateToStr) {

		log
				.info("Enter ChinarewardsManagerReportService getChinarewardsMamagerReport");

		log
				.info("getChinarewardsMamagerReport PARAMETER: contractStartDateFromStr : "
						+ contractStartDateFromStr
						+ " contractStartTostr :"
						+ contractStartDateToStr);

		ChinarewardsManagerReportRes res = new ChinarewardsManagerReportRes();

		Connection crmconn = null;
		Connection appconn = null;

		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");

			crmconn = DbConnectionFactory.getInstance().getConnection("crm");
			appconn = DbConnectionFactory.getInstance().getConnection("posapp");

			StringBuffer sbsql = null;

			// 新增注册会员数 每月申请并注册激活的缤分联盟会员数量
			getNewlyRegisterMemberNum(sbsql, contractStartDateFromStr,
					contractStartDateToStr, crmconn, pstmt, rs, res);

			// 新增发卡会员数 每月持有缤分联盟或缤分联盟联名卡会员数量
			getNewlyGetCardMemberNum(sbsql, contractStartDateFromStr,
					contractStartDateToStr, crmconn, pstmt, rs, res);

			// 新增消费会员数 每月新增一次及一次消费以上的会员数

			getNewlyConsumeMemberNum(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);

			// 新增活跃会员数 每月新增3次以上消费次数或跨商户消费的会员数

			getNewlyActiveMemberNum(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);

			// 新增跨商户会员数 每月新增跨越不同商户的消费会员数
			getNewlyCrossingShopMemberNum(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);

			// 缤分联盟会员每天消费次数 当前一月内平均每天缤分联盟会员积分累积次数
			getNewlyConsumeNumEveDay(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);

			// 新增获取缤分量 每月缤分联盟会员奖励积分赠送量，包括已到帐及未到帐积分
			getNewlyRewardsPointNum(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);

			// 新增消费总金额 每月缤分联盟会员在商户处消费的总金额
			getNewlyConsumeMoneyNum(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);

			// 消费次数 中国人寿会员参与超级优惠活动及在缤分联盟商户消费总次数，所有当前月活动和平日消费次数总和
			getNewlyConsumeNumOfChinaLife(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);
			
			// 中国人寿 消费会员数 当前月在缤分联盟消费过的会员数
			getNewlyConsumeNumOfCLMember(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);
			
			//中国人寿会员获取缤分总量
			//当前月中国人寿会员在活动和平日消费中获取的积分（缤分）总和
			getTotalPointOfChinaLife(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);
			
			//中国人寿消费总金额
			//当前月中国人寿会员在商户处消费的总金额
			getNewlyTotalMoneyOfChinaLife(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);
			
			//深圳航空消费次数
			//当前月深航会员参与超级优惠活动及在缤分联盟商户消费总次数，所有活动和平日消费次数总和
			getNewlyConsumeNumOfSZAir(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);
			
			//深圳航空 消费会员数 当前月在缤分联盟消费过的会员数
			getNewlyConsumeMemberNumOfSZAir(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);
			
			//深圳航空会员获取缤分总量
			//当前月深航会员在缤分联盟商户消费获得的所有缤分总和，包括已到帐和未到帐
			getNewlyTotalPointOfSZAir(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);
			
			//深圳航空消费总金额
			//当前月深航会员在商户处消费的总金额
			getNewlyTotalMoneyOfSZAir(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);
			
			//深圳航空会员获取里程总量
			//当前月深航会员在缤分联盟商户消费获得的所有里程总和，全部为到账
			getNewlyTotalMileageOfSZAir(sbsql, contractStartDateFromStr,
					contractStartDateToStr, appconn, pstmt, rs, res);
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			SqlUtil.close(rs);
			SqlUtil.close(pstmt);
			SqlUtil.close(crmconn);
			SqlUtil.close(appconn);
		}

		log
				.info("Exit ChinarewardsManagerReportService getChinarewardsMamagerReport");

		return res;
	}
	
//	select sum(sellamount) from pointtransactiondetail where clubpoint_id in(
//			select id from clubpoint cp 
//			where cp.clubid = '00'
//			and cp.isrollback = 0
//			and cp.transdate  >= to_date('2011-08-01 00:00:01','yyyy-MM-dd HH24:mi:ss') 
//			and cp.transdate <= to_date('2011-08-31 23:59:59','yyyy-MM-dd HH24:mi:ss')
//			) and partnerid = 'ff8080812523c77e0125243556691083' and status = 'OK'
	
	/**
	 * 深圳航空会员获取里程总量
     * 当前月深航会员在缤分联盟商户消费获得的所有里程总和，全部为到账
	 * 
	 */
	private void getNewlyTotalMileageOfSZAir(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {
		
		sbsql = new StringBuffer(
				"select sum(sellamount) from pointtransactiondetail where clubpoint_id in( select id from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0 ");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}
		
		sbsql.append(") and partnerid = 'ff8080812523c77e0125243556691083' and status = 'OK'");

		log.info("getChinarewardsMamagerReport 17: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		
		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyTotalMileageOfSZAir(String.valueOf(rs.getInt(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}
	
	/**
	 * 深圳航空消费总金额
	 * 当前月深航会员在商户处消费的总金额
	 * 
	 */
	private void getNewlyTotalMoneyOfSZAir(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {
		
		sbsql = new StringBuffer(
				"select sum(cp.amountcurrency) from clubpoint cp where cp.id in(select pd.clubpoint_id from pointtransactiondetail pd where pd.partnerid = 'ff8080812523c77e0125243556691083'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and pd.transactiondate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and pd.transactiondate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}
		
		sbsql.append(") and cp.clubid = '00' and cp.isrollback = 0");

		log.info("getChinarewardsMamagerReport 16: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		
		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyTotalMoneyOfSZAir(String.valueOf(rs.getInt(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}
	
	/**
	 * 深圳航空会员获取缤分总量
	 * 当前月深航会员在缤分联盟商户消费获得的所有缤分总和，包括已到帐和未到帐
	 * 
	 */
	private void getNewlyTotalPointOfSZAir(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {
		
		sbsql = new StringBuffer(
				"select sum(cp.point) from clubpoint cp where cp.id in(select pd.clubpoint_id from pointtransactiondetail pd where pd.partnerid = 'ff8080812523c77e0125243556691083'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and pd.transactiondate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and pd.transactiondate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}
		
		sbsql.append(") and cp.clubid = '00' and cp.isrollback = 0");

		log.info("getChinarewardsMamagerReport 15: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		
		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyTotalPointOfSZAir(String.valueOf(rs.getInt(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}
	
	/**
	 * 深圳航空 消费会员数 当前月在缤分联盟消费过的会员数
	 * 
	 */
	private void getNewlyConsumeMemberNumOfSZAir(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {
		
		sbsql = new StringBuffer(
				"select count(distinct cp.tempmembertxid ) from clubpoint cp where cp.id in(select pd.clubpoint_id from pointtransactiondetail pd where pd.partnerid = 'ff8080812523c77e0125243556691083'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and pd.transactiondate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and pd.transactiondate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}
		
		sbsql.append(") and cp.clubid = '00' and cp.isrollback = 0");

		log.info("getChinarewardsMamagerReport 14: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		int degree = 0;
		rs = pstmt.executeQuery();
		if (rs.next()) {
			degree = rs.getInt(1);
		}

		res.setNewlyConsumeMemberNumOfSZAir(String.valueOf(degree));

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}
	
	
	/**
	 * 深圳航空消费次数
	 * 当前月深航会员参与超级优惠活动及在缤分联盟商户消费总次数，所有活动和平日消费次数总和
	 * 
	 */
	private void getNewlyConsumeNumOfSZAir(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {
		
		sbsql = new StringBuffer(
				"select count(cp.posdegree) from clubpoint cp where cp.id in(select pd.clubpoint_id from pointtransactiondetail pd where pd.partnerid = 'ff8080812523c77e0125243556691083'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and pd.transactiondate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and pd.transactiondate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}
		
		sbsql.append(") and cp.clubid = '00' and cp.isrollback = 0");

		log.info("getChinarewardsMamagerReport 13: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		int degree = 0;
		rs = pstmt.executeQuery();
		if (rs.next()) {
			degree = rs.getInt(1);
		}

		res.setNewlyConsumeNumOfSZAir(String.valueOf(degree));

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}
	
	/**
	 * 中国人寿消费总金额
	 * 当前月中国人寿会员在商户处消费的总金额
	 */
	private void getNewlyTotalMoneyOfChinaLife(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {
		sbsql = new StringBuffer(
				"select sum(cp.amountcurrency) from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0   and cp.membercardid like '95519%'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 12: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyTotalMoneyOfChinaLife(String.valueOf(rs.getFloat(1)));
			
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);
	}
	
	/**
	 * 中国人寿会员获取缤分总量
	 * 当前月中国人寿会员在活动和平日消费中获取的积分（缤分）总和
	 */
	private void getTotalPointOfChinaLife(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select sum(cp.point) from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0   and cp.membercardid like '95519%'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 11: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyTotalPointOfChinaLife(String.valueOf(rs.getInt(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}
	
	/**
	 * 中国人寿 消费会员数 当前月在缤分联盟消费过的会员数
	 */
	private void getNewlyConsumeNumOfCLMember(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select count(distinct cp.tempmembertxid) from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0  and cp.membercardid like '95519%'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 10: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyConsumeNumOfCLMember(String.valueOf(rs.getInt(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}

	/**
	 * 消费次数 中国人寿会员参与超级优惠活动及在缤分联盟商户消费总次数，所有当前月活动和平日消费次数总和
	 */
	private void getNewlyConsumeNumOfChinaLife(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select count(cp.posdegree) from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0 and cp.membercardid like '95519%'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 9: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		int degree = 0;
		rs = pstmt.executeQuery();
		if (rs.next()) {
			degree = rs.getInt(1);
		}

		res.setNewlyConsumeNumOfChinaLife(String.valueOf(degree));

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}

	/**
	 * 新增消费总金额 每月缤分联盟会员在商户处消费的总金额
	 */
	private void getNewlyConsumeMoneyNum(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {
		sbsql = new StringBuffer(
				"select sum(cp.amountcurrency) from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 8: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyConsumeMoneyNum(String.valueOf(rs.getFloat(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);
	}

	/**
	 * 新增获取缤分量 每月缤分联盟会员奖励积分赠送量，包括已到帐及未到帐积分
	 */
	private void getNewlyRewardsPointNum(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select sum(cp.point) from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 7: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyRewardsPointNum(String.valueOf(rs.getInt(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}

	/**
	 * 缤分联盟会员每天消费次数 当前一月内平均每天缤分联盟会员积分累积次数
	 */
	private void getNewlyConsumeNumEveDay(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select count(cp.posdegree) from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 6: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		int day = 0;
		rs = pstmt.executeQuery();
		if (rs.next()) {
			int degree = rs.getInt(1);

			int l = getDayOfTwoDate(contractStartDateFromStr,
					contractStartDateToStr);

			day = degree / l;
		}

		res.setNewlyConsumeNumEveDay(String.valueOf(day));

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}

	/**
	 * 新增跨商户会员数 每月新增跨越不同商户的消费会员数
	 */
	private void getNewlyCrossingShopMemberNum(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select cp.shopid,cp.tempmembertxid from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0 and cp.shopid is not null");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 5: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		Map<String, String> map = new HashMap<String, String>();
		Set<String> set = new HashSet<String>();
		rs = pstmt.executeQuery();
		while (rs.next()) {
			String shopId = rs.getString(1);
			String txId = rs.getString(2);

			// 如果这个会员消费过
			if (map.containsKey(txId)) {
				String value = map.get(txId);

				// 如果消费的门市不同
				if (!shopId.equals(value)) {
					// 如果这个会员没有记录，则记录这个会员
					set.add(txId);
				} else {
					// do nothing
				}
			} else {
				map.put(txId, shopId);
			}
		}

		res.setNewlyCrossingShopMemberNum(String.valueOf(set.size()));

		map.clear();
		map = null;
		set.clear();
		set = null;

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);
	}

	/**
	 * 新增活跃会员数 每月新增3次以上消费次数或跨商户消费的会员数
	 */
	private void getNewlyActiveMemberNum(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select count(*) ,cp.tempmembertxid from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		sbsql.append(" group by cp.tempmembertxid having count(*) >2");

		log.info("getChinarewardsMamagerReport 4: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		int num = 0;
		rs = pstmt.executeQuery();
		while (rs.next()) {
			++num;
		}

		res.setNewlyActiveMemberNum(String.valueOf(num));

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}

	/**
	 * 新增消费会员数 每月新增一次及一次消费以上的会员数
	 */
	private void getNewlyConsumeMemberNum(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection appconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select count(distinct cp.tempmembertxid) from clubpoint cp where cp.clubid = '00' and cp.isrollback = 0");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and cp.transdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and cp.transdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 3: " + sbsql.toString());

		pstmt = appconn.prepareStatement(sbsql.toString());

		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyConsumeMemberNum(String.valueOf(rs.getInt(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}

	/**
	 * 新增发卡会员数 每月持有缤分联盟或缤分联盟联名卡会员数量
	 */
	private void getNewlyGetCardMemberNum(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection crmconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select count(distinct ms.member_id) from membership ms where ms.activeflag = 'effective'and ms.cardstatus = '2'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append(" and ms.startdate  >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append(" and ms.startdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 2: " + sbsql.toString());

		pstmt = crmconn.prepareStatement(sbsql.toString());

		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyGetCardMemberNum(String.valueOf(rs.getInt(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}

	/**
	 * 新增注册会员数 每月申请并注册激活的缤分联盟会员数量
	 */
	private void getNewlyRegisterMemberNum(StringBuffer sbsql,
			String contractStartDateFromStr, String contractStartDateToStr,
			Connection crmconn, PreparedStatement pstmt, ResultSet rs,
			ChinarewardsManagerReportRes res) throws Exception {

		sbsql = new StringBuffer(
				"select count(*) from member m where m.activeflag='effective' and m.memberstatus = 'activated'");

		if (contractStartDateFromStr != null
				&& !contractStartDateFromStr.isEmpty()) {

			sbsql.append("and m.registdate >= ").append(
					getOracleDateStr(true, contractStartDateFromStr));

		}

		if (contractStartDateToStr != null && !contractStartDateToStr.isEmpty()) {
			sbsql.append("and m.registdate <= ").append(
					getOracleDateStr(false, contractStartDateToStr));
		}

		log.info("getChinarewardsMamagerReport 1: " + sbsql.toString());

		pstmt = crmconn.prepareStatement(sbsql.toString());

		rs = pstmt.executeQuery();
		if (rs.next()) {
			res.setNewlyRegisterMemberNum(String.valueOf(rs.getInt(1)));
		}

		SqlUtil.close(rs);
		SqlUtil.close(pstmt);

	}

	/**
	 * 获取2个时间之间的天数
	 * 
	 * @param d
	 *            format yyyy/mm/dd
	 * @param d1
	 *            format yyyy/mm/dd
	 * @return days
	 */
	private int getDayOfTwoDate(String d, String d1) {
		String[] ds = d.split("/");
		String[] ds1 = d1.split("/");

		GregorianCalendar gc = new GregorianCalendar();
		gc.set(Calendar.YEAR, Integer.valueOf(ds[0]).intValue());
		gc.set(Calendar.MONTH, Integer.valueOf(ds[1]).intValue());
		gc.set(Calendar.DAY_OF_MONTH, Integer.valueOf(ds[2]).intValue());
		gc.set(Calendar.HOUR_OF_DAY, 0);
		gc.set(Calendar.MINUTE, 0);
		gc.set(Calendar.SECOND, 1);

		GregorianCalendar gc1 = new GregorianCalendar();
		gc1.set(Calendar.YEAR, Integer.valueOf(ds1[0]).intValue());
		gc1.set(Calendar.MONTH, Integer.valueOf(ds1[1]).intValue());
		gc1.set(Calendar.DAY_OF_MONTH, Integer.valueOf(ds1[2]).intValue());
		gc1.set(Calendar.HOUR_OF_DAY, 23);
		gc1.set(Calendar.MINUTE, 59);
		gc1.set(Calendar.SECOND, 59);

		long l = gc.getTimeInMillis();
		long ll = gc1.getTimeInMillis();

		long r = (ll - l) / (1000 * 60 * 60 * 24) + 1;
		return new Long(r).intValue();
	}

	/**
	 * 
	 * @param isHeadOfMonth
	 * @param dateStr
	 * @return format like to_date('1980-01-01 00:00:01','yyyy-MM-dd
	 *         HH24:mi:ss') or to_date('1980-01-31 23:59:59','yyyy-MM-dd
	 *         HH24:mi:ss')
	 */
	private String getOracleDateStr(boolean isHeadOfMonth, String dateStr) {
		String[] ds = dateStr.split("/");
		String newdate = "to_date('".concat(ds[0]).concat("-").concat(ds[1])
				.concat("-").concat(ds[2]);

		String res;
		if (isHeadOfMonth) {
			res = newdate.concat(" 00:00:01','yyyy-MM-dd HH24:mi:ss')");
		} else {
			res = newdate.concat(" 23:59:59','yyyy-MM-dd HH24:mi:ss')");
		}

		return res;

	}

}
