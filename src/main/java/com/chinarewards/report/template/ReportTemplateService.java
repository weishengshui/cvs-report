package com.chinarewards.report.template;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.chinarewards.report.db.impl.PosnetDb;

public class ReportTemplateService {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	//根据交易类型的总计报表。比如：礼品总数200,、优惠总数320
	public  List<Object> getTotalStatements(
			String startDate, String endDate, String activity_id) {
		PosnetDb db = null;
		try {
			Calendar toDate = getEndDate(startDate, endDate);
			if (toDate == null) {
				return null;
			}
			endDate = calendarToStringFormatDate(toDate);
			db = new PosnetDb();
			db.OpenConn();
			ResultSet rs = null;
			List<String> exchangeTypeLists = getExchangeTypes(activity_id);
			if (exchangeTypeLists != null) {
				List<Object> totalStatement = new ArrayList<Object>();
				for (Iterator<String> it = exchangeTypeLists.iterator(); it
						.hasNext();) {
					String exchangeType = (String) it.next();
					StringBuffer exAmountSql = new StringBuffer(
							"select sum((select count(*) from QQMeishiXaction meishi ");
					exAmountSql = concatLimitTime(exAmountSql, "meishi.ts",
							startDate, endDate);
					exAmountSql
							.append(" and meishi.posid=am1.posid and meishi.xactResultCode = '0')) as '"
									+ exchangeType
									+ "总数'  from Merchant m1,Activitymerchant  am1 where  m1.exchangeType='"
									+ exchangeType
									+ "' and m1.id=am1.merchant_id  and am1.activity_id='"
									+ activity_id + "'");
					rs = db.executeQuery(exAmountSql.toString());
					
					System.out.println("Get total statements with activity_id="+activity_id+" and exchange type ="+exchangeType+" SQL: "+exAmountSql.toString());
					
					if (rs.next()) {
						totalStatement.add(rs.getInt(1));
					}
				}
				if(totalStatement.size()>0){
					return totalStatement;
				}
				else {
					return null;
				}
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
	
	
	//根据每天交易类型的总计报表。比如：2012/07/25礼品总数200,优惠总数320；2012/07/26礼品总数52,优惠总数47
	public Map<String, List<Object>> getTotalStatementsEveryDay(
			String startDate, String endDate, String activity_id) {
		PosnetDb db = null;
		try {
			Calendar toDate = getEndDate(startDate, endDate);
			if (toDate == null) {
				return null;
			}
			endDate = calendarToStringFormatDate(toDate);
			db = new PosnetDb();
			db.OpenConn();
			ResultSet rs = null;
			List<String> exchangeTypeLists = getExchangeTypes(activity_id);
			if (exchangeTypeLists != null) {
				Map<String, List<Object>> totalStatementPreDay = new TreeMap<String, List<Object>>();
				
				
				StringBuffer statementsPreDaySql = new StringBuffer("select date_format(ts,'%Y/%m/%d') as '日期' ");
				int typeCount = exchangeTypeLists.size();
				for (int i=0;i<typeCount;i++) {
					String exchangeType = (String) exchangeTypeLists.get(i);
					statementsPreDaySql.append(", sum((select count(*) from QQMeishiXaction q2  where  year(q1.ts) = year(q2.ts) and  month(q1.ts) = month(q2.ts) and day(q1.ts) = day(q2.ts) and  q2.xactResultCode = '0' and " +
							" m1.exchangeType='"+exchangeType+"'  and  q1.posid=q2.posid)) as '"+exchangeType+"总数'");
				}
				statementsPreDaySql.append(" from QQMeishiXaction q1 ,  Merchant m1, Activitymerchant am ");
				statementsPreDaySql = concatLimitTime(statementsPreDaySql, "q1.ts", startDate, endDate);
				statementsPreDaySql.append(" and q1.xactResultCode = '0' and am.posid = q1.posid  and am.merchant_id=m1.id and  am.activity_id='" +
						activity_id +
						"' group by year(ts),month(ts),day(ts)");
					rs = db.executeQuery(statementsPreDaySql.toString());
					
					System.out.println("Get total statements for everyday with activity_id="+activity_id+" SQL: "+statementsPreDaySql.toString());
					
					while (rs.next()) {
						String preRecordDate = null;
						List<Object> preRecordNumber= new ArrayList<Object>();
						preRecordDate = rs.getString(1);
						for(int i=2;i<=typeCount+1;i++){
							preRecordNumber.add(rs.getInt(i));
						}
						totalStatementPreDay.put(preRecordDate, preRecordNumber);
				}
					Calendar fromday = stringFormatDateToCalendar(startDate);
					Calendar today = stringFormatDateToCalendar(endDate);
					int bet = getDaysBetween(fromday, today);
					if(totalStatementPreDay.size()==0){
						for(int i=0;i<bet+1;i++){
							String tmpDay = calendarToStringFormatDate(fromday);
							List<Object> preRecordNumber= new ArrayList<Object>();
							
							for(int j=0;j<typeCount;j++){
								preRecordNumber.add((Integer)0);
							}
							fromday.add(Calendar.DATE, 1);
							totalStatementPreDay.put(tmpDay,preRecordNumber);
						}
						return totalStatementPreDay;
					}else{
						for (int i = 0; i < bet + 1; i++) {
							String tmpDay = calendarToStringFormatDate(fromday);
							
							List<Object> preRecordNumber= totalStatementPreDay.get(tmpDay);
							if(preRecordNumber==null){
								preRecordNumber = new ArrayList<Object>();
								for(int j=0;j<typeCount;j++){
									preRecordNumber.add((Integer)0);
								}
								totalStatementPreDay.put(tmpDay, preRecordNumber);
							}
							
							fromday.add(Calendar.DATE, 1);
						}
						return totalStatementPreDay;
					}
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
	
	//针对交易类型的商户总计报表。比如：大饱口福 礼品总数200,消费总金额65231
	public Map<String, List<Object>> getMerchantTotalStatementsWithExchangeType(String startDate, String endDate, String activity_id,String exchangeType){
		
		PosnetDb db = null;
		try {
			Calendar toDate = getEndDate(startDate, endDate);
			if (toDate == null) {
				return null;
			}
			endDate = calendarToStringFormatDate(toDate);
			db = new PosnetDb();
			db.OpenConn();
			ResultSet rs = null;
			ResultSet posrs = null;

			Map<String, List<Object>> merchantTotalStatementWithType = new TreeMap<String, List<Object>>();
				
			StringBuffer statementsPreMerchantWithTypeSql = new StringBuffer("select m1.id, m1.Merchant_name, sum((select count(*)  from QQMeishiXaction mshi1  ");
			statementsPreMerchantWithTypeSql = concatLimitTime(statementsPreMerchantWithTypeSql, "mshi1.ts", startDate, endDate);
			statementsPreMerchantWithTypeSql.append(" and mshi1.xactResultCode = '0' and mshi1.posid = am1.posid)) as '"+exchangeType+"总数',");
			statementsPreMerchantWithTypeSql.append("sum((select sum(mshi1.consumeAmount) from QQMeishiXaction mshi1 ");
			statementsPreMerchantWithTypeSql = concatLimitTime(statementsPreMerchantWithTypeSql, "mshi1.ts", startDate, endDate);
			statementsPreMerchantWithTypeSql.append(" and mshi1.xactResultCode = '0' and mshi1.posid = am1.posid )) as '消费总金额' ");
			statementsPreMerchantWithTypeSql.append("from Merchant m1, Activitymerchant am1   where am1.merchant_id = m1.id  and  am1.activity_id = '"+
					activity_id
					+"' and m1.exchangeType='"+
					exchangeType
					+"' group by am1.merchant_id ");
			
			rs = db.executeQuery(statementsPreMerchantWithTypeSql.toString());
			System.out.println("Get total statements for merchant with activity_id="+activity_id+" and exchangeType="+exchangeType+" SQL: "+statementsPreMerchantWithTypeSql.toString());
			while(rs.next()){
				StringBuffer posSql = new StringBuffer("select am1.posid, (select count(*) from QQMeishiXaction mshi  ");
				posSql = concatLimitTime(posSql, "mshi.ts", startDate, endDate);
				posSql.append(" and mshi.xactResultCode = 0 and am1.posid = mshi.posid) as pos机交易总数  from Activitymerchant am1 where am1.Merchant_id = '" +
						rs.getString(1) 
						+"'");
				posrs = db.executeQuery(posSql.toString());
				System.out.println("check pos with merchanId sql: "+posSql.toString());
				Map<String, Integer> posMap = new TreeMap<String, Integer>();
				while(posrs.next()){
					String posid = posrs.getString(1);
					int exchangeCount = posrs.getInt(2);
					posMap.put(posid, exchangeCount);
				}
				String merchant = rs.getString(2);
				List<Object> countAndAmount = new ArrayList<Object>();
				countAndAmount.add(rs.getInt(3));
				countAndAmount.add(rs.getDouble(4));
				countAndAmount.add(posMap);
				merchantTotalStatementWithType.put(merchant, countAndAmount);
			}
			if(merchantTotalStatementWithType.size()>0){
				return merchantTotalStatementWithType;
			}
			return null;
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

	public List<String> getExchangeTypes(String activity_id) throws Exception {
		
		PosnetDb db = new PosnetDb();
		db.OpenConn();
		ResultSet rs = null;
		String exchangeTypesSql = "select m.exchangeType from Merchant m, Activitymerchant am where am.activity_id='"
				+ activity_id
				+ "' and am.merchant_id=m.id group  by m.exchangeType  desc";
		List<String> exchangeTypeLists = new ArrayList<String>();
		rs = db.executeQuery(exchangeTypesSql);
		
		System.out.println("get exchange Types with activity_id="+activity_id+" SQL: " + exchangeTypesSql);
		
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
}
