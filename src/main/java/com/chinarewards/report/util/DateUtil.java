/**
 * 
 */
package com.chinarewards.report.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 
 * 
 * 
 * @author Cyril
 * @since 2010-01-04
 */
public class DateUtil {

	/**
	 * Add the specified Calendar field and amount to the given date.
	 * 
	 * @param date
	 * @param field
	 * @param amount
	 * @return
	 */
	public static final Date add(Date date, int field, int amount) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(field, amount);
		return c.getTime();
	}

	/**
	 * Clears the time component from the given date object.
	 * 
	 * @param date
	 * @return
	 */
	public static final Date clearTimeComponents(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		return cal.getTime();
	}

	/**
	 * Create a date object from a YYYYMMDD string.
	 * 
	 * @param dateString
	 * @throws ParseException
	 */
	public static final Date createDateFromYYYYMMDD(String dateString)
			throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		sdf.setLenient(false);
		Date d = sdf.parse(dateString);
		return d;
	}

	/**
	 * 
	 * @param d
	 * @param field
	 * @return
	 */
	public static final int getDateField(Date d, int field) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(d);
		return cal.get(field);
	}

	/**
	 * Returns the string representation of the given week day.
	 * 
	 * @param weekday
	 * @return
	 * @throws IllegalArgumentException
	 *             if the weekday is out of range.
	 */
	public static final String getWeekdayString(int weekday) {
		switch (weekday) {
		case Calendar.MONDAY:
			return "Monday";
		case Calendar.TUESDAY:
			return "Tuesday";
		case Calendar.WEDNESDAY:
			return "Wednesday";
		case Calendar.THURSDAY:
			return "Thurday";
		case Calendar.FRIDAY:
			return "Friday";
		case Calendar.SATURDAY:
			return "Saturday";
		case Calendar.SUNDAY:
			return "Sunday";
		default:
			throw new IllegalArgumentException("Unknown weekday value "
					+ weekday);
		}
	}

	/**
	 * 获得d1-d2的天数差
	 * 
	 * @param d1
	 * @param d2
	 * @return
	 */
	public static long getTwoDaysTimes(java.util.Date d1, java.util.Date d2) {
		long diff = d1.getTime() - d2.getTime();
		long days = diff / (1000 * 60 * 60 * 24);
		return days;
	}

	public static String getFormatDateStr(String pattern, Date date) {
		SimpleDateFormat format = new SimpleDateFormat(pattern);

		String s = format.format(date);

		return s;
	}

	public static Date getFormatDate(String pattern, String dateStr)
			throws ParseException {
		SimpleDateFormat format = new SimpleDateFormat(pattern);

		Date date = format.parse(dateStr);

		return date;
	}

}
