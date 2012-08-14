package com.chinarewards.report.coastalcity;

import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.omg.Dynamic.Parameter;

import com.chinarewards.report.db.impl.PosnetDb;

/**
 * 海岸之城7月活动service
 * 
 * @author weishengshui
 * 
 */
public class CoastlCityService {

	// 总计报表
	public FunctionCountVo getQQMeishiActionHistoryLists(String fromDate,
			String toDate) {

		FunctionCountVo result = new FunctionCountVo();

		PosnetDb db = null;
		Calendar fromday = stringFormatDateToCalendar(fromDate);

		Calendar todate = stringFormatDateToCalendar(toDate);

		Calendar today = new GregorianCalendar();

		if (fromday.after(today)) {
			return result;
		}
		if (fromday.after(todate)) {
			return result;
		}
		if (today.after(todate)) {
			today = todate;
		}
		try {
			db = new PosnetDb();

			ResultSet rs = null;
			db.OpenConn();

			toDate = CalendarToStringFormatDate(today);
			// 领取礼品总数
			StringBuffer sqlGift = new StringBuffer(
					"select count(*) from QQMeishiXaction ");
			sqlGift = concatLimitTime(sqlGift, "ts", fromDate, toDate);
			sqlGift.append(" and posid in ('SCL-00000001', 'SCL-00000002', 'SCL-00000003') and xactResultCode = '0' ");
			System.out.println("海岸之城----总计报表 礼品 SQL:" + sqlGift.toString());
			rs = db.executeQuery(sqlGift.toString());

			if (rs.next()) {
				result.setGiftCount(rs.getInt(1));
			}

			// 获取优惠总数
			StringBuffer sqlPrivilege = new StringBuffer(
					"select count(*) from QQMeishiXaction mshi, Merchant m1, Activitymerchant am1 ");
			sqlPrivilege = concatLimitTime(sqlPrivilege, "mshi.ts", fromDate, toDate);
			sqlPrivilege
					.append(" and mshi.posid not in ('SCL-00000001', 'SCL-00000002', 'SCL-00000003')  and mshi.posid = am1.posid and am1.merchant_id = m1.id  and am1.activity_id='01'  and xactResultCode = '0'   ");
			System.out.println("海岸之城----总计报表 优惠 SQL:" + sqlPrivilege.toString());
			rs = db.executeQuery(sqlPrivilege.toString());

			if (rs.next()) {
				result.setPrivilegeCount(rs.getInt(1));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			db.closeConn();
		}

		return result;
	}

	// 每日总计报表
	public List<FunctionCountOfDayVo> getQQMeishiActionCountOfDay(
			String fromDate, String toDate) {

		List<FunctionCountOfDayVo> fcdvs = new ArrayList<FunctionCountOfDayVo>();
		PosnetDb db = null;

		Calendar fromday = stringFormatDateToCalendar(fromDate);

		Calendar todate = stringFormatDateToCalendar(toDate);

		Calendar today = new GregorianCalendar();

		if (fromday.after(today)) {
			return null;
		}
		if (fromday.after(todate)) {
			return null;
		}
		if (today.after(todate)) {
			today = todate;
		}

		try {
			db = new PosnetDb();

			ResultSet rs = null;
			db.OpenConn();

			StringBuffer sqlBuffer = new StringBuffer(
					"select date_format(ts,'%Y/%m/%d'),count(*), "
							+ " (select count(*) from QQMeishiXaction q2 ");
			sqlBuffer = concatLimitTime(sqlBuffer, "q2.ts",
					CalendarToStringFormatDate(fromday),
					CalendarToStringFormatDate(today));
			sqlBuffer
					.append(" and year(q1.ts) = year(q2.ts) and "
							+ " month(q1.ts) = month(q2.ts) and day(q1.ts) = day(q2.ts) and "
							+ " q2.xactResultCode = '0' and q2.posid in ('SCL-00000001', 'SCL-00000002', 'SCL-00000003')) as 领取礼品数"
							+ " from QQMeishiXaction q1, Activitymerchant am  ");
			sqlBuffer = concatLimitTime(sqlBuffer, "q1.ts",
					CalendarToStringFormatDate(fromday),
					CalendarToStringFormatDate(today));
			sqlBuffer
					.append(" and q1.xactResultCode = '0' and  am.activity_id='01' and am.posid = q1.posid group by year(ts),month(ts),day(ts)");
			System.out.println("海岸之城----每日总计报表 优惠 SQL:" + sqlBuffer.toString());
			rs = db.executeQuery(sqlBuffer.toString());

			// while (rs.next()) {
			// String stringDate = rs.getString(1);
			// int total = rs.getInt(2);
			// int giftNum = rs.getInt(3);
			// int privilegeNum = total - giftNum;
			//
			// FunctionCountVo fcv = new FunctionCountVo();
			// fcv.setGiftCount(giftNum);
			// fcv.setPrivilegeCount(privilegeNum);
			// FunctionCountOfDayVo fcdv = new FunctionCountOfDayVo();
			// fcdv.setDay(stringDate);
			// fcdv.setFc(fcv);
			// fcdvs.add(fcdv);
			// }

			Map<String, FunctionCountVo> dataFrombase = new HashMap<String, FunctionCountVo>();
			while (rs.next()) {
				String stringDate = rs.getString(1);
				int total = rs.getInt(2);
				int giftNum = rs.getInt(3);
				int privilegeNum = total - giftNum;

				FunctionCountVo fcv = new FunctionCountVo();
				fcv.setGiftCount(giftNum);
				fcv.setPrivilegeCount(privilegeNum);
				System.out.println("海岸之城----每日总计报表 while: " + stringDate);
				dataFrombase.put(stringDate, fcv);
			}
			int bet = getDaysBetween(fromday, today);
			if (dataFrombase.size() == 0) {
				for (int i = 0; i < bet + 1; i++) {
					String tmpDay = CalendarToStringFormatDate(fromday);
					FunctionCountVo fcv = new FunctionCountVo();
					FunctionCountOfDayVo countOfDayVo = new FunctionCountOfDayVo();
					countOfDayVo.setDay(tmpDay);
					countOfDayVo.setFc(fcv);

					fcdvs.add(countOfDayVo);

					fromday.add(Calendar.DATE, 1);
				}
			} else {
				for (int i = 0; i < bet + 1; i++) {
					String tmpDay = CalendarToStringFormatDate(fromday);
					FunctionCountVo fcv = dataFrombase.get(tmpDay);

					System.out.println("for:" + tmpDay);
					System.out.println("FunctionCountVo:" + fcv);
					if (fcv == null) {
						fcv = new FunctionCountVo();
					}
					FunctionCountOfDayVo countOfDayVo = new FunctionCountOfDayVo();
					countOfDayVo.setDay(tmpDay);
					countOfDayVo.setFc(fcv);

					fcdvs.add(countOfDayVo);

					fromday.add(Calendar.DATE, 1);
				}
			}
			dataFrombase.clear();

			rs.close();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			db.closeConn();
		}

		return fcdvs;
	}

	// 商户汇总报表
	public List<QQMeishiActionHistoryShopVO> getQQMeishiActionCountOfShop(
			String fromDate, String toDate) {
		List<QQMeishiActionHistoryShopVO> historyShopVOs = new ArrayList<QQMeishiActionHistoryShopVO>();
		PosnetDb db = null;

		Calendar fromday = stringFormatDateToCalendar(fromDate);

		Calendar todate = stringFormatDateToCalendar(toDate);

		Calendar today = new GregorianCalendar();

		if (fromday.after(today)) {
			return getNullMerchant();
		}
		if (fromday.after(todate)) {
			return getNullMerchant();
		}
		if (today.after(todate)) {
			today = todate;
		}

		try {
			db = new PosnetDb();

			ResultSet rs = null;
			db.OpenConn();

			String fd = CalendarToStringFormatDate(fromday);
			String td = CalendarToStringFormatDate(today);

			StringBuffer sqlBuffer = new StringBuffer(
					"select m1.id,m1.Merchant_name,(select count(*) "
							+ "from QQMeishiXaction mshi1, Activitymerchant am2  ");
			sqlBuffer = concatLimitTime(sqlBuffer, "mshi1.ts", fd, td);
			sqlBuffer
					.append(" and mshi1.xactResultCode = '0' and mshi1.posid in ('SCL-00000001', 'SCL-00000002', 'SCL-00000003') "
							+ " and mshi1.posid = am2.posid and am2.merchant_id = am1.merchant_id ) as 换取礼品总数 ,"
							+ "(select count(*) from QQMeishiXaction mshi2, Activitymerchant am3  ");
			sqlBuffer = concatLimitTime(sqlBuffer, "mshi2.ts", fd, td);
			sqlBuffer
					.append(" and  mshi2.xactResultCode = 0 "
							+ " and mshi2.posid not in ('SCL-00000001', 'SCL-00000002', 'SCL-00000003') "
							+ " and mshi2.posid = am3.posid and am3.merchant_id = am1.merchant_id) as 兑换优惠总数 ,");
			sqlBuffer
					.append(" (select sum(mshi3.consumeAmount) from QQMeishiXaction mshi3 , Activitymerchant am4  ");
			sqlBuffer = concatLimitTime(sqlBuffer, "mshi3.ts", fd, td);
			sqlBuffer
					.append(" and mshi3.xactResultCode = '0' and mshi3.posid not in ('SCL-00000001', 'SCL-00000002', 'SCL-00000003') "
							+ " and mshi3.posid = am4.posid and am4.merchant_id = am1.merchant_id) as 兑换优惠总金额    from Merchant m1, Activitymerchant am1 ");

			sqlBuffer
					.append(" where am1.activity_id = '01' and am1.merchant_id = m1.id group by am1.merchant_id ");
			System.out.println("海岸之城----商户汇总报表 SQL:" + sqlBuffer.toString());
			rs = db.executeQuery(sqlBuffer.toString());

			while (rs.next()) {
				QQMeishiActionHistoryShopVO actionHistoryShopVO = new QQMeishiActionHistoryShopVO();
				String shopId = rs.getString(1);
				actionHistoryShopVO.setShopId(shopId);
				actionHistoryShopVO.setShopName(rs.getString(2));

				FunctionCountVo fcv = new FunctionCountVo();
				fcv.setGiftCount(rs.getInt(3));
				fcv.setPrivilegeCount(rs.getInt(4));
				actionHistoryShopVO.setAmount(rs.getDouble(5));
				actionHistoryShopVO.setFcv(fcv);

				List<EveryPosEveryTypeCount> everyPosEveryTypeCounts = new ArrayList<EveryPosEveryTypeCount>();
				ResultSet rs2 = null;
				StringBuffer sqlBuffer2 = new StringBuffer(
						"select am1.posid, (select count(*)"
								+ " from QQMeishiXaction mshi  ");

				sqlBuffer2 = concatLimitTime(sqlBuffer2, "mshi.ts", fd, td);
				sqlBuffer2
						.append(" and mshi.xactResultCode = 0 and am1.posid = mshi.posid) as pos机交易总数 "
								+ " from Activitymerchant am1 where am1.Merchant_id = '"
								+ shopId + "'");
				System.out.println("pos sql: " + sqlBuffer2.toString());
				rs2 = db.executeQuery(sqlBuffer2.toString());
				while (rs2.next()) {
					String posId = rs2.getString(1);

					int count = rs2.getInt(2);
					if (count > 0) {
						EveryPosEveryTypeCount everyPosEveryTypeCount = new EveryPosEveryTypeCount();
						everyPosEveryTypeCount.setPosId(posId);
						everyPosEveryTypeCount.setCount(count);
						String[] giftPos = { "SCL-00000001", "SCL-00000002",
								"SCL-00000003" };
						boolean isGift = false;
						for (int i = 0; i < giftPos.length; i++) {
							if (posId.equals(giftPos[i])) {
								isGift = true;
								break;
							}
						}
						if (isGift) {
							everyPosEveryTypeCount.setType("GIFT");
						} else {
							everyPosEveryTypeCount.setType("PRIVILEGE");
						}
						everyPosEveryTypeCounts.add(everyPosEveryTypeCount);
					}
				}
				actionHistoryShopVO
						.setEveryPosEveryTypeCounts(everyPosEveryTypeCounts);
				historyShopVOs.add(actionHistoryShopVO);
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			db.closeConn();
		}
		return historyShopVOs;
	}

	// 查询验证码使用情况
	public QQMeishiActionHistoryVO getQQMeishiActionHistoryVO(String userToken) {
		PosnetDb db = null;
		try {
			db = new PosnetDb();

			StringBuffer sql = new StringBuffer(
					"select m1.merchant_name as 商家名称,"
							+ "a1.posid as POS机编号,mshi.qqUserToken as 验证码,mshi.consumeAmount as 消费金额,"
							+ "mshi.ts as 交易时间 from Merchant m1,Activitymerchant a1,QQMeishiXaction mshi where mshi.qqUserToken ='"
							+ userToken
							+ "'"
							+ " and a1.activity_id = '01' and mshi.xactResultCode = '0' and mshi.posid = a1.posid "
							+ "and a1.merchant_id = m1.id ");
			db.OpenConn();
			ResultSet rs = db.executeQuery(sql.toString());
			System.out.println("海岸之城----查询验证码使用情况 SQL: "+sql.toString());
			
			if (rs.next()) {
				QQMeishiActionHistoryVO actionHistoryVO = new QQMeishiActionHistoryVO();
				actionHistoryVO.setShopName(rs.getString(1));
				actionHistoryVO.setPosId(rs.getString(2));
				actionHistoryVO.setQqUserToken(rs.getString(3));
				actionHistoryVO.setConsumeAmt(rs.getDouble(4));
				actionHistoryVO.setTime(rs.getString(5));
				System.out.println("海岸之城----查询验证码使用情况 ts: "+ rs.getString(5));
				rs.close();
				return actionHistoryVO;
			}
			rs.close();
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			db.closeConn();
		}
	}
	
	//明细列表
	public List<QQMeishiActionHistoryVO> getDetailList(String fromDate, String toDate, String shopId, int page, int size){
		
		List<QQMeishiActionHistoryVO> actionHistoryVOs=null;
		PosnetDb db = null;

		Calendar fromday = stringFormatDateToCalendar(fromDate);

		Calendar todate = stringFormatDateToCalendar(toDate);

		Calendar today = new GregorianCalendar();

		if (fromday.after(today)) {
			return null;
		}
		if (fromday.after(todate)) {
			return null;
		}
		if (today.after(todate)) {
			today = todate;
		}

		try {
			actionHistoryVOs= new ArrayList<QQMeishiActionHistoryVO>();
			db = new PosnetDb();

			ResultSet rs = null;
			db.OpenConn();
			
			
			String fd = CalendarToStringFormatDate(fromday);
			String td = CalendarToStringFormatDate(today);
			
			StringBuffer sql;
			if(shopId.equals("all")){//查询所有商户的
				sql = new StringBuffer("select m1.merchant_name as 商家名称,a1.posid as POS机编号,mshi.qqUserToken as 验证码,mshi.consumeAmount as 消费金额,mshi.ts as 交易时间  " +
				" from Merchant m1,Activitymerchant a1,QQMeishiXaction mshi ");
				sql = concatLimitTime(sql, "mshi.ts", fd, td);
				sql.append(" and a1.activity_id = '01'  and a1.merchant_id = m1.id and mshi.posid = a1.posid and mshi.xactResultCode = '0' "
				+"  order by  mshi.ts desc, m1.id asc   limit "+
				(page-1)*size
				+","+size);
			}else{//查询指定商户的
				sql = new StringBuffer("select m1.merchant_name as 商家名称,a1.posid as POS机编号,mshi.qqUserToken as 验证码,mshi.consumeAmount as 消费金额,mshi.ts as 交易时间  " +
				" from Merchant m1,Activitymerchant a1,QQMeishiXaction mshi ");
				sql = concatLimitTime(sql, "mshi.ts", fd, td);
				sql.append(" and a1.activity_id = '01'  and a1.merchant_id = m1.id and mshi.posid = a1.posid and mshi.xactResultCode = '0'  and m1.id = '"+
				shopId
				+"' order by m1.id asc, mshi.ts desc  limit "+
				(page-1)*size
				+","+size);

			}
			
			rs = db.executeQuery(sql.toString());
			
			System.out.println("海岸之城----明细列表 SQL: "+sql.toString());
			
			while(rs.next()){
				QQMeishiActionHistoryVO actionHistoryVO = new QQMeishiActionHistoryVO();
				actionHistoryVO.setShopName(rs.getString(1));
				actionHistoryVO.setPosId(rs.getString(2));
				actionHistoryVO.setQqUserToken(rs.getString(3));
				actionHistoryVO.setConsumeAmt(rs.getDouble(4));
				actionHistoryVO.setTime(rs.getString(5));
				System.out.println("海岸之城----明细列表 ts: "+ rs.getString(5));
				actionHistoryVOs.add(actionHistoryVO);
			}
			rs.close();
			
			return actionHistoryVOs;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			db.closeConn();
		}
	}
	
	//获取明细列表总记录数
	public int getDetailRecordesCount(String fromDate, String toDate, String shopId){
		
		PosnetDb db = null;
		int sum = 0;
		
		Calendar fromday = stringFormatDateToCalendar(fromDate);

		Calendar todate = stringFormatDateToCalendar(toDate);

		Calendar today = new GregorianCalendar();

		if (fromday.after(today)) {
			return sum;
		}
		if (fromday.after(todate)) {
			return sum;
		}
		if (today.after(todate)) {
			today = todate;
		}
		
		try {
			String fd = CalendarToStringFormatDate(fromday);
			String td = CalendarToStringFormatDate(today);
			
			
			db = new PosnetDb();
			db.OpenConn();
			
			ResultSet rs = null;
			StringBuffer sql ;
			if(shopId.equals("all")){
				sql = new StringBuffer("select count(*) as 数据总量 " +
				"from Merchant m1,Activitymerchant a1,QQMeishiXaction mshi ");
				sql = concatLimitTime(sql, "mshi.ts", fd, td);
				sql.append(" and a1.activity_id = '01' and a1.merchant_id = m1.id " +
				" and mshi.posid = a1.posid and mshi.xactResultCode = '0' ");
			}else {
				sql = new StringBuffer("select count(*) as 数据总量 " +
				"from Merchant m1,Activitymerchant a1,QQMeishiXaction mshi ");
				sql = concatLimitTime(sql, "mshi.ts", fd, td);
				sql.append(" and a1.activity_id = '01' and a1.merchant_id = m1.id " +
				" and mshi.posid = a1.posid and mshi.xactResultCode = '0'  and m1.id = '"+
				shopId//商户ID
				+"'");
			}
			
			rs = db.executeQuery(sql.toString());
			System.out.println("海岸之城----获取明细列表总记录数 SQL: "+sql.toString());
			if(rs.next()){
				sum = rs.getInt(1);
			}
			rs.close();
			return sum;
		} catch (Exception e) {
			e.printStackTrace();
			return sum;
		}finally{
			db.closeConn();
		}
	}
	
	//获取商户列表Map<K, V>对应 <Merchant_ID, Merchant_NAME>
	public Map<List<String>,List<String>> getMerchantList(){
		
		PosnetDb db = null;
		try {
			Map<List<String>,List<String>> merchantNames = new HashMap<List<String>,List<String>>();
			List<String> idList = new ArrayList<String>();
			List<String> shopNameList = new ArrayList<String>();
			db = new PosnetDb();
			db.OpenConn();
			ResultSet rs = null;

			String sql = " select m1.id as 商户ID,m1.merchant_name as 商户名称  " +
					" from Merchant m1 where  m1.id in (select a1.merchant_id  from Activitymerchant a1 " +
					" where a1.activity_id = '01') order by m1.id asc";
			rs = db.executeQuery(sql);
			System.out.println("海岸之城----获取商户列表 SQL: "+sql);
			
			while(rs.next()){
				idList.add(rs.getString(1));
				shopNameList.add(rs.getString(2));
			}if(idList.size()!=0&&shopNameList.size()!=0){
				merchantNames.put(idList, shopNameList);
			}
			rs.close();
			return merchantNames;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}finally{
			db.closeConn();
		}
	}
	private StringBuffer concatLimitTime(StringBuffer sqlBuf,
			String timeFieldName, String fromDate, String toDate) {
		if (fromDate != null && !fromDate.isEmpty()) {

			sqlBuf.append(" where ").append(timeFieldName).append(" >= '")
					.append(getMysqlDateStr(true, fromDate)).append("'");

		}

		if (toDate != null && !toDate.isEmpty()) {
			sqlBuf.append(" and ").append(timeFieldName).append(" <= '")
					.append(getMysqlDateStr(false, toDate)).append("'");
		}

		System.out.println("after concatLimitTime sql is " + sqlBuf.toString());

		return sqlBuf;
	}

	private String getMysqlDateStr(boolean isHeadOfMonth, String dateStr) {
		String[] ds = dateStr.split("/");
		String newdate = ds[0].concat("-").concat(ds[1]).concat("-")
				.concat(ds[2]);

		String res;
		if (isHeadOfMonth) {
			res = newdate.concat(" 00:00:00");
		} else {
			res = newdate.concat(" 23:59:59");
		}

		return res;

	}

	private Calendar stringFormatDateToCalendar(String stringDate) {
		try {
			String[] ds = stringDate.split("/");
			int year = Integer.valueOf(ds[0]).intValue();
			int month = Integer.valueOf(ds[1]).intValue() - 1;
			int day = Integer.valueOf(ds[2]).intValue();

			Calendar calendar = new GregorianCalendar(year, month, day);

			return calendar;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	private String CalendarToStringFormatDate(Calendar calendar) {
		try {
			int yearto = calendar.get(Calendar.YEAR);
			int monthto = calendar.get(Calendar.MONTH) + 1;
			int dayto = calendar.get(Calendar.DAY_OF_MONTH);

			String monthStr = null;
			if (monthto < 10) {
				monthStr = "0" + monthto;
			} else {
				monthStr = "" + monthto;
			}

			String dayStr = null;
			if (dayto < 10) {
				dayStr = "0" + dayto;
			} else {
				dayStr = "" + dayto;
			}

			String stringDate = new String(yearto + "/" + monthStr + "/"
					+ dayStr);

			return stringDate;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	private int getDaysBetween(java.util.Calendar d1, java.util.Calendar d2) {
		if (d1.after(d2)) { // swap dates so that d1 is start and d2 is end
			java.util.Calendar swap = d1;
			d1 = d2;
			d2 = swap;
		}
		int days = d2.get(java.util.Calendar.DAY_OF_YEAR)
				- d1.get(java.util.Calendar.DAY_OF_YEAR);
		int y2 = d2.get(java.util.Calendar.YEAR);
		if (d1.get(java.util.Calendar.YEAR) != y2) {
			d1 = (java.util.Calendar) d1.clone();
			do {
				days += d1.getActualMaximum(java.util.Calendar.DAY_OF_YEAR);
				d1.add(java.util.Calendar.YEAR, 1);
			} while (d1.get(java.util.Calendar.YEAR) != y2);
		}
		return days;
	}

	private List<QQMeishiActionHistoryShopVO> getNullMerchant() {
		PosnetDb db = null;
		try {
			List<QQMeishiActionHistoryShopVO> historyShopVOs = new ArrayList<QQMeishiActionHistoryShopVO>();
			db = new PosnetDb();
			String sqlStr = "select  m1.id,m1.Merchant_name from Merchant m1 group by id ";
			db.OpenConn();
			ResultSet rs = db.executeQuery(sqlStr);
			while (rs.next()) {
				QQMeishiActionHistoryShopVO actionHistoryShopVO = new QQMeishiActionHistoryShopVO();
				actionHistoryShopVO.setEveryPosEveryTypeCounts(null);
				actionHistoryShopVO.setFcv(new FunctionCountVo());
				actionHistoryShopVO.setShopId(rs.getString(1));
				actionHistoryShopVO.setShopName(rs.getString(2));
				actionHistoryShopVO.setAmount(0);
				historyShopVOs.add(actionHistoryShopVO);
			}
			if (historyShopVOs.size() == 0) {
				return null;
			}
			return historyShopVOs;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			db.closeConn();
		}
	}
}
