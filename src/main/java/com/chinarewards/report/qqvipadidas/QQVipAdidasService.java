package com.chinarewards.report.qqvipadidas;

import java.sql.ResultSet;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import com.chinarewards.report.db.impl.PosnetDb;

public class QQVipAdidasService {

	private static String posIds = "('CR-000000320','CR-000000304','CR-000000155','CR-000000309','CR-000000047','CR-000000084','CR-000000097','CR-000000321','CR-000000230','CR-000000329','CR-000000206','CR-000000229','CR-000000306','CR-000000216','CR-000000234','CR-000000095','CR-000000305','CR-000000159','CR-000000079','CR-000000208','CR-000000226','CR-000000333','CR-000000283','CR-000000214','CR-000000263','CR-000000335','CR-000000402','CR-000000227','CR-000000057','CR-000000290','CR-000000036','CR-000000409','CR-000000025','CR-000000184','CR-000000266','CR-000000318','CR-000000120','CR-000000015','CR-000000243','CR-000000212','CR-000000179','CR-000000004','CR-000000080','CR-000000096','CR-000000008')";

	public List<QQActiveHistoryVOOfShopOfDayVo> getQQActiveHistoryListOfShopOfDay(
			String fromDate, String ptoDate) {
		List<QQActiveHistoryVOOfShopOfDayVo> result = new LinkedList<QQActiveHistoryVOOfShopOfDayVo>();

		PosnetDb db = new PosnetDb();

		try {

			String[] ds = fromDate.split("/");
			int year = Integer.valueOf(ds[0]).intValue();
			int month = Integer.valueOf(ds[1]).intValue() - 1;
			int day = Integer.valueOf(ds[2]).intValue();

			Calendar fromday = new GregorianCalendar(year, month, day);

			String[] tos = ptoDate.split("/");
			int yearto = Integer.valueOf(tos[0]).intValue();
			int monthto = Integer.valueOf(tos[1]).intValue() - 1;
			int dayto = Integer.valueOf(tos[2]).intValue();

			Calendar todate = new GregorianCalendar(yearto, monthto, dayto);

			Calendar today = new GregorianCalendar();

			if (fromday.after(today)) {
				return result;
			}

			if (today.after(todate)) {
				today = todate;
			}

			int bet = getDaysBetween(today, fromday);

			db.OpenConn();

			for (int i = 0; i < bet + 1; i++) {

				year = fromday.get(Calendar.YEAR);
				month = fromday.get(Calendar.MONDAY) + 1;
				day = fromday.get(Calendar.DATE);
				String toDate = new String(year + "/" + (month) + "/" + day);
				List<QQActiveHistoryVOOfShop> listshop = getQQActiveHistoryListOfShop(
						toDate, toDate, db);

				for (QQActiveHistoryVOOfShop shopvo : listshop) {
					if (shopvo.getVoList() == null) {
						System.out.println(shopvo.getShopId()
								+ " ------ list is null");
					}

				}

				QQActiveHistoryVOOfShopOfDayVo fvo = new QQActiveHistoryVOOfShopOfDayVo();
				fvo.setDay(toDate);
				fvo.setListOfday(listshop);
				result.add(fvo);
				fromday.add(Calendar.DATE, 1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			db.closeConn();
		}

		return result;
	}

	private List<QQActiveHistoryVOOfShop> getQQActiveHistoryListOfShop(
			String fromDate, String toDate, PosnetDb db) {
		// List<QQActiveHistoryVO> list = new LinkedList<QQActiveHistoryVO>();

		List<QQActiveHistoryVOOfShop> result = initQQActiveHistoryVOOfShopReport();

		try {

			ResultSet rs = null;
			db.OpenConn();

			StringBuffer sqlBuf = new StringBuffer(
					"select id,memberKey,aType,consumeAmt,rebateAmt,posId,DATE_FORMAT( createdAt, '%Y-%m-%d %k:%i:%s' ) createdAt from QQActivityHistory ");

			StringBuffer sqlBuffer = concatLimitTime(sqlBuf, "createdAt",
					fromDate, toDate);

			sqlBuffer.append(" order by createdAt");

			rs = db.executeQuery(sqlBuffer.toString());
			List<QQActiveHistoryVO> hislist = new LinkedList<QQActiveHistoryVO>();

			while (rs.next()) {
				QQActiveHistoryVO vo = new QQActiveHistoryVO();
				vo.setId((rs.getString("id")));
				vo.setMemberkey(rs.getString("memberKey"));
				vo.setAType(rs.getString("aType"));
				vo.setConsumeAmt(rs.getDouble("consumeAmt"));
				vo.setRebateAmt(rs.getDouble("rebateAmt"));
				vo.setPosId(rs.getString("posId"));
				vo.setTime(rs.getString("createdAt"));
				hislist.add(vo);

			}

			for (QQActiveHistoryVO vo : hislist) {
				String shopName = PosOfCity.getMerchantNameByPosId(vo
						.getPosId());

				for (QQActiveHistoryVOOfShop shopvo : result) {

					// System.out
					// .print("In the getQQActiveHistoryListOfShop shopName is "
					// + shopName
					// + " shopvo.getShopName is "
					// + shopvo.getShopName());

					if (shopName.equals(shopvo.getShopName())) {
						// System.out.println("  is equals");

						List<QQActiveHistoryVO> list = shopvo.getVoList();

						// for(QQActiveHistoryVO hvo:list)
						// {
						// hvo.setMerchantName(shopName);
						// }

						vo.setMerchantName(shopName);

						list.add(vo);
						shopvo.setVoList(list);
						// System.out.println("shopid is " + shopvo.getShopId()
						// + " , list size is " + shopvo.getVoList().size());

						break;
					}
				}
			}
			rs.close();
			db.closeStmt();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	public List<QQActiveHistoryVO> getQQActiveHistoryList(String aType,
			String fromDate, String toDate) {
		List<QQActiveHistoryVO> list = new LinkedList<QQActiveHistoryVO>();

		try {
			PosnetDb db = new PosnetDb();
			ResultSet rs = null;
			db.OpenConn();

			StringBuffer sqlBuf = new StringBuffer(
					"select id,memberKey,aType,consumeAmt,rebateAmt,posId,DATE_FORMAT( createdAt, '%Y-%m-%d %k:%i:%s' ) createdAt from QQActivityHistory ");

			StringBuffer sqlBuffer = concatLimitTime(sqlBuf, "createdAt",
					fromDate, toDate);
			
			sqlBuffer.append(" and posId in ").append(posIds);

			sqlBuffer.append(" and aType = '").append(aType).append(
					"' order by posId,createdAt desc");

			rs = db.executeQuery(sqlBuffer.toString());
			while (rs.next()) {
				QQActiveHistoryVO vo = new QQActiveHistoryVO();
				vo.setId((rs.getString("id")));
				vo.setMemberkey(rs.getString("memberKey"));
				vo.setAType(rs.getString("aType"));
				vo.setConsumeAmt(rs.getDouble("consumeAmt"));
				vo.setRebateAmt(rs.getDouble("rebateAmt"));
				String posId = rs.getString("posId");
				vo.setPosId(posId);
				vo.setTime(rs.getString("createdAt"));
				String merchantName = PosOfCity.getMerchantNameByPosId(posId);
				vo.setMerchantName(merchantName);
				
				if(!"未知".equals(merchantName))
				{
					list.add(vo);
				}
				
			}
			rs.close();
			db.closeStmt();
			db.closeConn();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<QQWeiXinSignIn> getQQWeiXinSignIn(String fromDate, String toDate) {

		List<QQWeiXinSignIn> list = new LinkedList<QQWeiXinSignIn>();

		try {
			PosnetDb db = new PosnetDb();
			ResultSet rs = null;
			db.OpenConn();

			StringBuffer sqlBuf = new StringBuffer(
					"select id,weixinNo,posId,DATE_FORMAT( createdAt, '%Y-%m-%d %k:%i:%s' ) createdAt from QQWeixinSignIn ");

			StringBuffer sqlBuffer = concatLimitTime(sqlBuf, "createdAt",
					fromDate, toDate);
			
			sqlBuffer.append(" and posId in ").append(posIds);

			sqlBuffer.append(" order by posId,createdAt desc");
			rs = db.executeQuery(sqlBuffer.toString());
			while (rs.next()) {
				QQWeiXinSignIn vo = new QQWeiXinSignIn();
				vo.setId((rs.getString("id")));
				vo.setWeixinNo(rs.getString("weixinNo"));
				vo.setPosId(rs.getString("posId"));
				vo.setTime(rs.getString("createdAt"));
				list.add(vo);
			}
			rs.close();
			db.closeStmt();
			db.closeConn();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;

	}

	public List<FunctionCountOfDayVo> getQQActiveMemberCountOfDay(
			String fromDate,String ptoDate) {

		List<FunctionCountOfDayVo> res = new LinkedList<FunctionCountOfDayVo>();

		try {

			String[] ds = fromDate.split("/");
			int year = Integer.valueOf(ds[0]).intValue();
			int month = Integer.valueOf(ds[1]).intValue() - 1;
			int day = Integer.valueOf(ds[2]).intValue();

			Calendar fromday = new GregorianCalendar(year, month, day);
			
			ds = ptoDate.split("/");
			year = Integer.valueOf(ds[0]).intValue();
			month = Integer.valueOf(ds[1]).intValue() - 1;
			day = Integer.valueOf(ds[2]).intValue();
			
			Calendar toDate = new GregorianCalendar(year, month, day);

			Calendar today = new GregorianCalendar();
			
			if(today.after(toDate))
			{
				today = toDate;
			}

			int bet = getDaysBetween(today, fromday);

			PosnetDb db = new PosnetDb();
			db.OpenConn();

			for (int i = 0; i < bet + 1; i++) {

				year = fromday.get(Calendar.YEAR);
				month = fromday.get(Calendar.MONDAY) + 1;
				day = fromday.get(Calendar.DATE);
				String date = new String(year + "/" + (month) + "/" + day);
				FunctionCountVo vo = getQQActiveMemberCount(date, date, db);
				FunctionCountOfDayVo fvo = new FunctionCountOfDayVo();
				fvo.setDay(date);
				fvo.setFc(vo);
				res.add(fvo);
				fromday.add(Calendar.DATE, 1);
			}

			db.closeConn();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return res;
	}

	private FunctionCountVo getQQActiveMemberCount(String fromDate,
			String toDate, PosnetDb db) {

		FunctionCountVo result = new FunctionCountVo();

		try {
			ResultSet rs = null;

			StringBuffer sqlBuf = new StringBuffer(
					"select count(id) count from QQWeixinSignIn");

			StringBuffer sql = concatLimitTime(sqlBuf, "createdAt", fromDate,
					toDate);
			
			sql.append(" and posId in ").append(posIds);

			rs = db.executeQuery(sql.toString());
			if (rs.next()) {
				result.setWeixinCount(rs.getInt("count"));
			}
			rs.close();

			sqlBuf = new StringBuffer(
					"select count(id) count from QQActivityHistory");
			sql = concatLimitTime(sqlBuf, "createdAt", fromDate, toDate);
			sql = sql.append(" and aType = 'GIFT'");
			sql.append(" and posId in ").append(posIds);
			rs = db.executeQuery(sql.toString());
			if (rs.next()) {
				result.setGiftCount(rs.getInt("count"));
			}
			rs.close();

			sqlBuf = new StringBuffer(
					"select count(id) count from QQActivityHistory");
			sql = concatLimitTime(sqlBuf, "createdAt", fromDate, toDate);
			sql = sql.append(" and aType = 'PRIVILEGE'");
			sql.append(" and posId in ").append(posIds);
			
			rs = db.executeQuery(sql.toString());
			if (rs.next()) {
				result.setPrivilegeCount(rs.getInt("count"));
			}
			rs.close();

			sqlBuf = new StringBuffer(
					"select count(id) count from QQActivityMember");
			sql = concatLimitTime(sqlBuf, "createdAt", fromDate, toDate);
			
			
			rs = db.executeQuery(sql.toString());
			if (rs.next()) {
				result.setMemberKeyCount(rs.getInt("count"));
			}
			rs.close();
			db.closeStmt();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	public FunctionCountVo getQQActiveMemberCount(String fromDate, String toDate) {

		FunctionCountVo result = new FunctionCountVo();

		try {
			PosnetDb db = new PosnetDb();
			ResultSet rs = null;
			db.OpenConn();

			StringBuffer sqlBuf = new StringBuffer(
					"select count(id) count from QQWeixinSignIn");

			StringBuffer sql = concatLimitTime(sqlBuf, "createdAt", fromDate,
					toDate);
			sql.append(" and posId in ").append(posIds);

			System.out.println("---1 sql is " + sql.toString());

			rs = db.executeQuery(sql.toString());
			if (rs.next()) {
				result.setWeixinCount(rs.getInt("count"));
			}
			rs.close();

			sqlBuf = new StringBuffer(
					"select count(id) count from QQActivityHistory");
			sql = concatLimitTime(sqlBuf, "createdAt", fromDate, toDate);
			sql = sql.append(" and aType = 'GIFT'");
			sql.append(" and posId in ").append(posIds);
			System.out.println("---2 sql is " + sql.toString());
			rs = db.executeQuery(sql.toString());
			if (rs.next()) {
				result.setGiftCount(rs.getInt("count"));
			}
			rs.close();

			sqlBuf = new StringBuffer(
					"select count(id) count from QQActivityHistory");
			sql = concatLimitTime(sqlBuf, "createdAt", fromDate, toDate);
			sql = sql.append(" and aType = 'PRIVILEGE'");
			sql.append(" and posId in ").append(posIds);

			System.out.println("---3 sql is " + sql.toString());
			rs = db.executeQuery(sql.toString());
			if (rs.next()) {
				result.setPrivilegeCount(rs.getInt("count"));
			}
			rs.close();

			sqlBuf = new StringBuffer(
					"select count(id) count from QQActivityMember");
			sql = concatLimitTime(sqlBuf, "createdAt", fromDate, toDate);
			rs = db.executeQuery(sql.toString());
			if (rs.next()) {
				result.setMemberKeyCount(rs.getInt("count"));
			}
			rs.close();

			db.closeStmt();
			db.closeConn();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	public List<PosOfCityRecord> getPosOfCityReport(String fromDate,
			String toDate) {

		List<PosOfCityRecord> report = initReport();

		try {
			PosnetDb db = new PosnetDb();
			ResultSet rs = null;
			db.OpenConn();

			StringBuffer sqlBuf = new StringBuffer(
					"SELECT count( id ) count , posId,aType FROM QQActivityHistory  ");

			StringBuffer sql = concatLimitTime(sqlBuf, "createdAt", fromDate,
					toDate);

			String sql1 = sql.append(" GROUP BY posId,aType").toString();

			rs = db.executeQuery(sql1);
			while (rs.next()) {
				String posId = rs.getString("posId");
				String aType = rs.getString("aType");
				int count = rs.getInt("count");

				PosCount posCount = new PosCount();
				posCount.setAType(aType);
				posCount.setCount(count);
				posCount.setPosId(posId);

				String cityName = PosOfCity.getMerchantNameByPosId(posId);

				// System.out.println(cityName + ":" + posId + ":" + aType + ":"
				// + count);

				int sum = 0;

				for (PosOfCityRecord posOfCityRecord : report) {
					if (cityName.equals(posOfCityRecord.getCityName())) {
						posOfCityRecord.getPosCountList().add(posCount);
						if ("GIFT".equals(aType)) {
							sum = posOfCityRecord.getGiftCount() + count;
							posOfCityRecord.setGiftCount(sum);
						} else if ("PRIVILEGE".equals(aType)) {
							sum = posOfCityRecord.getPrivilegeCount() + count;
							posOfCityRecord.setPrivilegeCount(sum);
						}
						break;
					}
				}

			}
			rs.close();

			sqlBuf = new StringBuffer(
					"SELECT count( id ) count, posId FROM QQWeixinSignIn ");
			sql = concatLimitTime(sqlBuf, "createdAt", fromDate, toDate);
			sql = sql.append(" GROUP BY posId");
			rs = db.executeQuery(sql.toString());
			while (rs.next()) {
				String posId = rs.getString("posId");
				String aType = "WEIXIN";
				int count = rs.getInt("count");

				PosCount posCount = new PosCount();
				posCount.setAType(aType);
				posCount.setCount(count);
				posCount.setPosId(posId);

				String cityName = PosOfCity.getMerchantNameByPosId(posId);

				for (PosOfCityRecord posOfCityRecord : report) {
					if (cityName.equals(posOfCityRecord.getCityName())) {
						posOfCityRecord.getPosCountList().add(posCount);
						int sum = posOfCityRecord.getWeixinCount() + count;
						posOfCityRecord.setWeixinCount(sum);
						break;
					}
				}

			}
			rs.close();

			db.closeStmt();
			db.closeConn();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return report;
	}

	private List<PosOfCityRecord> initReport() {

		List<PosOfCityRecord> report = new LinkedList<PosOfCityRecord>();

		Set<String> citys = PosOfCity.getAllMerchantName();
		for (String cityName : citys) {
			PosOfCityRecord record = new PosOfCityRecord();
			record.setCityName(cityName);
			record.setCityId(PosOfCity.getIndexByMerchantName(cityName));
			report.add(record);
		}
		return report;

	}

	private List<QQActiveHistoryVOOfShop> initQQActiveHistoryVOOfShopReport() {
		List<QQActiveHistoryVOOfShop> report = new LinkedList<QQActiveHistoryVOOfShop>();

		Set<String> citys = PosOfCity.getAllMerchantName();
		for (String shopName : citys) {
			QQActiveHistoryVOOfShop record = new QQActiveHistoryVOOfShop();
			record.setShopName(shopName);
			record.setShopId(PosOfCity.getIndexByMerchantName(shopName));
			List<QQActiveHistoryVO> list = new LinkedList<QQActiveHistoryVO>();
			record.setVoList(list);
			report.add(record);
		}

		return report;
	}

	// public List<QQActiveMemberVo> getQQActiveMemberVoBy(String memberKey)
	// throws RecordNotFoundException {
	// List<QQActiveMemberVo> voList = new LinkedList<QQActiveMemberVo>();
	//
	// try {
	// PosnetDb db = new PosnetDb();
	// ResultSet rs = null;
	// db.OpenConn();
	//
	// StringBuffer sql = new StringBuffer(
	// "select id,memberKey,giftStatus,privilegeStatus,DATE_FORMAT( sendTime, '%Y-%m-%d %k:%i:%s' ) sendTime, DATE_FORMAT( createdAt, '%Y-%m-%d %k:%i:%s' ) createdAt,DATE_FORMAT( lastModifiedAt, '%Y-%m-%d %k:%i:%s' ) lastModifiedAt from QQActivityMember where createdAt >= '2012-05-18 15:09:11' "
	// );
	//
	// if (memberKey != null && !memberKey.isEmpty()) {
	// sql.append(" and memberKey ='").append(memberKey).append("'");
	// }
	//
	// rs = db.executeQuery(sql.toString());
	//
	// boolean hasRecord = false;
	//
	// while (rs.next()) {
	// hasRecord = true;
	// QQActiveMemberVo vo = new QQActiveMemberVo();
	// vo.setId(rs.getString("id"));
	// vo.setMemberkey(rs.getString("memberKey"));
	// vo.setGiftStatus(rs.getString("giftStatus"));
	// vo.setPrivilegeStatus(rs.getString("privilegeStatus"));
	// vo.setSendTime(rs.getString("sendTime"));
	// vo.setCreatedAt(rs.getString("createdAt"));
	// vo.setLastModifiedAt(rs.getString("lastModifiedAt"));
	// voList.add(vo);
	// }
	//
	// if (!hasRecord) {
	// throw new RecordNotFoundException(memberKey + " not found");
	// }
	// rs.close();
	// db.closeStmt();
	// db.closeConn();
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// return voList;
	// }

	/**
	 * 
	 * @param isHeadOfMonth
	 * @param dateStr
	 * @return format like 1980-01-01 00:00:01 or 1980-01-31 23:59:59
	 * 
	 */
	private String getMysqlDateStr(boolean isHeadOfMonth, String dateStr) {
		String[] ds = dateStr.split("/");
		String newdate = ds[0].concat("-").concat(ds[1]).concat("-").concat(
				ds[2]);

		String res;
		if (isHeadOfMonth) {
			res = newdate.concat(" 00:00:01");
		} else {
			res = newdate.concat(" 23:59:59");
		}

		return res;

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

	public static int getDaysBetween(java.util.Calendar d1,
			java.util.Calendar d2) {
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
}
