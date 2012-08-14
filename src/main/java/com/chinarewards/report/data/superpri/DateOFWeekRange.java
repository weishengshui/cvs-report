package com.chinarewards.report.data.superpri;

import java.util.Calendar;
import java.util.GregorianCalendar;

public class DateOFWeekRange implements Comparable<DateOFWeekRange> {

	int year;

	int weekOfYear;

	/**
	 * formday of this week;
	 */
	private Calendar fromday;

	/**
	 * today of this week;
	 */
	private Calendar today;

	private int degreeCount = 0;

	private int memberCount = 0;

	// add by yanxin 2010-03-17
	private int paidedDegreeCount = 0;

	private int paidedMemberCount = 0;

	public Calendar getFromday() {
		if (fromday == null) {
			fromday = new GregorianCalendar();
			fromday.set(Calendar.YEAR, this.year);

			this.getCalendarBy(fromday);

			getLast(fromday, Calendar.SUNDAY);
		}
		return fromday;
	}

	public void setFromday(Calendar fromday) {

		this.fromday = fromday;
	}

	public Calendar getToday() {

		if (today == null) {
			today = new GregorianCalendar();
			today.set(Calendar.YEAR, this.year);

			this.getCalendarBy(today);

			getLast(today, Calendar.SATURDAY);
		}
		return today;
	}

	public void setToday(Calendar today) {
		this.today = today;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public int getWeekOfYear() {
		return weekOfYear;
	}

	public void setWeekOfYear(int weekOfYear) {
		this.weekOfYear = weekOfYear;
	}

	private void getLast(Calendar cal, int dayOfWeek) {
		int day = cal.get(Calendar.DAY_OF_WEEK);
		// System.out.println("cal day of week is " + day +
		// " and need dayofweek is " + dayOfWeek);

		if (day == dayOfWeek)
			return;

		int size = dayOfWeek - day;
		cal.add(Calendar.DAY_OF_YEAR, size);
	}

	private void getCalendarBy(Calendar cal) {

		for (int i = 0; i < 12; i++) {
			cal.set(Calendar.MONTH, i);

			for (int j = 1; j <= 28; j++) {
				cal.set(Calendar.DAY_OF_MONTH, j);
				int res = cal.get(Calendar.WEEK_OF_YEAR);

				if (res == this.weekOfYear)
					return;
			}

		}

	}

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

	public int getPaidedDegreeCount() {
		return paidedDegreeCount;
	}

	public void setPaidedDegreeCount(int paidedDegreeCount) {
		this.paidedDegreeCount = paidedDegreeCount;
	}

	public int getPaidedMemberCount() {
		return paidedMemberCount;
	}

	public void setPaidedMemberCount(int paidedMemberCount) {
		this.paidedMemberCount = paidedMemberCount;
	}

	@Override
	public int compareTo(DateOFWeekRange o) {
		return (int) (o.getToday().getTimeInMillis() - this.getToday()
				.getTimeInMillis());
	}

}
