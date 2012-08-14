/**
 * 
 */
package com.chinarewards.report.util;

/**
 * 
 * 
 * @author Cyril
 * @since 1.3.0 2010-01-20
 */
public abstract class StringUtil {

	/**
	 * Checks whether the input string is empty. A string is empty if:
	 * <ul>
	 * <li>is {@code null}</li>
	 * <li>has a length of 0 after trim()</li>
	 * </ul>
	 * 
	 * @param s
	 * @return
	 */
	public static final boolean isEmpty(String s) {
		if (s == null)
			return true;
		if ("".equals(s.trim()))
			return true;
		return false;
	}

	/**
	 * Trim the string and return. If the string has a length of zero,
	 * <code>null</code> is returned.
	 * 
	 * @param s
	 * @return
	 * @see #isEmpty(String)
	 */
	public static final String trimToNull(String s) {
		if (isEmpty(s))
			return null;
		return s.trim();
	}

}
