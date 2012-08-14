/**
 * 
 */
package com.chinarewards.report.http.util;

import javax.servlet.ServletRequest;

/**
 * 
 * 
 * @author Cyril
 * 
 */
public abstract class ServletUtil {

	/**
	 * Returns the domain part of the URL. For example, http://www.example.com
	 * 
	 * @param request
	 * @return
	 */
	public static final String getDomainUrl(ServletRequest request) {
		StringBuffer s = new StringBuffer();
		// http, https, etc.
		s.append(request.getScheme());
		s.append("://");
		// domain
		s.append(request.getServerName());
		// port number. If it is a well-known port number, it is not appended.
		if (!(("http".equalsIgnoreCase(request.getScheme()) && request
				.getServerPort() == 80) || ("https".equalsIgnoreCase(request
				.getScheme()) && request.getServerPort() == 443))) {
			// non-standard port.
			s.append(":" + request.getServerPort());
		}
		return s.toString();
	}

}
