/**
 * 
 */
package com.chinarewards.report.jsp.util;

/**
 * 
 * 
 * @author cyril
 * @since 1.3.0 2010-01-11
 */
public class JspDisplayUtil {

	public static final String noNull(Object o) {
		if (o == null)
			return "";
		return o.toString();
	}

}
