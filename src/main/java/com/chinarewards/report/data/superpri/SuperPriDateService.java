package com.chinarewards.report.data.superpri;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Calendar;
import java.util.Collections;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Logger;

import com.chinarewards.report.db.DbConnectionFactory;
import com.chinarewards.report.sql.SqlUtil;

public class SuperPriDateService {

	/**
	 * Store statistic data.
	 * 
	 * @author yanxin
	 * 
	 */
	static class StatisticData {

		private int degreeCount = 0;

		private int memberCount = 0;

		public int getDegreeCount() {
			return degreeCount;
		}

		public void setDegreeCount(int degreeCount) {
			this.degreeCount = degreeCount;
		}

		public int getMemberCount() {
			return memberCount;
		}

		public void setMemberCount(int memberCount) {
			this.memberCount = memberCount;
		}

	}

	Logger log = Logger.getLogger("SuperPriDateService");

	// /**
	// * @param args
	// */
	// public static void main(String[] args) {
	//
	// Calendar start = new GregorianCalendar();
	// start.set(2009, 4, 1);
	//
	// Calendar end = new GregorianCalendar();
	// end.set(2011, 3, 23);
	//
	// List<DateOFWeekRange> res = getDateOFWeekRangeOfYearBetween(start, end);
	//
	// SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	//
	// for (DateOFWeekRange one : res) {
	// System.out.println("year:" + one.getYear() + " and weekofyear:"
	// + one.getWeekOfYear() + " startday is "
	// + format.format(one.getFromday().getTime()) + " endday is "
	// + format.format(one.getToday().getTime()));
	// }
	//
	// }

	private List<DateOFWeekRange> getDateOfWeekRangesBetween(
			List<Integer> years, Calendar startday, Calendar endday) {

		log.info("Enter SuperPriDateService ");
		List<DateOFWeekRange> allRes = new LinkedList<DateOFWeekRange>();

		int startYear = startday.get(Calendar.YEAR);

		int endYear = endday.get(Calendar.YEAR);

		int startWeekOfYear = startday.get(Calendar.WEEK_OF_YEAR);
		int endWeekOfYear = endday.get(Calendar.WEEK_OF_YEAR);

		System.out.println("startYear is " + startYear + " endYear is "
				+ endYear);

		for (Integer year : years) {
			System.out.println("current year is " + year);
			boolean betweenYear = false;
			int startWeek = 0;
			int endWeek = 0;

			if (year == startYear) {

				startWeek = startWeekOfYear;
				// Calendar enddayOfYear = (Calendar) startday.clone();
				// enddayOfYear.set(Calendar.MONTH, 11);
				// enddayOfYear.set(Calendar.DAY_OF_WEEK_IN_MONTH, 4);
				//
				// endWeek = enddayOfYear.get(Calendar.WEEK_OF_YEAR);

				endWeek = endday.get(Calendar.WEEK_OF_YEAR);

			} else if (year == endYear) {

				endWeek = endWeekOfYear;

				Calendar startdayOfYear = (Calendar) endday.clone();
				startdayOfYear.set(Calendar.MONDAY, 0);
				startdayOfYear.set(Calendar.DAY_OF_MONTH, 1);

				startWeek = startdayOfYear.get(Calendar.WEEK_OF_YEAR);
			} else {

				Calendar baseCal = new GregorianCalendar();
				baseCal.set(Calendar.YEAR, year);

				Calendar startdayOfYear = ((Calendar) baseCal.clone());
				startdayOfYear.set(Calendar.MONTH, 0);
				startdayOfYear.set(Calendar.DAY_OF_MONTH, 1);

				startWeek = startdayOfYear.get(Calendar.WEEK_OF_YEAR);

				Calendar enddayOfYear = ((Calendar) baseCal.clone());
				enddayOfYear.set(Calendar.MONTH, 11);
				enddayOfYear.set(Calendar.DAY_OF_WEEK_IN_MONTH, 4);

				endWeek = enddayOfYear.get(Calendar.WEEK_OF_YEAR);
			}

			System.out.println("startWeek is " + startWeek + " endWeek is "
					+ endWeek);

			// 每年得最后一周如果包括第二年第一周得日期，那么这最后一周在java得日历中属于第二年得第一周
			if (endWeek < startWeek) {
				if (endWeek == 1) {
					betweenYear = true;
				}
				endWeek = startWeek + 1;
			}

			List<DateOFWeekRange> oneRes = getResForOneYear(year, startWeek,
					endWeek);
			allRes.addAll(oneRes);

			if (betweenYear) {
				year = year + 1;
				startWeek = 1;
				endWeek = 1;

				List<DateOFWeekRange> res = getResForOneYear(year, startWeek,
						endWeek);
				allRes.addAll(res);

				betweenYear = false;
			}

		}

		Collections.sort(allRes);

		log.info("Exit SuperPriDateService size is " + allRes.size());

		return allRes;

	}

	private List<DateOFWeekRange> getResForOneYear(int year, int startWeek,
			int endWeek) {

		log.info("Enter SuperPriDateService getResForOneYear  year is " + year
				+ " and startweek is " + startWeek + " and endWeek is "
				+ endWeek);
		List<DateOFWeekRange> res = new LinkedList<DateOFWeekRange>();

		for (int i = startWeek; i <= endWeek; i++) {
			DateOFWeekRange range = new DateOFWeekRange();
			range.setYear(year);
			range.setWeekOfYear(i);

			res.add(range);

		}

		log.info("Exit SuperPriDateService getResForOneYear size is "
				+ res.size());

		return res;
	}

	public List<DateOFWeekRange> getDateOFWeekRangeOfYearBetween(
			Calendar startday, Calendar endday) throws Exception {
		List<Integer> years = new LinkedList<Integer>();
		int startYear = startday.get(Calendar.YEAR);

		int endYear = endday.get(Calendar.YEAR);
		System.out.println("start year is " + startYear);
		System.out.println("end year is " + endYear);

		if (startYear == endYear) {
			years.add(Integer.valueOf(startYear));
		} else {
			int num = endYear - startYear;
			System.out.println("num is " + num);
			for (int i = 0; i <= num; i++) {
				int year = startYear + i;
				years.add(Integer.valueOf(year));
			}
		}
		List<DateOFWeekRange> ranges = getDateOfWeekRangesBetween(years,
				startday, endday);
		ranges = getTotalOfSuperPriConsumedata(ranges, false);
		return getTotalOfSuperPriConsumedata(ranges, true);
	}

	private StatisticData getStatisticDataByDataRange(Connection financeConn,
			Calendar from, Calendar to, boolean isPaided) throws Exception {
		log.info("ENTER getSatisticDataByDataRange date from=" + from + ",to="
				+ to);

		ResultSet rs = null;
		PreparedStatement pstmt = null;
		StatisticData data = null;
		try {
			String sql = "SELECT COUNT(md.id), COUNT(DISTINCT(md.membercardno)) FROM merchantdetail md where md.merchantbill_id IN (SELECT id FROM merchantbill WHERE merchantbill.createflag = 'NEW' AND merchantbill.billtype  = 'Privilege') AND md.transactiondate > ? AND md.transactiondate <= ?";
			if (isPaided) {
				sql += "  AND md.paystatus IN ('full','half')";
			}
			pstmt = financeConn.prepareStatement(sql.toString(),
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
			java.sql.Date start = new java.sql.Date(from.getTimeInMillis());
			java.sql.Date end = new java.sql.Date(to.getTimeInMillis());

			pstmt.setDate(1, start);
			pstmt.setDate(2, end);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				int degreeCount = rs.getInt(1);
				int memberCount = rs.getInt(2);
				data = new StatisticData();
				data.setDegreeCount(degreeCount);
				data.setMemberCount(memberCount);
			}

			if (rs != null) {
				rs.close();
				rs = null;
			}
		} catch (Exception e) {
			e.printStackTrace();
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
		log.info("EXIT getSatisticDataByDataRange");

		return data;
	}

	private List<DateOFWeekRange> getTotalOfSuperPriConsumedata(
			List<DateOFWeekRange> rangedata, boolean isPaided) throws Exception {
		log.info("Enter SuperPriDateService getTotalOfSuperPriConsumedata size is"
				+ rangedata.size());

		Connection financeConn = DbConnectionFactory.getInstance()
				.getConnection("finance");

		for (DateOFWeekRange data : rangedata) {
			StatisticData totalData = getStatisticDataByDataRange(financeConn,
					data.getFromday(), data.getToday(), false);
			data.setDegreeCount(totalData.getDegreeCount());
			data.setMemberCount(totalData.getMemberCount());
			StatisticData paidedData = getStatisticDataByDataRange(financeConn,
					data.getFromday(), data.getToday(), true);
			data.setPaidedDegreeCount(paidedData.getDegreeCount());
			data.setPaidedMemberCount(paidedData.getMemberCount());
		}

		if (financeConn != null) {
			SqlUtil.close(financeConn);
			financeConn = null;
		}

		log.info("Exit SuperPriDateService getTotalOfSuperPriConsumedata size is "
				+ rangedata.size());
		return rangedata;
	}
}
