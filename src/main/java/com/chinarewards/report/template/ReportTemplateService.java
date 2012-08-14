package com.chinarewards.report.template;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.chinarewards.report.db.impl.PosnetDb;

public class ReportTemplateService {

	private Logger log = LoggerFactory.getLogger(getClass());

	public Map<List<String>, List<Integer>> getTotalStatements(
			String startDate, String endDate, String activity_id) {
		PosnetDb db = null;
		try {
			Calendar toDate = getEndDate(startDate, endDate);
			if (toDate == null) {
				return null;
			}
			endDate = calendarToStringFormatDate(toDate);
			db = new PosnetDb();
			ResultSet rs = null;
			List<String> exchangeTypeLists = getExchangeTypes(activity_id);
			if (exchangeTypeLists != null) {
				Map<List<String>, List<Integer>> totalStatement = new HashMap<List<String>, List<Integer>>();
				List<String> exchangeTypes = new ArrayList<String>();
				List<Integer> exchangeAmounts = new ArrayList<Integer>();
				for (Iterator<String> it = exchangeTypeLists.iterator(); it
						.hasNext();) {
					String exchangeType = (String) it.next();
					StringBuffer exAmountSql = new StringBuffer(
							"select sum((select count(*) from QQMeishiXaction meishi ");
					exAmountSql = concatLimitTime(exAmountSql, "meishi.ts",
							startDate, endDate);
					exAmountSql
							.append(" and meishi.posid=am1.posid and meishi.xactResultCode = '0')) as "
									+ exchangeType
									+ "总数  from Merchant m1,Activitymerchant  am1 where  m1.exchangeType='"
									+ exchangeType
									+ "' and m1.id=am1.merchant_id  and am1.activity_id='"
									+ activity_id + "'");
					rs = db.executeQuery(exAmountSql.toString());
					if (rs.next()) {
						exchangeAmounts.add(rs.getInt(1));
						exchangeTypes.add(exchangeType);
					}
				}
				totalStatement.put(exchangeTypes, exchangeAmounts);
				return totalStatement;
			} else {
				return null;
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return null;
		} finally {
			if (db != null) {
				db.closeConn();
			}
		}

	}

	private Calendar getEndDate(String startDate, String endDate) {

		Calendar fromday = stringFormatDateToCalendar(startDate);

		Calendar todate = stringFormatDateToCalendar(endDate);

		Calendar today = new GregorianCalendar();

		if (fromday.after(todate)) {
			return null;
		}
		if (today.after(todate)) {
			return todate;
		}
		if (todate.after(today)) {
			return today;
		}
		return null;

	}

	private Calendar stringFormatDateToCalendar(String stringDate) {

		String[] ds = stringDate.split("/");
		int year = Integer.valueOf(ds[0]).intValue();
		int month = Integer.valueOf(ds[1]).intValue() - 1;
		int day = Integer.valueOf(ds[2]).intValue();

		Calendar calendar = new GregorianCalendar(year, month, day);

		return calendar;

	}

	private String calendarToStringFormatDate(Calendar calendar) {

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

		String stringDate = new String(yearto + "/" + monthStr + "/" + dayStr);

		return stringDate;

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

	private List<String> getExchangeTypes(String activity_id) throws Exception {
		
		PosnetDb db = new PosnetDb();
		ResultSet rs = null;
		String exchangeTypesSql = "select m.exchangeType from Merchant m, Activitymerchant am where am.activity_id='"
				+ activity_id
				+ "' and am.merchant_id=m.id group  by m.exchangeType  desc";
		List<String> exchangeTypeLists = new ArrayList<String>();
		rs = db.executeQuery(exchangeTypesSql);
		log.debug("get exchange Types SQL: " + exchangeTypesSql);
		while (rs.next()) {
			exchangeTypeLists.add(rs.getString(1));
		}
		db.closeConn();
		rs.close();
		if (exchangeTypeLists.size() != 0) {
			return exchangeTypeLists;
		}
		return null;

	}
}
