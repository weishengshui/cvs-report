/**
 * 
 */
package com.chinarewards.report.data.crm;

/**
 * 
 * 
 * @author cyril
 * @since 1.3.0 2010-01-27
 */
public class GenderUtil {

	/**
	 * Converts the CRM member gender value to string representation. If the
	 * gender contains invalid value, empty string is returned.
	 * 
	 * @param gender
	 * @return the string representation of the gender. If the value is out of
	 *         range, an empty string will be returned.
	 */
	public static final String toString(int gender) {
		switch (gender) {
		case 0:
			return "男";
		case 1:
			return "女";
		default:
			return "";
		}
	}

}
