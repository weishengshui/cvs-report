/**
 * 
 */
package com.chinarewards.report.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

/**
 * 
 * 
 * @author cyril
 * @since 1.2.2 2010-04-07
 */
public abstract class UrlUtil {

	/**
	 * 
	 * 
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static final String buildQueryString(Map<String, String> params)
			throws UnsupportedEncodingException {

		StringBuffer sb = new StringBuffer();
		String enc = "UTF-8";

		Iterator<Entry<String, String>> i = params.entrySet().iterator();
		while (i.hasNext()) {
			Entry<String, String> e = i.next();
			if (sb.length() > 0) {
				sb.append("&");
			}
			sb.append(URLEncoder.encode(e.getKey(), enc));
			sb.append("=");
			sb.append(URLEncoder.encode(e.getValue(), enc));
		}
		return sb.toString();

	}

}
